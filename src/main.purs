module Main where

import Prelude

import Data.Lens ((^.))

import Deku.Toplevel (runInBody)

import Effect (Effect)

import Run (Run, EFFECT, runBaseEffect)
import Type.Row (type (+))

import ToA (toa)
import ToA.Capability.Log (LOG, debug, error, info, runLog, warn)
import ToA.Data.Log (Level(Debug))
import ToA.Data.Env (_debugLog)

main :: Effect Unit
main = do
  let
    re = runEffects Debug
    effects =
      { log:
          { error: re <<< error
          , warn: re <<< warn
          , info: re <<< info
          , debug: re <<< debug
          }
      }

    world =
      { effects
      }

  void $ runInBody $ toa
  world ^. _debugLog $ "started!"

runEffects :: Level -> Run (EFFECT + LOG + ()) ~> Effect
runEffects logLevel =
  runBaseEffect <<< runLog logLevel
