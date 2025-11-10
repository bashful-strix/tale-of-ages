module ToA.Data.Icon.Name
  ( Name(..)
  , class Named
  , _name
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Newtype (class Newtype)

newtype Name = Name String

derive instance Newtype Name _
derive newtype instance Eq Name
derive newtype instance Ord Name

class Named a where
  _name :: Lens' a Name
