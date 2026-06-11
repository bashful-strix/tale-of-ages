module ToA.Component.TitleBar
  ( titleBar
  ) where

import ToA.Prelude

import Data.Codec (decode, encode)
import Data.Maybe (Maybe(..))

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectEq)

import Routing.Duplex (print)

import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Capability.Theme (class Theme, saveTheme)
import ToA.Data.Route (Route(..), JobPath(..), routeCodec)
import ToA.Data.Store (Store, StoreAction)
import ToA.Data.Theme (Theme(..), themeCodec)

import ToA.Util.Html (css)

data Action i
  = Receive (Connected (Maybe Theme) i)
  | Navigate Route (Maybe MouseEvent)
  | ChangeTheme String

titleBar
  :: ∀ q i o m
   . MonadStore StoreAction Store m
  => Navigate m
  => Theme m
  => H.Component q i o m
titleBar =
  connect (selectEq _.theme) $ H.mkComponent
    { initialState: _.context
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where
  act = case _ of
    Receive { context } -> H.put context
    Navigate r e -> navigate r e
    ChangeTheme theme -> saveTheme $ decode themeCodec theme

  render theme =
    HD.div
      [ css
          [ "h-8"
          , "flex"
          , "shrink-0"
          , "items-center"
          , "justify-between"
          , "pr-2"
          , "bg-stone-400"
          , "text-stone-800"
          , "dark:bg-stone-700"
          , "dark:text-stone-300"
          ]
      ]
      [ HD.nav
          [ css [ "flex", "h-full" ] ]
          [ HD.ul
              [ css [ "flex", "h-full" ] ]
              $
                [ "ToA" /\ "icon-[game-icons--black-book]" /\ Home
                , "Jobs" /\ "icon-[game-icons--sverd-i-fjell]" /\ Jobs None
                , "Characters" /\ "icon-[game-icons--archive-register]" /\
                    Characters Nothing
                , "Encounters" /\ "icon-[game-icons--guarded-tower]" /\
                    Encounters Nothing
                ]
              <#> \(label /\ sign /\ route) ->
                HD.li
                  [ css [ "flex", "h-full" ] ]
                  [ routeLink label sign route ]
          ]

      , HD.div []
          [ HD.select
              [ HE.onValueChange ChangeTheme ]
              [ HD.option
                  [ HP.value $ encode themeCodec Light
                  , HP.selected $ theme == Just Light
                  ]
                  [ HD.text "Light" ]
              , HD.option
                  [ HP.value $ encode themeCodec Dark
                  , HP.selected $ theme == Just Dark
                  ]
                  [ HD.text "Dark" ]
              , HD.option
                  [ HP.value ""
                  , HP.selected $ theme == Nothing
                  ]
                  [ HD.text "System" ]
              ]
          ]
      ]

  routeLink label sign route =
    HD.a
      [ css
          [ "flex"
          , "items-center"
          , "gap-2"
          , "h-full"
          , "max-w-10"
          , "sm:max-w-none"
          , "px-2"
          , "overflow-hidden"
          , "hover:bg-stone-500"
          , "focus:bg-stone-500"
          , "dark:hover:bg-stone-500"
          , "dark:focus:bg-stone-500"
          ]
      , HP.href $ print routeCodec route
      , HE.onClick $ Navigate route <<< pure
      ]
      [ HD.span [ css [ "size-6", "shrink-0", sign ] ] []
      , HD.text label
      ]
