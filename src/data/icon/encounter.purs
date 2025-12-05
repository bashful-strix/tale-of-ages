module ToA.Data.Icon.Encounter
  ( Encounter(..)
  , EncounterData
  , FoeEntry(..)
  , FoeEntryData

  , stringEncounter
  , jsonEncounter
  ) where

import Prelude
import PointFree ((~$))

import Data.Codec (Codec', codec')
import Data.Codec.JSON as CJ
import Data.Codec.JSON.Common as CJC
import Data.Codec.JSON.Record as CJR
import Data.Either (Either)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Foldable (foldMap, intercalate)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Tuple (fst)
import Data.Tuple.Nested ((/\))

import Parsing (Parser, ParseError, runParser)
import Parsing.Combinators ((<|>), lookAhead, optional, optionMaybe)
import Parsing.Combinators.Array (many)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon.Name (Name(..), class Named, jsonName)
import ToA.Util.Optic (key)

type FoeEntryData =
  { name :: Name
  , alias :: Maybe String
  , count :: Int
  , faction :: Maybe Name
  , template :: Maybe Name
  }

newtype FoeEntry = FoeEntry FoeEntryData

derive newtype instance Eq FoeEntry

jsonFoeEntry :: CJ.Codec FoeEntry
jsonFoeEntry = CJ.coercible "FoeEntry" foeEntry_
  where
  foeEntry_ = CJR.object
    { name: jsonName
    , alias: CJC.maybe CJ.string
    , count: CJ.int
    , faction: CJC.maybe jsonName
    , template: CJC.maybe jsonName
    }

type EncounterData =
  { name :: Name
  , notes :: Maybe String
  , foes :: Array FoeEntry
  , reserves :: Array FoeEntry
  }

newtype Encounter = Encounter EncounterData

derive instance Newtype Encounter _
derive newtype instance Eq Encounter

instance Named Encounter where
  _name = _Newtype <<< key @"name"

stringEncounter :: Codec' (Either ParseError) String Encounter
stringEncounter = codec' parseEnc serialiseEncounter
  where
  parseEnc = (runParser ~$ (encounterParser <* eof))

serialiseFoeEntry :: FoeEntry -> String
serialiseFoeEntry (FoeEntry { name: foeName, alias, count, faction, template }) =
  "- "
    <> show count
    <> "x "
    <> (template # foldMap \t -> "{" <> unwrap t <> "} ")
    <> (faction # foldMap \f -> "[" <> unwrap f <> "] ")
    <> unwrap foeName
    <> (alias # foldMap \a -> " | " <> a)

serialiseEncounter :: Encounter -> String
serialiseEncounter (Encounter { name, notes, foes, reserves }) =
  intercalate "\n" $
    [ "Name :: " <> unwrap name ]
      <> (notes # foldMap \n -> [ "\nNotes", n ])
      <>
        [ "\nFoes"
        , foes # intercalate "\n" <<< map serialiseFoeEntry
        ]
      <>
        [ "\nReserves"
        , reserves # intercalate "\n" <<< map serialiseFoeEntry
        ]

label :: String -> Parser String Unit
label l =
  string l *>
    ( void (string "\n") <|>
        (skipSpaces *> (string "::" <|> string ":") *> skipSpaces)
    )

gap :: Parser String Unit
gap = optional (many (string "\n"))

foeEntryP :: Parser String Unit -> Parser String FoeEntry
foeEntryP term = do
  count <- intDecimal <* string "x"
  skipSpaces
  template <- map (Name <<< fst) <$> optionMaybe
    (char '{' *> skipSpaces *> anyTill (skipSpaces *> char '}'))
  skipSpaces
  faction <- map (Name <<< fst) <$> optionMaybe
    (char '[' *> skipSpaces *> anyTill (skipSpaces *> char ']'))
  skipSpaces
  name <- Name <<< fst <$> anyTill
    (term <|> skipSpaces *> lookAhead (void (char '|')))
  alias <- map fst <$> optionMaybe (char '|' *> skipSpaces *> anyTill term)

  pure $ FoeEntry { name, alias, count, faction, template }

encounterParser :: Parser String Encounter
encounterParser = do
  skipSpaces
  name /\ _ <- label "Name" *> anyTill (string "\n")
  gap
  notes <- map fst <$> optionMaybe (label "Notes" *> anyTill (string "\n\n"))
  gap
  foes <- label "Foes" *>
    many (string "-" *> skipSpaces *> foeEntryP (void (string "\n")))
  gap
  reserves <- label "Reserves" *>
    many (string "-" *> skipSpaces *> foeEntryP (void (string "\n") <|> eof))
  skipSpaces

  pure $ Encounter { name: Name name, notes, foes, reserves }

jsonEncounter :: CJ.Codec Encounter
jsonEncounter = CJ.coercible "Encounter" encounter_
  where
  encounter_ = CJR.object
    { name: jsonName
    , notes: CJC.maybe CJ.string
    , foes: CJ.array jsonFoeEntry
    , reserves: CJ.array jsonFoeEntry
    }
