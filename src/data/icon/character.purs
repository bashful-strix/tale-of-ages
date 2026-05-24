module ToA.Data.Icon.Character
  ( Character(..)
  , CharacterData
  , _build
  , _state
  , _currentHp
  , _currentVigor
  , _currentPowerDice
  , _currentStatus
  , _currentParRes
  , _currentPerRes

  , State(..)
  , StateData
  , _combat
  , _expedition
  , CombatStateData
  , _hp
  , _vigor
  , _powerDice
  , _status
  , _partyResolve
  , ExpeditionStateData
  , _wounded
  , _camps
  , _personalResolve
  , _combats

  , Build(..)
  , BuildData
  , _level
  , _primary
  , _jobs
  , _talents
  , _abilities
  , _active
  , _inactive

  , Level(..)

  , stringCharacter
  , jsonCharacter
  ) where

import Prelude
import PointFree ((~$))

import Data.Array (elem, length, uncons)
import Data.Codec (Codec', codec')
import Data.Codec.JSON as CJ
import Data.Codec.JSON.Common as CJC
import Data.Codec.JSON.Record as CJR
import Data.Either (Either(..))
import Data.Filterable (partitionMap)
import Data.Foldable (intercalate)
import Data.FoldableWithIndex (foldMapWithIndex)
import Data.Lens (Lens', (^.), _2, traversed, preview, view)
import Data.Lens.Fold
  ( findOf
  , filtered
  , firstOf
  , folded
  , foldOf
  , foldMapOf
  , has
  )
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, empty, fromFoldable)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Profunctor.Strong (first)
import Data.Traversable (traverse_)
import Data.Tuple (fst)
import Data.Tuple.Nested (type (/\), (/\))

import Parsing (Parser, ParseError, fail, liftMaybe, runParser)
import Parsing.Combinators
  ( (<|>)
  , choice
  , lookAhead
  , optional
  , optionMaybe
  , sepBy
  , try
  , tryRethrow
  )
import Parsing.Combinators.Array (many)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon (_abilities, _classes, _jobs, _talents) as I
import ToA.Data.Icon.Class (_hp) as C
import ToA.Data.Icon.Id (Id, _id, jsonId)
import ToA.Data.Icon.Job (Job, JobLevel, jobLevelP, jsonJobLevel)
import ToA.Data.Icon.Job (_abilities, _talents) as J
import ToA.Data.Icon.Name (Name(..), class Named, _name, jsonName)
import ToA.Util.Optic ((^::), key)

type CharacterData =
  { name :: Name
  , state :: State
  , build :: Build
  }

newtype Character = Character CharacterData

derive instance Newtype Character _
instance Eq Character where
  eq (Character { name: n }) (Character { name: m }) = n == m

instance Named Character where
  _name = _Newtype <<< key @"name"

_build :: Lens' Character Build
_build = _Newtype <<< key @"build"

_state :: Lens' Character State
_state = _Newtype <<< key @"state"

_currentHp :: Lens' Character Int
_currentHp = _state <<< _combat <<< _hp

_currentVigor :: Lens' Character Int
_currentVigor = _state <<< _combat <<< _vigor

_currentPowerDice :: Lens' Character (Map String Int)
_currentPowerDice = _state <<< _combat <<< _powerDice

_currentStatus :: Lens' Character (Map Name Int)
_currentStatus = _state <<< _combat <<< _status

_currentParRes :: Lens' Character Int
_currentParRes = _state <<< _combat <<< _partyResolve

_currentPerRes :: Lens' Character Int
_currentPerRes = _state <<< _expedition <<< _personalResolve

newtype State = State StateData

derive instance Newtype State _

type StateData =
  { combat :: CombatStateData
  , expedition :: ExpeditionStateData
  , interlude :: {}
  }

_combat :: Lens' State CombatStateData
_combat = _Newtype <<< key @"combat"

_expedition :: Lens' State ExpeditionStateData
_expedition = _Newtype <<< key @"expedition"

