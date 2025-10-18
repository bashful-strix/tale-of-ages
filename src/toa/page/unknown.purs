module ToA.Page.Unknown
  ( unknownPage
  ) where

import Prelude

import Halogen as HC
import Halogen.HTML as H

import ToA.Util.Html (css)

unknownPage :: ∀ q i o m. HC.Component q i o m
unknownPage =
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
      [ H.text "Whoops! We can't find that page..." ]
