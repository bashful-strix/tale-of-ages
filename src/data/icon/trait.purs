module ToA.Data.Icon.Trait
  ( Trait(..)
  , class Traited
  , getTrait
  , setTrait
  , _trait
  ) where

import Prelude

import Data.Lens (Lens', lens)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (Name, class Named)

newtype Trait = Trait
  { name :: Name
  , description :: String
  }

derive instance Newtype Trait _
instance Eq Trait where
  eq (Trait { name: n }) (Trait { name: m }) = n == m

instance Named Trait where
  getName (Trait { name }) = name
  setName (Trait t) n = Trait t { name = n }

instance Described Trait where
  getDesc (Trait { description }) = description
  setDesc (Trait t) d = Trait t { description = d }

class Traited a where
  getTrait :: a -> Name
  setTrait :: a -> Name -> a

_trait :: ∀ a. Traited a => Lens' a Name
_trait = lens getTrait setTrait
