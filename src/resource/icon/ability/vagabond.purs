module ToA.Resource.Icon.Ability.Vagabond
  ( windsKiss
  , track
  , quickStep
  , flashPowder
  , gouge
  , smokeBomb
  , deathTrap
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
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

windsKiss :: Ability
windsKiss = Ability
  { name: Name "Wind's Kiss"
  , colour: Name "Yellow"
  , description: [ Text "A flash of blades." ]
  , cost: One
  , tags: [ Attack, RangeTag (Range 1 2) ]
  , steps:
      [ Step Nothing $ Eff [ Text "Dash 1." ]
      , Step Nothing $ AttackStep (Just $ Flat 2) (Just $ Roll 1 D6)
      , Step Nothing $ OnHit
          [ Text "Gain "
          , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
          , Text "."
          ]
      , Step Nothing $ Eff [ Text "Dash 1." ]
      ]
  }

track :: Ability
track = Ability
  { name: Name "Track"
  , colour: Name "Yellow"
  , description: [ Text "Pick your quarry carefully." ]
  , cost: One
  , tags: [ RangeTag (Range 1 4), KeywordTag (Name "Mark") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Mark")
          [ Text "Mark your foe."
          , List Unordered
              [ [ Text "While marked, your attacks gain attack "
                , Power
                , Text
                    """ against them and they cannot gain cover from
                    you."""
                ]
              , [ Text
                    """If you are bloodied, these bonuses apply to all
                    your allies as well."""
                ]
              ]
          ]
      ]
  }

quickStep :: Ability
quickStep = Ability
  { name: Name "Quick Step"
  , colour: Name "Yellow"
  , description: [ Text "You move with surprising agility and speed." ]
  , cost: Quick
  , tags: []
  , steps:
      [ Step (Just D3) $ Eff
          [ Text "Dash "
          , Italic [ Dice 1 D3 ]
          , Text " spaces. You can "
          , Italic [ Ref (Name "Phase") [ Text "phase" ] ]
          , Text " through foes during this movement."
          ]
      ]
  }

flashPowder :: Ability
flashPowder = Ability
  { name: Name "Flash Powder"
  , colour: Name "Yellow"
  , description:
      [ Text "Throw sparking powder that confounds the eyes." ]
  , cost: One
  , tags: [ RangeTag Melee, AreaTag (Burst 1 true) ]
  , steps:
      [ Step (Just D6) $ AreaEff
          [ Text "One, (4+) two or (6+) all foes in the area are "
          , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
          , Text "."
          ]
      , Step Nothing $ Eff [ Text "Then teleport 3." ]
      ]
  }

gouge :: Ability
gouge = Ability
  { name: Name "Gouge"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You unleash multiple slashes, shot or stabs against your
          foe, hitting weak spots."""
      ]
  , cost: Two
  , tags: [ Attack, RangeTag Melee ]
  , steps:
      [ Step Nothing $ Eff [ Text "Dash 1." ]
      , Step Nothing $ AttackStep (Just $ Flat 3) (Just $ Roll 3 D3)
      , Step Nothing $ OnHit
          [ Text "If your foe is "
          , Italic [ Ref (Name "Bloodied") [ Text "bloodied" ] ]
          , Text
              """, strike your target again, dealing 3 damage. If your
              foe is in """
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text ", deal 3 damage twice instead."
          ]
      ]
  }

smokeBomb :: Ability
smokeBomb = Ability
  { name: Name "Smoke Bomb"
  , colour: Name "Yellow"
  , description: [ Text "Prepare for the worst." ]
  , cost: One
  , tags: [ TargetTag Self, End ]
  , steps:
      [ Step (Just D6) $ Eff
          [ Bold [ Text "End your turn." ]
          , Text " Create an "
          , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
          , Text " space under you (4+) and gain "
          , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
          , Text "."
          ]
      ]
  }

deathTrap :: Ability
deathTrap = Ability
  { name: Name "Death Trap"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You place a carefully crafted trap: flechette bomb, shard
          net, razor wire - the possibilities are endless."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 2), KeywordTag (Name "Summon") ]
  , steps:
      [ SummonStep (Just D6) (Name "Death Trap") $ KeywordStep
          (Name "Summon")
          [ Text
              """Summon one or (5+) two death traps in a free space in
              range. Traps arm at the end of your turn."""
          ]
      ]
  }
