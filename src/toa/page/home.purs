module ToA.Page.Home
  ( homePage
  ) where

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Util.Html (css_)

homePage :: Nut
homePage =
  D.div
    [ css_
        [ "flex"
        , "grow"
        , "items-center"
        , "justify-center"
        ]
    ]
    [ D.text_ "Tale of Ages" ]
