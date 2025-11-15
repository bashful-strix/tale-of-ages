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

abilities :: Array Ability
abilities =
  [ furor
  , interpose
  , impel
  , hook
  , mightyHew
  , secondWind
  , shatter

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
