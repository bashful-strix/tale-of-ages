module ToA.Page.Unknown
  ( unknownPage
  ) where

import Halogen.HTML as HD

import ToA.Util.Html (css)

unknownPage :: ∀ w i. HD.HTML w i
unknownPage =
  HD.div
    [ css
        [ "flex"
        , "grow"
        , "items-center"
        , "justify-center"
        ]
    ]
    [ HD.text "Whoops! We can't find that page..." ]
