module ToA.Resource.Icon.Job.Chronomancer
  ( chronomancer
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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

chronomancer :: Icon
chronomancer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Chronomancer"
          , colour: Name "Green"
          , soul: Name "Oracle"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Of those that tinker with fundamental forces in the great
                  Guild academies, the Chronomancers are perhaps the most
                  feared. Their quarry is mastery over the flow of time, a dread
                  goal sought by many masters of the mortal world. At great
                  lengths, and with tremendous machinery, the chronomancers
                  examine every strand of Aether to determine the power of its
                  ebb and flow."""
              , Newline
              , Newline
              , Text
                  """In theory, chronomancy is a terrifying power. In practice,
                  chronomancy is an extremely ill-understood corner of the
                  Aetheric arts with very difficult conditions for its practice.
                  Even those that consider itself masters of its practice can
                  only manage the reversal or acceleration of time for a few
                  moments at a time."""
              ]
          , trait: Name "Chronal Echo"
          , keyword: Name "Overdrive"
          , abilities:
              (I /\ Name "Chronoripple")
                : (I /\ Name "The Chariot")
                : (II /\ Name "Sisyphus")
                : (IV /\ Name "Chronotemper")
                : empty
          , limitBreak: Name "Rewind"
          , talents:
              Name "Stutter"
                : Name "Chronodouble"
                : Name "Tick"
                : empty
          }
      ]

  , traits:
      [ InsetTrait
          { name: Name "Chronal Echo"
          , description:
              [ Text
                  """Once a round, when you or a character in range 1-3 of you
                  starts their turn, you may summon a time echo of them in or
                  adjacent to their space. At round 3+, you can trigger this
                  effect twice a round."""
              ]
          , inset: SummonInset
              { name: Name "Chronal Echo"
              , colour: Name "Green"
              , max: 6
              , abilities:
                  [ Step SummonEff Nothing
                      [ Text
                          """A character that enters the space of a chronal echo
                          for any reason teleports to any space adjacent to you,
                          or into the space of any other time echo in range 1-3.
                          If that character is a foe, you may choose their
                          destination."""
                      ]
                  ]
              }
          }
      ]

  , talents:
      [ Talent
          { name: Name "Stutter"
          , colour: Name "Green"
          , description:
              [ Text
                  """Once a round, when you teleport or teleport an ally, you
                  can teleport yourself or them again """
              , Dice 1 D3
              , Text " space. Overdrive: +2 more spaces."
              ]
          }
      , Talent
          { name: Name "Chronodouble"
          , colour: Name "Green"
          , description:
              [ Text
                  """At round 3+, each round, you can repeat one effect you
                  could normally only produce once a round. At round 5+, you can
                  repeat an effect you can only produce once a combat one more
                  time."""
              ]
          }
      , Talent
          { name: Name "Tick"
          , colour: Name "Green"
          , description:
              [ Text "At round 4+, you gain +1 use of all interrupts." ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Rewind"
          , colour: Name "Green"
          , description:
              [ Text
                  """You struggle against fate itself, undoing causality and
                  defying the stars."""
              ]
          , cost: Interrupt (NumVar 1) /\ 4
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ Step TriggerStep Nothing
                  [ Text "A character starts their turn." ]
              , Step Eff Nothing
                  [ Text
                      """Choose an ally in range. Note the character's current
                      position, hp vigor, and status effects. At the end of that
                      character's turn, remove them from the battlefield, then
                      reset them to the exact state they were in at the start of
                      the turn."""
                  ]
              ]
          }
      , Ability
          { name: Name "Chronoripple"
          , colour: Name "Green"
          , description: [ Text "Causality unmakes itself around you." ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 4))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , InsetStep (KeywordStep (Name "Zone")) (Just D6)
                  [ Text
                      """Create one or (5+) two spaces of an accelerated time
                      zone in free spaces inside or adjacent to the area."""
                  ]
                  $ KeywordInset
                      { name: Name "Accelerated Time"
                      , colour: Name "Green"
                      , keyword: Name "Zone"
                      , steps:
                          [ Step (KeywordStep (Name "Zone")) Nothing
                              [ Text
                                  """New spaces added to this area extend the
                                  zone instead of replacing it. A character that
                                  either starts or ends their turn inside takes
                                  1 piercing damage and increases a positive or
                                  negative status of your choice by 1."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "All spaces deal +"
                  , Dice 1 D3
                  , Text " damage to foes and no damage to allies."
                  ]
              ]
          }
      , Ability
          { name: Name "The Chariot"
          , colour: Name "Green"
          , description:
              [ Text
                  """You speed up time's flow in a small area, withering plant
                  life, hastening wounds, and causing those crossing it to move
                  in a flash."""
              ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 5))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """You create a zone of rapidly flowing time in free
                      space in range. Inside the area, spaces always cost a
                      maximum of 1 movement to enter or exit, and all characters
                      take damage """
                  , Power
                  , Text " from attacks."
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Increase to cross 3." ]
              ]
          }
      , Ability
          { name: Name "Sisyphus"
          , colour: Name "Green"
          , description:
              [ Text
                  """You bend a character's timeline, reversing causality so
                  that the very ground warps under their feet."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 5))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """Mark a character in range. While marked, note their
                      starting position at the start of their turn. At the end
                      of their turn, if they are in 1-3 of their position, you
                      may teleport that character to their starting position, or
                      as close as possible if the space is occupied. Then,
                      remove the mark. Otherwise, keep the mark."""
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Checks for original position in range 1-6." ]
              ]
          }
      , Ability
          { name: Name "Chronotemper"
          , colour: Name "Green"
          , description:
              [ Text
                  """Ripple of accelerated time bend around your ally's
                  movements, overlaying afterimages as they move."""
              ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Mark")
              , End
              , RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and mark an ally in range. While marked, they gain a
                      power die, starting at 6. They may tick the die down by 3
                      to make a free move at the end of any turn, even their
                      own. If the die reaches 0, roll """
                  , Dice 1 D6
                  , Text
                      """. This is not an effect roll. If you roll equal to or
                      under the round number, keep the die at its new value,
                      otherwise discard it and end this mark."""
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text
                      """If your foe has no other characters adjacent after they
                      move, tick the die down by only 2 instead."""
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Reduce action cost to 1." ]
              ]
          }
      ]
  }
