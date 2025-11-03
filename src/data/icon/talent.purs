module ToA.Data.Icon.Talent
  ( Talent(..)
  ) where

import Prelude

import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)

newtype Talent = Talent
  { name :: Name
  , description :: Markup
  }

derive instance Newtype Talent _
instance Eq Talent where
  eq (Talent { name: n }) (Talent { name: m }) = n == m

instance Named Talent where
  getName (Talent { name }) = name
  setName (Talent t) n = Talent t { name = n }

instance Described Talent Markup where
  getDesc (Talent { description }) = description
  setDesc (Talent t) d = Talent t { description = d }
