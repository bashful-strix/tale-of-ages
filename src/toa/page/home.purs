module ToA.Page.Home
  ( homePage
  ) where

import Prelude

import Halogen as HC
import Halogen.HTML as H

import ToA.Util.Html (css)

homePage :: ∀ q i o m. HC.Component q i o m
homePage =
  HC.mkComponent
    { initialState: const unit
    , render
    , eval: HC.mkEval HC.defaultEval
    }

  where
  render _ =
    H.div
      [ css
          [ "flex"
          , "grow"
          , "items-center"
          , "justify-center"
          ]
      ]
      [ H.text "Tale of Ages" ]
