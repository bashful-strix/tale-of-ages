module ToA.Capability.Navigate
  ( class Navigate
  , navigate
  ) where

import ToA.Prelude

import Data.Maybe (Maybe(..))

import Effect.Class (liftEffect)
import Foreign (unsafeToForeign)

import Halogen (HalogenM, lift)
import Halogen.Store.Monad (getStore)

import Routing.Duplex (print)

import Web.Event.Event (preventDefault)
import Web.UIEvent.MouseEvent (MouseEvent, toEvent)

import ToA.ToAM (ToAM)
import ToA.Capability.Log (debug)
import ToA.Data.Route (Route, routeCodec)

class Navigate m where
  navigate :: Route -> Maybe MouseEvent -> m Unit

instance Navigate ToAM where
  navigate route ev = do
    { history: { pushState } } <- getStore
    let r = print routeCodec route
    debug $ "navigating to: " <> r
    liftEffect $ case ev of
      Just e -> preventDefault $ toEvent e
      Nothing -> pure unit
    liftEffect $ pushState (unsafeToForeign unit) r

instance (Monad m, Navigate m) => Navigate (HalogenM s a sl o m) where
  navigate = lift <.. navigate
