module ToA.Data.Icon.Foe.Class
  ( FoeClass(..)
  , _hp
  , _maxVigor
  , _defense
  , _move
  ) where

import ToA.Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (class Abilitied)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (class Named, Name)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Trait (class Traited)

import ToA.Data.Icon.Foe.Ability (FoeAbility)
import ToA.Data.Icon.Foe.Trait (FoeTrait)

import ToA.Util.Optic (key)

newtype FoeClass = FoeClass
  { name :: Name
  , colour :: Name
  , description :: Markup
  , hp :: Int
  , maxVigor :: Maybe Int
  , defense :: Int
  , move :: Int
  , traits :: Array FoeTrait
  , abilities :: Array FoeAbility
  }

derive instance Newtype FoeClass _

instance Eq FoeClass where
  eq (FoeClass { name: a }) (FoeClass { name: b }) = a == b

instance Named FoeClass where
  _name = _Newtype <<< key @"name"

instance Coloured FoeClass where
  _colour = _Newtype <<< key @"colour"

instance Described FoeClass where
  _desc = _Newtype <<< key @"description"

instance Traited FoeClass (Array FoeTrait) where
  _trait = _Newtype <. key @"traits"

instance Abilitied FoeClass (Array FoeAbility) where
  _abilities = _Newtype <. key @"abilities"

_hp :: Lens' FoeClass Int
_hp = _Newtype <. key @"hp"

_maxVigor :: Lens' FoeClass (Maybe Int)
_maxVigor = _Newtype <. key @"maxVigor"

_defense :: Lens' FoeClass Int
_defense = _Newtype <. key @"defense"

_move :: Lens' FoeClass Int
_move = _Newtype <. key @"move"
