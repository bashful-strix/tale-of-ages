module ToA.Data.Icon.Soul
  ( Soul(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name, class Named)

data Soul = Soul
  { name :: Name
  , class :: Name
  , description :: String
  }

instance Eq Soul where
  eq (Soul { name: n }) (Soul { name: m }) = n == m

instance Named Soul where
  getName (Soul { name }) = name
  setName (Soul s) n = Soul s { name = n }
