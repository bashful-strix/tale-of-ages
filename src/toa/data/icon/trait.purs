module ToA.Data.Icon.Trait
  ( Trait(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name)

data Trait = Trait Name String

instance Eq Trait where
  eq (Trait n _) (Trait m _) = n == m
