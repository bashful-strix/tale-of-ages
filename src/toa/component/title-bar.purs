module ToA.Component.TitleBar
  ( titleBar
  ) where

import Prelude

import Control.Monad.Trans.Class (lift)

import Data.Codec (decode, encode)
import Data.Maybe (Maybe(..))

import Halogen as HC
import Halogen.HTML as H
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (StoreT, updateStore)
import Halogen.Store.Select (selectEq)

import Run (Run, EFFECT)
import Type.Row (type (+))

import ToA.Capability.Theme (THEME, save)
import ToA.Data.Theme (Theme(..), themeCodec)
import ToA.Data.Env (Env, EnvAction(..))
import ToA.Util.Html (css)

type State =
  { theme :: Maybe Theme
  }

data Action
  = SelectTheme String
  | Receive (Connected (Maybe Theme) Unit)

deriveState :: Connected (Maybe Theme) Unit -> State
deriveState { context } = { theme: context }

titleBar
  :: ∀ q o r
  . HC.Component q Unit o (StoreT EnvAction Env (Run (EFFECT + THEME + r)))
titleBar =
  connect (selectEq _.theme) $ HC.mkComponent
    { initialState: deriveState
    , render
    , eval: HC.mkEval $ HC.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }

  where
  act = case _ of
    SelectTheme e -> do
      let theme = decode themeCodec e
      updateStore $ SetTheme theme
      lift $ HC.lift $ save theme

    Receive env ->
      HC.put $ deriveState env

  render { theme } =
    H.div
      [ css
          [ "h-10"
          , "w-full"
          , "flex"
          , "items-center"
          , "justify-between"
          , "p-2"
          , "bg-stone-500"
          , "text-stone-800"
          , "dark:bg-stone-700"
          , "dark:text-stone-300"
          ]
      ]
      [ H.div [] [ H.text "ToA" ]
      , H.div
          []
          [ H.select
              [ HE.onValueChange SelectTheme
              ]
              [ H.option
                  [ HP.value $ encode themeCodec Light
                  , HP.selected $ theme == Just Light
                  -- , DA.unset @"selected" $ filter (not <<< eq (Just Light)) theme
                  ]
                  [ H.text "Light" ]
              , H.option
                  [ HP.value $ encode themeCodec Dark
                  , HP.selected $ theme == Just Dark
                  -- , DA.unset @"selected" $ filter (not <<< eq (Just Dark)) theme
                  ]
                  [ H.text "Dark" ]
              , H.option
                  [ HP.value ""
                  , HP.selected $ theme == Nothing
                  -- , DA.unset @"selected" $ filter (not <<< eq Nothing) theme
                  ]
                  [ H.text "System" ]
              ]
          ]
      ]
