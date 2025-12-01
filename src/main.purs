module Main
  ( main
  ) where

import Prelude
import PointFree ((<..))

import Control.Alt ((<|>))

import Data.Map (empty)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))

import Effect (Effect)

import Deku.Effect (useHot, useState, useState')
import Deku.Toplevel (runInBody)

import Routing.PushState (PushStateInterface, makeInterface)

import Run (Run, EFFECT, runBaseEffect)
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (toa)
import ToA.Capability.Character as CC
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

  _ /\ pushChars /\ characters <- useHot empty
  pushRoute /\ route <- useState Nothing
  pushTheme /\ theme <- useState'

  let
    re = runEffects Debug storage history
    effects =
      { character:
          { save: \c -> do
              cs <- re (CC.save c *> CC.readStorage)
              pushChars $ fromMaybe empty cs
          , delete: \c -> do
              cs <- re (CC.delete c *> CC.readStorage)
              pushChars $ fromMaybe empty cs
          , readStorage: (re $ CC.readStorage) <#> fromMaybe empty
          }
      , log:
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

  storageChars <- effects.character.readStorage
  pushChars storageChars

  systemTheme <- effects.theme.readSystem
  storageTheme <- effects.theme.readStorage

  void $ runInBody $ toa
    { effects
    , icon: pure icon
    , characters
    , encounters: pure []
    , route
    , systemTheme
    , theme: pure storageTheme <|> theme
    }

  effects.route.matchRoutes (pushRoute <<< pure)
  effects.log.debug "started!"

runEffects
  :: Level
  -> Storage
  -> PushStateInterface
  -> Run (CC.CHAR + EFFECT + LOG + NAVIGATE + STORAGE + THEME + ()) ~> Effect
runEffects logLevel storage history =
  runBaseEffect
    <<< runLog logLevel
    <<< runStorage storage
    <<< runNavigate history
    <<< runTheme
    <<< CC.runCharacter
