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
import ToA.Page.Character.Combat (combatCharacterPage)
import ToA.Page.Character.Edit (editCharacterPage)
import ToA.Page.Character.List (listCharacterPage)
import ToA.Page.Character.View (viewCharacterPage)
import ToA.Page.Encounter.Edit (editEncounterPage)
import ToA.Page.Encounter.List (listEncounterPage)
import ToA.Page.Encounter.View (viewEncounterPage)
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
        , "text-sm"
        , "bg-stone-300"
        , "text-stone-700"
        , "dark:bg-stone-900"
        , "dark:text-stone-400"
        , "scheme-light"
        , "dark:scheme-dark"
        , encode themeCodec (fromMaybe systemTheme t)
        ]
    ]
    [ titleBar env
    , D.div
        [ css_ [ "flex", "grow", "overflow-hidden", "m-2" ] ]
        [ route <#~> case _ of
            Just Home -> homePage env
            Just (Jobs path) -> jobsPage env path
            Just (Characters path) -> case path of
              Nothing -> listCharacterPage env
              Just subpath -> case subpath of
                CombatChar char -> combatCharacterPage env char
                CreateChar -> editCharacterPage env Nothing
                EditChar char -> editCharacterPage env $ Just char
                ViewChar char -> viewCharacterPage env char
            Just (Encounters path) -> case path of
              Nothing -> listEncounterPage env
              Just subpath -> case subpath of
                CreateEnc -> editEncounterPage env Nothing
                EditEnc enc -> editEncounterPage env $ Just enc
                ViewEnc enc -> viewEncounterPage env enc
            Nothing -> unknownPage
        ]
    ]
