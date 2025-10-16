module ToA.Component.TitleBar (titleBar) where

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Util.Html (css_)

titleBar :: Nut
titleBar =
  D.div
    [ css_
        [ "h-10"
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
    [ D.div [] [ D.text_ "ToA" ]
    , D.div [] [ D.text_ "light" ]
    ]
