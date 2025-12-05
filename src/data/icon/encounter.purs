module ToA.Data.Icon.Encounter
  ( Encounter(..)
  , EncounterData
  , FoeEntry(..)
  , FoeEntryData

  , jsonEncounter
  ) where

import Prelude

import Data.Codec.JSON as CJ
import Data.Codec.JSON.Common as CJC
import Data.Codec.JSON.Record as CJR
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Name (Name, class Named, jsonName)
import ToA.Util.Optic (key)

type FoeEntryData =
  { name :: Name
  , alias :: Maybe String
  , count :: Int
  , faction :: Maybe Name
  , template :: Maybe Name
  }

newtype FoeEntry = FoeEntry FoeEntryData

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

instance Named Encounter where
  _name = _Newtype <<< key @"name"

jsonEncounter :: CJ.Codec Encounter
jsonEncounter = CJ.coercible "Encounter" encounter_
  where
  encounter_ = CJR.object
    { name: jsonName
    , notes: CJC.maybe CJ.string
    , foes: CJ.array jsonFoeEntry
    , reserves: CJ.array jsonFoeEntry
    }