type CombatStateData =
  { hp :: Int
  , vigor :: Int
  , powerDice :: Map String Int
  , status :: Map Name Int
  , partyResolve :: Int
  }

_hp :: Lens' CombatStateData Int
_hp = key @"hp"

_vigor :: Lens' CombatStateData Int
_vigor = key @"vigor"

_powerDice :: Lens' CombatStateData (Map String Int)
_powerDice = key @"powerDice"

_status :: Lens' CombatStateData (Map Name Int)
_status = key @"status"

_partyResolve :: Lens' CombatStateData Int
_partyResolve = key @"partyResolve"

type ExpeditionStateData =
  { wounded :: Boolean
  , camps :: Int
  , personalResolve :: Int
  , combats :: Int
  }

_wounded :: Lens' ExpeditionStateData Boolean
_wounded = key @"wounded"

_camps :: Lens' ExpeditionStateData Int
_camps = key @"camps"

_personalResolve :: Lens' ExpeditionStateData Int
_personalResolve = key @"personalResolve"

_combats :: Lens' ExpeditionStateData Int
_combats = key @"combats"

type BuildData =
  { level :: Level
  , primary :: Name
  , jobs :: Map Name JobLevel
  , talents :: Array Id
  , abilities ::
      { active :: Array Name
      , inactive :: Array Name
      }
  }

newtype Build = Build BuildData

derive instance Newtype Build _
derive instance Eq Build

_level :: Lens' Build Level
_level = _Newtype <<< key @"level"

_primary :: Lens' Build Name
_primary = _Newtype <<< key @"primary"

_jobs :: Lens' Build (Map Name JobLevel)
_jobs = _Newtype <<< key @"jobs"

_talents :: Lens' Build (Array Id)
_talents = _Newtype <<< key @"talents"

_abilities :: Lens' Build { active :: Array Name, inactive :: Array Name }
_abilities = _Newtype <<< key @"abilities"

_active :: Lens' { active :: Array Name, inactive :: Array Name } (Array Name)
_active = key @"active"

_inactive :: Lens' { active :: Array Name, inactive :: Array Name } (Array Name)
_inactive = key @"inactive"

data Level
  = Zero
  | One
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  | Ten
  | Eleven
  | Twelve

derive instance Eq Level
derive instance Ord Level
instance Show Level where
  show = show <<< toInt

toInt :: Level -> Int
toInt Zero = 0
toInt One = 1
toInt Two = 2
toInt Three = 3
toInt Four = 4
toInt Five = 5
toInt Six = 6
toInt Seven = 7
toInt Eight = 8
toInt Nine = 9
toInt Ten = 10
toInt Eleven = 11
toInt Twelve = 12

fromInt :: Int -> Maybe Level
fromInt 0 = Just Zero
fromInt 1 = Just One
fromInt 2 = Just Two
fromInt 3 = Just Three
fromInt 4 = Just Four
fromInt 5 = Just Five
fromInt 6 = Just Six
fromInt 7 = Just Seven
fromInt 8 = Just Eight
fromInt 9 = Just Nine
fromInt 10 = Just Ten
fromInt 11 = Just Eleven
fromInt 12 = Just Twelve
fromInt _ = Nothing

stringCharacter :: Icon -> Codec' (Either ParseError) String Character
stringCharacter icon = codec' parseChar (serialise icon)
  where
  parseChar = (runParser ~$ (buildParser icon <* eof)) >>>
    map \(name /\ build) ->
      let
        job = icon # firstOf
          (I._jobs <<< folded <<< _name <<< filtered (eq (build ^. _primary)))
        hp = icon # firstOf
          ( I._classes
              <<< folded
              <<< filtered (eq job <<< preview _name)
              <<< C._hp
          )
      in
        Character
          { name
          , build
          , state: State
              { combat:
                  { hp: fromMaybe 0 hp
                  , vigor: 0
                  , powerDice: empty
                  , status: empty
                  , partyResolve: 0
                  }
              , expedition:
                  { wounded: false
                  , camps: 0
                  , personalResolve: 0
                  , combats: 0
                  }
              , interlude: {}
              }
          }

