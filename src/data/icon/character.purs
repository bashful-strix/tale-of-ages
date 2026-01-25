module ToA.Data.Icon.Character
  ( Character(..)
  , CharacterData
  , _build

  , State(..)
  , StateData

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

import Data.Codec (Codec', codec')
import Data.Codec.JSON as CJ
import Data.Codec.JSON.Common as CJC
import Data.Codec.JSON.Record as CJR
import Data.Either (Either(..))
import Data.Filterable (partitionMap)
import Data.Foldable (intercalate)
import Data.FoldableWithIndex (foldMapWithIndex)
import Data.Lens (Lens', traversed)
import Data.Lens.Fold (findOf)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, fromFoldable)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Data.Profunctor.Strong (first)
import Data.Traversable (traverse_)
import Data.Tuple (fst)
import Data.Tuple.Nested (type (/\), (/\))

import Parsing (Parser, ParseError, liftMaybe, runParser)
import Parsing.Combinators ((<|>), choice, optional, sepBy, try, tryRethrow)
import Parsing.Combinators.Array (many)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon (_abilities, _jobs, _talents) as I
import ToA.Data.Icon.Job (JobLevel, jobLevelP, jsonJobLevel)
import ToA.Data.Icon.Name (Name(..), class Named, _name, jsonName)
import ToA.Util.Optic (key)

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

type StateData = {}
newtype State = State StateData

type BuildData =
  { level :: Level
  , primary :: Name
  , jobs :: Map Name JobLevel
  , talents :: Array Name
  , abilities ::
      { active :: Array Name
      , inactive :: Array Name
      }
  }

newtype Build = Build BuildData

_level :: Lens' Build Level
_level = _Newtype <<< key @"level"

_primary :: Lens' Build Name
_primary = _Newtype <<< key @"primary"

_jobs :: Lens' Build (Map Name JobLevel)
_jobs = _Newtype <<< key @"jobs"

_talents :: Lens' Build (Array Name)
_talents = _Newtype <<< key @"talents"

_abilities :: Lens' Build { active :: Array Name, inactive :: Array Name }
_abilities = _Newtype <<< key @"abilities"

_active :: Lens' { active :: Array Name, inactive :: Array Name } (Array Name)
_active = key @"active"

_inactive :: Lens' { active :: Array Name, inactive :: Array Name } (Array Name)
_inactive = key @"inactive"

derive instance Newtype Build _
derive instance Eq Build

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
stringCharacter icon = codec' parseChar serialise
  where
  parseChar = (runParser ~$ (buildParser icon <* eof)) >>>
    map \(name /\ build) -> Character { name, state: State {}, build }

serialise :: Character -> String
serialise (Character { name, build: Build build }) =
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
    , build.talents # intercalate "\n" <<< map \t -> "- " <> unwrap t
    , "\nAbilities"
    , build.abilities.active # intercalate "\n" <<< map \a -> "+ " <> unwrap a
    , build.abilities.inactive # intercalate "\n" <<< map \a -> "- " <> unwrap a
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

buildParser :: Icon -> Parser String (Name /\ Build)
buildParser icon = do
  skipSpaces
  name /\ _ <- label "Name" *> anyTill (string "\n")
  gap
  level <- label "Level" *> levelP <* string "\n"
  gap
  primary /\ _ <- label "Primary" *> anyTill (string "\n")
  void $ liftMaybe (\_ -> "Invalid primary job name: " <> primary) $
    icon # findOf (I._jobs <<< traversed <<< _name <<< _Newtype) (_ == primary)

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
    many (char '-' *> skipSpaces *> anyTill (string "\n"))
  talents # traverse_ \(talent /\ _) ->
    liftMaybe (\_ -> "Invalid talent: " <> talent) $ icon # findOf
      (I._talents <<< traversed <<< _name <<< _Newtype)
      (_ == talent)

  gap
  abilities <- label "Abilities" *>
    many
      ( choice
          [ map (\_ -> false) <$>
              (string "-" *> skipSpaces *> anyTill (void (string "\n") <|> eof))
          , map (\_ -> true) <$>
              (string "+" *> skipSpaces *> anyTill (void (string "\n") <|> eof))
          ]
      )
  abilities # traverse_ \(ability /\ _) ->
    liftMaybe (\_ -> "Invalid ability: " <> ability) $ icon # findOf
      (I._abilities <<< traversed <<< _name <<< _Newtype)
      (_ == ability)

  skipSpaces

  let
    { left: inactive, right: active } = abilities #
      partitionMap \(a /\ isActive) ->
        if isActive then Right (Name a) else Left (Name a)

  pure $ (Name name) /\ Build
    { level
    , primary: Name primary
    , jobs: fromFoldable (first Name <$> jobs)
    , talents: Name <<< fst <$> talents
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
  state_ = CJR.object {}

jsonBuild :: CJ.Codec Build
jsonBuild = CJ.coercible "Build" build_
  where
  build_ = CJR.object
    { level: jsonLevel
    , primary: jsonName
    , jobs: CJC.map jsonName jsonJobLevel
    , talents: CJ.array jsonName
    , abilities: CJR.object $
        { active: CJ.array jsonName
        , inactive: CJ.array jsonName
        }
    }
