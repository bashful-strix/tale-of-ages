module ToA.Data.Env.Effects
  ( EnvEffects
  , _log
  , _storage
  , _theme
  ) where

import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Type.Proxy (Proxy(..))

import ToA.Data.Env.Effects.Log (LogEffects)
import ToA.Data.Env.Effects.Storage (StorageEffects)
import ToA.Data.Env.Effects.Theme (ThemeEffects)

type EnvEffects =
  { log :: LogEffects
  , storage :: StorageEffects
  , theme :: ThemeEffects
  }

_log :: Lens' EnvEffects LogEffects
_log = prop (Proxy :: _ "log")

_storage :: Lens' EnvEffects StorageEffects
_storage = prop (Proxy :: _ "storage")
 
_theme :: Lens' EnvEffects ThemeEffects
_theme = prop (Proxy :: _ "theme")
