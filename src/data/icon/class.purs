module ToA.Data.Icon.Class
  ( Class(..)
  , class Classed
  , getClass
  , setClass
  , _class
  , _tagline
  , _strengths
  , _weaknesses
  , _complexity
  , _move
  , _hp
  , _defense
  , _trait
  , _basic
  , _keywords
  , _apprentice
  ) where

import Prelude

import Data.Lens (Lens', lens)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Class = Class
  { name :: Name
  , tagline :: String
  , strengths :: String
  , weaknesses :: String
  , complexity :: String
  , description :: String
  , move :: Int
  , hp :: Int
  , defense :: Int
  , trait :: Name
  , basic :: Name
  , keywords :: Array Name
  , apprentice :: Array Name
  }

derive instance Newtype Class _
instance Eq Class where
  eq (Class { name: n }) (Class { name: m }) = n == m

instance Named Class where
  getName (Class { name }) = name
  setName (Class c) n = Class c { name = n }

instance Described Class where
  getDesc (Class { description }) = description
  setDesc (Class c) d = Class c { description = d }

_tagline :: Lens' Class String
_tagline = _Newtype <<< key @"tagline"

_strengths :: Lens' Class String
_strengths = _Newtype <<< key @"strengths"

_weaknesses :: Lens' Class String
_weaknesses = _Newtype <<< key @"weaknesses"

_complexity :: Lens' Class String
_complexity = _Newtype <<< key @"complexity"

_move :: Lens' Class Int
_move = _Newtype <<< key @"move"

_hp :: Lens' Class Int
_hp = _Newtype <<< key @"hp"

_defense :: Lens' Class Int
_defense = _Newtype <<< key @"defense"

_trait :: Lens' Class Name
_trait = _Newtype <<< key @"trait"

_basic :: Lens' Class Name
_basic = _Newtype <<< key @"basic"

_keywords :: Lens' Class (Array Name)
_keywords = _Newtype <<< key @"keywords"

_apprentice :: Lens' Class (Array Name)
_apprentice = _Newtype <<< key @"apprentice"

class Classed a where
  getClass :: a -> Name
  setClass :: a -> Name -> a

_class :: ∀ a. Classed a => Lens' a Name
_class = lens getClass setClass
