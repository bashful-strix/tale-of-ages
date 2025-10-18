module ToA.Page.Unknown
  ( unknownPage
  ) where

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Util.Html (css_)

unknownPage :: Nut
unknownPage =
  D.div
    [ css_
        [ "flex"
        , "grow"
        , "items-center"
        , "justify-center"
        ]
    ]
    [ D.text_ "Whoops! We can't find that page..." ]
