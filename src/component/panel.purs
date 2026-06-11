module ToA.Component.Panel
  ( tripanel
  ) where

import Halogen.HTML as HD

import ToA.Util.Html (css)

tripanel
  :: ∀ w i
   . Array (HD.HTML w i)
  -> Array (HD.HTML w i)
  -> Array (HD.HTML w i)
  -> HD.HTML w i
tripanel side a b =
  HD.div
    [ css
        [ "flex"
        , "flex-col"
        , "sm:flex-row"
        , "h-full"
        , "w-full"
        , "overflow-hidden"
        , "gap-2"
        ]
    ]
    [ HD.div
        [ css
            [ "flex"
            , "flex-1"
            , "flex-col"
            , "sm:min-w-48"
            , "sm:max-w-56"
            , "overflow-y-auto"
            , "p-2"
            , "gap-2"
            , "border"
            , "border-solid"
            , "border-rounded-sm"
            , "border-sky-800"
            ]
        ]
        side

    , HD.div
        [ css [ "flex", "flex-3", "overflow-y-auto", "gap-2" ] ]
        [ HD.div
            [ css [ "flex", "flex-col", "lg:flex-row", "grow", "gap-2" ] ]
            [ HD.div
                [ css
                    [ "flex-1"
                    , "flex"
                    , "flex-col"
                    , "lg:overflow-y-auto"
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

            , HD.div
                [ css
                    [ "flex-2"
                    , "lg:overflow-y-auto"
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
