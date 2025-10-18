module ToA.Component.TitleBar
  ( titleBar
  ) where

import Prelude

import Data.Codec (decode, encode)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import Halogen as HC
import Halogen.HTML as H
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (StoreT, updateStore)
import Halogen.Store.Select (selectEq)

import Routing.Duplex (print)

import Run (Run, EFFECT)
import Type.Row (type (+))

import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Navigate (NAVIGATE, navigate)
import ToA.Capability.Theme (THEME, save)
import ToA.Data.Env (Env, EnvAction(..))
import ToA.Data.Route (Route(..), routeCodec)
import ToA.Data.Theme (Theme(..), themeCodec)
import ToA.Util.Html (css)

type State =
  { theme :: Maybe Theme
  }

data Action
  = SelectTheme String
  | ClickLink Route MouseEvent
  | Receive (Connected (Maybe Theme) Unit)

deriveState :: Connected (Maybe Theme) Unit -> State
deriveState { context } = { theme: context }

titleBar
  :: ∀ q o r
  . HC.Component q Unit o
      (StoreT EnvAction Env (Run (EFFECT + NAVIGATE + THEME + r)))
titleBar =
  connect (selectEq _.theme) $ HC.mkComponent
    { initialState: deriveState
    , render
    , eval: HC.mkEval $ HC.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }

  where
  act = case _ of
    SelectTheme e -> do
      let theme = decode themeCodec e
      updateStore $ SetTheme theme
      HC.lift $ HC.lift $ save theme

    ClickLink route e ->
      HC.lift $ HC.lift $ navigate route (pure e)

    Receive env ->
      HC.put $ deriveState env

  render { theme } =
    H.div
      [ css
          [ "h-10"
          , "w-full"
          , "flex"
          , "items-center"
          , "justify-between"
          , "px-2"
          , "bg-stone-500"
          , "text-stone-800"
          , "dark:bg-stone-700"
          , "dark:text-stone-300"
          ]
      ]
      [ H.nav
          [ css [ "flex", "h-full" ] ]
          [ H.ul
              [ css [ "flex", "h-full" ] ] $
              [ "ToA" /\ Home
              , "Test" /\ Test "test"
              ] <#> \(label /\ route) ->
                H.li
                  [ css [ "flex", "h-full" ] ]
                  [ routeLink label route ]
          ]

      , H.div
          []
          [ H.select
              [ HE.onValueChange SelectTheme
              ]
              [ H.option
                  [ HP.value $ encode themeCodec Light
                  , HP.selected $ theme == Just Light
                  ]
                  [ H.text "Light" ]
              , H.option
                  [ HP.value $ encode themeCodec Dark
                  , HP.selected $ theme == Just Dark
                  ]
                  [ H.text "Dark" ]
              , H.option
                  [ HP.value ""
                  , HP.selected $ theme == Nothing
                  ]
                  [ H.text "System" ]
              ]
          ]
      ]

  routeLink label route =
    H.a
      [ HP.href $ print routeCodec route
      , HE.onClick $ ClickLink route
      , css
          [ "h-full"
          , "content-center"
          , "px-2"
          , "hover:bg-stone-400"
          , "focus:bg-stone-400"
          , "dark:hover:bg-stone-500"
          , "dark:focus:bg-stone-500"
          ]
      ]
      [ H.text label ]
