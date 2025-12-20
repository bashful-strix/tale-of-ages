module ToA.Resource.Icon.Ability.Stormscale
  ( furyOfTheDeeps
  , lightningClaw
  , rideTheWave
  , spiritSea
  , sparkingStorm
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
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

furyOfTheDeeps :: Ability
furyOfTheDeeps = LimitBreak
  { name: Name "Fury of the Deeps"
  , colour: Name "Yellow"
  , description:
      [ Text
          """Your form transforms, becoming rippling and sinuous, as you
          mantle the form of the most powerful apex predators of the deep
          ocean."""
      ]
  , cost: Quick /\ 2
  , tags: [ TargetTag Self ]
  , steps:
      [ Step Nothing $ Eff
          [ Text
              """For the rest of combat, you mantle the old gods of the
              deeps, transforming into a titanic ocean creature
              surrounded by surging water aether. Tou gain a greatly
              enhanced dash, with the following benefits:"""
          , List Unordered
              [ [ Text "All your movement gains "
                , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                , Text "."
                ]
              , [ Text "The basic dash ability becomes a quick ability." ]
              , [ Text "All dashes you gain or grant are increased by +2."
                ]
              , [ Text
                    """Once a round, after you pass through a foe's space
                    or swap places with them, you can shred them. They
                    take """
                , Dice 2 D3
                , Text " damage and are pushed half as many spaces."
                ]
              ]
          ]
      ]
  }

lightningClaw :: Ability
lightningClaw = Ability
  { name: Name "Lightning Claw"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You strike with the power of thunder, a fierce flash that
          can splinter the masts of ships."""
      ]
  , cost: One
  , tags: [ Attack, RangeTag Melee ]
  , steps:
      [ Step Nothing $ Eff
          [ Text "Dash 4 with "
          , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
          , Text
              """. Then attack one character you passed through,
              regardless of range. Damage from this ability ignores cover
              and line of sight."""
          ]
      , Step Nothing $ AttackStep
          [ Text "2 damage" ]
          [ Text "+", Dice 1 D3 ]
      , Step Nothing $ OnHit
          [ Text
              """Then deal 2 damage again if your target is 3 or more
              spaces away, or """
          , Dice 2 D3
          , Text
              """ again if they are 6 or more. Double this damage if
              they're in """
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text "."
          ]
      ]
  }

rideTheWave :: Ability
rideTheWave = Ability
  { name: Name "Ride the Wave"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You share some of the power of your mantle, rapidly shifting
          yourself or an ally into an animal and back again."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 2), TargetTag Self, TargetTag Ally ]
  , steps:
      [ Step (Just D6) $ Eff
          [ Text
              """Self or an ally in range shape shifts into an animal
              and dashes 3 or (5+) 6 spaces in a straight line with """
          , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
          , Text ", then gains "
          , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
          , Text
              """. If they dash the maximum range possible, they also
              gain """
          , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
          , Text "."
          ]
      ]
  }

spiritSea :: Ability
spiritSea = Ability
  { name: Name "Spirit Sea"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You let a portion of the deep ocean manifest, a roiling
          black sea."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 2), AreaTag (Cross 1) ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Zone")
          [ Text
              """Create a cross 1 roiling bubble of black water in free
              space in range, with the following effects:"""
          , List Unordered
              [ [ Text "Yourself and allies have "
                , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                , Text " in the area."
                ]
              , [ Text "The center space is an "
                , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                , Text " space."
                ]
              , [ Text
                    """Once a round, when a character of your choice
                    starts a voluntary movement is pushed or pulled in
                    the area, they are buffeted by a wave, and increase
                    it by +2."""
                ]
              ]
          ]
      ]
  }

sparkingStorm :: Ability
sparkingStorm = Ability
  { name: Name "Sparking Storm"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You call on the power of the old gods of the storm, bringing
          forth deep sea spirits in the shape of lightning."""
      ]
  , cost: One
  , tags: [ KeywordTag (Name "Mark"), RangeTag (Range 1 2) ]
  , steps:
      [ SummonStep (Just D6) (Name "Spirit Spark")
          $ KeywordStep (Name "Summon")
              [ Text
                  """You summon one or (5+) two spirit sparks in range.
                  The sparks prime after your turn passes."""
              ]
      , Step Nothing $ KeywordStep (Name "Heavy")
          [ Text "Summon +2 more sparks." ]
      ]
  }
