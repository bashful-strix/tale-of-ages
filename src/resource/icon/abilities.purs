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

import ToA.Resource.Icon.Ability.Vagabond
  ( windsKiss
  , track
  , quickStep
  , flashPowder
  , gouge
  , smokeBomb
  , deathTrap
  )
import ToA.Resource.Icon.Ability.WeepingAssassin
  ( hollow
  , harien
  , shadowCloak
  , nightsCaress
  , suddenStrike
  , swallowTheStars
  )

import ToA.Resource.Icon.Ability.Mendicant
  ( glia
  , gliaga
  , dios
  , megi
  , viga
  , aegi
  , diaga
  )
import ToA.Resource.Icon.Ability.Chanter
  ( monogatari
  , holy
  , magnasancti
  , gentlePrayer
  , esper
  )
import ToA.Resource.Icon.Ability.Sealer
  ( passageToTheAfterlife
  , godHand
  , matsuri
  , evilCrushingFist
  , condemn
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

import ToA.Resource.Icon.Ability.Spellblade
  ( granLevincross
  , gungnir
  , atherwand
  , odinforce
  , nothung
  , tenThousandCuts
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

  , windsKiss
  , track
  , quickStep
  , flashPowder
  , gouge
  , smokeBomb
  , deathTrap

  , glia
  , gliaga
  , dios
  , megi
  , viga
  , aegi
  , diaga

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

  , hollow
  , harien
  , shadowCloak
  , nightsCaress
  , suddenStrike
  , swallowTheStars

  , monogatari
  , holy
  , magnasancti
  , gentlePrayer
  , esper

  , passageToTheAfterlife
  , godHand
  , matsuri
  , evilCrushingFist
  , condemn

  , granLevincross
  , gungnir
  , atherwand
  , odinforce
  , nothung
  , tenThousandCuts
  ]
