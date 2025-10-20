module ToA.Data.Icon.Ability
  ( Ability(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name)

data Ability
  = Ability Name
  | LimitBreak Name Int

instance Eq Ability where
  eq (Ability n) (Ability m) = n == m
  eq (LimitBreak n _) (LimitBreak m _) = n == m
  eq _ _ = false
