module ToA.Data.Icon.Colour
  ( Colour(..)
  , class Coloured
  , _colour
  , _value
  ) where

import Prelude

import Color (Color)

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Colour = Colour
  { name :: Name
  , value :: Color
  }

derive instance Newtype Colour _
instance Eq Colour where
  eq (Colour { name: n }) (Colour { name: m }) = n == m

instance Named Colour where
  _name = _Newtype <<< key @"name"

class Coloured a where
  _colour :: Lens' a Name

_value :: Lens' Colour Color
_value = _Newtype <<< key @"value"
