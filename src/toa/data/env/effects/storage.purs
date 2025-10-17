module ToA.Data.Env.Effects.Storage
  ( StorageEffects
  , _read
  , _write
  , _delete
  ) where

import Prelude
import Effect (Effect)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.Maybe (Maybe)
import Type.Proxy (Proxy(..))

type StorageEffects =
  { read :: String -> Effect (Maybe String)
  , write :: String -> String -> Effect Unit
  , delete :: String -> Effect Unit
  }

_read :: Lens' StorageEffects (String -> Effect (Maybe String))
_read = prop (Proxy :: _ "read")

_write :: Lens' StorageEffects (String -> String -> Effect Unit)
_write = prop (Proxy :: _ "write")

_delete :: Lens' StorageEffects (String -> Effect Unit)
_delete = prop (Proxy :: _ "delete")
