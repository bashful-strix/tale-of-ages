module Main where

import Prelude
import PointFree ((<..))
import Data.Lens ((^.))

import Deku.Toplevel (runInBody)

import Effect (Effect)

import Run (Run, EFFECT, runBaseEffect)
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (toa)
import ToA.Capability.Log (LOG, debug, error, info, runLog, warn)
import ToA.Capability.Storage (STORAGE, delete, read, runStorage, write)
import ToA.Data.Env (_debugLog)
import ToA.Data.Log (Level(Debug))

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win

  let
    re = runEffects Debug storage
    effects =
      { log:
          { error: re <<< error
          , warn: re <<< warn
          , info: re <<< info
          , debug: re <<< debug
          }
      , storage:
          { read: re <<< read
          , write: re <.. write
          , delete: re <<< delete
          }
      }

    world =
      { effects
      }

  void $ runInBody $ toa
  world ^. _debugLog $ "started!"

runEffects
  :: Level -> Storage -> Run (EFFECT + LOG + STORAGE + ()) ~> Effect
runEffects logLevel storage =
  runBaseEffect <<< runLog logLevel <<< runStorage storage
