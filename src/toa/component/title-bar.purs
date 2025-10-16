module ToA.Component.TitleBar
  ( titleBar
  ) where

import Prelude

import Halogen as HC
import Halogen.HTML as H

import ToA.Util.Html (css)

titleBar :: ∀ q i o m. HC.Component q i o m
titleBar =
  HC.mkComponent
    { initialState: const unit
    , render
    , eval: HC.mkEval HC.defaultEval
    }

  where
  render _ =
    H.div
      [ css
          [ "h-10"
          , "w-full"
          , "flex"
          , "items-center"
          , "justify-between"
          , "p-2"
          , "bg-stone-500"
          , "text-stone-800"
          , "dark:bg-stone-700"
          , "dark:text-stone-300"
          ]
      ]
      [ H.div [] [ H.text "ToA" ]
      , H.div [] [ H.text "light" ]
      ]
