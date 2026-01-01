module ToA.Resource.Icon.Job.WorkshopKnight
  ( workshopKnight
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

workshopKnight :: Icon
workshopKnight =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Workshop Knight"
          , colour: Name "Red"
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Warriors of the great guild workshops lodged in the high
                  city spires. They are known as much for their genius as their
                  bravery, and wield arkentech, clockwork, and black powder as
                  easily as they wield a blade. They work fervently on new
                  contraptions meant nor only to better warfare but the lives of
                  kin - automated farm equipment, message delivery systems,
                  combustion powered gondolas and the like, often under the
                  skeptical gaze of the citizenry. Many of them find employ with
                  the great airship companies as engineers and carpenters. The
                  orders are especially open to those that have suffered
                  accidents of birth or battlefield and are well known for their
                  well crafted arkentech prosthetics."""
              ]
          , trait: Name "Ingenuity"
          , keyword: Name "Conserve"
          , abilities:
              (I /\ Name "Rocket Punch")
                : (I /\ Name "Ripper Claw")
                : (II /\ Name "Weapon Vault")
                : (IV /\ Name "Arsenal")
                : empty
          , limitBreak: Name "Masterstroke"
          , talents:
              Name "Alloy"
                : Name "Endure"
                : Name "Bolster"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Ingenuity"
          , description:
              [ Text
                  """If you don't attack during your turn, at the end of your
                  turn, you can perform one of the following effects:"""
              , List Unordered
                  [ [ Text "Fly 3 spaces" ]
                  , [ Text
                        """Pull a character in range 1-3 two spaces. Then you
                        may """
                    , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
                    , Text " them or grant them "
                    , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                    ]
                  , [ Text "Deal 2 damage to all adjacent foes and push them 1"
                    ]
                  ]
              ]
          }
      ]
  , talents:
      [ Talent
          { name: Name "Alloy"
          , colour: Name "Red"
          , description:
              [ Text "You improve the effect of "
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text
                  " to +3 defense for yourself and adjacent allies. You gain "
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text " when you are first bloodied in a combat."
              ]
          }
      , Talent
          { name: Name "Endure"
          , colour: Name "Red"
          , description:
              [ Text "If you don't attack during your turn, gain "
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text ". At round 3+, also gain 2 "
              , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
              , Text "."
              ]
          }
      , Talent
          { name: Name "Bolster"
          , colour: Name "Red"
          , description:
              [ Text
                  """Once a round, then you swap places with an ally, they may
                  clear a negative status. If they have no negative statuses,
                  they gain """
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text "."
              ]
          }
      ]
  , abilities:
      [ LimitBreak
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
              [ Step Eff Nothing
                  [ Text
                      """At the end of any of your turns you don't attack while
                      you have this limit break, gain a d6 """
                  , Italic [ Ref (Name "Power die") [ Text "power die" ] ]
                  , Text ", or tick the die up by 1 (max 6)."
                  ]
              , Step Eff Nothing
                  [ Text
                      """Fly 1, then swap places with an adjacent ally. That
                      ally gains 2 vigor, and an adjacent foe must save or
                      take """
                  , Dice 1 D6
                  , Text " damage and become "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text ", or half damage and "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text " on a successful save."
                  ]
              , Step Eff Nothing
                  [ Text
                      """Increase fly by +1, vigor gain by +2, and damage dealt
                      by +"""
                  , Dice 1 D6
                  , Text
                      """ for each tick on the die. If the die is at 3 or
                      higher, all damage dealt becomes """
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Rocket Punch"
          , colour: Name "Red"
          , description:
              [ Text
                  """The basic move of workshop martial arts, flashy and
                  effective."""
              ]
          , cost: One
          , tags: [ AreaTag (Burst (NumVar 1) true) ]
          , steps:
              [ Step AreaEff (Just D6)
                  [ Text
                      """Push all adjacent foes 1 or (5+) two spaces, then deal
                      2 damage to one of those foes. if you are adjacent to 3 or
                      more foes, increase damage and push by +2."""
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text "Damaged foes must save or be "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text ". Foe is "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text " on a successful save."
                  ]
              ]
          }
      , Ability
          { name: Name "Ripper Claw"
          , colour: Name "Red"
          , description:
              [ Text
                  """Using a grappling system, reel in a target with explosive
                  force."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 3) (NumVar 4)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Pull a character in range 3 spaces. Foes are "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text ". Allies gain "
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text "Increase max range and pull by +2." ]
              ]
          }
      , Ability
          { name: Name "Weapon Vault"
          , colour: Name "Red"
          , description:
              [ Text "Use your weapon or hilt like a vaulting pole." ]
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step Eff (Just D3)
                  [ Text
                      """Fly 1, then swap places with an adjacent character.
                      Then you may push your swapped target """
                  , Italic [ Dice 1 D3 ]
                  , Text " spaces."
                  ]
              , Step Eff Nothing
                  [ Text "If you use this after attacking, it becomes "
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text "Increase fly and push by +2, and swapped foes take 2 "
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage."
                  ]
              ]
          }
      , Ability
          { name: Name "Arsenal"
          , colour: Name "Red"
          , description:
              [ Text "Your bandoliers contain more than just weaponry." ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step OnHit Nothing [ Text "Push or pull target 1 space." ]
              , InsetStep (KeywordStep (Name "Conserve")) Nothing
                  [ Text
                      """You may use the following version of this ability
                      instead."""
                  ]
                  $ AbilityInset
                      { name: Name "Arsenal Flash Bomb"
                      , colour: Name "Red"
                      , cost: One
                      , tags:
                          [ RangeTag (Range (NumVar 1) (NumVar 2))
                          , KeywordTag (Name "Zone")
                          ]
                      , steps:
                          [ Step (KeywordStep (Name "Zone")) Nothing
                              [ Text
                                  """Create a cross 1 space zone in range. Foes
                                  caught inside take 2 """
                              , Italic
                                  [ Ref (Name "Pierce") [ Text "piercing" ] ]
                              , Text
                                  " damage. The center space of the zone is an "
                              , Italic
                                  [ Ref (Name "Obscured") [ Text "obscured" ] ]
                              , Text " space."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Excel")) Nothing
                  [ Text "You may also trigger the flash bomb effect." ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
