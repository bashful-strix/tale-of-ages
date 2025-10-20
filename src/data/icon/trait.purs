module ToA.Data.Icon.Trait
  ( Trait(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name, class Named)

data Trait = Trait Name String

instance Eq Trait where
  eq (Trait n _) (Trait m _) = n == m

instance Named Trait where
  getName (Trait n _) = n
  setName (Trait _ d) n = Trait n d
