module ToA.Data.Env.Effects.Route
  ( RouteEffects
  , _navigate
  , _matchRoutes
  ) where

import Prelude
import Data.Maybe (Maybe)
import Effect (Effect)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Type.Proxy (Proxy(..))
import Web.PointerEvent.PointerEvent (PointerEvent)

import ToA.Data.Route (Route)

type RouteEffects =
  { navigate :: Route -> Maybe PointerEvent -> Effect Unit
  , matchRoutes :: (Route -> Effect Unit) -> Effect Unit
  }

_navigate :: Lens' RouteEffects (Route -> Maybe PointerEvent -> Effect Unit)
_navigate = prop (Proxy :: _ "navigate")

_matchRoutes :: Lens' RouteEffects ((Route -> Effect Unit) -> Effect Unit)
_matchRoutes = prop (Proxy :: _ "matchRoutes")
