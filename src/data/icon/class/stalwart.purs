module ToA.Data.Icon.Class.Stalwart
  ( stalwart
  ) where

import Prelude

import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Name (Name(..))

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
  , trait: Name "Rampart"
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
