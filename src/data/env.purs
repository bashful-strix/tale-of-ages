module ToA.Data.Env
  ( Env

  , _saveChar
  , _deleteChar
  , _storageChars

  , _saveEnc
  , _deleteEnc
  , _storageEncs

  , _errorLog
  , _warnLog
  , _infoLog
  , _debugLog

  , _navigate
  , _matchRoutes

  , _read
  , _write
  , _delete

  , _saveTheme
  , _storageTheme
  , _systemTheme
  ) where

import Prelude
import Effect (Effect)
import Data.Lens (Lens')
import Data.Map (Map)
import Data.Maybe (Maybe)
import FRP.Poll (Poll)
import Web.PointerEvent.PointerEvent (PointerEvent)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Character (Character)
import ToA.Data.Icon.Encounter (Encounter)
import ToA.Data.Icon.Name (Name)
import ToA.Data.Route (Route)
import ToA.Data.Theme (Theme)
import ToA.Util.Optic (key)

type Env =
  { icon :: Poll Icon
  , characters :: Poll (Map Name Character)
  , encounters :: Poll (Map Name Encounter)
  , route :: Poll (Maybe Route)
  , systemTheme :: Theme
  , theme :: Poll (Maybe Theme)

  , effects ::
      { character ::
          { save :: Character -> Effect Unit
          , delete :: Character -> Effect Unit
          , readStorage :: Effect (Map Name Character)
          }
      , encounter ::
          { save :: Encounter -> Effect Unit
          , delete :: Encounter -> Effect Unit
          , readStorage :: Effect (Map Name Encounter)
          }
      , log ::
          { error :: String -> Effect Unit
          , warn :: String -> Effect Unit
          , info :: String -> Effect Unit
          , debug :: String -> Effect Unit
          }
      , route ::
          { navigate :: Route -> Maybe PointerEvent -> Effect Unit
          , matchRoutes :: (Route -> Effect Unit) -> Effect Unit
          }
      , storage ::
          { read :: String -> Effect (Maybe String)
          , write :: String -> String -> Effect Unit
          , delete :: String -> Effect Unit
          }
      , theme ::
          { save :: Maybe Theme -> Effect Unit
          , readStorage :: Effect (Maybe Theme)
          , readSystem :: Effect Theme
          }
      }
  }

_effects :: ∀ r a. Lens' { effects :: a | r } a
_effects = key @"effects"

_char :: ∀ r a. Lens' { character :: a | r } a
_char = key @"character"

_enc :: ∀ r a. Lens' { encounter :: a | r } a
_enc = key @"encounter"

_log :: ∀ r a. Lens' { log :: a | r } a
_log = key @"log"

_route :: ∀ r a. Lens' { route :: a | r } a
_route = key @"route"

_storage :: ∀ r a. Lens' { storage :: a | r } a
_storage = key @"storage"

_theme :: ∀ r a. Lens' { theme :: a | r } a
_theme = key @"theme"

_saveChar :: Lens' Env (Character -> Effect Unit)
_saveChar = _effects <<< _char <<< key @"save"

_deleteChar :: Lens' Env (Character -> Effect Unit)
_deleteChar = _effects <<< _char <<< key @"delete"

_storageChars :: Lens' Env (Effect (Map Name Character))
_storageChars = _effects <<< _char <<< key @"readStorage"

_saveEnc :: Lens' Env (Encounter -> Effect Unit)
_saveEnc = _effects <<< _enc <<< key @"save"

_deleteEnc :: Lens' Env (Encounter -> Effect Unit)
_deleteEnc = _effects <<< _enc <<< key @"delete"

_storageEncs :: Lens' Env (Effect (Map Name Encounter))
_storageEncs = _effects <<< _enc <<< key @"readStorage"

_errorLog :: Lens' Env (String -> Effect Unit)
_errorLog = _effects <<< _log <<< key @"error"

_warnLog :: Lens' Env (String -> Effect Unit)
_warnLog = _effects <<< _log <<< key @"warn"

_infoLog :: Lens' Env (String -> Effect Unit)
_infoLog = _effects <<< _log <<< key @"info"

_debugLog :: Lens' Env (String -> Effect Unit)
_debugLog = _effects <<< _log <<< key @"debug"

_navigate :: Lens' Env (Route -> Maybe PointerEvent -> Effect Unit)
_navigate = _effects <<< _route <<< key @"navigate"

_matchRoutes :: Lens' Env ((Route -> Effect Unit) -> Effect Unit)
_matchRoutes = _effects <<< _route <<< key @"matchRoutes"

_read :: Lens' Env (String -> Effect (Maybe String))
_read = _effects <<< _storage <<< key @"read"

_write :: Lens' Env (String -> String -> Effect Unit)
_write = _effects <<< _storage <<< key @"write"

_delete :: Lens' Env (String -> Effect Unit)
_delete = _effects <<< _storage <<< key @"delete"

_saveTheme :: Lens' Env (Maybe Theme -> Effect Unit)
_saveTheme = _effects <<< _theme <<< key @"save"

_storageTheme :: Lens' Env (Effect (Maybe Theme))
_storageTheme = _effects <<< _theme <<< key @"readStorage"

_systemTheme :: Lens' Env (Effect Theme)
_systemTheme = _effects <<< _theme <<< key @"readSystem"
