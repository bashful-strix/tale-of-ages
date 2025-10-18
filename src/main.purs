module Main
  ( main
  ) where

import Prelude

import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (Aff, launchAff_)

import Halogen (mkTell, hoist)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.Store.Monad (runStoreT)
import Halogen.VDom.Driver (runUI)

import Routing.Duplex (parse)
import Routing.PushState (PushStateInterface, makeInterface, matchesWith)

import Run (Run, AFF, EFFECT, runBaseAff')
import Type.Row (type (+))

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (Storage)

import ToA (Query(..), toa)
import ToA.Capability.Log (LOG, runLog)
import ToA.Capability.Navigate (NAVIGATE, runNavigate)
import ToA.Capability.Storage (STORAGE, runStorage)
import ToA.Capability.Theme (THEME, runTheme)
import ToA.Data.Env (initialEnv, reduce)
import ToA.Data.Log (Level(Debug))
import ToA.Data.Route (routeCodec)

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win
  history <- makeInterface

  runHalogenAff $ do
    body <- awaitBody
    root <- runStoreT initialEnv reduce toa
    io <- runUI (hoist (runEffects Debug storage history) root) unit body

    history # liftEffect <<< matchesWith
      (parse routeCodec)
      \old new ->
        when (pure new /= old)
          ( launchAff_ $ void $ io.query
              $ mkTell (TellRoute (pure new))
          )

runEffects
  :: Level
  -> Storage
  -> PushStateInterface
  -> Run (AFF + EFFECT + LOG + NAVIGATE + STORAGE + THEME + ()) ~> Aff
runEffects logLevel storage history =
  runBaseAff'
    <<< runLog logLevel
    <<< runStorage storage
    <<< runNavigate history
    <<< runTheme
