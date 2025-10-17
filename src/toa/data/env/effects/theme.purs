module ToA.Data.Env.Effects.Theme
  ( ThemeEffects
  , _save
  , _readStorage
  , _readSystem
  ) where

import Prelude
import Effect (Effect)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.Maybe (Maybe)
import Type.Proxy (Proxy(..))

import ToA.Data.Theme (Theme)

type ThemeEffects =
  { save :: Maybe Theme -> Effect Unit
  , readStorage :: Effect (Maybe Theme)
  , readSystem :: Effect Theme
  }

_save :: Lens' ThemeEffects (Maybe Theme -> Effect Unit)
_save = prop (Proxy :: _ "save")

_readStorage :: Lens' ThemeEffects (Effect (Maybe Theme))
_readStorage = prop (Proxy :: _ "readStorage")

_readSystem :: Lens' ThemeEffects (Effect Theme)
_readSystem = prop (Proxy :: _ "readSystem")
