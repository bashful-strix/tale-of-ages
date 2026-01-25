module ToA.Resource.Icon.Job.Spellblade
  ( spellblade
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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

spellblade :: Icon
spellblade =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Spellblade"
          , colour: Name "Blue"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description:
              [ Text
                  """Spellblades are a martial order of highly trained wrights.
                  Many of them come from the Guild Academies in the great cities
                  of Arden Eld, where they often take prestigious posts in the
                  local militias and city watch. Other wrights tend to view
                  Spellblades as stiff, unfeeling military types, but
                  Spellblades themselves know they are consummate professionals
                  and unparalleled masters of their art."""
              , Newline
              , Newline
              , Text
                  """The lightning aether that the Spellblades wield is highly
                  volatile, and requires intense training and focus to control.
                  Once a Spellblade has learned their craft, however, the speed,
                  power, and precision at which they can act is intoxicating,
                  crossing greats spans of space in an instant, riding the
                  Aetherial currents with a flash of gleaming steel."""
              ]
          , trait: Name "Klingenkunst"
          , keyword: Name "Isolate"
          , abilities:
              (I /\ Name "Gungnir")
                : (I /\ Name "Ätherwand")
                : (II /\ Name "Odinforce")
                : (IV /\ Name "Nothung")
                : empty
          , limitBreak: Name "Gran Levincross"
          , talents:
              Name "Vex"
                : Name "Fence"
                : Name "Bladework"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Klingenkunst"
          , description:
              [ Text "Once a round, you may teleport 2 as a "
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text " ability. If you are "
              , Italic [ Ref (Name "Isolate") [ Text "isolated" ] ]
              , Text
                  """, you may teleport 4 instead. If there are no other
                  characters in range 1-2, you may teleport 6."""
              ]
          }
      ]
  , talents:
      [ Talent
          { id: Id "vex|talent|spellblade"
          , name: Name "Vex"
          , colour: Name "Blue"
          , description:
              [ Text "After you attack an "
              , Italic [ Ref (Name "Isolate") [ Text "isolated" ] ]
              , Text
                  " character, you may teleport 2 after the ability resolves."
              ]
          }
      , Talent
          { id: Id "fence|talent|spellblade"
          , name: Name "Fence"
          , colour: Name "Blue"
          , description:
              [ Text
                  """If a foe is at the very end space of one of your damaging
                  line or arc effects, they take 2 damage again after the
                  ability resolves."""
              ]
          }
      , Talent
          { id: Id "bladework|talent|spellblade"
          , name: Name "Bladework"
          , colour: Name "Blue"
          , description:
              [ Text
                  """The first time in a round you take damage, after the
                  triggering ability resolves, you may teleport 2."""
              ]
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Gran Levincross"
          , colour: Name "Blue"
          , description:
              [ Text "I summon thee, bloody gods of the cutting art,"
              , Newline
              , Text
                  """Let the might of the divine realm crash upen the piteous
                  earth,"""
              , Newline
              , Text "Strike eighty thousand blows at once,"
              , Newline
              , Text "And split the air asunder!"
              ]
          , cost: Two /\ 4
          , tags: [ KeywordTag (Name "Zone") ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """Your blade extends and you make two massive cuts across
                      the map, splitting the walls between worlds. Draw a cross
                      section across the map, splitting it into four sections of
                      any size. Deal 4 """
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text
                      """ damage to all characters caught in the cross, then
                      remove all characters out of the affected area and place
                      them in the nearest fere space of your choice. Characters
                      may pass a save to choose to the space themselves."""
                  , Newline
                  , Newline
                  , Text
                      """ The affected area becomes a crackling wall of
                      lightning. Each space is an """
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text
                      """ space. Characters that voluntarily enter the space or
                      start their turn there must save or take """
                  , Dice 6 D3
                  , Text " damage and become "
                  , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                  , Text ", or half and no slow on a successful save."
                  ]
              ]
          }
      , Ability
          { name: Name "Gungnir"
          , colour: Name "Blue"
          , description:
              [ Text "A thousand spears of light, each striking a perfect blow."
              ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep [ Text "3 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "3 damage." ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text
                      """Isolated foes in the area are struck by a lightning
                      bolt, taking 2 damage again. You may then teleport
                      adjacent to one of those characters."""
                  ]
              ]
          }
      , Ability
          { name: Name "Ätherwand"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You summon the highwinds, swirling around your weapon to
                  banish your foes."""
              ]
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff (Just D3)
                  [ Text "End your turn. Your next attack gains:"
                  , List Unordered
                      [ [ Text "+2 damage on hit" ]
                      , [ Text "You may teleport 3 spaces before the attack" ]
                      , [ Italic [ Text "On hit: " ]
                        , Text "teleport your foe "
                        , Dice 1 D3
                        , Text "+1. "
                        , Italic [ Text "Miss: " ]
                        , Text "1 space"
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text "Teleport your foe +2 on hit." ]
              ]
          }
      , Ability
          { name: Name "Odinforce"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You slash, and phantom images of your blade linger over
                  your shoulder."""
              ]
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Power die") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
                  , Text
                      """ and six lingering lightning infused copies of your
                      weapon, represented by a power die, starting at 6."""
                  , List Unordered
                      [ [ Text
                            """At the end of your turn you may tick down the die
                            to fire a weapon at one or two foes in range 1-4,
                            dealing 1 """
                        , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                        , Text
                            " damage and ticking the die down by 1 each time."
                        ]
                      , [ Text "The last sword deals an extra "
                        , Dice 1 D6
                        , Text " "
                        , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                        , Text "."
                        ]
                      , [ Text "If the die ticks to 0, exit this stance." ]
                      ]
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text
                      """If you end your turn with no other characters adjacent,
                      regain two swords."""
                  ]
              , Step (KeywordStep (Name "Isolate")) (Just D3)
                  [ Text "You may fire "
                  , Italic [ Dice 1 D3 ]
                  , Text " swords at a foe instead if they are isolated."
                  ]
              ]
          }
      , Ability
          { name: Name "Nothung"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You slash through your target, then cause slashes of damage
                  built up within their body to explode. A difficult technique,
                  not for the faint of heart."""
              ]
          , cost: Two
          , tags: [ Attack, KeywordTag (Name "Mark"), RangeTag Melee ]
          , steps:
              [ Step Eff Nothing [ Text "Teleport 2." ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , InsetStep OnHit Nothing
                  [ Bold [ Ref (Name "Mark") [ Text "Mark" ] ]
                  , Text
                      """ your foe. then gain the following interrupt at the end
                      of your turns while your foe is marked. You can choose not
                      to trigger it."""
                  ]
                  $ AbilityInset
                      { name: Name "Ten Thousand Cuts"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "The end of your foe's turn." ]
                          , Step Eff (Just D6)
                              [ Text
                                  """Call a number between 1 and 6, then roll
                                  the effect die. If you roll equal to or over
                                  your number, deal 2 damage a number of times
                                  to your target equal to the number chosen. If
                                  you roll under your number, deal just 1 """
                              , Italic
                                  [ Ref (Name "Pierce") [ Text "piercing" ] ]
                              , Text " damage to them. Then end this mark."
                              ]
                          , Step (KeywordStep (Name "Isolate")) Nothing
                              [ Text
                                  """Increase each instance of damage to 3
                                  damage. If there are no other characters in
                                  range 1-2, destroy all vigor on your foe
                                  before dealing damage."""
                              ]
                          ]
                      }
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
