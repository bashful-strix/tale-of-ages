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
import ToA.Capability.Encounter as CE
import ToA.Capability.Log as CL
import ToA.Capability.Navigate as CN
import ToA.Capability.Storage as CS
import ToA.Capability.Theme as CT
import ToA.Data.Log (Level(Debug))
import ToA.Resource.Icon (icon)

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win
  history <- makeInterface

  _ /\ pushChars /\ characters <- useHot empty
  _ /\ pushEncs /\ encounters <- useHot empty
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
      , encounter:
          { save: \e -> do
              es <- re (CE.save e *> CE.readStorage)
              pushEncs $ fromMaybe empty es
          , delete: \e -> do
              es <- re (CE.delete e *> CE.readStorage)
              pushEncs $ fromMaybe empty es
          , readStorage: (re $ CE.readStorage) <#> fromMaybe empty
          }
      , log:
          { error: re <<< CL.error
          , warn: re <<< CL.warn
          , info: re <<< CL.info
          , debug: re <<< CL.debug
          }
      , route:
          { navigate: re <.. CN.navigate
          , matchRoutes: re <<< CN.matchRoutes
          }
      , storage:
          { read: re <<< CS.read
          , write: re <.. CS.write
          , delete: re <<< CS.delete
          }
      , theme:
          { save: \t -> (pushTheme t) *> (re $ CT.save t)
          , readStorage: re CT.readStorage
          , readSystem: re CT.readSystem
          }
      }

  storageChars <- effects.character.readStorage
  pushChars storageChars
  storageEncs <- effects.encounter.readStorage
  pushEncs storageEncs

  systemTheme <- effects.theme.readSystem
  storageTheme <- effects.theme.readStorage

  void $ runInBody $ toa
    { effects
    , icon: pure icon
    , characters
    , encounters
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
  -> Run
       ( EFFECT
           + CC.CHAR
           + CE.ENCOUNTER
           + CL.LOG
           + CN.NAVIGATE
           + CS.STORAGE
           + CT.THEME
           + ()
       )
       ~> Effect
runEffects logLevel storage history =
  runBaseEffect
    <<< CL.runLog logLevel
    <<< CS.runStorage storage
    <<< CN.runNavigate history
    <<< CT.runTheme
    <<< CC.runCharacter
    <<< CE.runEncounter
