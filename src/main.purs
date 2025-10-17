module Main where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)

import Halogen (hoist)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.Store.Monad (runStoreT)
import Halogen.VDom.Driver (runUI)

import Run (Run, AFF, EFFECT, runBaseAff')
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (toa)
import ToA.Capability.Log (LOG, runLog)
import ToA.Capability.Storage (STORAGE, runStorage)
import ToA.Capability.Theme (THEME, runTheme)
import ToA.Data.Env (initialEnv, reduce)
import ToA.Data.Log (Level(Debug))

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win

  runHalogenAff $ do
    body <- awaitBody
    root <- runStoreT initialEnv reduce toa
    runUI (hoist (runEffects Debug storage) root) unit body

runEffects
  :: Level -> Storage -> Run (AFF + EFFECT + LOG + STORAGE + THEME + ()) ~> Aff
runEffects logLevel storage =
  runBaseAff' <<< runLog logLevel <<< runStorage storage <<< runTheme
