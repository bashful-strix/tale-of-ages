module ToA.Data.Icon.Job
  ( Job(..)
  , _soul
  , _trait
  , _keyword
  , _abilities
  , _limitBreak
  , _talents

  , JobLevel(..)
  , _One
  , _Two
  , _Three
  , _Four
  ) where

import Prelude

import Data.FastVect.FastVect (Vect)
import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (Prism', only)
import Data.Newtype (class Newtype)
import Data.Tuple.Nested (type (/\))

import ToA.Data.Icon.Class (class Classed)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Job = Job
  { name :: Name
  , soul :: Name
  , class :: Name
  , description :: String
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
  getName (Job { name }) = name
  setName (Job j) n = Job j { name = n }

instance Classed Job where
  getClass (Job j) = j.class
  setClass (Job j) c = Job j { class = c }

instance Described Job where
  getDesc (Job { description }) = description
  setDesc (Job j) d = Job j { description = d }

_soul :: Lens' Job Name
_soul = _Newtype <<< key @"soul"

_trait :: Lens' Job Name
_trait = _Newtype <<< key @"trait"

_keyword :: Lens' Job Name
_keyword = _Newtype <<< key @"keyword"

_abilities :: Lens' Job (Vect 4 (JobLevel /\ Name))
_abilities = _Newtype <<< key @"abilities"

_limitBreak :: Lens' Job Name
_limitBreak = _Newtype <<< key @"limitBreak"

_talents :: Lens' Job (Vect 3 Name)
_talents = _Newtype <<< key @"talents"

data JobLevel
  = One
  | Two
  | Three
  | Four

derive instance Eq JobLevel

_One :: Prism' JobLevel Unit
_One = only One

_Two :: Prism' JobLevel Unit
_Two = only Two

_Three :: Prism' JobLevel Unit
_Three = only Three

_Four :: Prism' JobLevel Unit
_Four = only Four
