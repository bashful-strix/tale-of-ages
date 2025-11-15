module ToA.Data.Icon.Soul
  ( Soul(..)
  ) where

import Prelude

import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Class (class Classed)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Soul = Soul
  { name :: Name
  , colour :: Name
  , class :: Name
  , description :: Markup
  }

derive instance Newtype Soul _
instance Eq Soul where
  eq (Soul { name: n }) (Soul { name: m }) = n == m

instance Named Soul where
  _name = _Newtype <<< key @"name"

instance Coloured Soul where
  _colour = _Newtype <<< key @"colour"

instance Classed Soul where
  _class = _Newtype <<< key @"class"

instance Described Soul where
  _desc = _Newtype <<< key @"description"
