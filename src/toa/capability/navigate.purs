module ToA.Capability.Navigate
  ( NavigateF
  , NAVIGATE

  , runNavigate

  , navigate
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import Effect.Class (liftEffect)
import Foreign (unsafeToForeign)

import Routing.Duplex (print)
import Routing.PushState (PushStateInterface)

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import Web.Event.Event (preventDefault)
import Web.UIEvent.MouseEvent (MouseEvent, toEvent)

import ToA.Capability.Log (LOG, debug)
import ToA.Data.Route (Route, routeCodec)

data NavigateF r
  = Navigate Route (Maybe MouseEvent) r

derive instance Functor NavigateF

type NAVIGATE r = (navigate :: NavigateF | r)
_navigate = Proxy :: Proxy "navigate"

navigate :: ∀ r. Route -> (Maybe MouseEvent) -> Run (NAVIGATE + r) Unit
navigate route ev = lift _navigate (Navigate route ev unit)

pushRoute :: ∀ r. PushStateInterface -> NavigateF ~> Run (EFFECT + LOG + r)
pushRoute { pushState } = case _ of
  Navigate route ev next -> do
    let r = print routeCodec route
    debug $ "navigating to: " <> r
    liftEffect $ case ev of
      Just e -> preventDefault $ toEvent e
      Nothing -> pure unit
    liftEffect $ pushState (unsafeToForeign unit) r
    pure next

runNavigate
  :: ∀ r
   . PushStateInterface
  -> Run (EFFECT + LOG + NAVIGATE + r) ~> Run (EFFECT + LOG + r)
runNavigate history = interpret (on _navigate (pushRoute history) send)
