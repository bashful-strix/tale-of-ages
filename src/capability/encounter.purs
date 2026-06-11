module ToA.Capability.Encounter
  ( class Encounter
  , saveEnc
  , deleteEnc
  , readEncs
  ) where

import Prelude

import Data.Codec.JSON (Codec, decode, encode)
import Data.Codec.JSON.Common (map) as CJC
import Data.Either (hush)
import Data.Lens ((^.), (.~))
import Data.Lens.At (at)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, empty, singleton)
import Data.Maybe (Maybe(..), maybe)
import JSON (parse, print)

import Halogen (HalogenM, lift)
import Halogen.Store.Monad (updateStore)

import ToA.ToAM (ToAM)
import ToA.Capability.Log (debug)
import ToA.Capability.Storage (read, write)
import ToA.Data.Icon.Encounter (Encounter, jsonEncounter)
import ToA.Data.Icon.Name (Name, _name, jsonName)

class Encounter m where
  saveEnc :: Encounter -> m Unit
  deleteEnc :: Encounter -> m Unit
  readEncs :: m (Maybe (Map Name Encounter))

encMap :: Codec (Map Name Encounter)
encMap = CJC.map jsonName jsonEncounter

instance Encounter ToAM where
  saveEnc enc = do
    debug $ "save encounter: " <> enc ^. _name <<< _Newtype
    encs <- readEncs
    let
      newEncs = case encs of
        Nothing -> singleton (enc ^. _name) enc
        Just es -> es # at (enc ^. _name) .~ pure enc
    updateStore _ { encounters = newEncs }
    write "encounters" $ print $ encode encMap newEncs

  deleteEnc enc = do
    debug $ "delete encounter: " <> enc ^. _name <<< _Newtype
    encs <- readEncs
    let newEncs = encs # maybe empty (at (enc ^. _name) .~ Nothing)
    updateStore _ { encounters = newEncs }
    write "encounters" $ print $ encode encMap newEncs

  readEncs = do
    debug $ "read storage encounters"
    read "encounters"
      <#> (_ >>= (parse >>> hush >=> decode encMap >>> hush))

instance (Monad m, Encounter m) => Encounter (HalogenM s a sl o m) where
  saveEnc = lift <<< saveEnc
  deleteEnc = lift <<< deleteEnc
  readEncs = lift readEncs
