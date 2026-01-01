module ToA.Data.Icon.Trait
  ( Trait(..)
  , TraitData
  , _Trait
  , _InsetTrait
  , class Traited
  , _trait
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))

import Type.Row (type (+))

import ToA.Data.Icon.Ability (class Inseted, Inset)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

type TraitData r =
  ( name :: Name
  , description :: Markup
  | r
  )

data Trait
  = Trait { | TraitData + () }
  | InsetTrait { inset :: Inset | TraitData + () }

instance Eq Trait where
  eq (Trait { name: n }) (Trait { name: m }) = n == m
  eq (InsetTrait { name: n }) (InsetTrait { name: m }) = n == m
  eq _ _ = false

instance Named Trait where
  _name = lens' case _ of
    Trait a -> map Trait <$> lensStore k a
    InsetTrait a -> map InsetTrait <$> lensStore k a
    where
    k = key @"name"

instance Described Trait where
  _desc = lens' case _ of
    Trait a -> map Trait <$> lensStore k a
    InsetTrait a -> map InsetTrait <$> lensStore k a
    where
    k = key @"description"

instance Inseted Trait where
  _inset = _InsetTrait <<< key @"inset"

_Trait :: Prism' Trait ({ | TraitData + () })
_Trait = prism' Trait case _ of
  Trait a -> Just a
  _ -> Nothing

_InsetTrait :: Prism' Trait ({ inset :: Inset | TraitData + () })
_InsetTrait = prism' InsetTrait case _ of
  InsetTrait a -> Just a
  _ -> Nothing

class Traited a where
  _trait :: Lens' a Name
