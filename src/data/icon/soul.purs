module ToA.Data.Icon.Soul
  ( Soul(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name)

data Soul = Soul Name String

instance Eq Soul where
  eq (Soul n _) (Soul m _) = n == m
