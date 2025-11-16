module ToA.Resource.Icon.Souls
  ( souls
  ) where

import ToA.Data.Icon.Soul (Soul)

import ToA.Resource.Icon.Soul.Knight (knight)
import ToA.Resource.Icon.Soul.Warrior (warrior)
import ToA.Resource.Icon.Soul.Berserker (berserker)
import ToA.Resource.Icon.Soul.Mercenary (mercenary)

import ToA.Resource.Icon.Soul.Shadow (shadow)
import ToA.Resource.Icon.Soul.Gunner (gunner)
import ToA.Resource.Icon.Soul.Thief (thief)
import ToA.Resource.Icon.Soul.Ranger (ranger)

import ToA.Resource.Icon.Soul.Bard (bard)
import ToA.Resource.Icon.Soul.Witch (witch)
import ToA.Resource.Icon.Soul.Monk (monk)
import ToA.Resource.Icon.Soul.Oracle (oracle)

import ToA.Resource.Icon.Soul.Flame (flame)
import ToA.Resource.Icon.Soul.Earth (earth)
import ToA.Resource.Icon.Soul.Bolt (bolt)
import ToA.Resource.Icon.Soul.Water (water)

souls :: Array Soul
souls =
  [ knight
  , warrior
  , berserker
  , mercenary

  , shadow
  , gunner
  , thief
  , ranger

  , bard
  , witch
  , monk
  , oracle

  , flame
  , earth
  , bolt
  , water
  ]
