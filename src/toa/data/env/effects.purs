module ToA.Data.Env.Effects
  ( EnvEffects
  , _log
  ) where

import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Type.Proxy (Proxy(..))

import ToA.Data.Env.Effects.Log (LogEffects)

type EnvEffects =
  { log :: LogEffects
  }

_log :: Lens' EnvEffects LogEffects
_log = prop (Proxy :: _ "log")
