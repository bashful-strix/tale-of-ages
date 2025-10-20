module ToA.Data.Icon.Ability.Tactician
  ( pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard
  , mightyCommand
  ) where

import Prelude

import ToA.Data.Icon.Ability (Ability(..))
import ToA.Data.Icon.Name (Name(..))

pincerAttack :: Ability
pincerAttack = Ability $ Name "Pincer Attack"

baitAndSwitch :: Ability
baitAndSwitch = Ability $ Name "Bait and Switch"

holdTheCenter :: Ability
holdTheCenter = Ability $ Name "Hold the Center"

mightyStandard :: Ability
mightyStandard = Ability $ Name "Mighty Standard"

mightyCommand :: Ability
mightyCommand = LimitBreak (Name "Mighty Command") 2
