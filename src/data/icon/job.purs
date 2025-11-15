module ToA.Data.Icon.Job
  ( Job(..)
  , _soul
  , _keyword
  , _abilities
  , _limitBreak
  , _talents

  , JobLevel(..)
  , _I
  , _II
  , _III
  , _IV
  ) where

import Prelude

import Data.FastVect.FastVect (Vect)
import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (Prism', only)
import Data.Newtype (class Newtype)
import Data.Tuple.Nested (type (/\))

import ToA.Data.Icon.Class (class Classed)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Data.Icon.Trait (class Traited)
import ToA.Util.Optic (key)

newtype Job = Job
  { name :: Name
  , colour :: Name
  , soul :: Name
  , class :: Name
  , description :: Markup
  , trait :: Name
  , keyword :: Name
  , abilities :: Vect 4 (JobLevel /\ Name)
  , limitBreak :: Name
  , talents :: Vect 3 Name
  }

derive instance Newtype Job _
instance Eq Job where
  eq (Job { name: n }) (Job { name: m }) = n == m

instance Named Job where
  _name = _Newtype <<< key @"name"

instance Coloured Job where
  _colour = _Newtype <<< key @"colour"

instance Classed Job where
  _class = _Newtype <<< key @"class"

instance Described Job where
  _desc = _Newtype <<< key @"description"

instance Traited Job where
  _trait = _Newtype <<< key @"trait"

_soul :: Lens' Job Name
_soul = _Newtype <<< key @"soul"

_keyword :: Lens' Job Name
_keyword = _Newtype <<< key @"keyword"

_abilities :: Lens' Job (Vect 4 (JobLevel /\ Name))
_abilities = _Newtype <<< key @"abilities"

_limitBreak :: Lens' Job Name
_limitBreak = _Newtype <<< key @"limitBreak"

_talents :: Lens' Job (Vect 3 Name)
_talents = _Newtype <<< key @"talents"

data JobLevel
  = I
  | II
  | III
  | IV

derive instance Eq JobLevel

_I :: Prism' JobLevel Unit
_I = only I

_II :: Prism' JobLevel Unit
_II = only II

_III :: Prism' JobLevel Unit
_III = only III

_IV :: Prism' JobLevel Unit
_IV = only IV
