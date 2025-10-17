module Main where

import Prelude
import PointFree ((<..))
import Data.Lens ((^.))

import Control.Monad.ST.Class (liftST)
import Control.Alt ((<|>))

import Effect (Effect)

import Deku.Toplevel (runInBody)
import FRP.Event (create)
import FRP.Poll (sham)

import Run (Run, EFFECT, runBaseEffect)
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (toa)
import ToA.Capability.Log (LOG, debug, error, info, runLog, warn)
import ToA.Capability.Storage (STORAGE, delete, read, runStorage, write)
import ToA.Capability.Theme (THEME, readStorage, readSystem, save, runTheme)
import ToA.Data.Env (_debugLog)
import ToA.Data.Log (Level(Debug))

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win

  { event: theme, push: pushTheme } <- liftST create

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
      , theme:
          { save: \t -> do
              pushTheme t
              re $ save t
          , readStorage: re readStorage
          , readSystem: re readSystem
          }
      }

  systemTheme <- effects.theme.readSystem
  storageTheme <- effects.theme.readStorage

  let
    world =
      { effects
      , systemTheme
      , theme: pure storageTheme <|> sham theme
      }

  void $ runInBody $ toa world
  world ^. _debugLog $ "started!"

runEffects
  :: Level -> Storage -> Run (EFFECT + LOG + STORAGE + THEME + ()) ~> Effect
runEffects logLevel storage =
  runBaseEffect <<< runLog logLevel <<< runStorage storage <<< runTheme
