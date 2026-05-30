module ToA
  ( Query(..)
  , toaDeku
  , toa
  ) where

import Prelude

import Data.Codec (encode)
import Data.Maybe (Maybe(..), fromMaybe)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Hooks ((<#~>))

import Halogen (Component, defaultEval, mkComponent, mkEval, put)
import Halogen.HTML as H
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (updateStore)
import Halogen.Store.Select (selectAll)

import Routing.Duplex (print)

import Type.Row (type (+))

import ToA.ToAM (ToAM, Store, liftRun)
import ToA.Capability.Log (LOG, debug)
import ToA.Capability.Navigate (NAVIGATE)
import ToA.Capability.Theme (THEME, readSystem)
import ToA.Component.TitleBar (titleBar)
import ToA.Data.Env (Env)
import ToA.Data.Route
  ( Route(..)
  , CharacterPath(..)
  , EncounterPath(..)
  , routeCodec
  )
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

data Query a = OnRoute Route a
data Action = Init | Receive (Connected Store Unit)

toa :: ∀ r o. Component Query Unit o (ToAM (LOG + NAVIGATE + THEME + r))
toa =
  connect selectAll
    $ mkComponent
        { initialState: _.context
        , render
        , eval: mkEval $ defaultEval
            { initialize = pure Init
            , receive = pure <<< Receive
            , handleAction = act
            , handleQuery = case _ of
                OnRoute route a ->
                  updateStore _ { route = pure route } $> Just a
            }
        }
  where

  act = case _ of
    Init -> do
      systemTheme <- liftRun readSystem
      updateStore _ { systemTheme = systemTheme }
      -- liftRun $ matchRoutes (\route -> updateStore _ { route = pure route })
      liftRun $ debug "test"
    Receive { context } -> put context

  render { route, systemTheme, theme } =
    H.div
      [ HP.classes $ H.ClassName <$>
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
          , encode themeCodec (fromMaybe systemTheme theme)
          ]
      ]
      [ H.div [] [ H.text "Halogen" ]
      , H.div [] [ H.text $ show $ print routeCodec <$> route ]
      ]

toaDeku :: Env -> Nut
toaDeku env@{ route, systemTheme, theme } =
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
