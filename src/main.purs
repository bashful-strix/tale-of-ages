module Main where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)

import Halogen (hoist)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import Run (Run, AFF, EFFECT, runBaseAff')
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (toa)
import ToA.Capability.Log (LOG, runLog)
import ToA.Capability.Storage (STORAGE, runStorage)
import ToA.Data.Log (Level(Debug))

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win

  runHalogenAff $ awaitBody
    >>= runUI (hoist (runEffects Debug storage) toa) unit

runEffects :: Level -> Storage -> Run (AFF + EFFECT + LOG + STORAGE + ()) ~> Aff
runEffects logLevel storage =
  runBaseAff' <<< runLog logLevel <<< runStorage storage
