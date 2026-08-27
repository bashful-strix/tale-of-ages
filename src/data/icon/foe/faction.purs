module ToA.Data.Icon.Foe.Faction
  ( Faction(..)
  , _template
  , _mechanic
  , _keywords

  , FactionMechanic(..)
  , FactionTemplate(..)
  ) where

import ToA.Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (class Named, Name)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Trait (class Traited)

import ToA.Util.Optic (key)

newtype FactionTemplate = FactionTemplate
  { description :: Markup
  , traits :: Array Name
  }

derive instance Newtype FactionTemplate _

instance Described FactionTemplate where
  _desc = _Newtype <<< key @"description"

instance Traited FactionTemplate (Array Name) where
  _trait = _Newtype <<< key @"traits"

newtype FactionMechanic = FactionMechanic
  { name :: Name
  , description :: Markup
  }

derive instance Newtype FactionMechanic _

instance Named FactionMechanic where
  _name = _Newtype <<< key @"name"

instance Described FactionMechanic where
  _desc = _Newtype <<< key @"description"

newtype Faction = Faction
  { name :: Name
  , description :: Markup
  , template :: FactionTemplate
  , mechanic :: FactionMechanic
  , keywords :: Array Name
  }

derive instance Newtype Faction _

instance Named Faction where
  _name = _Newtype <<< key @"name"

instance Described Faction where
  _desc = _Newtype <<< key @"description"

_template :: Lens' Faction FactionTemplate
_template = _Newtype <. key @"template"

_mechanic :: Lens' Faction FactionMechanic
_mechanic = _Newtype <. key @"mechanic"

_keywords :: Lens' Faction (Array Name)
_keywords = _Newtype <. key @"keywords"
