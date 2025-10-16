module Main where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)

import Halogen (hoist)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import Run (Run, AFF, EFFECT, runBaseAff')
import Type.Row (type (+))

import ToA (toa)
import ToA.Capability.Log (LOG, runLog)
import ToA.Data.Log (Level(Debug))

main :: Effect Unit
main =
  runHalogenAff $ awaitBody >>= runUI (hoist (runEffects Debug) toa) unit

runEffects :: Level -> Run (AFF + EFFECT + LOG + ()) ~> Aff
runEffects logLevel =
  runBaseAff' <<< runLog logLevel
