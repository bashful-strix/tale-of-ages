module ToA.Data.Env.Effects
  ( EnvEffects
  , _log
  , _storage
  ) where

import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Type.Proxy (Proxy(..))

import ToA.Data.Env.Effects.Log (LogEffects)
import ToA.Data.Env.Effects.Storage (StorageEffects)

type EnvEffects =
  { log :: LogEffects
  , storage :: StorageEffects
  }

_log :: Lens' EnvEffects LogEffects
_log = prop (Proxy :: _ "log")

_storage :: Lens' EnvEffects StorageEffects
_storage = prop (Proxy :: _ "storage")

