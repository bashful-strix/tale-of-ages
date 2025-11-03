module ToA.Resource.Icon.Talents
  ( talents
  ) where

import ToA.Data.Icon.Talent (Talent)
import ToA.Resource.Icon.Talent.Tactician (fieldwork, mastermind, spur)

talents :: Array Talent
talents =
  [ mastermind
  , spur
  , fieldwork
  ]
