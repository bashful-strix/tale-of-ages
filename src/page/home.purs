module ToA.Page.Home
  ( homePage
  ) where

import ToA.Prelude

import Data.Maybe (Maybe(..))

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP

import Routing.Duplex (print)

import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route
  ( Route(..)
  , JobPath(..)
  , routeCodec
  )
import ToA.Util.Html (css)

data Action = Navigate Route (Maybe MouseEvent)

homePage :: ∀ q i o m. Monad m => Navigate m => H.Component q i o m
homePage =
  H.mkComponent
    { initialState: identity
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = case _ of Navigate r e -> navigate r e
        }
    }
  where
  render _ =
    HD.div
      [ css
          [ "flex"
          , "flex-col"
          , "grow"
          , "items-center"
          , "gap-6"
          , "overflow-y-auto"
          ]
      ]
      [ HD.h1
          [ css [ "text-2xl", "font-bold" ] ]
          [ HD.text "Tale of Ages" ]

      , HD.div
          [ css
              [ "grid"
              , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
              , "w-full"
              , "sm:max-w-4/5"
              , "md:max-w-3/5"
              , "gap-4"
              ]
          ]
          $
            [ "Jobs" /\ "icon-[game-icons--sverd-i-fjell]" /\ Just (Jobs None)
            , "Foes" /\ "icon-[game-icons--brute]" /\ Nothing
            , "Glossary" /\ "icon-[game-icons--rule-book]" /\ Nothing
            , "Inventory" /\ "icon-[game-icons--relic-blade]" /\ Nothing
            , "Characters" /\ "icon-[game-icons--archive-register]" /\ Just
                (Characters Nothing)
            , "Encounters" /\ "icon-[game-icons--guarded-tower]" /\ Just
                (Encounters Nothing)
            ]
          <#> \(label /\ sign /\ route) -> case route of
            Just r ->
              HD.a
                [ css
                    [ "flex"
                    , "items-center"
                    , "gap-2"
                    , "p-2"
                    , "bg-stone-500"
                    , "text-stone-800"
                    , "dark:bg-stone-700"
                    , "dark:text-stone-300"
                    , "hover:bg-stone-400"
                    , "focus:bg-stone-400"
                    , "dark:hover:bg-stone-500"
                    , "dark:focus:bg-stone-500"
                    ]
                , HP.href $ print routeCodec r
                , HE.onClick $ Navigate r <<< pure
                ]
                [ HD.div
                    [ css [ "shrink-0", "size-16", sign ] ]
                    []
                , HD.div
                    [ css [ "text-center", "text-lg" ] ]
                    [ HD.text label ]
                ]

            Nothing ->
              HD.div
                [ css
                    [ "flex"
                    , "items-center"
                    , "gap-2"
                    , "p-2"
                    , "bg-stone-600"
                    , "text-stone-400"
                    , "dark:text-stone-800"
                    ]
                ]
                [ HD.div
                    [ css [ "shrink-0", "size-16", sign ] ]
                    []
                , HD.div
                    [ css [ "text-center", "text-lg" ] ]
                    [ HD.text label ]
                ]
      ]
