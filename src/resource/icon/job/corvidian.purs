module ToA.Resource.Icon.Job.Corvidian
  ( corvidian
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , SubItem(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

corvidian :: Icon
corvidian =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Corvidian"
          , colour: Name "Red"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Also known as Raven Knights, the Corvidian orders are an
                  ill-reputed Churner organization that are known primarily for
                  being traveling peddlers and battlefield scavengers. Once the
                  fighting is over, be it between monsters or kin, they descend
                  on the battlefield with their black, tattered cloaks, and
                  leaving strapped with pouches full of loot."""
              , Newline
              , Newline
              , Text
                  """Despite their dismal reputation, many of them operate as
                  vital lifelines to local communities impacted by war, blights,
                  or monster activity, acting as fences and suppliers when
                  nobody else will dare brave a conflict area."""
              ]
          , trait: Name "Way of the Crow"
          , keyword: Name "Finishing Blow"
          , abilities:
              (I /\ Name "Demoralize")
                : (I /\ Name "Kidney Shot")
                : (II /\ Name "Intimidate")
                : (IV /\ Name "Execute")
                : empty
          , limitBreak: Name "Bloodbath"
          , talents:
              Name "Cruelty"
                : Name "Mortality"
                : Name "Camraderie"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Way of the Crow"
          , description:
              [ Text
                  """Before you attack a foe, you may consume a negative status
                  token on your foe to deal +2 damage on hit. You may consume 3
                  negative statuses to also grant the attack """
              , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
              , Text
                  """. If an attack powered up this way defeats your foe, clear
                  a negative status on yourself, then gain """
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      ]

  , talents:
      [ Talent
          { name: Name "Cruelty"
          , colour: Name "Red"
          , description:
              [ Text "Your attacks gain attack "
              , Power
              , Text " and damage "
              , Power
              , Text " against characters in crisis."
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Mortality"
          , colour: Name "Red"
          , description:
              [ Text
                  """Foes in crisis treat you and all allies adjacent to you as
                  having +1 armor."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Camraderie"
          , colour: Name "Red"
          , description:
              [ Text "When you "
              , Italic [ Ref (Name "Rescue") [ Text "rescue" ] ]
              , Text " an ally, you and that ally gain "
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text " and "
              , Dice 1 D3
              , Text "+1 "
              , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Bloodbath"
          , colour: Name "Red"
          , description:
              [ Text
                  """Your skill at looting corpses has given you more than quick
                  fingers - it has given you an intimate knowledge of both
                  killing implements and where best to poke them."""
              ]
          , cost: One /\ 3
          , tags: [ KeywordTag (Name "Aura"), KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Text "While in this stance, gain aura 1."
                  , List Unordered
                      [ [ Text
                            """All foes in the aura count as bloodied, and
                            bloodied foes count as being in crisis."""
                        ]
                      , [ Text
                            """The first time in a round a foe is defeated in
                            the aura, yourself and allies in the aura gain """
                        , Dice 1 D3
                        , Text " vigor and clear a negative status."
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Demoralize"
          , colour: Name "Red"
          , description:
              [ Text
                  """You strike down their strongest and best, driving them to
                  their inevitable end."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step (KeywordStep (Name "Finishing Blow")) (Just D3)
                  [ Text
                      """Release a burst 1 (self) area effect, pushing all foes
                      inside 1. If your foe is in crisis, push + """
                  , Dice 1 D3
                  , Text "."
                  ]
              , Step Eff Nothing
                  [ Text
                      """If your attack defeats your foe, all foes in the area
                      become """
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Kidney Shot"
          , colour: Name "Red"
          , description: [ Text "Fighting fair never got anyone anywhere." ]
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step Eff Nothing
                  [ Text "An adjacent foe must save. They are "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text
                      """ and pushed 1. On a failed save, they then increase a
                      negative status of your choice by +1."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text
                      """Foe fails the save. If they are in crisis, they
                      increase """
                  , Italic [ Text "all" ]
                  , Text " their negative statuses by +1."
                  ]
              ]
          }
      , Ability
          { name: Name "Intimidate"
          , colour: Name "Red"
          , description:
              [ Text
                  """You lock eyes with a foe, letting them know the fate that
                  will befall them if they come in your reach."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 3) (NumVar 5))
              , End
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and mark a foe in range. While marked, that foe gains
                      attack """
                  , Weakness
                  , Text
                      """ against you and adjacent allies. If you start your
                      turn adjacent to your marked foe, that foe must save. They
                      take """
                  , Dice 1 D6
                  , Text
                      """+4 damage, or half as much on a successful save. Then
                      end the mark. The mark otherwise remains active."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text "Foe is also "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text " on a failed save."
                  ]
              ]
          }
      , Ability
          { name: Name "Execute"
          , colour: Name "Red"
          , description: [ Text "Finish them." ]
          , cost: One
          , tags: [ End ]
          , steps:
              [ SubStep Eff Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text " and gain "
                  , Italic [ Ref (Name "Sturdy") [ Text "sturdy" ] ]
                  , Text
                      """. Gain the following interrupt until the end your next
                      turn."""
                  ]
                  $ AbilityItem
                      { name: Name "Cut Down"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  "You hit an attack, and the attack resolves."
                              ]
                          , Step Eff (Just D6)
                              [ Text
                                  """Roll the effect die. If your foe's HP is
                                  under the effect die, they are instantly
                                  defeated, ignoring all other effect. Then
                                  gain """
                              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                              , Text
                                  """, and vigor equal to the effect die if you
                                  defeated your foe this way. Otherwise this has
                                  no effect."""
                              ]
                          , Step (KeywordStep (Name "Afflicted")) Nothing
                              [ Text "If your foe is afflicted, gain effect "
                              , Power
                              , Text ", or "
                              , Power
                              , Power
                              , Text
                                  """ if they have 3 or more negative status
                                  tokens of any kind."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
