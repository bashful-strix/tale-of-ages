module ToA.Resource.Icon.Ability.Tactician
  ( mightyCommand
  , pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

mightyCommand :: Ability
mightyCommand = LimitBreak
  { name: Name "Mighty Command"
  , description:
      [ Text
          """You issue an earth shattering command, breaking enemy
          morale and driving your allies on."""
      ]
  , cost: One /\ 2
  , tags: [ TargetTag Ally, TargetTag Foe ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ Eff
          [ Text
              """Every other character on the battlefield,
              regardless of range and line of sight is pushed or
              pulled 1 space in any direction of your choice. You
              may move them in any order, and may choose different
              directions for each character."""
          ]
      , Step Nothing $ Eff
          [ Text "Bloodied characters or pushed +2 spaces." ]
      , Step Nothing $ Eff
          [ Text "Foes in "
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text " are additionally "
          , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
          , Text "."
          ]
      ]
  }

pincerAttack :: Ability
pincerAttack = Ability
  { name: Name "Pincer Attack"
  , description:
      [ Text
          """Your weapon finds every weakness, driving your foe
          straight into your waiting ally."""
      ]
  , cost: One
  , tags: [ Attack, RangeTag Melee ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ AttackStep (Just $ Flat 1) (Just $ Roll 1 D3)
      , Step Nothing $ OnHit
          [ Text
              """Push 1. If your foe would be pushed into an ally's
              space, that ally deals 2 """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage to that foe and gains "
          , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
          , Text
              """. Double these effects if your ally or you target is
              in """
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text "."
          ]
      ]
  }

baitAndSwitch :: Ability
baitAndSwitch = Ability
  { name: Name "Bait and Switch"
  , description:
      [ Text
          """You lay a trap for your foe, striking when they
          overextend themselves."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 2), TargetTag Ally ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ Eff [ Text "Swap places with an ally in range." ]
      , Step Nothing $ Eff
          [ Text
              """If your ally was adjacent to at least one foe, you may
              then deal 2 damage to one of those foes after swapping
              and """
          , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
          , Text " them."
          ]
      ]
  }

holdTheCenter :: Ability
holdTheCenter = Ability
  { name: Name "Hold the Center"
  , description:
      [ Text
          """You brace with a shield or armor, strengthening your
          formation against incoming blows."""
      ]
  , cost: Interrupt 1
  , tags: [ TargetTag Ally, RangeTag Adjacent ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ TriggerStep
          [ Text "An adjacent ally is damaged." ]
      , Step (Just D6) $ Eff
          [ Text
              """Reduce that damage by the number of adjacent allies
              to you, then push all adjacent foes 1, (4+) two, or (6+)
              four spaces."""
          ]
      , Step Nothing $ Eff
          [ Text "If that ally was in "
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text " double damage reduction and push."
          ]
      ]
  }

mightyStandard :: Ability
mightyStandard = Ability
  { name: Name "Mighty Standard"
  , description:
      [ Text
          """You place your banner, striking fear into the hearts of
          your foes."""
      ]
  , cost: One
  , tags: [ KeywordTag (Name "Zone"), RangeTag (Range 1 3), End ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ KeywordStep (Name "Zone")
          [ Bold [ Text "End your turn" ]
          , Text " and designate a blast 3 "
          , Italic [ Ref (Name "Zone") [ Text "zone" ] ]
          , Text
              """ with at least one space in range, which could overlap
              characters. Allies that end their turn inside the
              zone gain """
          , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
          , Text ". If they are in "
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text
              ", they also gain +1 armor while inside the zone."
          ]
      , Step (Just D3) $ Eff
          [ Text
              "While inside the zone, you can pick up the banner as a "
          , Bold [ Text "quick" ]
          , Text
              """ ability and swing it, pushing all other characters
              inside """
          , Italic [ Dice 1 D3 ]
          , Text ", but removing the zone. Foes pushed are "
          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
          , Text "."
          ]
      ]
  }
