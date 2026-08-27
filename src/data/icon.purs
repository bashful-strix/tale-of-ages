module ToA.Data.Icon
  ( Icon
  , _classes
  , _colours
  , _souls
  , _jobs
  , _traits
  , _talents
  , _abilities
  , _keywords
  , _foes
  , _foeClasses
  , _factions
  ) where

import Data.Lens (Lens')

import ToA.Data.Icon.Colour (Colour)
import ToA.Data.Icon.Keyword (Keyword)
import ToA.Data.Icon.Trait (Trait)

import ToA.Data.Icon.Pc.Ability (Ability)
import ToA.Data.Icon.Pc.Class (Class)
import ToA.Data.Icon.Pc.Job (Job)
import ToA.Data.Icon.Pc.Soul (Soul)
import ToA.Data.Icon.Pc.Talent (Talent)

import ToA.Data.Icon.Foe.Class (FoeClass)
import ToA.Data.Icon.Foe.Faction (Faction)
import ToA.Data.Icon.Foe.Job (FoeJob)

import ToA.Util.Optic (key)

type Icon =
  { classes :: Array Class
  , colours :: Array Colour
  , souls :: Array Soul
  , jobs :: Array Job
  , traits :: Array Trait
  , talents :: Array Talent
  , abilities :: Array Ability
  , keywords :: Array Keyword
  , foes :: Array FoeJob
  , foeClasses :: Array FoeClass
  , factions :: Array Faction
  }

_classes :: Lens' Icon (Array Class)
_classes = key @"classes"

_colours :: Lens' Icon (Array Colour)
_colours = key @"colours"

_souls :: Lens' Icon (Array Soul)
_souls = key @"souls"

_jobs :: Lens' Icon (Array Job)
_jobs = key @"jobs"

_traits :: Lens' Icon (Array Trait)
_traits = key @"traits"

_talents :: Lens' Icon (Array Talent)
_talents = key @"talents"

_abilities :: Lens' Icon (Array Ability)
_abilities = key @"abilities"

_keywords :: Lens' Icon (Array Keyword)
_keywords = key @"keywords"

_foes :: Lens' Icon (Array FoeJob)
_foes = key @"foes"

_foeClasses :: Lens' Icon (Array FoeClass)
_foeClasses = key @"foeClasses"

_factions :: Lens' Icon (Array Faction)
_factions = key @"factions"