serialise :: Icon -> Character -> String
serialise icon (Character { name, build: Build build }) =
  intercalate "\n"
    [ "Name :: " <> unwrap name
    , "Level :: " <> show build.level
    , "Primary :: " <> unwrap build.primary
    , "Jobs :: " <>
        ( build.jobs
            # intercalate " | " <<< foldMapWithIndex \jn jl ->
                [ unwrap jn <> " " <> show jl ]
        )
    , "\nTalents"
    , build.talents # intercalate "\n" <<< map \t ->
        "- "
          <>
            ( icon # foldOf
                ( I._talents <<< traversed <<< filtered (eq t <<< view _id)
                    <<< _name
                    <<< _Newtype
                )
            )
          <>
            ( icon # foldMapOf
                ( I._jobs
                    <<< folded
                    <<< filtered
                      (has (J._talents <<< folded <<< filtered (eq t)))
                    <<< _name
                    <<< _Newtype
                )
                (" | " <> _)
            )
    , "\nAbilities"
    , build.abilities.active # intercalate "\n" <<< map \a -> "+ " <> unwrap a
        <>
          ( icon # foldMapOf
              ( I._jobs
                  <<< folded
                  <<< filtered
                    (has (J._abilities <<< folded <<< _2 <<< filtered (eq a)))
                  <<< _name
                  <<< _Newtype
              )
              (" | " <> _)
          )
    , build.abilities.inactive # intercalate "\n" <<< map \a -> "- " <> unwrap a
        <>
          ( icon # foldMapOf
              ( I._jobs
                  <<< folded
                  <<< filtered
                    (has (J._abilities <<< folded <<< _2 <<< filtered (eq a)))
                  <<< _name
                  <<< _Newtype
              )
              (" | " <> _)
          )
    ]

levelP :: Parser String Level
levelP = tryRethrow do
  n <- intDecimal
  liftMaybe (\_ -> "Invalid level " <> show n) $ fromInt n

label :: String -> Parser String Unit
label l =
  string l *>
    ( void (string "\n") <|>
        (skipSpaces *> (string "::" <|> string ":") *> skipSpaces)
    )

gap :: Parser String Unit
gap =
  optional (many (string "\n"))

optJob :: Icon -> Parser String Unit -> Parser String (Maybe Job)
optJob icon term = do
  jobName <- map (Name <<< fst) <$> optionMaybe
    ( (char '(' *> anyTill (char ')' *> term)) <|>
        (char '|' *> skipSpaces *> anyTill term)
    )
  case jobName of
    Nothing -> pure Nothing
    Just jn ->
      let
        foundJob = icon # firstOf
          (I._jobs <<< folded <<< filtered (eq jn <<< view _name))
      in
        case foundJob of
          Nothing -> fail $ "No job " <> jn ^. simple _Newtype
          Just fj -> pure $ Just fj

talent :: Icon -> Parser String Id
talent icon = do
  name <- fst <$> anyTill
    ( void (string "\n") <|> skipSpaces *> lookAhead
        (void (char '(' <|> char '|'))
    )
  job <- optJob icon (void (char '\n'))

  let
    ids = icon ^:: I._talents <<< traversed
      <<< filtered (eq name <<< view (_name <<< _Newtype))
      <<< _id

  case job of
    Nothing -> case uncons ids of
      Nothing -> fail $ "Invalid talent: " <> name
      Just { head, tail } -> case length tail of
        0 -> pure head
        _ -> fail $ "Several talents called " <> name <> ", try adding a job"
    Just j ->
      liftMaybe
        (\_ -> "No talent " <> name <> " for job " <> j ^. _name <<< _Newtype)
        $ j # firstOf
            (J._talents <<< traversed <<< filtered (elem ~$ ids))

