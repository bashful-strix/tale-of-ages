module ToA.Data.Icon.Ability
  ( Ability(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name)

newtype Ability = Ability Name

instance Eq Ability where
  eq (Ability n) (Ability m) = n == m
