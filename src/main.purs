module Main where

import Prelude

import Effect (Effect)

import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

import ToA (toa)

main :: Effect Unit
main =
  runHalogenAff $ awaitBody >>= runUI toa unit
