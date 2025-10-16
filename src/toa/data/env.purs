module ToA.Data.Env
  ( Env
  , _effects

  , _errorLog
  , _warnLog
  , _infoLog
  , _debugLog

  ) where

import Prelude
import Effect (Effect)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Type.Proxy (Proxy(..))

import ToA.Data.Env.Effects (EnvEffects, _log)
import ToA.Data.Env.Effects.Log (_debug, _error, _info, _warn)

type Env =
  { effects :: EnvEffects
  }

_effects :: Lens' Env EnvEffects
_effects = prop (Proxy :: _ "effects")

-- compositions

_errorLog :: Lens' Env (String -> Effect Unit)
_errorLog = _effects <<< _log <<< _error

_warnLog :: Lens' Env (String -> Effect Unit)
_warnLog = _effects <<< _log <<< _warn

_infoLog :: Lens' Env (String -> Effect Unit)
_infoLog = _effects <<< _log <<< _info

_debugLog :: Lens' Env (String -> Effect Unit)
_debugLog = _effects <<< _log <<< _debug
