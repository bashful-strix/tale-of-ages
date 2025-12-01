module ToA
  ( toa
  ) where

import Prelude

import Data.Codec (encode)
import Data.Maybe (Maybe(..), fromMaybe)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Hooks ((<#~>))

import ToA.Component.TitleBar (titleBar)
import ToA.Data.Env (Env)
import ToA.Data.Route (Route(..), CharacterPath(..))
import ToA.Data.Theme (themeCodec)
import ToA.Page.Characters (charactersPage)
import ToA.Page.EditCharacter (editCharacterPage)
import ToA.Page.Encounters (encountersPage)
import ToA.Page.Home (homePage)
import ToA.Page.Jobs (jobsPage)
import ToA.Page.Unknown (unknownPage)
import ToA.Util.Html (css, css_)

toa :: Env -> Nut
toa env@{ route, systemTheme, theme } =
  D.div
    [ css $ theme <#> \t ->
        [ "w-dvw"
        , "h-dvh"
        , "flex"
        , "flex-col"
        , "overflow-hidden"
        , "text-sm"
        , "bg-stone-300"
        , "text-stone-700"
        , "dark:bg-stone-900"
        , "dark:text-stone-400"
        , encode themeCodec (fromMaybe systemTheme t)
        ]
    ]
    [ titleBar env
    , D.div
        [ css_ [ "flex", "grow", "overflow-hidden", "m-2" ] ]
        [ route <#~> case _ of
            Just Home -> homePage
            Just (Jobs path) -> jobsPage env path
            Just (Characters path) -> case path of
              Edit char -> editCharacterPage env char
              View char -> charactersPage env char
            Just (Encounters enc) -> encountersPage env enc
            Nothing -> unknownPage
        ]
    ]
