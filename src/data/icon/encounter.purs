module ToA.Data.Icon.Encounter
  ( Encounter(..)
  , EncounterData
  , _players
  , _notes
  , _foes

  , FoeEntry(..)
  , FoeEntryData
  , _alias
  , _state
  , _faction
  , _template
  , _Active
  , _Reserve

  , FoeState(..)
  , FoeStateData
  , _hp
  , _vigor
  , _status

  , stringEncounter
  , jsonEncounter
  ) where

import ToA.Prelude

import Data.Codec (Codec', codec')
import Data.Codec.JSON as CJ
import Data.Codec.JSON.Common as CJC
import Data.Codec.JSON.Record as CJR
import Data.Array (length)
import Data.Either (Either(..))
import Data.Filterable (partition)
import Data.Function (on)
import Data.Lens ((^.), (^?), is, view, filtered, folded, _Just)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Lens (Lens', lens', lensStore)
import Data.Lens.Prism (Prism', prism')
import Data.Foldable (foldMap, intercalate)
import Data.Map (Map, empty)
import Data.Monoid (power)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Tuple (fst)

import Parsing (Parser, ParseError, liftMaybe, runParser)
import Parsing.Combinators (lookAhead, optional, optionMaybe)
import Parsing.Combinators.Array (many)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon (_foes, _foeClasses) as I
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Name (class Named, Name(..), jsonName, _name)

import ToA.Data.Icon.Foe.Job (_Legend, _hp) as J
import ToA.Data.Icon.Foe.Class (_hp) as C

