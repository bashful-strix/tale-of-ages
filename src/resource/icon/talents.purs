module ToA.Resource.Icon.Talents
  ( talents
  ) where

import ToA.Data.Icon.Talent (Talent)

import ToA.Resource.Icon.Talent.Tactician (fieldwork, mastermind, spur)

import ToA.Resource.Icon.Talent.WorkshopKnight (alloy, endure, bolster)

import ToA.Resource.Icon.Talent.WeepingAssassin
  ( commiserate
  , infiltrate
  , shimmer
  )

import ToA.Resource.Icon.Talent.Chanter (poise, elegance, peace)

import ToA.Resource.Icon.Talent.Sealer (surge, flash, ascension)

import ToA.Resource.Icon.Talent.Spellblade (vex, fence, bladework)

talents :: Array Talent
talents =
  [ mastermind
  , spur
  , fieldwork
  
  , alloy
  , endure
  , bolster

  , commiserate
  , infiltrate
  , shimmer

  , poise
  , elegance
  , peace

  , surge
  , flash
  , ascension

  , vex
  , fence
  , bladework
  ]
