module ToA (toa) where

import Prelude

import Data.Codec (encode)
import Data.Maybe (fromMaybe)

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Component.TitleBar (titleBar)
import ToA.Data.Theme (themeCodec)
import ToA.Data.Env (Env)
import ToA.Util.Html (css, css_)

toa :: Env -> Nut
toa world@{ systemTheme, theme } =
  D.div
    [ css $ theme <#> \t ->
        [ "w-dvw"
        , "h-dvh"
        , "flex"
        , "flex-col"
        , "bg-stone-300"
        , "text-stone-700"
        , "dark:bg-stone-900"
        , "dark:text-stone-400"
        , encode themeCodec (fromMaybe systemTheme t)
        ]
    ]
    [ titleBar world
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
