module ToA.Page.Characters
  ( charactersPage
  ) where

import Prelude

import CSS (backgroundColor, render, renderedInline)

import Data.Foldable (foldMap, intercalate)
import Data.Lens
  ( (^.)
  , (^?)
  , preview
  , view
  , ifoldMapOf
  , findOf
  , filtered
  , to
  , traversed
  , _Just
  )
import Data.Lens.Common (simple)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import Routing.Duplex (print)

import ToA.Data.Env (Env, _navigate)
import ToA.Data.Icon.Character (_build, _jobs, _level, _primary)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Icon.Sign (_sign)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Util.Html (css_)
import ToA.Util.Optic ((^::))

charactersPage :: Env -> Nut
charactersPage env@{ characters, icon } =
  ((/\) <$> characters <*> icon) <#~> \(chars /\ { colours, jobs }) ->
    D.div
      [ css_ [ "flex", "flex-col", "items-center", "grow", "gap-2" ] ]
      [ chars # foldMap \char ->
          let
            primary = char ^. _build <<< _primary
            job = jobs # traversed `findOf` (view _name >>> eq primary)
          in
            D.a
              [ css_
                  [ "flex"
                  , "items-center"
                  , "gap-2"
                  , "w-full"
                  , "sm:max-w-4/5"
                  , "md:max-w-3/5"
                  , "p-2"
                  , "rounded"
                  , "bg-stone-500"
                  , "text-stone-800"
                  , "dark:bg-stone-700"
                  , "dark:text-stone-300"
                  , "hover:bg-stone-400"
                  , "focus:bg-stone-400"
                  , "dark:hover:bg-stone-500"
                  , "dark:focus:bg-stone-500"
                  ]
              , DA.href_ $ print routeCodec $ Characters $ Just $ ViewChar $
                  char
                    ^. _name
              , DL.click_ $
                  (env ^. _navigate)
                    (Characters $ Just $ ViewChar $ char ^. _name) <<< pure
              ]
              [ D.div
                  [ css_ $ [ "size-16" ]
                      <> job ^:: _Just <<< _sign <<< _Newtype
                  ]
                  []
              , D.div
                  [ css_ [ "flex", "flex-col" ] ]
                  [ D.h3
                      [ css_ [ "font-bold" ] ]
                      [ D.text_ $ char ^. _name <<< _Newtype ]

                  , D.div
                      [ css_ [ "flex", "gap-2" ] ]
                      [ D.div
                          []
                          [ D.text_ $ "L " <> char
                              ^. _build <<< _level <<< to show
                          ]
                      , D.text_ "∷"
                      , D.div
                          [ css_ [ "font-bold", "text-white" ]
                          , DA.style_ $ fromMaybe "" $ renderedInline $
                              render =<< colours
                                ^? traversed
                                  <<< filtered
                                    ( preview _name >>> eq
                                        (job ^? _Just <<< _colour)
                                    )
                                  <<< _value
                                  <<< to backgroundColor
                          ]
                          [ D.text_ $ primary ^. simple _Newtype ]
                      ]

                  , D.div
                      []
                      [ D.text_
                          $ intercalate " | "
                          $ char # (_build <<< _jobs <<< itraversed)
                              `ifoldMapOf` \n l ->
                                [ (n ^. simple _Newtype) <> " " <> show l ]
                      ]
                  ]
              ]

      , D.a
          [ css_
              [ "flex"
              , "items-center"
              , "gap-2"
              , "p-2"
              , "rounded"
              , "bg-stone-500"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              , "hover:bg-stone-400"
              , "focus:bg-stone-400"
              , "dark:hover:bg-stone-500"
              , "dark:focus:bg-stone-500"
              ]
          , DA.href_ $ print routeCodec $ Characters $ Just CreateChar
          , DL.click_ $
              (env ^. _navigate)
                (Characters $ Just CreateChar) <<< pure
          ]
          [ D.text_ "Create character" ]
      ]
