module ToA.Data.Icon.Name
  ( Name(..)
  , class Named
  , getName
  , setName
  , _name
  ) where

import Prelude

import Data.Lens (Lens', lens)
import Data.Newtype (class Newtype)

newtype Name = Name String

derive instance Newtype Name _
derive newtype instance Eq Name

class Named a where
  getName :: a -> Name
  setName :: a -> Name -> a

_name :: ∀ a. Named a => Lens' a Name
_name = lens getName setName