ability :: Icon -> Parser String (Name /\ Boolean)
ability icon = do
  let
    term = choice
      [ void (string "\n")
      , eof
      , skipSpaces *> lookAhead (void (char '(' <|> char '|'))
      ]
  name /\ isActive <- choice
    [ map (\_ -> false) <$> (string "-" *> skipSpaces *> anyTill term)
    , map (\_ -> true) <$> (string "+" *> skipSpaces *> anyTill term)
    ]
  job <- optJob icon (void (char '\n') <|> eof)

  let
    names = icon ^:: I._abilities <<< traversed
      <<< filtered (eq name <<< view (_name <<< _Newtype))
      <<< _name

  ab <- case job of
    Nothing -> case uncons names of
      Nothing -> fail $ "Invalid ability: " <> name
      Just { head, tail } -> case length tail of
        0 -> pure head
        _ -> fail $ "Several abilities called " <> name <> ", try adding a job"
    Just j ->
      liftMaybe
        (\_ -> "No ability " <> name <> " for job " <> j ^. _name <<< _Newtype)
        $ j # firstOf
            (J._abilities <<< traversed <<< _2 <<< filtered (elem ~$ names))

  pure $ ab /\ isActive

buildParser :: Icon -> Parser String (Name /\ Build)
buildParser icon = do
  skipSpaces
  name /\ _ <- label "Name" *> anyTill (string "\n")

  gap
  level <- label "Level" *> levelP <* string "\n"

  gap
  primary /\ _ <- label "Primary" *> anyTill (string "\n")
  void $ liftMaybe (\_ -> "Invalid primary job name: " <> primary) $ icon #
    findOf
      (I._jobs <<< traversed <<< _name <<< _Newtype)
      (_ == primary)

  gap
  jobs <- label "Jobs"
    *>
      ( sepBy
          (anyTill (skipSpaces *> jobLevelP))
          (try (skipSpaces *> (char '|' <|> char '/') <* skipSpaces))
      )
    <* string "\n"
  jobs # traverse_ \(job /\ _) ->
    liftMaybe (\_ -> "Invalid job: " <> job) $ icon # findOf
      (I._jobs <<< traversed <<< _name <<< _Newtype)
      (_ == job)

  gap
  talents <- label "Talents" *>
    many (char '-' *> skipSpaces *> talent icon)

  gap
  abilities <- label "Abilities" *>
    many (ability icon)

  skipSpaces

  let
    { left: inactive, right: active } = abilities #
      partitionMap \(a /\ isActive) ->
        if isActive then Right a else Left a

  pure $ (Name name) /\ Build
    { level
    , primary: Name primary
    , jobs: fromFoldable (first Name <$> jobs)
    , talents
    , abilities: { active, inactive }
    }

jsonLevel :: CJ.Codec Level
jsonLevel = CJ.prismaticCodec "Level" fromInt toInt CJ.int

jsonCharacter :: CJ.Codec Character
jsonCharacter = CJ.coercible "Character" char_
  where
  char_ = CJR.object
    { name: jsonName
    , state: jsonState
    , build: jsonBuild
    }

jsonState :: CJ.Codec State
jsonState = CJ.coercible "State" state_
  where
  state_ :: CJ.Codec StateData
  state_ = CJR.object
    { combat: CJR.object
        { hp: CJ.int
        , vigor: CJ.int
        , powerDice: CJC.map CJ.string CJ.int
        , status: CJC.map jsonName CJ.int
        , partyResolve: CJ.int
        }
    , expedition: CJR.object
        { wounded: CJ.boolean
        , camps: CJ.int
        , personalResolve: CJ.int
        , combats: CJ.int
        }
    , interlude: CJR.object {}
    }

jsonBuild :: CJ.Codec Build
jsonBuild = CJ.coercible "Build" build_
  where
  build_ = CJR.object
    { level: jsonLevel
    , primary: jsonName
    , jobs: CJC.map jsonName jsonJobLevel
    , talents: CJ.array jsonId
    , abilities: CJR.object $
        { active: CJ.array jsonName
        , inactive: CJ.array jsonName
        }
    }
