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
  ]
