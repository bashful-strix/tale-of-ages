module Main where

import Prelude

import Effect (Effect)

import Deku.Toplevel (runInBody)

import ToA (toa)

main :: Effect Unit
main =
  void $ runInBody $ toa
