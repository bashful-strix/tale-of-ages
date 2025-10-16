module ToA where

import Prelude

import Data.String (joinWith)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

toa :: Nut
toa =
  D.div
    [ DA.klass_ $ joinWith " "
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
    [ D.text_ "Tale of Ages" ]
