module ToA
  ( Query(..)
  , toa
  ) where

import Prelude

import Data.Codec (encode)
import Data.Map (empty)
import Data.Maybe (Maybe(..), fromMaybe)

import Effect.Aff.Class (class MonadAff)

import Halogen as H
import Halogen.HTML as HD
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore, updateStore)
import Halogen.Store.Select (selectAll)

import Type.Proxy (Proxy(..))

import ToA.Capability.Character (class Character, readChars)
import ToA.Capability.Encounter (class Encounter, readEncs)
import ToA.Capability.Log (class Log)
import ToA.Capability.Navigate (class Navigate)
import ToA.Capability.Theme (class Theme, readTheme, systemTheme)

import ToA.Data.Route (Route(..), CharacterPath(..), EncounterPath(..))
import ToA.Data.Store (Store, StoreAction)
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

import ToA.Component.TitleBar (titleBar)
import ToA.Util.Html (css)

data Query a = OnRoute Route a
data Action = Init | Receive (Connected Store Unit)

toa
  :: ∀ m o
   . MonadAff m
  => MonadStore StoreAction Store m
  => Character m
  => Log m
  => Character m
  => Encounter m
  => Navigate m
  => Theme m
  => H.Component Query Unit o m
toa =
  connect selectAll $ H.mkComponent
    { initialState: _.context
    , render
    , eval: H.mkEval $ H.defaultEval
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
    Receive { context } -> H.put context
    Init -> do
      sysTheme <- systemTheme
      theme <- readTheme
      characters <- readChars
      encounters <- readEncs
      updateStore _
        { systemTheme = sysTheme
        , theme = theme
        , characters = fromMaybe empty characters
        , encounters = fromMaybe empty encounters
        }

  render { route, systemTheme, theme } =
    HD.div
      [ css
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
          , encode themeCodec (fromMaybe systemTheme theme)
          ]
      ]
      [ HD.slot_ (Proxy :: _ "titleBar") unit titleBar unit
      , HD.div
          [ css [ "flex", "grow", "overflow-hidden", "m-2" ] ]
          [ case route of
              Just Home -> HD.slot_ (Proxy :: _ "home") unit homePage unit
              Just (Jobs path) ->
                HD.slot_ (Proxy :: _ "jobs") unit jobsPage path
              Just (Characters path) -> case path of
                Nothing ->
                  HD.slot_ (Proxy :: _ "listChars") unit listCharacterPage unit
                Just subpath -> case subpath of
                  CombatChar char ->
                    HD.slot_ (Proxy :: _ "combatChar") unit combatCharacterPage
                      char
                  CreateChar ->
                    HD.slot_ (Proxy :: _ "createChar") unit editCharacterPage
                      Nothing
                  EditChar char ->
                    HD.slot_ (Proxy :: _ "editChar") unit editCharacterPage $
                      Just char
                  ViewChar char ->
                    HD.slot_ (Proxy :: _ "viewChar") unit viewCharacterPage char
              Just (Encounters path) -> case path of
                Nothing ->
                  HD.slot_ (Proxy :: _ "listEnc") unit listEncounterPage unit
                Just subpath -> case subpath of
                  CreateEnc ->
                    HD.slot_ (Proxy :: _ "createEnc") unit editEncounterPage
                      Nothing
                  EditEnc enc ->
                    HD.slot_ (Proxy :: _ "editEnc") unit editEncounterPage $
                      Just enc
                  ViewEnc enc ->
                    HD.slot_ (Proxy :: _ "viewEnc") unit viewEncounterPage enc
              Nothing -> unknownPage
          ]
      ]
