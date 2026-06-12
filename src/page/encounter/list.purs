module ToA.Page.Encounter.List
  ( listEncounterPage
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

import ToA.Component.Encounter
  ( encounterSummary
  , exportEncounter
  , importEncounter
  )
import ToA.Data.Env (Env, _deleteEnc, _navigate)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Route (Route(..), EncounterPath(..), routeCodec)
import ToA.Util.Html (css_)
import ToA.Util.Style as S

listEncounterPage :: Env -> Nut
listEncounterPage env@{ encounters, icon } =
  encounters <&> icon <#~> \(encs /\ icon_) ->
    D.div
      [ css_
          [ "flex"
          , "flex-col"
          , "items-center"
          , "grow"
          , "gap-2"
          , "overflow-scroll"
          ]
      ]
      [ encs # foldMap \enc ->
          D.div
            [ css_
                [ "flex"
                , "w-full"
                , "sm:max-w-4/5"
                , "md:max-w-3/5"
                , "rounded"
                , "bg-stone-500"
                , "text-stone-800"
                ]
            ]
            [ D.a
                [ css_ $ S.interactable <>
                    [ "flex", "grow", "items-center", "gap-2", "p-2" ]
                , DA.href_ $ print routeCodec $ Encounters $ Just $ ViewEnc $
                    enc ^. _name
                , DL.click_
                    $ (env ^. _navigate)
                        (Encounters $ Just $ ViewEnc $ enc ^. _name)
                    <<< pure
                ]
                [ encounterSummary icon_ enc ]

            , D.div
                [ css_ [ "flex", "flex-col" ] ]
                [ D.button
                    [ css_ $ S.interactableDanger <>
                        [ "flex", "grow", "items-center", "px-2" ]
                    , DL.runOn_ DL.click $ (env ^. _deleteEnc) enc
                    ]
                    [ D.text_ "Delete" ]

                , exportEncounter
                    ( S.interactable <>
                        [ "flex", "grow", "items-center", "px-2" ]
                    )
                    enc
                ]
            ]

      , D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.a
              [ css_ $ S.button <>
                  [ "flex", "items-center", "gap-2", "py-2" ]
              , DA.href_ $ print routeCodec $ Encounters $ Just CreateEnc
              , DL.click_
                  $ (env ^. _navigate)
                      (Encounters $ Just CreateEnc)
                  <<< pure
              ]
              [ D.text_ "Create" ]

          , importEncounter env
          ]
      ]
