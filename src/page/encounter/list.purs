module ToA.Page.Encounter.List
  ( listEncounterPage
  ) where

import ToA.Prelude

import Data.Foldable (foldMap)
import Data.Lens ((^.))
import Data.Maybe (Maybe(..))

import Effect.Aff.Class (class MonadAff)

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectAll)

import Routing.Duplex (print)

import Type.Proxy (Proxy(..))
import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Encounter (class Encounter, deleteEnc)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), EncounterPath(..), routeCodec)
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon.Encounter (Encounter)
import ToA.Data.Icon.Name (_name)

import ToA.Component.Encounter
  ( encounterSummary
  , exportEncounter
  , importEncounter
  )
import ToA.Util.Html (css)
import ToA.Util.Style as S

data Action i
  = Receive (Connected Store i)
  | Navigate Route (Maybe MouseEvent)
  | DeleteEnc Encounter

listEncounterPage
  :: ∀ q i o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Encounter m
  => Navigate m
  => H.Component q i o m
listEncounterPage =
  connect selectAll $ H.mkComponent
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
    DeleteEnc e -> deleteEnc e

  render { encounters, icon } =
    HD.div
      [ css
          [ "flex"
          , "flex-col"
          , "items-center"
          , "grow"
          , "gap-2"
          , "overflow-y-auto"
          ]
      ] $ join
      [ encounters # foldMap \enc -> pure $
          HD.div
            [ css
                [ "flex"
                , "w-full"
                , "sm:max-w-4/5"
                , "md:max-w-3/5"
                , "rounded"
                , "bg-stone-500"
                , "text-stone-800"
                ]
            ]
            [ HD.a
                [ css $ S.interactable <>
                    [ "flex", "grow", "items-center", "gap-2", "p-2" ]
                , HP.href $ print routeCodec $ Encounters $ Just $ ViewEnc $
                    enc ^. _name
                , HE.onClick $ Navigate
                    (Encounters $ Just $ ViewEnc $ enc ^. _name) <<< pure
                ]
                [ encounterSummary icon enc ]

            , HD.div
                [ css [ "flex", "flex-col" ] ]
                [ HD.button
                    [ css $ S.interactableDanger <>
                        [ "flex", "grow", "items-center", "px-2" ]
                    , HE.onClick \_ -> DeleteEnc enc
                    ]
                    [ HD.text "Delete" ]

                , HD.slot_
                    (Proxy :: _ "exportEnc")
                    (enc ^. _name)
                    ( exportEncounter
                        [ "flex", "grow" ]
                        [ "items-center", "px-2", "rounded-none" ]
                        enc
                    )
                    unit
                ]
            ]

      , [ HD.div
            [ css [ "flex", "gap-2" ] ]
            [ HD.a
                [ css $ S.button <> [ "flex", "items-center", "gap-2", "py-2" ]
                , HP.href $ print routeCodec $ Encounters $ Just CreateEnc
                , HE.onClick $ Navigate (Encounters $ Just CreateEnc) <<< pure
                ]
                [ HD.text "Create" ]

            , HD.slot_ (Proxy :: _ "importEnc") unit importEncounter unit
            ]
        ]
      ]
