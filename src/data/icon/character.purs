module ToA.Data.Icon.Character
  ( Character(..)
  , _hp
  , _vigor
  , _wounded
  , _scars
  , _build

  , Build(..)
  , _level
  , _jobs
  , _primaryJob
  , _abilities
  , _prepared
  , _talents

  , Level(..)
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Job (JobLevel)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype Character = Character
  { name :: Name
  , hp :: Int
  , vigor :: Int
  , wounded :: Boolean
  , scars :: Int
  , build :: Build
  }

derive instance Newtype Character _
instance Eq Character where
  eq (Character { name: n }) (Character { name: m }) = n == m

instance Named Character where
  _name = _Newtype <<< key @"name"

_hp :: Lens' Character Int
_hp = _Newtype <<< key @"hp"

_vigor :: Lens' Character Int
_vigor = _Newtype <<< key @"vigor"

_wounded :: Lens' Character Boolean
_wounded = _Newtype <<< key @"wounded"

_scars :: Lens' Character Int
_scars = _Newtype <<< key @"scars"

_build :: Lens' Character Build
_build = _Newtype <<< key @"build"

newtype Build = Build
  { level :: Level
  , jobs :: Map Name JobLevel
  , primaryJob :: Name
  , abilities :: Array Name
  , prepared :: Array Name
  , talents :: Array Name
  }

_level :: Lens' Build Level
_level = _Newtype <<< key @"level"

_jobs :: Lens' Build (Map Name JobLevel)
_jobs = _Newtype <<< key @"jobs"

_primaryJob :: Lens' Build Name
_primaryJob = _Newtype <<< key @"primaryJob"

_abilities :: Lens' Build (Array Name)
_abilities = _Newtype <<< key @"abilities"

_prepared :: Lens' Build (Array Name)
_prepared = _Newtype <<< key @"prepared"

_talents :: Lens' Build (Array Name)
_talents = _Newtype <<< key @"talents"

derive instance Newtype Build _

data Level
  = Zero
  | One
  | Two
  | Three
  | Four
  | Five
  | Six
  | Seven
  | Eight
  | Nine
  | Ten
  | Eleven
  | Twelve

derive instance Eq Level
derive instance Ord Level
instance Show Level where
  show Zero = "0"
  show One = "1"
  show Two = "2"
  show Three = "3"
  show Four = "4"
  show Five = "5"
  show Six = "6"
  show Seven = "7"
  show Eight = "8"
  show Nine = "9"
  show Ten = "10"
  show Eleven = "11"
  show Twelve = "12"
