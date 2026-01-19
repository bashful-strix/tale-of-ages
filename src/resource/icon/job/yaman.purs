module ToA.Resource.Icon.Job.Yaman
  ( yaman
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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

yaman :: Icon
yaman =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Yaman"
          , colour: Name "Green"
          , soul: Name "Monk"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Eccentric mountain hermits, the Yaman are supremely skilled
                  martial artists sought after by many from the lowlands, who
                  spend long years struggling to pry some wisdom or skill from
                  their grasp, often to no avail. The yaman draw their strength
                  from their isolation, the frigid mountain air, and their
                  (quite literal) closeness to heaven, or so they say."""
              , Newline
              , Newline
              , Text
                  """The Yaman have their origins in an order of wardens tasked
                  with protecting the great Chronicler bells, used for warning
                  and long distance communication. The few temples, meagre
                  cliffside shrines, or rocky cairns that they occupy tend to be
                  the hosts to these bells, which are treated with intense
                  reverence. A Yaman must have the strength of body, if
                  necessary, to carry the massive bronze bell itself long
                  distances, and therefore nearly all of them are the product of
                  unbelievably rigorous training regimens."""
              ]
          , trait: Name "Master's Touch"
          , keyword: Name "Impact"
          , abilities:
              (I /\ Name "Roppo")
                : (I /\ Name "Forceful Instruction")
                : (II /\ Name "Master's Eye")
                : (IV /\ Name "Peak Performance")
                : empty
          , limitBreak: Name "Great Temple Bell"
          , talents:
              Name "Victory"
                : Name "Shift"
                : Name "Sway"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Master's Touch"
          , description:
              [ Text
                  """You increase all pushes and pulls you make by half the
                  round number, rounded up. When you push or pull an ally, you
                  can choose how many spaces you push or pull them."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Victory"
          , colour: Name "Green"
          , description: [ Text "Round 4 and 5 count as round 6 for you." ]
          }
      , Talent
          { name: Name "Shift"
          , colour: Name "Green"
          , description:
              [ Text
                  """You push or pull targets with any amount of vigor +1
                  spaces, or +2 spaces if they have maximum vigor."""
              ]
          }
      , Talent
          { name: Name "Sway"
          , colour: Name "Green"
          , description:
              [ Text "While you are at 75% hp or higher, you gain attack "
              , Power
              , Text ". While you're in crisis, you gain attack "
              , Power
              , Text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Great Temple Bell"
          , colour: Name "Green"
          , description:
              [ Text
                  """You summon a massive, aetheric echo of a temple bell - no
                  less heavy then the real thing."""
              ]
          , cost: Two /\ 3
          , tags:
              [ KeywordTag (Name "Object")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Object")) Nothing
                  [ Text
                      """You summon a great temple bell in free space in range,
                      pushing all adjacent characters 1 when it is summoned. The
                      bell is a height 1 object."""
                  ]
                  $ KeywordInset
                      { name: Name "Great Bell"
                      , colour: Name "Green"
                      , keyword: Name "Object"
                      , steps:
                          [ Step Eff Nothing [ Text "Height 1." ]
                          , Step Eff Nothing
                              [ Text "When a character "
                              , Bold [ Ref (Name "Impact") [ Text "impacts" ] ]
                              , Text
                                  """ the bell, it rings out, dealing 2 damage
                                  to """
                              , Italic [ Text "all" ]
                              , Text " foes and granting 2 vigor to "
                              , Italic [ Text "all" ]
                              , Text
                                  """ allies. Then roll a d6. If you roll under
                                  the round number, the bell's effect can be
                                  activated again. It can activate any number of
                                  times, as long as the roll is successful.
                                  Otherwise, the bell loses its power until the
                                  end the current round."""
                              ]
                          , Step Eff Nothing
                              [ Text
                                  "As a quick ability, you may push the bell "
                              , Dice 2 D3
                              , Text
                                  """ spaces. If it impacts a character, it has
                                  the same effect as above."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Roppo"
          , colour: Name "Green"
          , description:
              [ Text
                  """A series of hops from peak to peak, then series of blows
                  that can shatter steel."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Teleport 1, then you may push an adjacent character 1,
                      then repeat this effect."""
                  ]
              , AttackStep [ Text "3 damage" ] [ Text "+", Dice 1 D3 ]
              , Step OnHit (Just D6) [ Text "Push your foe 1 or (6+) spaces." ]
              ]
          }
      , Ability
          { name: Name "Forceful Instruction"
          , colour: Name "Green"
          , description:
              [ Text
                  """Students must be pushed past their limits - sometimes
                  literally."""
              ]
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step Eff (Just D3)
                  [ Text "Push an ally "
                  , Italic [ Dice 1 D3, Text "+1" ]
                  , Text " spaces. That ally gains "
                  , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing
                  [ Text
                      """If your ally impacts a foe, they may swap places with
                      that foe, then that foe takes 2 damage."""
                  ]
              ]
          }
      , Ability
          { name: Name "Master's Eye"
          , colour: Name "Green"
          , description:
              [ Text
                  """You stand ready to step in at the slightest mistake in
                  stance."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 3))
              , KeywordTag (Name "Interrupt")
              ]
          , steps:
              [ InsetStep Eff Nothing
                  [ Text
                      """You may clear a negative status on yourself. Then gain
                      the following interrupt until the start of your next
                      turn."""
                  ]
                  $ AbilityInset
                      { name: Name "Correction"
                      , colour: Name "Green"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "An ally in range is attacked." ]
                          , Step Eff (Just D6)
                              [ Text "The attack gains "
                              , Weakness
                              , Text
                                  """. Then, after the attack resolves, swap
                                  places with your ally and you may push both
                                  them and the attacking foe 1 (4+) or 2
                                  spaces."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Peak Performance"
          , colour: Name "Green"
          , description: [ Text "You lead best by example." ]
          , cost: One
          , tags: [ End, KeywordTag (Name "Stance") ]
          , steps:
              [ InsetStep (KeywordStep (Name "Stance")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text " and gain "
                  , Bold [ Text "Stance" ]
                  , Text ": While in this stance, your attack gains "
                  , Power
                  , Text " and you gain the following interrupt."
                  ]
                  $ AbilityInset
                      { name: Name "Again, Student"
                      , colour: Name "Green"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)) ]
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  """An ally in range attacks a foe, and you see
                                  the result of the attack roll."""
                              ]
                          , Step Eff (Just D6)
                              [ Text
                                  """Make your own attack roll, using any
                                  bonuses you have. You may substitute your
                                  attack roll for your ally's. Then after the 
                                  attack resolves, you may push your ally """
                              , Italic [ Dice 1 D3 ]
                              , Text "."
                              ]
                          , Step (KeywordStep (Name "Excel")) Nothing
                              [ Text "Double this push." ]
                          , Step (KeywordStep (Name "Impact")) Nothing
                              [ Text
                                  """Ally deals damage to any foe they impact
                                  with equal to the spaces they were pushed
                                  before impact (max 6)."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
