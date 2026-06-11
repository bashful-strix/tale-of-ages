module ToA.Page.Encounter.Edit
  ( editEncounterPage
  ) where

import ToA.Prelude

import Data.Codec (decode, encode)
import Data.Either (Either(..), hush, isLeft)
import Data.Foldable (intercalate)
import Data.Lens ((^.), (^?), preview, view, filtered, traversed)
import Data.Map (empty)
import Data.Maybe (Maybe(..), fromMaybe)

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectAll)

import Parsing.String (parseErrorHuman)

import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Encounter (class Encounter, saveEnc)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), EncounterPath(..))
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon.Encounter
  ( Encounter(..)
  , FoeEntry(..)
  , FoeState(..)
  , stringEncounter
  )
import ToA.Data.Icon.Name (Name(..), _name)

import ToA.Util.Html (css)
import ToA.Util.Style as S

emptyEnc :: Encounter
emptyEnc = Encounter
  { name: Name "<Encounter name>"
  , players: 1
  , notes: Just "<Notes>"
  , foes:
      [ Active
          { name: Name "Foe name"
          , alias: Just "Foe alias"
          , faction: Just $ Name "Faction"
          , template: Just $ Name "Template"
          , state: [ FoeState { hp: 0, vigor: 0, status: empty } ]
          }
      , Reserve
          { name: Name "Reserve foe name"
          , alias: Nothing
          , faction: Nothing
          , template: Nothing
          , state:
              [ FoeState { hp: 0, vigor: 0, status: empty }
              , FoeState { hp: 0, vigor: 0, status: empty }
              ]
          }
      ]
  }

data Action
  = Receive (Connected Store (Maybe Name))
  | Navigate Route (Maybe MouseEvent)
  | SetTextEnc String
  | SaveEnc (Maybe Encounter)

editEncounterPage
  :: ∀ q o m
   . MonadStore StoreAction Store m
  => Encounter m
  => Navigate m
  => H.Component q (Maybe Name) o m
editEncounterPage =
  connect selectAll $ H.mkComponent
    { initialState: deriveState
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where

  deriveState { context: { encounters, icon }, input } =
    let
      pathEnc = encounters ^? traversed <. filtered (preview _name >>> eq input)
    in
      { icon
      , pathEnc
      , text: encode (stringEncounter icon) $ fromMaybe emptyEnc pathEnc
      }

  act = case _ of
    Receive update -> H.put $ deriveState update
    Navigate r e -> navigate r e
    SetTextEnc text -> H.modify_ _ { text = text }
    SaveEnc menc -> case menc of
      Nothing -> pure unit
      Just enc -> do
        saveEnc enc
        navigate (Encounters $ Just $ ViewEnc $ enc ^. _name) Nothing

  render { icon, pathEnc, text } =
    let
      parsed = decode (stringEncounter icon) text
    in
      HD.div
        [ css [ "flex", "flex-col", "gap-2" ] ]
        [ HD.form
            [ css [ "flex", "flex-col", "gap-2" ] ]
            [ HD.label
                [ css [ "font-bold" ], HP.for "edit" ]
                [ HD.text "Edit encounter" ]

            , HD.div
                [ css [ "flex" ] ]
                [ HD.textarea
                    [ css
                        [ "mx-2"
                        , "font-mono"
                        , "bg-stone-400"
                        , "dark:bg-stone-800"
                        ]
                    , HP.rows 15
                    , HP.cols 40
                    , HP.id "edit"
                    , HP.value text
                    , HE.onValueChange SetTextEnc
                    ]

                , case parsed of
                    Right _ -> HD.span [] []
                    Left e ->
                      HD.pre
                        [ css [ "text-red-600" ] ]
                        [ HD.text $ intercalate "\n" $ parseErrorHuman text 20 e
                        ]
                ]

            , HD.div
                [ css [ "flex", "gap-2" ] ]
                [ HD.button
                    [ css S.button
                    , HP.type_ HP.ButtonButton
                    , HP.disabled $ isLeft parsed
                    , HE.onClick \_ -> SaveEnc $ hush parsed
                    ]
                    [ HD.text "Save" ]

                , HD.button
                    [ css S.button
                    , HE.onClick \_ -> Navigate
                        (Encounters $ ViewEnc <<< view _name <$> pathEnc)
                        Nothing
                    ]
                    [ HD.text "Cancel" ]
                ]
            ]
        ]
