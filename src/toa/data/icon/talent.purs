module ToA.Data.Icon.Talent
  ( Talent(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name)

data Talent = Talent Name String

instance Eq Talent where
  eq (Talent n _) (Talent m _) = n == m
