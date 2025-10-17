module ToA.Component.TitleBar (titleBar) where

import Prelude
import Data.Lens ((^.))

import Data.Codec (decode, encode)
import Data.Filterable (filter)
import Data.Maybe (Maybe(..))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL

import ToA.Data.Theme (Theme(..), themeCodec)
import ToA.Data.Env (Env, _saveTheme)
import ToA.Util.Html (css_)

titleBar :: Env -> Nut
titleBar world@{ theme } =
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
    , D.div
        []
        [ D.select
            [ DL.selectOn_ DL.change $
                (world ^. _saveTheme) <<< decode themeCodec
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
