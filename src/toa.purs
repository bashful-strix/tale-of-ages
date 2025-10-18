module ToA
  ( Query(..)
  , toa
  ) where

import Prelude

import Data.Codec (encode)
import Data.Maybe (Maybe(..), fromMaybe)

import Halogen as HC
import Halogen.HTML as H
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore, StoreT, updateStore)
import Halogen.Store.Select (selectAll)

import Routing.Duplex (print)

import Run (Run, AFF, EFFECT)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Capability.Log (LOG, debug)
import ToA.Capability.Navigate (NAVIGATE)
import ToA.Capability.Theme (THEME, readStorage, readSystem)
import ToA.Component.TitleBar (titleBar)
import ToA.Data.Env (Env, EnvAction(..))
import ToA.Data.Route (Route(..), routeCodec)
import ToA.Data.Theme (themeCodec)
import ToA.Page.Home (homePage)
import ToA.Page.Unknown (unknownPage)
import ToA.Util.Html (css)

type Slots =
  ( titleBar :: ∀ q. HC.Slot q Void Unit
  , homePage :: ∀ q. HC.Slot q Void Unit
  , unknownPage :: ∀ q. HC.Slot q Void Unit
  )

data Query a = TellRoute (Maybe Route) a

data Action
  = Init
  | Receive (Connected Env Unit)

deriveState :: Connected Env Unit -> Env
deriveState = _.context

toa
  :: ∀ o r
  . HC.Component Query Unit o
      (StoreT EnvAction Env (Run (AFF + EFFECT + LOG + NAVIGATE + THEME + r)))
toa =
  connect selectAll $ HC.mkComponent
    { initialState: deriveState
    , render
    , eval: HC.mkEval $ HC.defaultEval
        { initialize = pure Init
        , handleAction = act
        , handleQuery = query
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

  query
    :: ∀ out m a
     . MonadStore EnvAction Env m
    => Query a
    -> HC.HalogenM Env Action Slots out m (Maybe a)
  query = case _ of
    TellRoute route next -> do
      updateStore $ SetRoute route
      pure $ pure next

  render { route, systemTheme, theme } =
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
              , "overflow-scroll"
              ]
          ]
          [ H.text $ show $ print routeCodec <$> route
          , case route of
              Just Home -> H.slot_ (Proxy :: _ "homePage") unit homePage unit
              Just (Test s) -> H.text s
              Nothing -> H.slot_ (Proxy :: _ "unknownPage") unit unknownPage
                unit
          ]
      ]
