module ToA.Resource.Icon.Ability.WorkshopKnight
  ( masterstroke
  , rocketPunch
  , ripperClaw
  , weaponVault
  , arsenal
  , arsenalFlashBomb
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

masterstroke :: Ability
masterstroke = LimitBreak
  { name: Name "Masterstroke"
  , colour: Name "Red"
  , description:
      [ Text
          """Your mind constantly works like a well oiled gear assembly,
          finding the perfect spot to tip the fight in your favor."""
      ]
  , cost: One /\ 4
  , tags: [ TargetTag Ally, KeywordTag (Name "Power die") ]
  , steps:
      [ Step Nothing $ Eff
          [ Text
              """At the end of any of your turns you don't attack while
              you have this limit break, gain a d6 """
          , Italic [ Ref (Name "Power die") [ Text "power die" ] ]
          , Text ", or tick the die up by 1 (max 6)."
          ]
      , Step Nothing $ Eff
          [ Text
              """Fly 1, then swap places with an adjacent ally. That ally
              gains 2 vigor, and an adjacent foe must save or take """
          , Dice 1 D6
          , Text " damage and become "
          , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
          , Text ", or half damage and "
          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
          , Text " on a successful save."
          ]
      , Step Nothing $ Eff
          [ Text
              """Increase fly by +1, vigor gain by +2, and damage dealt
              by +"""
          , Dice 1 D6
          , Text
              """ for each tick on the die. If the die is at 3 or higher,
              all damage dealt becomes 
              """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text "."
          ]
      ]
  }

rocketPunch :: Ability
rocketPunch = Ability
  { name: Name "Rocket Punch"
  , colour: Name "Red"
  , description:
      [ Text
          """The basic move of workshop martial arts, flashy and
          effective."""
      ]
  , cost: One
  , tags: [ AreaTag (Burst 1 true) ]
  , steps:
      [ Step (Just D6) $ AreaEff
          [ Text
              """Push all adjacent foes 1 or (5+) two spaces, then deal 2
              damage to one of those foes. if you are adjacent to 3 or
              more foes, increase damage and push by +2."""
          ]
      , Step Nothing $ KeywordStep (Name "Conserve")
          [ Text "Damaged foes must save or be "
          , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
          , Text ". Foe is "
          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
          , Text " on a successful save."
          ]
      ]
  }

ripperClaw :: Ability
ripperClaw = Ability
  { name: Name "Ripper Claw"
  , colour: Name "Red"
  , description:
      [ Text
          """Using a grappling system, reel in a target with explosive
          force."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 3 4) ]
  , steps:
      [ Step Nothing $ Eff
          [ Text "Pull a character in range 3 spaces. Foes are "
          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
          , Text ". Allies gain "
          , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
          , Text "."
          ]
      , Step Nothing $ KeywordStep (Name "Conserve")
          [ Text "Increase max range and pull by +2."
          ]
      ]
  }

weaponVault :: Ability
weaponVault = Ability
  { name: Name "Weapon Vault"
  , colour: Name "Red"
  , description:
      [ Text "Use your weapon or hilt like a vaulting pole." ]
  , cost: One
  , tags: [ RangeTag Melee ]
  , steps:
      [ Step (Just D3) $ Eff
          [ Text
              """Fly 1, then swap places with an adjacent character. Then
              you may push your swapped target """
          , Italic [ Dice 1 D3 ]
          , Text " spaces."
          ]
      , Step Nothing $ Eff
          [ Text "If you use this after attacking, it becomes "
          , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
          , Text "."
          ]
      , Step Nothing $ KeywordStep (Name "Conserve")
          [ Text "Increase fly and push by +2, and swapped foes take 2 "
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage."
          ]
      ]
  }

arsenal :: Ability
arsenal = Ability
  { name: Name "Arsenal"
  , colour: Name "Red"
  , description:
      [ Text "Your bandoliers contain more than just weaponry." ]
  , cost: One
  , tags: [ Attack, RangeTag (Range 1 3) ]
  , steps:
      [ Step Nothing $ AttackStep
          [ Text "2 damage" ]
          [ Text "+", Dice 1 D6 ]
      , Step Nothing $ OnHit
          [ Text "Push or pull target 1 space." ]
      , SubStep Nothing (Name "Arsenal Flash Bomb") $ KeywordStep
          (Name "Conserve")
          [ Text
              """You may use the following version of this ability
              instead."""
          ]
      , Step Nothing $ KeywordStep (Name "Excel")
          [ Text
              "You may also trigger the flash bomb effect."
          ]
      ]
  }

arsenalFlashBomb :: Ability
arsenalFlashBomb = Ability
  { name: Name "Arsenal Flash Bomb"
  , colour: Name "Red"
  , description: []
  , cost: One
  , tags: [ RangeTag (Range 1 2), KeywordTag (Name "Zone") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Zone")
          [ Text
              """Create a cross 1 space zone in range. Foes caught inside
              take 2 """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage. The center space of the zone is an "
          , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
          , Text " space."
          ]
      ]
  }
