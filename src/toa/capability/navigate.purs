module ToA.Capability.Navigate
  ( NavigateF
  , NAVIGATE

  , runNavigate

  , navigate
  , matchRoutes
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import Effect (Effect)
import Effect.Class (liftEffect)
import Foreign (unsafeToForeign)

import Routing.Duplex (parse, print)
import Routing.PushState (PushStateInterface, matchesWith)

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import Web.Event.Event (preventDefault)
import Web.PointerEvent.PointerEvent (PointerEvent, toEvent)

import ToA.Capability.Log (LOG, debug)
import ToA.Data.Route (Route, routeCodec)

data NavigateF r
  = Navigate Route (Maybe PointerEvent) r
  | MatchRoutes (Route -> Effect Unit) r

derive instance Functor NavigateF

type NAVIGATE r = (navigate :: NavigateF | r)
_navigate = Proxy :: Proxy "navigate"

navigate :: ∀ r. Route -> (Maybe PointerEvent) -> Run (NAVIGATE + r) Unit
navigate route ev = lift _navigate (Navigate route ev unit)

matchRoutes :: ∀ r. (Route -> Effect Unit) -> Run (NAVIGATE + r) Unit
matchRoutes act = lift _navigate (MatchRoutes act unit)

pushRoute :: ∀ r. PushStateInterface -> NavigateF ~> Run (EFFECT + LOG + r)
pushRoute history@{ pushState } = case _ of
  Navigate route ev next -> do
    let r = print routeCodec route
    debug $ "navigating to: " <> r
    liftEffect $ case ev of
      Just e -> preventDefault $ toEvent e
      Nothing -> pure unit
    liftEffect $ pushState (unsafeToForeign unit) r
    pure next

  MatchRoutes act next -> do
    debug $ "matching routes"
    liftEffect $ void $ history # matchesWith
      (parse routeCodec)
      \old new -> when (pure new /= old) (act new)
    pure next

runNavigate
  :: ∀ r
   . PushStateInterface
  -> Run (EFFECT + LOG + NAVIGATE + r) ~> Run (EFFECT + LOG + r)
runNavigate history = interpret (on _navigate (pushRoute history) send)
