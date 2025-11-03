module Main
  ( main
  ) where

import Prelude
import PointFree ((<..))

import Control.Monad.ST.Class (liftST)
import Control.Alt ((<|>))

import Data.Maybe (Maybe(..))

import Effect (Effect)

import Deku.Toplevel (runInBody)
import FRP.Event (create)
import FRP.Poll (sham)

import Routing.PushState (PushStateInterface, makeInterface)

import Run (Run, EFFECT, runBaseEffect)
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (toa)
import ToA.Capability.Log (LOG, debug, error, info, runLog, warn)
import ToA.Capability.Navigate (NAVIGATE, matchRoutes, navigate, runNavigate)
import ToA.Capability.Storage (STORAGE, delete, read, runStorage, write)
import ToA.Capability.Theme (THEME, readStorage, readSystem, save, runTheme)
import ToA.Data.Log (Level(Debug))
import ToA.Resource.Icon (icon)

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win
  history <- makeInterface

  { event: theme, push: pushTheme } <- liftST create
  { event: route, push: pushRoute } <- liftST create

  let
    re = runEffects Debug storage history
    effects =
      { log:
          { error: re <<< error
          , warn: re <<< warn
          , info: re <<< info
          , debug: re <<< debug
          }
      , route:
          { navigate: re <.. navigate
          , matchRoutes: re <<< matchRoutes
          }
      , storage:
          { read: re <<< read
          , write: re <.. write
          , delete: re <<< delete
          }
      , theme:
          { save: \t -> (pushTheme t) *> (re $ save t)
          , readStorage: re readStorage
          , readSystem: re readSystem
          }
      }

  systemTheme <- effects.theme.readSystem
  storageTheme <- effects.theme.readStorage

  void $ runInBody $ toa
    { effects
    , icon: pure icon
    , route: pure Nothing <|> sham route
    , systemTheme
    , theme: pure storageTheme <|> sham theme
    }

  effects.route.matchRoutes (pushRoute <<< pure)
  effects.log.debug "started!"

runEffects
  :: Level
  -> Storage
  -> PushStateInterface
  -> Run (EFFECT + LOG + NAVIGATE + STORAGE + THEME + ()) ~> Effect
runEffects logLevel storage history =
  runBaseEffect
    <<< runLog logLevel
    <<< runStorage storage
    <<< runNavigate history
    <<< runTheme
