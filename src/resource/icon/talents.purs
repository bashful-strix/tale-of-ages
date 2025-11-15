module ToA.Resource.Icon.Talents
  ( talents
  ) where

import ToA.Data.Icon.Talent (Talent)
import ToA.Resource.Icon.Talent.Tactician (fieldwork, mastermind, spur)
import ToA.Resource.Icon.Talent.WorkshopKnight (alloy, endure, bolster)

talents :: Array Talent
talents =
  [ mastermind
  , spur
  , fieldwork
  
  , alloy
  , endure
  , bolster
  ]
