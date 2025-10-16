module ToA.Data.Env.Effects.Log
  ( LogEffects
  , _error
  , _warn
  , _info
  , _debug
  ) where

import Prelude
import Effect (Effect)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Type.Proxy (Proxy(..))

type LogEffects =
  { error :: String -> Effect Unit
  , warn :: String -> Effect Unit
  , info :: String -> Effect Unit
  , debug :: String -> Effect Unit
  }

_error :: Lens' LogEffects (String -> Effect Unit)
_error = prop (Proxy :: _ "error")

_warn :: Lens' LogEffects (String -> Effect Unit)
_warn = prop (Proxy :: _ "warn")

_info :: Lens' LogEffects (String -> Effect Unit)
_info = prop (Proxy :: _ "info")

_debug :: Lens' LogEffects (String -> Effect Unit)
_debug = prop (Proxy :: _ "debug")
