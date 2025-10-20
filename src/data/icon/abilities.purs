module ToA.Data.Icon.Abilities
  ( abilities
  ) where

import ToA.Data.Icon.Ability (Ability)
import ToA.Data.Icon.Ability.Stalwart
  ( furor
  , interpose
  , impel
  , hook
  , mightyHew
  , secondWind
  , shatter
  )
import ToA.Data.Icon.Ability.Tactician
  ( pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard
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

  , pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard
  ]
