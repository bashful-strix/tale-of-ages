module ToA.Data.Env
  ( Env
  , _effects

  , _errorLog
  , _warnLog
  , _infoLog
  , _debugLog

  , _readStore
  , _writeStore
  , _deleteStore

  , _saveTheme
  , _storageTheme
  , _systemTheme
  ) where

import Prelude
import Effect (Effect)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.Maybe (Maybe)
import FRP.Poll (Poll)
import Type.Proxy (Proxy(..))

import ToA.Data.Theme (Theme)
import ToA.Data.Env.Effects (EnvEffects, _log, _storage, _theme)
import ToA.Data.Env.Effects.Log (_debug, _error, _info, _warn)
import ToA.Data.Env.Effects.Storage (_delete, _read, _write)
import ToA.Data.Env.Effects.Theme (_readStorage, _readSystem, _save)

type Env =
  { effects :: EnvEffects
  , systemTheme :: Theme
  , theme :: Poll (Maybe Theme)
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

_readStore :: Lens' Env (String -> Effect (Maybe String))
_readStore = _effects <<< _storage <<< _read

_writeStore :: Lens' Env (String -> String -> Effect Unit)
_writeStore = _effects <<< _storage <<< _write

_deleteStore :: Lens' Env (String -> Effect Unit)
_deleteStore = _effects <<< _storage <<< _delete

_saveTheme :: Lens' Env (Maybe Theme -> Effect Unit)
_saveTheme = _effects <<< _theme <<< _save

_storageTheme :: Lens' Env (Effect (Maybe Theme))
_storageTheme = _effects <<< _theme <<< _readStorage

_systemTheme :: Lens' Env (Effect Theme)
_systemTheme = _effects <<< _theme <<< _readSystem
