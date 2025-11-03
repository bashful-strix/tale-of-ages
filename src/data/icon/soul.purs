module ToA.Data.Icon.Soul
  ( Soul(..)
  ) where

import Prelude

import Data.Newtype (class Newtype)

import ToA.Data.Icon.Class (class Classed)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)

newtype Soul = Soul
  { name :: Name
  , class :: Name
  , description :: Markup
  }

derive instance Newtype Soul _
instance Eq Soul where
  eq (Soul { name: n }) (Soul { name: m }) = n == m

instance Named Soul where
  getName (Soul { name }) = name
  setName (Soul s) n = Soul s { name = n }

instance Classed Soul where
  getClass (Soul s) = s.class
  setClass (Soul s) c = Soul s { class = c }

instance Described Soul Markup where
  getDesc (Soul { description }) = description
  setDesc (Soul s) d = Soul s { description = d }
