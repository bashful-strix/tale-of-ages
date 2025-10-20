module ToA.Data.Icon
  ( Icon
  , icon
  ) where

import ToA.Data.Icon.Ability (Ability)
import ToA.Data.Icon.Abilities (abilities)
import ToA.Data.Icon.Class (Class)
import ToA.Data.Icon.Classes (classes)
import ToA.Data.Icon.Job (Job)
import ToA.Data.Icon.Jobs (jobs)
import ToA.Data.Icon.LimitBreak (LimitBreak)
import ToA.Data.Icon.LimitBreaks (limitBreaks)
import ToA.Data.Icon.Soul (Soul)
import ToA.Data.Icon.Souls (souls)
import ToA.Data.Icon.Talent (Talent)
import ToA.Data.Icon.Talents (talents)
import ToA.Data.Icon.Trait (Trait)
import ToA.Data.Icon.Traits (traits)

icon :: Icon
icon =
  { classes
  , souls
  , jobs
  , traits
  , talents
  , abilities
  , limitBreaks
  }

type Icon =
  { classes :: Array Class
  , souls :: Array Soul
  , jobs :: Array Job
  , traits :: Array Trait
  , talents :: Array Talent
  , abilities :: Array Ability
  , limitBreaks :: Array LimitBreak
  }
