module ToA.Page.Character.List
  ( listCharacterPage
  ) where

import ToA.Prelude

import Data.Foldable (foldMap)
import Data.Lens ((^.))
import Data.Maybe (Maybe(..))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import Routing.Duplex (print)

import ToA.Component.Character
  ( characterSummary
  , exportCharacter
  , importCharacter
  )
import ToA.Data.Env (Env, _deleteChar, _navigate)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Util.Html (css_)
import ToA.Util.Style as S

listCharacterPage :: Env -> Nut
listCharacterPage env@{ characters, icon } =
  characters <&> icon <#~> \(chars /\ icon_) ->
    D.div
      [ css_
          [ "flex"
          , "flex-col"
          , "items-center"
          , "grow"
          , "gap-2"
          , "overflow-y-auto"
          ]
      ]
      [ chars # foldMap \char ->
          D.div
            [ css_
                [ "flex"
                , "w-full"
                , "sm:max-w-4/5"
                , "md:max-w-3/5"
                , "rounded"
                , "bg-stone-400"
                , "text-stone-800"
                ]
            ]
            [ D.a
                [ css_ $ S.interactable <>
                    [ "flex", "grow", "items-center", "gap-2", "p-2" ]
                , DA.href_ $ print routeCodec $ Characters $ Just $ ViewChar $
                    char ^. _name
                , DL.click_
                    $ (env ^. _navigate)
                        (Characters $ Just $ ViewChar $ char ^. _name)
                    <<< pure
                ]
                [ characterSummary icon_ char ]

            , D.div
                [ css_ [ "flex", "flex-col" ] ]
                [ D.button
                    [ css_ $ S.interactableDanger <>
                        [ "flex", "grow", "items-center", "px-2" ]
                    , DL.runOn_ DL.click $ (env ^. _deleteChar) char
                    ]
                    [ D.text_ "Delete" ]

                , exportCharacter icon_
                    ( S.interactable <>
                        [ "flex", "grow", "items-center", "px-2" ]
                    )
                    char
                ]
            ]

      , D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.a
              [ css_ $ S.button <> [ "flex", "items-center", "gap-2", "p-2" ]
              , DA.href_ $ print routeCodec $ Characters $ Just CreateChar
              , DL.click_
                  $ (env ^. _navigate) (Characters $ Just CreateChar)
                  <<< pure
              ]
              [ D.text_ "Create" ]

          , importCharacter env
          ]
      ]
