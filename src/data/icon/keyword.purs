module ToA.Data.Icon.Keyword
  ( Keyword(..)
  , Category(..)
  , StatusType(..)
  ) where

import Prelude

import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (Name, class Named)

newtype Keyword = Keyword
  { name :: Name
  , category :: Category
  , description :: String
  }

derive instance Newtype Keyword _
instance Eq Keyword where
  eq (Keyword { name: n }) (Keyword { name: m }) = n == m

instance Named Keyword where
  getName (Keyword { name }) = name
  setName (Keyword k) n = Keyword k { name = n }

instance Described Keyword String where
  getDesc (Keyword { description }) = description
  setDesc (Keyword k) d = Keyword k { description = d }

data Category
  = Status StatusType
  | Tag
  | General

data StatusType
  = Positive
  | Negative
