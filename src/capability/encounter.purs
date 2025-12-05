module ToA.Capability.Encounter
  ( EncounterF
  , ENCOUNTER

  , runEncounter

  , save
  , delete
  , readStorage
  ) where

import Prelude

import Data.Codec.JSON (Codec, decode, encode)
import Data.Codec.JSON.Common (map) as CJC
import Data.Either (hush)
import Data.Lens ((^.), (.~))
import Data.Lens.At (at)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, empty, singleton)
import Data.Maybe (Maybe(..))
import JSON (parse, print)

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Capability.Log (LOG, debug)
import ToA.Capability.Storage (STORAGE, read, write)
import ToA.Data.Icon.Encounter (Encounter, jsonEncounter)
import ToA.Data.Icon.Name (Name, _name, jsonName)

data EncounterF a
  = Save Encounter a
  | Delete Encounter a
  | ReadStorage (Maybe (Map Name Encounter) -> a)

derive instance Functor EncounterF

type ENCOUNTER r = (enccounter :: EncounterF | r)
_enccounter = Proxy :: Proxy "enccounter"

save :: ∀ r. Encounter -> Run (ENCOUNTER + r) Unit
save enc = lift _enccounter (Save enc unit)

delete :: ∀ r. Encounter -> Run (ENCOUNTER + r) Unit
delete enc = lift _enccounter (Delete enc unit)

readStorage :: ∀ r. Run (ENCOUNTER + r) (Maybe (Map Name Encounter))
readStorage = lift _enccounter (ReadStorage identity)

encMap :: Codec (Map Name Encounter)
encMap = CJC.map jsonName jsonEncounter

browserEnc :: ∀ r. EncounterF ~> Run (EFFECT + LOG + STORAGE + r)
browserEnc = case _ of
  Save enc next -> do
    debug $ "save encounter: " <> enc ^. _name <<< _Newtype
    es <- read "encounters"
    write "encounters" $ print $ encode encMap $
      case es >>= parse >>> hush >>= decode encMap >>> hush of
        Nothing -> singleton (enc ^. _name) enc
        Just encs -> encs # at (enc ^. _name) .~ pure enc
    pure next

  Delete enc next -> do
    debug $ "delete encounter: " <> enc ^. _name <<< _Newtype
    es <- read "encounters"
    write "encounters" $ print $ encode encMap $
      case es >>= parse >>> hush >>= decode encMap >>> hush of
        Nothing -> empty
        Just encs -> encs # at (enc ^. _name) .~ Nothing
    pure next

  ReadStorage reply -> do
    debug $ "read storage encounters"
    read "encounters"
      <#> reply <<< (_ >>= (parse >>> hush >=> decode encMap >>> hush))

runEncounter
  :: ∀ r. Run (EFFECT + LOG + STORAGE + ENCOUNTER + r) ~> Run (EFFECT + LOG + STORAGE + r)
runEncounter = interpret (on _enccounter browserEnc send)
