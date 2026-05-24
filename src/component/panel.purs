module ToA.Component.Panel
  ( tripanel
  ) where

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Util.Html (css_)

tripanel :: Array Nut -> Array Nut -> Array Nut -> Nut
tripanel side a b =
  D.div
    [ css_
        [ "flex"
        , "flex-col"
        , "sm:flex-row"
        , "h-full"
        , "w-full"
        , "overflow-hidden"
        , "gap-2"
        ]
    ]
    [ D.div
        [ css_
            [ "flex"
            , "flex-1"
            , "flex-col"
            , "sm:min-w-48"
            , "sm:max-w-56"
            , "overflow-scroll"
            , "p-2"
            , "gap-2"
            , "border"
            , "border-solid"
            , "border-rounded-sm"
            , "border-sky-800"
            ]
        ]
        side

    , D.div
        [ css_ [ "flex", "flex-3", "overflow-scroll", "gap-2" ] ]
        [ D.div
            [ css_ [ "flex", "flex-col", "lg:flex-row", "grow", "gap-2" ] ]
            [ D.div
                [ css_
                    [ "flex-1"
                    , "flex"
                    , "flex-col"
                    , "lg:overflow-scroll"
                    , "p-2"
                    , "gap-x-2"
                    , "gap-y-4"
                    , "border"
                    , "border-solid"
                    , "border-rounded-sm"
                    , "border-sky-800"
                    ]
                ]
                a

            , D.div
                [ css_
                    [ "flex-2"
                    , "lg:overflow-scroll"
                    , "p-2"
                    , "gap-x-2"
                    , "gap-y-6"
                    , "border"
                    , "border-solid"
                    , "border-rounded-sm"
                    , "border-sky-800"
                    ]
                ]
                b
            ]
        ]
    ]
