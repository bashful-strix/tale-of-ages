module ToA.Data.Icon.Trait
  ( Trait(..)
  , _subItem
  , class Traited
  , _trait
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (SubItem)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Trait = Trait
  { name :: Name
  , description :: Markup
  , subItem :: Maybe SubItem
  }

derive instance Newtype Trait _
instance Eq Trait where
  eq (Trait { name: n }) (Trait { name: m }) = n == m

instance Named Trait where
  _name = _Newtype <<< key @"name"

instance Described Trait where
  _desc = _Newtype <<< key @"description"

_subItem :: Lens' Trait (Maybe SubItem)
_subItem = _Newtype <<< key @"subItem"

class Traited a where
  _trait :: Lens' a Name
