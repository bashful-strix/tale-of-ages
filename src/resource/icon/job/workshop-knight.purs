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
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (ListKind(..), dice, list, italic, ref, seq, text)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
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
          , sign: Sign "icon-[game-icons--spanner]"
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description: text
              """Warriors of the great guild workshops lodged in the high city
              spires. They are known as much for their genius as their bravery,
              and wield arkentech, clockwork, and black powder as easily as they
              wield a blade. They work fervently on new contraptions meant nor
              only to better warfare but the lives of kin - automated farm
              equipment, message delivery systems, combustion powered gondolas
              and the like, often under the skeptical gaze of the citizenry.
              Many of them find employ with the great airship companies as
              engineers and carpenters. The orders are especially open to those
              that have suffered accidents of birth or battlefield and are well
              known for their well crafted arkentech prosthetics."""
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
              Id "alloy|talent|workshop-knight"
                : Id "endure|talent|workshop-knight"
                : Id "bolster|talent|workshop-knight"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Ingenuity"
          , description: seq
              [ text
                  """If you don't attack during your turn, at the end of your
                  turn, you can perform one of the following effects:"""
              , list Unordered
                  [ text "Fly 3 spaces"
                  , seq
                      [ text
                          """Pull a character in range 1-3 two spaces. Then you
                          may """
                      , italic $ ref (Name "Daze") $ text "daze"
                      , text " them or grant them "
                      , italic $ ref (Name "Shield") $ text "shield"
                      ]
                  , text "Deal 2 damage to all adjacent foes and push them 1"
                  ]
              ]
          }
      ]
  , talents:
      [ Talent
          { id: Id "alloy|talent|workshop-knight"
          , name: Name "Alloy"
          , colour: Name "Red"
          , description: seq
              [ text "You improve the effect of "
              , italic $ ref (Name "Shield") $ text "shield"
              , text
                  " to +3 defense for yourself and adjacent allies. You gain "
              , italic $ ref (Name "Shield") $ text "shield"
              , text " when you are first bloodied in a combat."
              ]
          }
      , Talent
          { id: Id "endure|talent|workshop-knight"
          , name: Name "Endure"
          , colour: Name "Red"
          , description: seq
              [ text "If you don't attack during your turn, gain "
              , italic $ ref (Name "Shield") $ text "shield"
              , text ". At round 3+, also gain 2 "
              , italic $ ref (Name "Vigor") $ text "vigor"
              , text "."
              ]
          }
      , Talent
          { id: Id "bolster|talent|workshop-knight"
          , name: Name "Bolster"
          , colour: Name "Red"
          , description: seq
              [ text
                  """Once a round, then you swap places with an ally, they may
                  clear a negative status. If they have no negative statuses,
                  they gain """
              , italic $ ref (Name "Shield") $ text "shield"
              , text "."
              ]
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Masterstroke"
          , colour: Name "Red"
          , description: text
              """Your mind constantly works like a well oiled gear assembly,
              finding the perfect spot to tip the fight in your favor."""
          , cost: One /\ 4
          , tags: [ TargetTag Ally, KeywordTag (Name "Power die") ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """At the end of any of your turns you don't attack while
                      you have this limit break, gain a d6 """
                  , italic $ ref (Name "Power die") $ text "power die"
                  , text ", or tick the die up by 1 (max 6)."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """Fly 1, then swap places with an adjacent ally. That
                      ally gains 2 vigor, and an adjacent foe must save or
                      take """
                  , dice 1 D6
                  , text " damage and become "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text ", or half damage and "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text " on a successful save."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """Increase fly by +1, vigor gain by +2, and damage dealt
                      by +"""
                  , dice 1 D6
                  , text
                      """ for each tick on the die. If the die is at 3 or
                      higher, all damage dealt becomes """
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Rocket Punch"
          , colour: Name "Red"
          , description: text
              "The basic move of workshop martial arts, flashy and effective."
          , cost: One
          , tags: [ AreaTag (Burst (NumVar 1) true) ]
          , steps:
              [ Step AreaEff (Just D6) $ text
                  """Push all adjacent foes 1 or (5+) two spaces, then deal 2
                  damage to one of those foes. If you are adjacent to 3 or more
                  foes, increase damage and push by +2."""
              , Step (KeywordStep (Name "Conserve")) Nothing $ seq
                  [ text "Damaged foes must save or be "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text ". Foe is "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text " on a successful save."
                  ]
              ]
          }
      , Ability
          { name: Name "Ripper Claw"
          , colour: Name "Red"
          , description: text
              "Using a grappling system, reel in a target with explosive force."
          , cost: One
          , tags: [ RangeTag (Range (NumVar 3) (NumVar 4)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Pull a character in range 3 spaces. Foes are "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text ". Allies gain "
                  , italic $ ref (Name "Shield") $ text "shield"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing $ text
                  "Increase max range and pull by +2."
              ]
          }
      , Ability
          { name: Name "Weapon Vault"
          , colour: Name "Red"
          , description: text "Use your weapon or hilt like a vaulting pole."
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step Eff (Just D3) $ seq
                  [ text
                      """Fly 1, then swap places with an adjacent character.
                      Then you may push your swapped target """
                  , italic $ dice 1 D3
                  , text " spaces."
                  ]
              , Step Eff Nothing $ seq
                  [ text "If you use this after attacking, it becomes "
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing $ seq
                  [ text "Increase fly and push by +2, and swapped foes take 2 "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage."
                  ]
              ]
          }
      , Ability
          { name: Name "Arsenal"
          , colour: Name "Red"
          , description: text "Your bandoleers contain more than just weaponry."
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ AttackStep (text "2 damage") $ seq [ text "+", dice 1 D6 ]
              , Step OnHit Nothing $ text "Push or pull target 1 space."
              , InsetStep (KeywordStep (Name "Conserve")) Nothing
                  ( text
                      """You may use the following version of this ability
                      instead."""
                  )
                  $ AbilityInset
                      { name: Name "Arsenal Flash Bomb"
                      , colour: Name "Red"
                      , cost: One
                      , tags:
                          [ RangeTag (Range (NumVar 1) (NumVar 2))
                          , KeywordTag (Name "Zone")
                          ]
                      , steps:
                          [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                              [ text
                                  """Create a cross 1 space zone in range. Foes
                                  caught inside take 2 """
                              , italic $ ref (Name "Pierce") $ text "piercing"
                              , text
                                  " damage. The center space of the zone is an "
                              , italic $ ref (Name "Obscured") $ text "obscured"
                              , text " space."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Excel")) Nothing $ text
                  "You may also trigger the flash bomb effect."
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
