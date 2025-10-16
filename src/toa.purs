module ToA where

import Prelude

import Halogen as HC
import Halogen.HTML as H

import Run (Run, AFF, EFFECT)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Capability.Log (LOG, debug)
import ToA.Component.TitleBar (titleBar)
import ToA.Util.Html (css)

type Slots = (titleBar :: ∀ q. HC.Slot q Void Unit)

data Action = Init

toa :: ∀ q i o r. HC.Component q i o (Run (AFF + EFFECT + LOG + r))
toa =
  HC.mkComponent
    { initialState: const unit
    , render
    , eval: HC.mkEval $ HC.defaultEval
        { initialize = pure Init
        , handleAction = act
        }
    }

  where
  act = case _ of
    Init -> HC.lift $ debug "started!"

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
