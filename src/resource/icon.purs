module ToA.Resource.Icon
  ( icon
  ) where

import ToA.Data.Icon (Icon)

import ToA.Resource.Icon.Abilities (abilities)
import ToA.Resource.Icon.Classes (classes)
import ToA.Resource.Icon.Colours (colours)
import ToA.Resource.Icon.Jobs (jobs)
import ToA.Resource.Icon.Keywords (keywords)
import ToA.Resource.Icon.Souls (souls)
import ToA.Resource.Icon.Talents (talents)
import ToA.Resource.Icon.Traits (traits)

icon :: Icon
icon =
  { classes
  , colours
  , souls
  , jobs
  , traits
  , talents
  , abilities
  , summons: []
  , keywords
  }
