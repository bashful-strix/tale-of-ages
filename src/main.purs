module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Deku.DOM as D
import Deku.Toplevel (runInBody)

main :: Effect Unit
main = do
  log "🍝"
  void $ runInBody $ D.text_ "init"
