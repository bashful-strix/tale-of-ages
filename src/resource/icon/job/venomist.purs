module ToA.Resource.Icon.Job.Venomist
  ( venomist
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
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

venomist :: Icon
venomist =
  { classes: []
  , colours: []
  , souls: []
  , foes: []
  , foeClasses: []
  , factions: []

  , keywords:
      [ Keyword
          { name: Name "Shadow Venom"
          , category: Status Negative
          , description:
              [ Text
                  """A unique status. When taking a turn, a character afflicted
                  by Shadow Venom cannont draw line of sight except to adjacent
                  spaces until the end of that turn. They can ignore this effect
                  while they are adjacent to an ally."""
              ]
          }
      ]

  , jobs:
      [ Job
          { name: Name "Venomist"
          , colour: Name "Yellow"
          , soul: Name "Shadow"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Night-walkers, shadow-steppers, and masters of secret venom
                  arts, the Venomists are spies, scouts, and assassins of
                  unparalleled skill. Joining their order is presumed to be
                  extremely difficult, but they tend to open their ranks to
                  anyone that has been lost or abandoned. Their number forms a
                  secret and deadly society of Vermin Clans spread across Arden
                  Eld, each practicing and refining the Night Venom Techniques.
                  They are known for hunting and drawing out poisons from the
                  deadliest creatures in Arden Eld, which which they coat their
                  weapons and even ingest to build up immunity and practice
                  toxic enlightenment. As poison can fell anything, whether lord
                  or beast, it is a great leveler."""
              ]
          , trait: Name "Shadow Venom"
          , keyword: Name "Afflicted"
          , abilities:
              (I /\ Name "Venom Lash")
                : (I /\ Name "Fume Slice")
                : (II /\ Name "Centipede Dash")
                : (IV /\ Name "Choking Cloud")
                : empty
          , limitBreak: Name "Abyssal Ecstasy"
          , talents:
              Name "Taste"
                : Name "Slither"
                : Name "Pressure"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Shadow Venom"
          , description:
              [ Text
                  """Once a round, when you damage a target, you can inflict
                  them with """
              , Ref (Name "Shadow Venom") [ Text "Shadow Venom (-)" ]
              , Text
                  """, a unique status. When taking a turn, a character
                  afflicted by Shadow Venom cannont draw line of sight except to
                  adjacent spaces until the end of that turn. They can ignore
                  this effect while they are adjacent to an ally."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Taste"
          , colour: Name "Yellow"
          , description:
              [ Text "Improve the effect of "
              , Italic [ Ref (Name "Blind") [ Text "blind" ] ]
              , Text " to "
              , Weakness
              , Weakness
              , Text
                  """ on attacks against you and adjacent allies. When you
                  critical hit, you may inflict """
              , Italic [ Ref (Name "Blind") [ Text "blind" ] ]
              , Text "."
              ]
          }
      , Talent
          { name: Name "Slither"
          , colour: Name "Yellow"
          , description:
              [ Text "You can "
              , Italic [ Ref (Name "Phasing") [ Text "phase" ] ]
              , Text
                  """ through afflicted foes when you move. Once a round, when
                  you do this, you can deal 2 damage to that foe, or """
              , Dice 2 D3
              , Text " if they are in crisis."
              ]
          }
      , Talent
          { name: Name "Pressure"
          , colour: Name "Yellow"
          , description:
              [ Text "Your attacks gain "
              , Italic [ Ref (Name "Critical Hit") [ Text "critical hit" ] ]
              , Text
                  """: increase all negative statuses on your foe by +1, or +2
                  if your foe is in """
              , Italic [ Text "crisis" ]
              , Text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Abyssal Ecstasy"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You catalyze a toxic mist in your blood so potent that it
                  coats the entire battlefield in a deadly, hallucinogenic
                  haze."""
              ]
          , cost: One /\ 3
          , tags: []
          , steps:
              [ Step Eff Nothing
                  [ Text "Yourself and all allies gain "
                  , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                  , Text ", and all foes gain "
                  , Italic [ Ref (Name "Blind") [ Text "blind" ] ]
                  , Text " and "
                  , Italic [ Ref (Name "Shadow Venom") [ Text "shadow venom" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Venom Lash"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You lash out with a chain, whip, or grapple filled with
                  tiny channels and barbs for containing poisons."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step Eff Nothing
                  [ Text "Pull yourself 1 or 2 spaces towards your target." ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text
                      """Then you may choose to have your foe save or be pulled
                      1, or up to 3 spaces on a failed save, choosing the pull
                      distance. If your foe has 3 negative status tokens or
                      more, they fail the save."""
                  ]
              ]
          }
      , Ability
          { name: Name "Fume Slice"
          , colour: Name "Yellow"
          , description:
              [ Text "Spattered venom from your weapon creates a toxic shield."
              ]
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 3)) ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """Slash a line 3 zone, which could be created over 
                      characters. Each space of the zone is an """
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text " space and is "
                  , Italic
                      [ Ref
                          (Name "Difficult Terrain")
                          [ Text "difficult terrain" ]
                      ]
                  , Text ". When created, characters in the area effect take 2 "
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage and must save or be "
                  , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text
                      """If inititally targeting at least one afflicted foe,
                      extend the line by +2. If that foe had 3 or more negative
                      statuses, extend the area by +6."""
                  ]
              ]
          }
      , Ability
          { name: Name "Centipede Dash"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """As you weave around your foes, tiny nicks with needles or
                  blades blossom into stinging death."""
              ]
          , cost: One
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 4)), End ]
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """Target a line 4 area, then dash to the end, or as far
                      as possible, with """
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text ". Then "
                  , Bold [ Text "end your turn." ]
                  , List Unordered
                      [ [ Text
                            """The first foe you pass through during this
                            movement is """
                        , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                        , Text "."
                        ]
                      , [ Text
                            """All bloodied foes then have all their statuses
                            increased by +1. Foes in crisis have their statuses
                            increased by +2.
                            """
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text
                      """Afflicted foes take 2 damage. Foes with 3 or more
                      negative status tokens takes 2 """
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Choking Cloud"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You throw a gleaming stone of condensed pure poison. On
                  impact, it blossoms into a beautiful, shimmering, and very
                  deadly cloud."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 3))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D6)
                  [ Text "Summon one or (5+) two choking clouds in range." ]
                  $ SummonInset
                      { name: Name "Choking Cloud"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text "The could is an "
                              , Italic
                                  [ Ref (Name "Obscured") [ Text "obscured" ] ]
                              , Text
                                  """ space. In addition, characters other than
                                  you standing in or adjacent to a could do not
                                  clear statuses at the end of their turn."""
                              ]
                          , Step SummonEff Nothing
                              [ Text "Afflicted foes treat the area as "
                              , Italic
                                  [ Ref
                                      (Name "Difficult Terrain")
                                      [ Text "difficult" ]
                                  ]
                              , Text " and "
                              , Italic
                                  [ Ref
                                      (Name "Danagerous Terrain")
                                      [ Text "dangerous terrain" ]
                                  ]
                              , Text "."
                              ]
                          , Step SummonAction Nothing
                              [ Text
                                  """The could flies 2 spaces. It can enter or
                                  end this movement in character's spaces."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
