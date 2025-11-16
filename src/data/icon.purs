module ToA.Data.Icon
  ( Icon
  , _classes
  , _colours
  , _souls
  , _jobs
  , _traits
  , _talents
  , _abilities
  , _summons
  , _keywords
  ) where

import Data.Lens (Lens')

import ToA.Data.Icon.Ability (Ability)
import ToA.Data.Icon.Class (Class)
import ToA.Data.Icon.Colour (Colour)
import ToA.Data.Icon.Foe (Faction, Foe, FoeClass)
import ToA.Data.Icon.Job (Job)
import ToA.Data.Icon.Keyword (Keyword)
import ToA.Data.Icon.Name (Name)
import ToA.Data.Icon.Soul (Soul)
import ToA.Data.Icon.Talent (Talent)
import ToA.Data.Icon.Trait (Trait)

import ToA.Util.Optic (key)

type Icon =
  { classes :: Array Class
  , colours :: Array Colour
  , souls :: Array Soul
  , jobs :: Array Job
  , traits :: Array Trait
  , talents :: Array Talent
  , abilities :: Array Ability
  , summons :: Array Name
  , keywords :: Array Keyword
  , foes :: Array Foe
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

_summons :: Lens' Icon (Array Name)
_summons = key @"summons"

_keywords :: Lens' Icon (Array Keyword)
_keywords = key @"keywords"
