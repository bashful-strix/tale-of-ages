module ToA.Data.Icon.Ability
  ( Ability(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name, class Named)

data Ability = Ability Name

instance Eq Ability where
  eq (Ability n) (Ability m) = n == m

instance Named Ability where
  getName (Ability n) = n
  setName (Ability _) n = Ability n
