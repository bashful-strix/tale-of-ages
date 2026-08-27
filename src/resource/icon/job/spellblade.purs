module ToA.Resource.Icon.Job.Spellblade
  ( spellblade
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
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
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , newline
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))

spellblade :: Icon
spellblade =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Spellblade"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--zeus-sword]"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Spellblades are a martial order of highly trained wrights.
                  Many of them come from the Guild Academies in the great cities
                  of Arden Eld, where they often take prestigious posts in the
                  local militias and city watch. Other wrights tend to view
                  Spellblades as stiff, unfeeling military types, but
                  Spellblades themselves know they are consummate professionals
                  and unparalleled masters of their art."""
              , newline
              , newline
              , text
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
              Id "vex|talent|spellblade"
                : Id "fence|talent|spellblade"
                : Id "bladework|talent|spellblade"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Klingenkunst"
          , description: seq
              [ text "Once a round, you may teleport 2 as a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text " ability. If you are "
              , italic $ ref (Name "Isolate") $ text "isolated"
              , text
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
          , description: seq
              [ text "After you attack an "
              , italic $ ref (Name "Isolate") $ text "isolated"
              , text
                  " character, you may teleport 2 after the ability resolves."
              ]
          }
      , Talent
          { id: Id "fence|talent|spellblade"
          , name: Name "Fence"
          , colour: Name "Blue"
          , description: text
              """If a foe is at the very end space of one of your damaging line
              or arc effects, they take 2 damage again after the ability
              resolves."""
          }
      , Talent
          { id: Id "bladework|talent|spellblade"
          , name: Name "Bladework"
          , colour: Name "Blue"
          , description: text
              """The first time in a round you take damage, after the triggering
              ability resolves, you may teleport 2."""
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Gran Levincross"
          , colour: Name "Blue"
          , description: seq
              [ text "I summon thee, bloody gods of the cutting art,"
              , newline
              , text
                  """Let the might of the divine realm crash upon the piteous
                  earth,"""
              , newline
              , text "Strike eighty thousand blows at once,"
              , newline
              , text "And split the air asunder!"
              ]
          , cost: Two /\ 4
          , tags: [ KeywordTag (Name "Zone") ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """Your blade extends and you make two massive cuts across
                      the map, splitting the walls between worlds. Draw a cross
                      section across the map, splitting it into four sections of
                      any size. Deal 4 """
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text
                      """ damage to all characters caught in the cross, then
                      remove all characters out of the affected area and place
                      them in the nearest free space of your choice. Characters
                      may pass a save to choose to the space themselves."""
                  , newline
                  , newline
                  , text
                      """ The affected area becomes a crackling wall of
                      lightning. Each space is an """
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text
                      """ space. Characters that voluntarily enter the space or
                      start their turn there must save or take """
                  , dice 6 D3
                  , text " damage and become "
                  , italic $ ref (Name "Slow") $ text "slow"
                  , text ", or half and no slow on a successful save."
                  ]
              ]
          }
      , Ability
          { name: Name "Gungnir"
          , colour: Name "Blue"
          , description: text
              "A thousand spears of light, each striking a perfect blow."
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep (text "3 damage") $ seq [ text "+", dice 1 D3 ]
              , Step AreaEff Nothing $ text "3 damage."
              , Step (KeywordStep (Name "Isolate")) Nothing $ text
                  """Isolated foes in the area are struck by a lightning bolt,
                  taking 2 damage again. You may then teleport adjacent to one
                  of those characters."""
              ]
          }
      , Ability
          { name: Name "Ätherwand"
          , colour: Name "Blue"
          , description: text
              """You summon the highwinds, swirling around your weapon to banish
              your foes."""
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff (Just D3) $ seq
                  [ text "End your turn. Your next attack gains:"
                  , list Unordered
                      [ text "+2 damage on hit"
                      , text "You may teleport 3 spaces before the attack"
                      , seq
                          [ italic $ text "On hit: "
                          , text "teleport your foe "
                          , dice 1 D3
                          , text "+1. "
                          , italic $ text "Miss: "
                          , text "1 space"
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing $ text
                  "Teleport your foe +2 on hit."
              ]
          }
      , Ability
          { name: Name "Odinforce"
          , colour: Name "Blue"
          , description: text
              """You slash, and phantom images of your blade linger over your
              shoulder."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Power die") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text "Gain "
                  , italic $ ref (Name "Keen") $ text "keen"
                  , text
                      """ and six lingering lightning infused copies of your
                      weapon, represented by a power die, starting at 6."""
                  , list Unordered
                      [ seq
                          [ text
                              """At the end of your turn you may tick down the
                              die to fire a weapon at one or two foes in range
                              1-4, dealing 1 """
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text
                              " damage and ticking the die down by 1 each time."
                          ]
                      , seq
                          [ text "The last sword deals an extra "
                          , dice 1 D6
                          , text " "
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text "."
                          ]
                      , text "If the die ticks to 0, exit this stance."
                      ]
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing $ text
                  """If you end your turn with no other characters adjacent,
                  regain two swords."""
              , Step (KeywordStep (Name "Isolate")) (Just D3) $ seq
                  [ text "You may fire "
                  , italic $ dice 1 D3
                  , text " swords at a foe instead if they are isolated."
                  ]
              ]
          }
      , Ability
          { name: Name "Nothung"
          , colour: Name "Blue"
          , description: text
              """You slash through your target, then cause slashes of damage
              built up within their body to explode. A difficult technique, not
              for the faint of heart."""
          , cost: Two
          , tags: [ Attack, KeywordTag (Name "Mark"), RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ text "Teleport 2."
              , AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , InsetStep OnHit Nothing
                  ( seq
                      [ bold $ ref (Name "Mark") $ text "Mark"
                      , text
                          """ your foe, then gain the following interrupt at the
                          end of your turns while your foe is marked. You can
                          choose not to trigger it."""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Ten Thousand Cuts"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "The end of your foe's turn."
                          , Step Eff (Just D6) $ seq
                              [ text
                                  """Call a number between 1 and 6, then roll
                                  the effect die. If you roll equal to or over
                                  your number, deal 2 damage a number of times
                                  to your target equal to the number chosen. If
                                  you roll under your number, deal just 1 """
                              , italic $ ref (Name "Pierce") $ text "piercing"
                              , text " damage to them. Then end this mark."
                              ]
                          , Step (KeywordStep (Name "Isolate")) Nothing $ text
                              """Increase each instance of damage to 3 damage.
                              If there are no other characters in range 1-2,
                              destroy all vigor on your foe before dealing
                              damage."""
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
