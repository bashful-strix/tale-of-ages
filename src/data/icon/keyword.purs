module ToA.Data.Icon.Keyword
  ( Keyword(..)
  , _category
  , Category(..)
  , _Status
  , _Tag
  , _General
  , StatusType(..)
  , _Positive
  , _Negative
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (Prism', only, prism')
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Keyword = Keyword
  { name :: Name
  , category :: Category
  , description :: Markup
  }

derive instance Newtype Keyword _
instance Eq Keyword where
  eq (Keyword { name: n }) (Keyword { name: m }) = n == m

instance Named Keyword where
  _name = _Newtype <<< key @"name"

instance Described Keyword where
  _desc = _Newtype <<< key @"description"

_category :: Lens' Keyword Category
_category = _Newtype <<< key @"category"

data Category
  = Status StatusType
  | Tag
  | General

derive instance Eq Category

_Status :: Prism' Category StatusType
_Status = prism' Status case _ of
  Status t -> Just t
  _ -> Nothing

_Tag :: Prism' Category Unit
_Tag = only Tag

_General :: Prism' Category Unit
_General = only General

data StatusType
  = Positive
  | Negative

derive instance Eq StatusType

_Positive :: Prism' StatusType Unit
_Positive = only Positive

_Negative :: Prism' StatusType Unit
_Negative = only Negative
