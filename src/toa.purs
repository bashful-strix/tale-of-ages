module ToA where

import Prelude

import Halogen (Component, defaultEval, mkComponent, mkEval)
import Halogen.HTML as H
import Halogen.HTML.Core (ClassName(..))
import Halogen.HTML.Properties as HP

toa :: ∀ q i o m. Component q i o m
toa =
  mkComponent
    { initialState: const unit
    , render: render
    , eval: mkEval defaultEval
    }

  where
  render _ =
    H.div
      [ HP.classes $ ClassName <$>
          [ "w-full"
          , "h-screen"
          , "overflow-hidden"
          , "flex"
          , "items-center"
          , "justify-center"
          , "bg-stone-300"
          , "text-stone-700"
          , "dark:bg-stone-900"
          , "dark:text-stone-400"
          ]
      ]
      [ H.text "Tale of Ages" ]
