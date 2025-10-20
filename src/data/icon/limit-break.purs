module ToA.Data.Icon.LimitBreak
  ( LimitBreak(..)
  , _resolve
  , _ability
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (Ability)
import ToA.Data.Icon.Name (class Named, getName, setName)
import ToA.Util.Optic (key)

newtype LimitBreak = LimitBreak
  { resolve :: Int
  , ability :: Ability
  }

derive instance Newtype LimitBreak _
instance Eq LimitBreak where
  eq (LimitBreak { ability: a }) (LimitBreak { ability: b }) = a == b

instance Named LimitBreak where
  getName (LimitBreak { ability }) = getName ability
  setName (LimitBreak lb) n = LimitBreak lb { ability = setName lb.ability n }

_resolve :: Lens' LimitBreak Int
_resolve = _Newtype <<< key @"resolve"

_ability :: Lens' LimitBreak Ability
_ability = _Newtype <<< key @"ability"
