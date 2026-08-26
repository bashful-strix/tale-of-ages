module ToA.Resource.Icon.Job.Raconteur
  ( raconteur
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
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
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
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

raconteur :: Icon
raconteur =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Raconteur"
          , colour: Name "Green"
          , sign: Sign "icon-[game-icons--robin-hood-hat]"
          , soul: Name "Bard"
          , class: Name "Mendicant"
          , description: seq
              [ text
                  """Across the broad land of Arden Eld, no profession is more
                  respected than storytelling, even if its practitioners range
                  widely in their methods and audiences. From the churner camps,
                  to the village longhall, to the tavern of the great cities,
                  there are none who can dispute the power of gathering around a
                  warm hearth, listening to a retelling of one of the old
                  greats."""
              , newline
              , newline
              , text
                  """There are some in the profession, whether with instrument
                  or with well tempered voice, whose skill with their craft is
                  more than talent. Drawing on the aether in the wind, they can
                  infuse their performances with flair - sound effects, or
                  dancing shadows or light. This power is equally as effective
                  at entertaining villagers and children as it is a potent tool
                  for self defense - and humiliating the cruel and malicious."""
              ]
          , trait: Name "Ballad Master"
          , keyword: Name "Weave"
          , abilities:
              (I /\ Name "Withering Insult")
                : (I /\ Name "Pithy Retort")
                : (II /\ Name "Spirited Ballad")
                : (IV /\ Name "Fantasia")
                : empty
          , limitBreak: Name "Amp Up"
          , talents:
              Id "finale|talent|raconteur"
                : Id "pity|talent|raconteur"
                : Id "echo|talent|raconteur"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Ballad Master"
          , description: seq
              [ text
                  """You can maintain two stances at the same time. At the start
                  of combat, or the first time in a round you enter a stance you
                  haven't entered before this combat, you can trigger one of the
                  following effects:"""
              , list Unordered
                  [ text
                      """Make a free move, or allow an ally in range 1-3 to do
                      the same."""
                  , text
                      """Swap yourself or two allies in range 1-3 of you and
                      each other."""
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "finale|talent|raconteur"
          , name: Name "Finale"
          , colour: Name "Green"
          , description: text
              "At round 3+, you can enter one more stance than normal."
          }
      , Talent
          { id: Id "pity|talent|raconteur"
          , name: Name "Pity"
          , colour: Name "Green"
          , description: seq
              [ text
                  """Once a round, when a character rolls a '1' on the final die
                  of an attack roll, you may use one of the following: """
              , list Unordered
                  [ seq
                      [ bold $ text "Foe"
                      , text ": "
                      , italic $ ref (Name "Brand") $ text "Brand"
                      , text " your foe and push them 3."
                      ]
                  , seq
                      [ bold $ text "Ally"
                      , text
                          """: Re-roll one die of the attack roll, taking that
                          result as final."""
                      ]
                  ]
              ]
          }
      , Talent
          { id: Id "echo|talent|raconteur"
          , name: Name "Echo"
          , colour: Name "Green"
          , description: text
              """Choose a weave effect from your abilities. You can activate it
              with any ability you use, even the original ability, once per
              combat."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Amp Up"
          , colour: Name "Green"
          , description: text
              """You redouble your efforts, your words or music burning with a
              fiery passion that instills an unbreakable spirit in your
              allies."""
          , cost: Quick /\ 2
          , tags: [ End, KeywordTag (Name "Aura") ]
          , steps:
              [ Step (KeywordStep (Name "Aura")) Nothing $ seq
                  [ text
                      """Until the end of your next turn, for all allies in aura
                      3:"""
                  , list Unordered
                      [ text "Rolling a 1 or a 10 on a d10 counts as an 11."
                      , text "Rolling a 1 or a 6 on a d6 counts as an 7."
                      ]
                  , text
                      """Allies in the aura also score critical hits on 11s.
                      When an ally scores a critical hit, it deals +damage equal
                      to the round number and they can fly 3 after their attack
                      resolves."""
                  ]
              ]
          }
      , Ability
          { name: Name "Withering Insult"
          , colour: Name "Green"
          , description: text
              """Your words bite into your foe's resolve, weakening their
              strikes."""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 5))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ AttackStep
                  (text "1 piercing damage")
                  $ seq [ text "+", dice 1 D3, text " piercing" ]
              , Step OnHit Nothing $ seq
                  [ bold $ ref (Name "Mark") $ text "Mark"
                  , text " your foe. Your marked foe has attack "
                  , weakness
                  , text " and takes "
                  , dice 2 D3
                  , text " "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text
                      """ damage if they miss an attack. A foe can save at the
                      end of their turn to remove this mark."""
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing $ text
                  """After this ability resolves, increase a negative status on
                  a foe in range 2-5 by +1."""
              ]
          }
      , Ability
          { name: Name "Pithy Retort"
          , colour: Name "Green"
          , description: text
              "Your quick tongue lashes out in reply, stabbing like a dagger."
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text
                      """While in this stance, gain aura 2. When any foe misses
                      an attack against you or an ally in the aura, you may """
                  , italic $ ref (Name "Brand") $ text "brand"
                  , text " that foe, deal "
                  , dice 1 D3
                  , text " "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage to them, and push them 1."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing $ seq
                  [ text "After this ability resolves, "
                  , italic $ ref (Name "Brand") $ text "brand"
                  , text " a foe in range 1-3."
                  ]
              ]
          }
      , Ability
          { name: Name "Spirited Ballad"
          , colour: Name "Green"
          , description: text
              """You start up a bawdy ballad, inspiring your allies to acts of
              greater heroism."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ InsetStep (KeywordStep (Name "Stance")) Nothing
                  (text "While in this stance, gain the following interrupt.")
                  $ AbilityInset
                      { name: Name "Inspire"
                      , colour: Name "Green"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "An ally in range 1-3 uses an ability."
                          , Step Eff Nothing $ text
                              """Your ally can re-roll a single die rolled as
                              part of this ability, taking the second roll as
                              final."""
                          , Step Eff Nothing $ text
                              """If your ally is in crisis, they can re-roll
                              two dice."""
                          ]
                      }
              , Step (KeywordStep (Name "Weave")) Nothing $ text
                  """After this ability resolves, clear a negative status from
                  yourself or an ally in range 1-3."""
              ]
          }
      , Ability
          { name: Name "Fantasia"
          , colour: Name "Green"
          , description: text "No, no, that's not how it happened."
          , cost: One
          , tags: [ End ]
          , steps:
              [ InsetStep Eff Nothing
                  (text "Gain the following interrupt:")
                  $ AbilityInset
                      { name: Name "Deus Ex Machina"
                      , colour: Name "Green"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ RangeTag (Range (NumVar 2) (NumVar 4)) ]
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              """Your ally in range is damaged by a foe's
                              ability, and the damaging ability resolves."""
                          , Step Eff (Just D3) $ seq
                              [ text
                                  """Your ally may save. On a failed save, they
                                  may fly """
                              , italic $ dice 1 D3
                              , text
                                  """. On a successful save, they may fly twice
                                  as far. During this flight, they are """
                              , italic
                                  $ ref (Name "Unstoppable")
                                  $ text "unstoppable"
                              , text " and immune to all damage."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Weave")) Nothing $ seq
                  [ text
                      """After this ability resolves, grant 2 vigor to an
                      adjacent ally. Increase by +"""
                  , dice 1 D6
                  , text " for allies in crisis."
                  ]
              ]
          }
      ]
  }
