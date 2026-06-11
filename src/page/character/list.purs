module ToA.Page.Character.List
  ( listCharacterPage
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

import ToA.Capability.Character (class Character, deleteChar)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon.Character (Character)
import ToA.Data.Icon.Name (_name)

import ToA.Component.Character
  ( characterSummary
  , exportCharacter
  , importCharacter
  )
import ToA.Util.Html (css)
import ToA.Util.Style as S

data Action i
  = Receive (Connected Store i)
  | Navigate Route (Maybe MouseEvent)
  | DeleteChar Character

listCharacterPage
  :: ∀ q i o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Character m
  => Navigate m
  => H.Component q i o m
listCharacterPage =
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
    DeleteChar c -> deleteChar c

  render { characters, icon } =
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
      [ characters # foldMap \char -> pure $
          HD.div
            [ css
                [ "flex"
                , "w-full"
                , "sm:max-w-4/5"
                , "md:max-w-3/5"
                , "rounded"
                , "bg-stone-400"
                , "text-stone-800"
                ]
            ]
            [ HD.a
                [ css $ S.interactable <>
                    [ "flex", "grow", "items-center", "gap-2", "p-2" ]
                , HP.href $ print routeCodec $ Characters $ Just $ ViewChar $
                    char ^. _name
                , HE.onClick $ Navigate
                    (Characters $ Just $ ViewChar $ char ^. _name)
                    <<< pure
                ]
                [ characterSummary icon char ]

            , HD.div
                [ css [ "flex", "flex-col" ] ]
                [ HD.button
                    [ css $ S.interactableDanger <>
                        [ "flex", "grow", "items-center", "px-2" ]
                    , HE.onClick \_ -> DeleteChar char
                    ]
                    [ HD.text "Delete" ]

                , HD.slot_
                    (Proxy :: _ "exportChar")
                    (char ^. _name)
                    (exportCharacter
                      [ "flex", "grow" ]
                      [  "items-center", "px-2", "rounded-none" ]
                      char
                    )
                    unit
                ]
            ]

      , [ HD.div
            [ css [ "flex", "gap-2" ] ]
            [ HD.a
                [ css $ S.button <> [ "flex", "items-center", "gap-2", "p-2" ]
                , HP.href $ print routeCodec $ Characters $ Just CreateChar
                , HE.onClick $ Navigate (Characters $ Just CreateChar) <<< pure
                ]
                [ HD.text "Create" ]

            , HD.slot_ (Proxy :: _ "importChar") unit importCharacter unit
            ]
        ]
      ]
