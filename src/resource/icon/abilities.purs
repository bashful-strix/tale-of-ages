module ToA.Resource.Icon.Abilities
  ( abilities
  ) where

import ToA.Data.Icon.Ability (Ability)

import ToA.Resource.Icon.Ability.Stalwart
  ( furor
  , interpose
  , impel
  , hook
  , mightyHew
  , secondWind
  , shatter
  )
import ToA.Resource.Icon.Ability.Tactician
  ( mightyCommand
  , pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard
  ) 
import ToA.Resource.Icon.Ability.WorkshopKnight
  ( masterstroke
  , rocketPunch
  , ripperClaw
  , weaponVault
  , arsenal
  , arsenalFlashBomb
  )

import ToA.Resource.Icon.Ability.Wright
  ( magi
  , ember
  , emberZone
  , aero
  , geo
  , cryo
  , ruin
  , shift
  , gleam
  )

abilities :: Array Ability
abilities =
  [ furor
  , interpose
  , impel
  , hook
  , mightyHew
  , secondWind
  , shatter

  , magi
  , ember
  , emberZone
  , aero
  , geo
  , cryo
  , ruin
  , shift
  , gleam

  , mightyCommand
  , pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard

  , masterstroke
  , rocketPunch
  , ripperClaw
  , weaponVault
  , arsenal
  , arsenalFlashBomb
  ]
