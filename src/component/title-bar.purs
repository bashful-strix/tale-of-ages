module ToA.Component.TitleBar
  ( titleBar
  ) where

import ToA.Prelude

import Data.Codec (decode, encode)
import Data.Filterable (filter)
import Data.Lens ((^.))
import Data.Maybe (Maybe(..))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL

import Routing.Duplex (print)

import ToA.Data.Env (Env, _navigate, _saveTheme)
import ToA.Data.Route
  ( Route(..)
  , EncounterPath(..)
  , JobPath(..)
  , routeCodec
  )
import ToA.Data.Theme (Theme(..), themeCodec)
import ToA.Util.Html (css_)

titleBar :: Env -> Nut
titleBar env@{ theme } =
  D.div
    [ css_
        [ "h-8"
        , "flex"
        , "shrink-0"
        , "items-center"
        , "justify-between"
        , "pr-2"
        , "bg-stone-500"
        , "text-stone-800"
        , "dark:bg-stone-700"
        , "dark:text-stone-300"
        ]
    ]
    [ D.nav
        [ css_ [ "flex", "h-full" ] ]
        [ D.ul
            [ css_ [ "flex", "h-full" ] ] $
            [ "ToA" /\ "icon-[game-icons--black-book]" /\ Home
            , "Jobs" /\ "icon-[game-icons--sverd-i-fjell]" /\ Jobs None
            , "Characters" /\ "icon-[game-icons--archive-register]" /\ Characters Nothing
            , "Encounters" /\ "icon-[game-icons--guarded-tower]" /\ Encounters (ViewEnc Nothing)
            ] <#> \(label /\ sign /\ route) ->
              D.li
                [ css_ [ "flex", "h-full" ] ]
                [ routeLink env label sign route ]
        ]

    , D.div []
        [ D.select
            [ DL.selectOn_ DL.change $
                (env ^. _saveTheme) <<< decode themeCodec
            ]
            [ D.option
                [ DA.value_ $ encode themeCodec Light
                , DA.selected $ "selected" <$ filter (eq (Just Light)) theme
                , DA.unset @"selected" $ filter (not <<< eq (Just Light)) theme
                ]
                [ D.text_ "Light" ]
            , D.option
                [ DA.value_ $ encode themeCodec Dark
                , DA.selected $ "selected" <$ filter (eq (Just Dark)) theme
                , DA.unset @"selected" $ filter (not <<< eq (Just Dark)) theme
                ]
                [ D.text_ "Dark" ]
            , D.option
                [ DA.value_ ""
                , DA.selected $ "selected" <$ filter (eq Nothing) theme
                , DA.unset @"selected" $ filter (not <<< eq Nothing) theme
                ]
                [ D.text_ "System" ]
            ]
        ]
    ]

routeLink :: Env -> String -> String -> Route -> Nut
routeLink env label sign route =
  D.a
    [ DA.href_ $ print routeCodec route
    , DL.click_ $ (env ^. _navigate) route <<< pure
    , css_
        [ "flex"
        , "items-center"
        , "gap-2"
        , "h-full"
        , "max-w-10"
        , "sm:max-w-none"
        , "px-2"
        , "overflow-hidden"
        , "hover:bg-stone-400"
        , "focus:bg-stone-400"
        , "dark:hover:bg-stone-500"
        , "dark:focus:bg-stone-500"
        ]
    ]
    [ D.span [ css_ [ "size-6", "shrink-0", sign ] ] []
    , D.text_ label
    ]
