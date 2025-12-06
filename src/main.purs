module Main
  ( main
  ) where

import ToA.Prelude

import Data.Map (empty)
import Data.Maybe (Maybe(..))

import Effect (Effect)

import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import Routing.PushState (makeInterface)

import Web.HTML (window)
import Web.HTML.Window (localStorage)

import ToA (toa)
import ToA.ToAM (runToAM)
import ToA.Capability.Character as CC
import ToA.Capability.Encounter as CE
import ToA.Capability.Log as CL
import ToA.Capability.Navigate as CN
import ToA.Capability.Storage as CS
import ToA.Capability.Theme as CT
import ToA.Data.Log (Level(Debug))
import ToA.Data.Theme (Theme(..))
import ToA.Resource.Icon (icon)

main :: Effect Unit
main = do
  win <- window
  storage <- localStorage win
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
      }
      ( CL.runLog Debug
          <<< CS.runStorage storage
          <<< CN.runNavigate history
          <<< CT.runTheme
          <<< CC.runCharacter
          <<< CE.runEncounter
      )
      toa
    runUI root unit body
