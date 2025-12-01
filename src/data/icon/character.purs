module ToA.Data.Icon.Character
  ( Character(..)
  , CharacterData
  , _hp
  , _vigor
  , _wounded
  , _scars
  , _build

  , Build(..)
  , BuildData
  , _level
  , _jobs
  , _primaryJob
  , _abilities
  , _prepared
  , _talents

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
import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, fromFoldable)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, unwrap)
import Data.Profunctor.Strong (first)
import Data.Tuple (fst)
import Data.Tuple.Nested (type (/\), (/\))

import Parsing (Parser, ParseError, liftMaybe, runParser)
import Parsing.Combinators ((<|>), choice, optional, sepBy, try, tryRethrow)
import Parsing.Combinators.Array (many)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon.Job (JobLevel, jobLevelP, jsonJobLevel)
import ToA.Data.Icon.Name (Name(..), class Named, jsonName)
import ToA.Util.Optic (key)

type CharacterData =
  { name :: Name
  , hp :: Int
  , vigor :: Int
  , wounded :: Boolean
  , scars :: Int
  , build :: Build
  }
newtype Character = Character CharacterData

derive instance Newtype Character _
instance Eq Character where
  eq (Character { name: n }) (Character { name: m }) = n == m

instance Named Character where
  _name = _Newtype <<< key @"name"

_hp :: Lens' Character Int
_hp = _Newtype <<< key @"hp"

_vigor :: Lens' Character Int
_vigor = _Newtype <<< key @"vigor"

_wounded :: Lens' Character Boolean
_wounded = _Newtype <<< key @"wounded"

_scars :: Lens' Character Int
_scars = _Newtype <<< key @"scars"

_build :: Lens' Character Build
_build = _Newtype <<< key @"build"

type BuildData =
  { level :: Level
  , jobs :: Map Name JobLevel
  , primaryJob :: Name
  , abilities :: Array Name
  , prepared :: Array Name
  , talents :: Array Name
  }
newtype Build = Build BuildData

_level :: Lens' Build Level
_level = _Newtype <<< key @"level"

_jobs :: Lens' Build (Map Name JobLevel)
_jobs = _Newtype <<< key @"jobs"

_primaryJob :: Lens' Build Name
_primaryJob = _Newtype <<< key @"primaryJob"

_abilities :: Lens' Build (Array Name)
_abilities = _Newtype <<< key @"abilities"

_prepared :: Lens' Build (Array Name)
_prepared = _Newtype <<< key @"prepared"

_talents :: Lens' Build (Array Name)
_talents = _Newtype <<< key @"talents"

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

stringCharacter :: Codec' (Either ParseError) String Character
stringCharacter = codec' parseChar serialise
  where
  parseChar = (runParser ~$ (buildParser <* eof)) >>> map \(name /\ build) ->
    Character { name, hp: 0, vigor: 0, wounded: false, scars: 0, build }

serialise :: Character -> String
serialise (Character { name, build: Build build }) =
  intercalate "\n"
    [ "Name :: " <> unwrap name
    , "Level :: " <> show build.level
    , "Primary :: " <> unwrap build.primaryJob
    , "Jobs :: " <>
        ( build.jobs
            # intercalate " | " <<< foldMapWithIndex \jn jl ->
                [ unwrap jn <> " " <> show jl ]
        )
    , "\nTalents"
    , build.talents # intercalate "\n" <<< map \t -> "- " <> unwrap t
    , "\nAbilities"
    , build.prepared # intercalate "\n" <<< map \a -> "+ " <> unwrap a
    , build.abilities # intercalate "\n" <<< map \a -> "- " <> unwrap a
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

buildParser :: Parser String (Name /\ Build)
buildParser = do
  _ <- skipSpaces
  name /\ _ <- label "Name" *> anyTill (string "\n")
  gap
  level <- label "Level" *> levelP <* string "\n"
  gap
  primaryJob /\ _ <- label "Primary" *> anyTill (string "\n")
  gap
  jobs <- label "Jobs"
    *>
      ( sepBy
          (anyTill (skipSpaces *> jobLevelP))
          (try (skipSpaces *> (char '|' <|> char '/') <* skipSpaces))
      )
    <* string "\n"
  gap
  talents <- label "Talents" *>
    many (char '-' *> skipSpaces *> anyTill (string "\n"))
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
  _ <- skipSpaces

  let
    { left: inactive, right: prepared } = abilities #
      partitionMap \(a /\ active) ->
        if active then Right (Name a) else Left (Name a)

  pure $ (Name name) /\ Build
    { level
    , jobs: fromFoldable (first Name <$> jobs)
    , primaryJob: Name primaryJob
    , abilities: inactive
    , prepared
    , talents: Name <<< fst <$> talents
    }

jsonLevel :: CJ.Codec Level
jsonLevel = CJ.prismaticCodec "Level" fromInt toInt CJ.int

jsonCharacter :: CJ.Codec Character
jsonCharacter = CJ.coercible "Character" char_
  where
  char_ = CJR.objectStrict
    { name: jsonName
    , hp: CJ.int
    , vigor: CJ.int
    , wounded: CJ.boolean
    , scars: CJ.int
    , build: jsonBuild
    }

jsonBuild :: CJ.Codec Build
jsonBuild = CJ.coercible "Build" build_
  where
  build_ = CJR.objectStrict
    { level: jsonLevel
    , jobs: CJC.map jsonName jsonJobLevel
    , primaryJob: jsonName
    , abilities: CJ.array jsonName
    , prepared: CJ.array jsonName
    , talents: CJ.array jsonName
    }
