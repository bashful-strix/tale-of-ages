module ToA.Data.Icon.Traits
  ( traits
  ) where

import Prelude

import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Trait (Trait(..))

traits :: Array Trait
traits =
  [ rampart
  , pressTheFight
  ]

rampart :: Trait
rampart = Trait (Name "Rampart")
  $ "You are an imposing sight on the battlefield. Whether "
      <> "through gear, training, or simple toughness, you gain "
      <> "the following benefits:\n"
      <> "- You have 1 armor\n"
      <> "- Once a round, before you or an adjacent ally is "
      <> "targeted by a foe's ability, you may grant that "
      <> "character +1d3 _armor_ against the entire ability\n"
      <> "- Foes must spend +1 movement to exit a space adjecent "
      <> "to you"

pressTheFight :: Trait
pressTheFight = Trait (Name "Press the Fight")
  $ "Once a round, after you push, pull or swap any character, "
      <> "you may allow an ally in range 1-3 to dash spaces equal "
      <> "to the round number + 1. If your ally was in _crisis_, "
      <> "they may also gain _vigor_ equal to the distance dashed."
