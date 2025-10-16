module ToA (toa) where

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Component.TitleBar (titleBar)
import ToA.Util.Html (css_)

toa :: Nut
toa =
  D.div
    [ css_
        [ "w-dvw"
        , "h-dvh"
        , "flex"
        , "flex-col"
        , "bg-stone-300"
        , "text-stone-700"
        , "dark:bg-stone-900"
        , "dark:text-stone-400"
        ]
    ]
    [ titleBar
    , D.div
        [ css_
            [ "flex"
            , "grow"
            , "items-center"
            , "justify-center"
            , "overflow-hidden"
            ]
        ]
        [ D.text_ "Tale of Ages" ]
    ]
