module ToA.Data.Icon.Class
  ( Class
  , Trait
  ) where

import ToA.Data.Icon.Name (Name)

data Trait = Trait Name String

type Class =
  { name :: Name
  , trait :: Trait
  , move :: Int
  , hp :: Int
  , defense :: Int
  , basic :: Name
  , apprentice :: Array Name
  }
