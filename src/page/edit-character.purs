module ToA.Page.EditCharacter
  ( editCharacterPage
  ) where

import Prelude

import Data.Codec (decode, encode)
import Data.Either (Either(..), isLeft)
import Data.Foldable (intercalate)
import Data.Lens ((^.), (^?), preview, filtered, traversed)
import Data.Map (fromFoldable)
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

import ToA.Data.Env (Env, _navigate, _saveChar)
import ToA.Data.Icon.Character
  ( Character(..)
  , State(..)
  , Build(..)
  , Level(..)
  , stringCharacter
  )
import ToA.Data.Icon.Job (JobLevel(..))
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Route (Route(..), CharacterPath(..))
import ToA.Util.Html (css_)

editCharacterPage :: Env -> Maybe Name -> Nut
editCharacterPage env@{ characters, icon } pathChar =
  (/\) <$> characters <*> icon <#~> \(chars /\ icon_) -> Deku.do
    setChar /\ char <- useState $ encode (stringCharacter icon_) $ fromMaybe emptyChar $
      chars ^? traversed <<< filtered (preview _name >>> eq pathChar)

    let parsed = decode (stringCharacter icon_) <$> char

    D.div
      [ css_ [ "flex", "flex-col", "gap-2" ] ]
      [ D.form
          [ css_ [ "flex", "flex-col", "gap-2" ] ]
          [ D.label
              [ DA.for_ "edit", css_ [ "font-bold" ] ]
              [ D.text_ "Edit character" ]

          , D.div
              [ css_ [ "flex" ] ]
              [ D.textarea
                  [ DC.transformOn { fromEventTarget, value } DL.input
                      (pure setChar)
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
                  [ D.text char ]

              , (/\) <$> char <*> parsed <#~> \(c /\ p) -> case p of
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
                      Right c -> do
                        c # env ^. _saveChar
                        (env ^. _navigate)
                          (Characters $ ViewChar $ Just $ c ^. _name)
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
                      (env ^. _navigate) (Characters $ ViewChar pathChar)
                        Nothing
                  , css_ [ "px-2", "py-1", "border", "border-solid" ]
                  ]
                  [ D.text_ "Cancel" ]
              ]
          ]
      ]

emptyChar :: Character
emptyChar = Character
  { name: Name "<Character name>"
  , state: State {}
  , build: Build
      { level: Zero
      , primary: Name "<Primary job>"
      , jobs: fromFoldable [ Name "<Job 1>" /\ I, Name "<Job 2>" /\ IV ]
      , talents: [ Name "<Talent>" ]
      , abilities:
          { active: [ Name "<Active ability>" ]
          , inactive: [ Name "<Inactive ability>" ]
          }
      }
  }
