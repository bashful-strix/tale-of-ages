module ToA.Page.Home
  ( homePage
  ) where

import ToA.Prelude

import Data.Lens ((^.))
import Data.Maybe (Maybe(..))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL

import Routing.Duplex (print)

import ToA.Data.Env (Env, _navigate)
import ToA.Data.Route
  ( Route(..)
  , JobPath(..)
  , routeCodec
  )
import ToA.Util.Html (css_)

homePage :: Env -> Nut
homePage env =
  D.div
    [ css_
        [ "flex"
        , "flex-col"
        , "grow"
        , "items-center"
        , "gap-6"
        , "overflow-scroll"
        ]
    ]
    [ D.h1
        [ css_ [ "text-2xl", "font-bold" ] ]
        [ D.text_ "Tale of Ages" ]

    , D.div
        [ css_
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
            D.a
              [ css_
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
              , DA.href_ $ print routeCodec r
              , DL.click_ $ (env ^. _navigate) r <<< pure
              ]
              [ D.div
                  [ css_ [ "shrink-0", "size-16", sign ] ]
                  []
              , D.div
                  [ css_ [ "text-center", "text-lg" ] ]
                  [ D.text_ label ]
              ]

          Nothing ->
            D.div
              [ css_
                  [ "flex"
                  , "items-center"
                  , "gap-2"
                  , "p-2"
                  , "bg-stone-600"
                  , "text-stone-400"
                  , "dark:text-stone-800"
                  ]
              ]
              [ D.div
                  [ css_ [ "shrink-0", "size-16", sign ] ]
                  []
              , D.div
                  [ css_ [ "text-center", "text-lg" ] ]
                  [ D.text_ label ]
              ]
    ]
