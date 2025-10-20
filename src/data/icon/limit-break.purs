module ToA.Data.Icon.LimitBreak
  ( LimitBreak(..)
  ) where

import Prelude

import ToA.Data.Icon.Ability (Ability)
import ToA.Data.Icon.Name (class Named, getName, setName)

data LimitBreak = LimitBreak Int Ability

instance Eq LimitBreak where
  eq (LimitBreak _ n) (LimitBreak _ m) = n == m

instance Named LimitBreak where
  getName (LimitBreak _ a) = getName a
  setName (LimitBreak r a) n = LimitBreak r $ setName a n
