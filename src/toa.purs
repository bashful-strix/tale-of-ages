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
import ToA.Data.Route (Route(..), CharacterPath(..), EncounterPath(..))
import ToA.Data.Theme (themeCodec)
import ToA.Page.Characters (charactersPage)
import ToA.Page.Combat (combatPage)
import ToA.Page.EditCharacter (editCharacterPage)
import ToA.Page.ViewCharacter (viewCharacterPage)
import ToA.Page.Encounters (encountersPage)
import ToA.Page.EditEncounter (editEncounterPage)
import ToA.Page.Home (homePage)
import ToA.Page.Jobs (jobsPage)
import ToA.Page.Unknown (unknownPage)
import ToA.Util.Html (css, css_)

toa :: Env -> Nut
toa env@{ route, systemTheme, theme } =
  D.div
    [ css $ theme <#> \t ->
        [ "w-screen"
        , "h-screen"
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
              Nothing -> charactersPage env
              Just subpath -> case subpath of
                EditChar char -> editCharacterPage env $ Just char
                CreateChar -> editCharacterPage env Nothing
                ViewChar char -> viewCharacterPage env char
                CombatChar char -> combatPage env char
            Just (Encounters path) -> case path of
              EditEnc enc -> editEncounterPage env enc
              ViewEnc enc -> encountersPage env enc
            Nothing -> unknownPage
        ]
    ]
