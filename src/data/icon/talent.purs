module ToA.Data.Icon.Talent
  ( Talent(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name, class Named)

data Talent = Talent Name String

instance Eq Talent where
  eq (Talent n _) (Talent m _) = n == m

instance Named Talent where
  getName (Talent n _) = n
  setName (Talent _ d) n = Talent n d
