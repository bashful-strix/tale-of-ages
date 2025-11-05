module ToA.Data.Icon.Trait
  ( Trait(..)
  , class Traited
  , _trait
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Trait = Trait
  { name :: Name
  , description :: Markup
  }

derive instance Newtype Trait _
instance Eq Trait where
  eq (Trait { name: n }) (Trait { name: m }) = n == m

instance Named Trait where
  _name = _Newtype <<< key @"name"

instance Described Trait where
  _desc = _Newtype <<< key @"description"

class Traited a where
  _trait :: Lens' a Name
