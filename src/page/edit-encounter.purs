module ToA.Page.EditEncounter
  ( editEncounterPage
  ) where

import Prelude

import Data.Codec (decode, encode)
import Data.Either (Either(..), isLeft)
import Data.Foldable (intercalate)
import Data.Lens ((^.), (^?), preview, filtered, traversed)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Combinators as DC
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>), useState)

import Parsing.String (parseErrorHuman)

import Web.HTML.HTMLTextAreaElement (fromEventTarget, value)

import ToA.Data.Env (Env, _navigate, _saveEnc)
import ToA.Data.Icon.Encounter
  ( Encounter(..)
  , FoeEntry(..)
  , stringEncounter
  )
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Route (Route(..), EncounterPath(..))
import ToA.Util.Html (css_)

editEncounterPage :: Env -> Maybe Name -> Nut
editEncounterPage env@{ encounters, icon } pathEnc =
  (/\) <$> encounters <*> icon <#~> \(encs /\ _) -> Deku.do
    setEnc /\ enc <- useState $ encode stringEncounter $ fromMaybe emptyEnc $
      encs ^? traversed <<< filtered (preview _name >>> eq pathEnc)

    let parsed = decode stringEncounter <$> enc

    D.div
      [ css_ [ "flex", "flex-col", "gap-2" ] ]
      [ D.form
          [ css_ [ "flex", "flex-col", "gap-2" ] ]
          [ D.label
              [ DA.for_ "edit", css_ [ "font-bold" ] ]
              [ D.text_ "Edit encounter" ]

          , D.div
              [ css_ [ "flex" ] ]
              [ D.textarea
                  [ DC.transformOn { fromEventTarget, value } DL.input
                      (pure setEnc)
                  , DA.rows_ "15"
                  , DA.cols_ "40"
                  , DA.id_ "edit"
                  , css_
                      [ "mx-2"
                      , "font-mono"
                      , "bg-stone-400"
                      , "dark:bg-stone-800"
                      ]
                  ]
                  [ D.text enc ]

              , (/\) <$> enc <*> parsed <#~> \(c /\ p) -> case p of
                  Right _ -> mempty
                  Left e ->
                    D.pre
                      [ css_ [ "text-red-600" ] ]
                      [ D.text_ $ intercalate "\n" $ parseErrorHuman c 20 e ]
              ]

          , D.div
              [ css_ [ "flex", "gap-2" ] ]
              [ D.button
                  [ DL.runOn DL.click $ parsed <#> case _ of
                      Left _ -> pure unit
                      Right e -> do
                        e # env ^. _saveEnc
                        (env ^. _navigate)
                          (Encounters $ ViewEnc $ Just $ e ^. _name)
                          Nothing
                  , DA.disabled $ show <<< isLeft <$> parsed
                  , css_
                      [ "px-2"
                      , "py-1"
                      , "border"
                      , "border-solid"
                      , "disabled:border-stone-700"
                      , "disabled:text-stone-700"
                      ]
                  ]
                  [ D.text_ "Save" ]

              , D.button
                  [ DL.runOn_ DL.click $
                      (env ^. _navigate) (Encounters $ ViewEnc pathEnc)
                        Nothing
                  , css_ [ "px-2", "py-1", "border", "border-solid" ]
                  ]
                  [ D.text_ "Cancel" ]
              ]
          ]
      ]

emptyEnc :: Encounter
emptyEnc = Encounter
  { name: Name "<Encounter name>"
  , notes: Just "<Notes>"
  , foes:
      [ FoeEntry
          { name: Name "Foe name"
          , alias: Just "Foe alias"
          , count: 1
          , faction: Just $ Name "Faction"
          , template: Just $ Name "Template"
          }
      ]
  , reserves:
      [ FoeEntry
          { name: Name "Reserve foe name"
          , alias: Nothing
          , count: 2
          , faction: Nothing
          , template: Nothing
          }
      ]
  }
