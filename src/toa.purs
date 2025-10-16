module ToA where

import Prelude

import Halogen  as HC
import Halogen.HTML as H

import Type.Proxy (Proxy(..))

import ToA.Component.TitleBar (titleBar)
import ToA.Util.Html (css)

type Slots = (titleBar :: ∀ q. HC.Slot q Void Unit)

toa :: ∀ q i o m. HC.Component q i o m
toa =
  HC.mkComponent
    { initialState: const unit
    , render
    , eval: HC.mkEval HC.defaultEval
    }

  where
  render _ =
    H.div
      [ css
          [ "w-dvw"
          , "h-dvh"
          , "flex"
          , "items-center"
          , "justify-center"
          , "flex-col"
          , "bg-stone-300"
          , "text-stone-700"
          , "dark:bg-stone-900"
          , "dark:text-stone-400"
          ]
      ]
      [ H.slot_ (Proxy :: _ "titleBar") unit titleBar unit
      , H.div
          [ css
              [ "flex"
              , "grow"
              , "items-center"
              , "justify-center"
              , "overflow-hidden"
              ]
          ]
          [ H.text "Tale of Ages" ]
      ]