import ToA.Util.Optic ((#~), key)

type FoeStateData =
  { hp :: Int
  , vigor :: Int
  , status :: Map Name Int
  }

newtype FoeState = FoeState FoeStateData

derive instance Newtype FoeState _
derive newtype instance Eq FoeState

_hp :: Lens' FoeState Int
_hp = _Newtype <. key @"hp"

_vigor :: Lens' FoeState Int
_vigor = _Newtype <. key @"vigor"

_status :: Lens' FoeState (Map Name Int)
_status = _Newtype <. key @"status"

jsonFoeState :: CJ.Codec FoeState
jsonFoeState = CJ.coercible "FoeState" foeState_
  where
  foeState_ = CJR.object
    { hp: CJ.int
    , vigor: CJ.int
    , status: CJC.map jsonName CJ.int
    }

type FoeEntryData =
  { name :: Name
  , alias :: Maybe String
  , faction :: Maybe Name
  , template :: Maybe Name
  , state :: Array FoeState
  }

data FoeEntry
  = Active FoeEntryData
  | Reserve FoeEntryData

instance Eq FoeEntry where
  eq = eq `on` view _name
    && eq `on` view _alias
    && eq `on` view _faction
    && eq `on` view _template

instance Named FoeEntry where
  _name = lens' case _ of
    Active f -> map Active <$> lensStore k f
    Reserve f -> map Reserve <$> lensStore k f
    where
    k = key @"name"

_alias :: Lens' FoeEntry (Maybe String)
_alias = lens' case _ of
  Active f -> map Active <$> lensStore k f
  Reserve f -> map Reserve <$> lensStore k f
  where
  k = key @"alias"

_faction :: Lens' FoeEntry (Maybe Name)
_faction = lens' case _ of
  Active f -> map Active <$> lensStore k f
  Reserve f -> map Reserve <$> lensStore k f
  where
  k = key @"faction"

_template :: Lens' FoeEntry (Maybe Name)
_template = lens' case _ of
  Active f -> map Active <$> lensStore k f
  Reserve f -> map Reserve <$> lensStore k f
  where
  k = key @"template"

_state :: Lens' FoeEntry (Array FoeState)
_state = lens' case _ of
  Active f -> map Active <$> lensStore k f
  Reserve f -> map Reserve <$> lensStore k f
  where
  k = key @"state"

_Active :: Prism' FoeEntry FoeEntryData
_Active = prism' Active case _ of
  Active f -> Just f
  _ -> Nothing

_Reserve :: Prism' FoeEntry FoeEntryData
_Reserve = prism' Reserve case _ of
  Reserve f -> Just f
  _ -> Nothing

jsonFoeEntry :: CJ.Codec FoeEntry
jsonFoeEntry = CJC.taggedSum "FoeEntry" printTag parseTag dec enc
  where
  printTag = case _ of
    true -> "Active"
    false -> "Reserve"
  parseTag = case _ of
    "Active" -> Just true
    "Reserve" -> Just false
    _ -> Nothing
  dec = case _ of
    true -> Right $ map Active <<< CJ.decode foeEntry_
    false -> Right $ map Reserve <<< CJ.decode foeEntry_
  enc = case _ of
    Active f -> true /\ Just (CJ.encode foeEntry_ f)
    Reserve f -> false /\ Just (CJ.encode foeEntry_ f)
  foeEntry_ = CJR.object
    { name: jsonName
    , alias: CJC.maybe CJ.string
    , faction: CJC.maybe jsonName
    , template: CJC.maybe jsonName
    , state: CJ.array jsonFoeState
    }

type EncounterData =
  { name :: Name
  , notes :: Maybe String
  , foes :: Array FoeEntry
  , players :: Int
  }

newtype Encounter = Encounter EncounterData

derive instance Newtype Encounter _
derive newtype instance Eq Encounter

instance Named Encounter where
  _name = _Newtype <. key @"name"

_players :: Lens' Encounter Int
_players = _Newtype <. key @"players"

_notes :: Lens' Encounter (Maybe String)
_notes = _Newtype <. key @"notes"

_foes :: Lens' Encounter (Array FoeEntry)
_foes = _Newtype <. key @"foes"

stringEncounter :: Icon -> Codec' (Either ParseError) String Encounter
stringEncounter icon = codec' parseEnc serialiseEncounter
  where
  parseEnc = (runParser ~$ (encounterParser icon <* eof))

serialiseFoeEntry :: FoeEntry -> String
serialiseFoeEntry e =
  "- "
    <> (show (length $ e ^. _state) <> "x ")
    <> (e # _template <. _Just <. _Newtype #~ \t -> "{" <> t <> "} ")
    <> (e # _faction <. _Just <. _Newtype #~ \f -> "[" <> f <> "] ")
    <> (e ^. _name <. _Newtype)
    <> (e # _alias <. _Just #~ (" | " <> _))

serialiseEncounter :: Encounter -> String
serialiseEncounter (Encounter { name, players, notes, foes }) =
  intercalate "\n"
    $ [ "Name :: " <> unwrap name ]
    <> [ "Players :: " <> show players ]
    <> (notes # foldMap \n -> [ "\nNotes", n ])
    <> [ "\nFoes", actives # intercalate "\n" <<< map serialiseFoeEntry ]
    <> [ "\nReserves", reserves # intercalate "\n" <<< map serialiseFoeEntry ]
  where
  { yes: actives, no: reserves } = partition (is _Active) foes

label :: String -> Parser String Unit
label l =
  string l *>
    ( void (string "\n") <|>
        (skipSpaces *> (string "::" <|> string ":") *> skipSpaces)
    )

gap :: Parser String Unit
gap = optional (many (string "\n"))

foeEntryP :: Icon -> Parser String Unit -> Parser String FoeEntryData
foeEntryP icon term = do
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

  foe <- liftMaybe (\_ -> "Invalid foe: " <> name ^. simple _Newtype) $ icon ^?
    (I._foes <. folded <. filtered (view _name >>> eq name))
  let
    classHp = icon ^?
      I._foeClasses <. folded <. filtered (view _name >>> eq (foe ^. _class))
        <. C._hp
    hp_ = foe ^. J._hp <|> classHp
    hp = fromMaybe 0 $ if foe # is J._Legend then hp_ * pure 4 else hp_

  let
    state = power [ FoeState { hp, vigor: 0, status: empty } ] count

  pure { name, alias, faction, template, state }

encounterParser :: Icon -> Parser String Encounter
encounterParser icon = do
  skipSpaces
  name /\ _ <- label "Name" *> anyTill (string "\n")
  gap
  players <- label "Players" *> intDecimal <* string "\n"
  gap
  notes <- map fst <$> optionMaybe (label "Notes" *> anyTill (string "\n\n"))
  gap
  foes <- label "Foes" *>
    many (string "-" *> skipSpaces *> foeEntryP icon (void (string "\n")))
  gap
  reserves <- label "Reserves" *>
    many
      (string "-" *> skipSpaces *> foeEntryP icon (void (string "\n") <|> eof))
  skipSpaces

  pure $ Encounter
    { name: Name name
    , players
    , notes
    , foes: (Active <$> foes) <> (Reserve <$> reserves)
    }

jsonEncounter :: CJ.Codec Encounter
jsonEncounter = CJ.coercible "Encounter" encounter_
  where
  encounter_ = CJR.object
    { name: jsonName
    , players: CJ.int
    , notes: CJC.maybe CJ.string
    , foes: CJ.array jsonFoeEntry
    }
