module ToA.Resource.Icon.Foe.Foes
  ( foes
  ) where

import ToA.Data.Icon.Foe (Foe)

import ToA.Resource.Icon.Foe.Foe.Basic
  ( sledge
  , soldier
  , warrior

  , dervish
  , gunner
  , skulk

  , priest
  , sergeant

  , justicar
  , pyromancer
  , scourer

  , archon
  , rogue

  , nocturnal
  )

import  ToA.Resource.Icon.Foe.Foe.Relict
  ( husk
  , necrosavant
  , wraith
  )

import  ToA.Resource.Icon.Foe.Foe.Beast
  ( halitoad
  )

foes :: Array Foe
foes =
  [ sledge
  , soldier
  , warrior

  , dervish
  , gunner
  , skulk

  , priest
  , sergeant

  , justicar
  , pyromancer
  , scourer

  , archon
  , rogue

  , nocturnal
  
  , husk
  , necrosavant
  , wraith

  , halitoad
  ]
