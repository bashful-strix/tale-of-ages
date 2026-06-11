module ToA.Capability.Storage
  ( class Storage
  , read
  , write
  , delete
  ) where

import ToA.Prelude

import Data.Maybe (Maybe)

import Effect.Class (liftEffect)

import Halogen (HalogenM, lift)

import Web.HTML (window)
import Web.HTML.Window (localStorage)
import Web.Storage.Storage (getItem, removeItem, setItem)

import ToA.ToAM (ToAM)
import ToA.Capability.Log (debug)

class Storage m where
  read :: String  -> m (Maybe String)
  write :: String -> String -> m Unit
  delete :: String -> m Unit

instance Storage ToAM where
  read key = do
    storage <- liftEffect $ window >>= localStorage
    debug $ "read storage: " <> key
    liftEffect $ getItem key storage

  write key value = do
    storage <- liftEffect $ window >>= localStorage
    debug $ "write storage: " <> key <> " | " <> value
    liftEffect $ setItem key value storage

  delete key = do
    storage <- liftEffect $ window >>= localStorage
    debug $ "delete storage: " <> key
    liftEffect $ removeItem key storage

instance (Monad m, Storage m) => Storage (HalogenM s a sl o m) where
  read = lift <<< read
  write = lift <.. write
  delete = lift <<< delete
