module Main
  ( main
  ) where

import ToA.Prelude

import Data.Map (empty)
import Data.Maybe (Maybe(..))

import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (launchAff_)

import Halogen (mkTell)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import Routing.Duplex (parse)
import Routing.PushState (makeInterface, matchesWith)

import ToA (Query(..), toa)
import ToA.ToAM (runToAM)
import ToA.Data.Log (Level(Debug, Info))
import ToA.Data.Route (routeCodec)
import ToA.Data.Theme (Theme(..))
import ToA.Resource.Icon (icon)

main :: Boolean -> Effect Unit
main isDev = do
  history <- makeInterface

  runHalogenAff do
    body <- awaitBody
    root <- runToAM
      { icon
      , characters: empty
      , encounters: empty
      , route: Nothing
      , systemTheme: Light
      , theme: Nothing

      , logLevel: if isDev then Debug else Info
      , history
      }
      toa
    io <- runUI root unit body

    void $ liftEffect $ history # matchesWith
      (parse routeCodec)
      \old new -> when (pure new /= old) $ launchAff_
        (void $ io.query $ mkTell $ OnRoute new)
