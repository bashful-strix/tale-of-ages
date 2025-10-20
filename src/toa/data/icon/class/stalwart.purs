module ToA.Data.Icon.Class.Stalwart
  ( stalwart
  ) where

import Prelude

import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Trait (Trait(..))

stalwart :: Class
stalwart = Class
  { name: Name "Stalwart"
  , tagline: "Weapon master and unparalleled soldier"
  , strengths:
      "Tough, good at punishing foes, protecting allies, and "
        <> "controlling the battlefield"
  , weaknesses: "Lower mobility and weak to ranged attackers"
  , complexity: "Low"
  , description:
      "Stalwarts are consumate warriors and masters of martial "
        <> "prowess. Tough, vigorous, and equally skilled at "
        <> "punishing foes as they are protecting allies, they "
        <> "act as an anchor for their teams, protecting areas "
        <> "of the battlefield, preventing foes from "
        <> "approaching or harming allies, and pushing foes "
        <> "around with their immense strength."
  , move: 4
  , hp: 40
  , defense: 3
  , trait: Trait (Name "Rampart")
      $ "You are an imposing sight on the battlefield. "
          <> "Whether through gear, training, or simple "
          <> "toughness, you gain the following benefits:\n"
          <> "- You have 1 armor\n"
          <> "- Once a round, before you or an adjacent ally is "
          <> "targeted by a foe's ability, you may grant that "
          <> "character +1d3 _armor_ against the entire ability\n"
          <> "- Foes must spend +1 movement to exit a space "
          <> "adjecent to you"
  , basic: Name "Furor"
  , keywords:
      [ Name "Daze"
      , Name "Immobile"
      , Name "Push"
      , Name "Shield"
      , Name "Stance"
      , Name "Sturdy"
      , Name "Stun"
      , Name "Unstoppable"
      ]
  , apprentice:
      [ Name "Interpose"
      , Name "Impel"
      , Name "Hook"
      , Name "Mighty Hew"
      , Name "Second Wind"
      , Name "Shatter"
      ]
  }
