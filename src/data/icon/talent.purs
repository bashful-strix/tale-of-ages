module ToA.Data.Icon.Talent
  ( Talent(..)
  , _subItem
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (SubItem)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Talent = Talent
  { name :: Name
  , colour :: Name
  , description :: Markup
  , subItem :: Maybe SubItem
  }

derive instance Newtype Talent _
instance Eq Talent where
  eq (Talent { name: n }) (Talent { name: m }) = n == m

instance Named Talent where
  _name = _Newtype <<< key @"name"

instance Coloured Talent where
  _colour = _Newtype <<< key @"colour"

_subItem :: Lens' Talent (Maybe SubItem)
_subItem = _Newtype <<< key @"subItem"

instance Described Talent where
  _desc = _Newtype <<< key @"description"
