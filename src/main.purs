module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

import Halogen (defaultEval, mkComponent, mkEval)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.HTML as H
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  log "🍝"
  runHalogenAff $
    runUI component unit =<< awaitBody

  where
  component =
    mkComponent
      { initialState: const unit
      , render: const $ H.text "init"
      , eval: mkEval defaultEval
      }
