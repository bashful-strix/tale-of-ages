module ToA where

import Prelude

import Data.Codec (encode)
import Data.Maybe (fromMaybe)

import Halogen as HC
import Halogen.HTML as H
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (StoreT, updateStore)
import Halogen.Store.Select (selectAll)

import Run (Run, AFF, EFFECT)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Capability.Log (LOG, debug)
import ToA.Capability.Theme (THEME, readStorage, readSystem)
import ToA.Component.TitleBar (titleBar)
import ToA.Data.Theme (themeCodec)
import ToA.Data.Env (Env, EnvAction(..))
import ToA.Util.Html (css)

type Slots = (titleBar :: ∀ q. HC.Slot q Void Unit)

data Action
  = Init
  | Receive (Connected Env Unit)

deriveState :: Connected Env Unit -> Env
deriveState = _.context

toa
  :: ∀ q o r
  . HC.Component q Unit o
      (StoreT EnvAction Env (Run (AFF + EFFECT + LOG + THEME + r)))
toa =
  connect selectAll $ HC.mkComponent
    { initialState: deriveState
    , render
    , eval: HC.mkEval $ HC.defaultEval
        { initialize = pure Init
        , handleAction = act
        , receive = pure <<< Receive
        }
    }

  where
  act = case _ of
    Init -> do
      systemTheme <- HC.lift $ HC.lift readSystem
      storageTheme <- HC.lift $ HC.lift readStorage

      updateStore $ SetSystemTheme systemTheme
      updateStore $ SetTheme storageTheme

      HC.lift $ HC.lift $ debug "started!"

    Receive env ->
      HC.put $ deriveState env

  render { systemTheme, theme } =
    H.div
      [ css
          [ "w-dvw"
          , "h-dvh"
          , "flex"
          , "items-center"
          , "justify-center"
          , "flex-col"
          , "bg-stone-300"
          , "text-stone-700"
          , "dark:bg-stone-900"
          , "dark:text-stone-400"
          , encode themeCodec (fromMaybe systemTheme theme)
          ]
      ]
      [ H.slot_ (Proxy :: _ "titleBar") unit titleBar unit
      , H.div
          [ css
              [ "flex"
              , "grow"
              , "items-center"
              , "justify-center"
              , "overflow-hidden"
              ]
          ]
          [ H.text "Tale of Ages" ]
      ]
