module ToA.Data.Icon.LimitBreak
  ( LimitBreak(..)
  ) where

import Prelude

import ToA.Data.Icon.Ability (Ability)

data LimitBreak = LimitBreak Int Ability

instance Eq LimitBreak where
  eq (LimitBreak _ n) (LimitBreak _ m) = n == m
