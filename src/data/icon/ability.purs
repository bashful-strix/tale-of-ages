module ToA.Data.Icon.Ability
  ( Ability(..)
  ) where

import Prelude

import Data.Newtype (class Newtype)

import ToA.Data.Icon.Name (Name, class Named)

newtype Ability = Ability Name

derive instance Newtype Ability _
instance Eq Ability where
  eq (Ability n) (Ability m) = n == m

instance Named Ability where
  getName (Ability n) = n
  setName (Ability _) n = Ability n
