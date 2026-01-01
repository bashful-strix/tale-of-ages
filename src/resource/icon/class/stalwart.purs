module ToA.Resource.Icon.Class.Stalwart
  ( stalwart
  ) where

import Color (fromInt)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))
import ToA.Data.Icon.Trait (Trait(..))

stalwart :: Icon
stalwart =
  { classes:
      [ Class
          { name: Name "Stalwart"
          , colour: Name "Red"
          , tagline: [ Text "Weapon master and unparalleled soldier" ]
          , strengths:
              [ Text
                  """Tough, good at punishing foes, protecting allies, and
                  controlling the battlefield"""
              ]
          , weaknesses: [ Text "Lower mobility and weak to ranged attackers" ]
          , complexity: [ Text "Low" ]
          , description:
              [ Text
                  """Stalwarts are consumate warriors and masters of martial
                  prowess. Tough, vigorous, and equally skilled at punishing
                  foes as they are protecting allies, they act as an anchor for
                  their teams, protecting areas of the battlefield, preventing
                  foes from approaching or harming allies, and pushing foes
                  around with their immense strength."""
              ]
          , hp: 40
          , defense: 3
          , move: 4
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
      ]
  , colours: [ Colour { name: Name "Red", value: fromInt 0xe7000b } ] -- red-600
  , souls:
      [ Soul
          { name: Name "Knight"
          , colour: Name "Red"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """The soul of one affected by strife and embedded with steel.
                  An unbending, iron will, and the power to lead from the
                  front."""
              ]
          }
      , Soul
          { name: Name "Warrior"
          , colour: Name "Red"
          , class: Name "Stalwart"
          , description:
              [ Text "The soul of one who seeks power at all ends."
              , Newline
              , Text
                  """The will to cut down all before you with impossible
                  strength, and the hand to carry it out."""
              ]
          }
      , Soul
          { name: Name "Berserker"
          , colour: Name "Red"
          , class: Name "Stalwart"
          , description:
              [ Text "The soul of one fueled by a heart of rage."
              , Newline
              , Text
                  """The terrifying power to fight on even when the body is
                  broken and the blood is boiled away."""
              ]
          }
      , Soul
          { name: Name "Mercenary"
          , colour: Name "Red"
          , class: Name "Stalwart"
          , description:
              [ Text "The soul of one tempered by suffering and avarice."
              , Newline
              , Text
                  """The strength to fight on your own terms, to grasp your own
                  fate through the thorns that pierce you."""
              ]
          }
      ]
  , jobs: []
  , traits:
      [ Trait
          { name: Name "Rampart"
          , description:
              [ Text
                  """You are an imposing sight on the battlefield. Whether
                  through gear, training, or simple toughness, you gain the
                  following benefits:"""
              , Newline
              , List Unordered
                  [ [ Text "You have 1 armor" ]
                  , [ Text
                        """Once a round, before you or an adjacent ally is
                        targeted by a foe's ability, you may grant that
                        character +"""
                    , Dice 1 D3
                    , Text " "
                    , Italic [ Ref (Name "Armor") [ Text "armor" ] ]
                    , Text " against the entire ability"
                    ]
                  , [ Text
                        """Foes must spend +1 movement to exit a space adjecent
                        to you"""
                    ]
                  ]
              ]
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Furor"
          , colour: Name "Red"
          , description: [ Text "Strike with your heart." ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step OnHit Nothing
                  [ Text "Gain 2 vigor. If you or your target is in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text ", deals damage"
                  , Power
                  , Text " and double vigor gain."
                  ]
              ]
          }
      , Ability
          { name: Name "Interpose"
          , colour: Name "Red"
          , description:
              [ Text
                  """You are able to step quickly and rapidly in the midst of
                  combat."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)), TargetTag Ally ]
          , steps:
              [ Step TriggerStep Nothing
                  [ Text "An ally ends their turn in range." ]
              , Step Eff Nothing
                  [ Text
                      """Dash 2. If you end this move adjacent to that ally,
                      they gain """
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Impel"
          , colour: Name "Red"
          , description: [ Text "Hurl headlong into battle." ]
          , cost: One
          , tags: [ RangeTag Melee, TargetTag Foe ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text "Dash 1, then an adjacent foe is "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text " and pushed 1 (4+) two or (6+) four spaces."
                  ]
              ]
          }
      , Ability
          { name: Name "Hook"
          , colour: Name "Red"
          , description:
              [ Text
                  "You grab an ally and pull them from the teeth of the enemy."
              ]
          , cost: Quick
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 3)), TargetTag Ally ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Pull target 1. They are "
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text " and "
                  , Italic [ Ref (Name "Immune") [ Text "immune" ] ]
                  , Text " to all damage while moving this way."
                  ]
              ]
          }
      , Ability
          { name: Name "Mighty Hew"
          , colour: Name "Red"
          , description: [ Text "Finish them." ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "3 damage" ] [ Text "+", Dice 2 D6 ]
              , Step OnHit (Just D6)
                  [ Text "Deal a follow up blow against "
                  , Italic [ Ref (Name "Afflicted") [ Text "afflicted" ] ]
                  , Text " foes, dealing 2 damage again (5+) and "
                  , Italic [ Ref (Name "Stun") [ Text "stunning" ] ]
                  , Text " them."
                  ]
              ]
          }
      , Ability
          { name: Name "Second Wind"
          , colour: Name "Red"
          , description:
              [ Text "You brace and ready yourself for the fray." ]
          , cost: One
          , tags: [ End, TargetTag Self ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Gain 2 vigor and end a negative status token. If
                      you're in """
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text " increase vigor by +"
                  , Dice 1 D6
                  , Text "."
                  ]
              , Step Eff Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Sturdy") [ Text "sturdy" ] ]
                  , Text " or grant it to an adjacent ally. Then "
                  , Bold [ Text "end your turn" ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Shatter"
          , colour: Name "Red"
          , description:
              [ Text
                  "Slam your weapon into the ground, sending up shockwaves."
              ]
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Blast (NumVar 3)) ]
          , steps:
              [ Step AreaEff Nothing [ Dice 1 D6, Text "+2 damage, push 1." ]
              , Step Eff Nothing
                  [ Text
                      """If you catch three or more characters in the area,
                      increase area damage by +2."""
                  ]
              , Step Eff Nothing
                  [ Text "One character in the area is "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text "."
                  ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
