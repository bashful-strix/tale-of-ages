module ToA.Resource.Icon.Job.Entropist
  ( entropist
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

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
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

entropist :: Icon
entropist =
  { classes: []
  , colours: []
  , souls: []
  , foeClasses: []
  , factions: []
  , foes: []

  , keywords:
      [ Keyword
          { name: Name "Unmooring"
          , category: Status Negative
          , description:
              [ Text
                  """When your turn ends, the character that inflicted this
                  status teleports you """
              , Italic [ Dice 1 D3 ]
              , Text "+1 spaces."
              ]
          }
      ]

  , jobs:
      [ Job
          { name: Name "Entropist"
          , colour: Name "Blue"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description:
              [ Text
                  """Lightning Aether is a connective force, bringing all matter
                  together. The Arken manipulated this force to create
                  technological marvels - bridges that hung in the air, gates of
                  light, or communication networks that could send signals over
                  long distances. Among the Arken, however, there were those
                  that studied this force obsessively, concluding ultimately
                  that it could be strengthened to incredible levels or even
                  reversed. It was this use of lightning aether that led to the
                  most fiendish weapons in the late stages of their empire -
                  weapons capable of obliterating cities, tearing apart matter,
                  and slaying gods. The studies of these heretic
                  scholar-priests, written on cuneiform scroll-cylinders, were
                  sealed in one of the great Chambers and forbidden by Kin,
                  deemed too dangerous and too destructive."""
              , Newline
              , Newline
              , Text
                  """That chamber was burst open by a legendary but very foolish
                  thief-lord. Ignorant of its contents, is liberator spilled
                  them unfettered into the world, where they were sifted and
                  split apart by a select few. Now, that knowledge has its
                  students."""
              ]
          , trait: Name "Unmooring"
          , keyword: Name "Afflicted"
          , abilities:
              (I /\ Name "Magnabolt")
                : (I /\ Name "Magnetism")
                : (II /\ Name "Stop")
                : (IV /\ Name "Disintegrate")
                : empty
          , limitBreak: Name "Howling Void"
          , talents:
              Name "Energize"
                : Name "Halt"
                : Name "Align"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Unmooring"
          , description:
              [ Text
                  """Once a round, when you dmaage a foe, you can inflict them
                  with the """
              , Italic [ Ref (Name "Unmooring") [ Text "unmooring (-)" ] ]
              , Text
                  """ unique status. At the end of that foe's turn, theleport
                  them """
              , Italic [ Dice 1 D3 ]
              , Text "+1, then remove a stack of this status."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "energize|talent|entropist"
          , name: Name "Energize"
          , colour: Name "Blue"
          , description:
              [ Text
                  """At round 3+, increase all your teleports by +1, or +2 at
                  round 5+."""
              ]
          }
      , Talent
          { id: Id "halt|talent|entropist"
          , name: Name "Halt"
          , colour: Name "Blue"
          , description:
              [ Italic [ Ref (Name "Afflicted") [ Text "Afflicted" ] ]
              , Text " characters that end their turn adjacent to you gain "
              , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
              , Text
                  """. If they have 3 or more negative statuses, they treat all
                  spaces adjacent to you as """
              , Italic [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
              , Text " terrain."
              ]
          }
      , Talent
          { id: Id "align|talent|entropist"
          , name: Name "Align"
          , colour: Name "Blue"
          , description:
              [ Text "The first time in a round you mark an ally, they gain "
              , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
              , Text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Howling Void"
          , colour: Name "Blue"
          , description:
              [ Text
                  """A black bead streaks from your fingertips, ripping a
                  screaming hole in space."""
              ]
          , cost: Two /\ 4
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 5))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """You rip a massive tear in the gravitational aether of
                      the world, creating a black hole in range, with the
                      following effects:"""
                  , List Unordered
                      [ [ Text "the black hole is "
                        , Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "dangerous" ]
                            ]
                        , Text " and "
                        , Italic
                            [ Ref
                                (Name "Difficult Terrain")
                                [ Text "difficult" ]
                            ]
                        , Text " terrain."
                        ]
                      , [ Text "this "
                        , Italic [ Text "dangerous" ]
                        , Text
                            """ terrain deals additional damage equal to half
                            the round number, rounded up."""
                        ]
                      , [ Text
                            """any character that starts or ends their turn in
                            the black hole's spaces is teleported 3 to a space
                            of your choice."""
                        ]
                      , [ Text
                            """objects that enter the black hole's space are
                            destroyed, and summons are dismissed."""
                        ]
                      , [ Text
                            """any character, summon, or object in range 2 of
                            the black hole is pulled """
                        , Italic [ Dice 1 D3 ]
                        , Text
                            """ towards the black hole when it is created, and
                            at the end of each of your turns."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Magnabolt"
          , colour: Name "Blue"
          , description: [ Text "Dark lightning scathes your target." ]
          , cost: One
          , tags: [ Attack, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step OnHit Nothing
                  [ Text
                      """Your target releases a burst 1 (self) area effect,
                      dealing 2 damage to all characters inside. This damage
                      becomes piercing if your target is """
                  , Italic [ Ref (Name "Afflicted") [ Text "afflicted" ] ]
                  , Text "."
                  ]
              , Step Eff Nothing
                  [ Text
                      """If your targeted character is inside a zone, extend the
                      above area effect to all characters inside the zone."""
                  ]
              ]
          }
      , Ability
          { name: Name "Magnetism"
          , colour: Name "Blue"
          , description:
              [ Text "You charge your target with unstable magnetic energy." ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 5))
              , TargetTag Self
              , TargetTag Ally
              , TargetTag Foe
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """At the end of target's turn, one of the following
                      effects takes place:"""
                  , List Unordered
                      [ [ Italic [ Text "Positive" ]
                        , Text ": Push all adjacent characters "
                        , Italic [ Dice 1 D3 ]
                        , Text " spaces."
                        ]
                      , [ Italic [ Text "Negative" ]
                        , Text ": Pull all characters in range 1-3 "
                        , Italic [ Dice 1 D3 ]
                        , Text " spaces."
                        ]
                      , [ Italic [ Text "Dissolution" ]
                        , Text ": Teleport all characters 1."
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Italic [ Ref (Name "Afflicted") [ Text "Afflicted" ] ]
                  , Text
                      """ characters are pushed, pulled, or teleported +1 more
                      spaces, or +2 more spaces if they have 3 or more negative
                      status tokens."""
                  ]
              ]
          }
      , Ability
          { name: Name "Stop"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You intensify gravity's effect in an area, pulling foes to
                  their needs."""
              ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 5))
              , AreaTag (Blast (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """You create a crackling zone of strong gravitational
                      collapse in free space in range, with the following
                      effects."""
                  , List Unordered
                      [ [ Text "The space is "
                        , Italic
                            [ Ref
                                (Name "Difficult Terrain")
                                [ Text "difficult" ]
                            ]
                        , Text " terrain."
                        ]
                      , [ Text
                            """Foes that willingly enter the zone for the first
                            time in a turn or start their turn there gain """
                        , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                        , Text "."
                        ]
                      , [ Italic [ Ref (Name "Afflicted") [ Text "Afflicted" ] ]
                        , Text
                            """ foes cannot coluntarily dash, fly, swap, or
                            teleport when entering or exiting any space of the
                            zone."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Disintegrate"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You reverse matter's bond, ripping your targets apart at
                  the fundamental level."""
              ]
          , cost: Two
          , tags: [ Attack, AreaTag (Line (NumVar 8)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Passes through and destroys all objects on the line."
                  ]
              , AttackStep
                  [ Text "2 piercing damage" ]
                  [ Text "+", Dice 1 D6, Text " piercing" ]
              , Step AreaEff Nothing [ Text "2 piercing damage." ]
              , Step OnHit Nothing
                  [ Text "All "
                  , Italic [ Ref (Name "Afflicted") [ Text "afflicted" ] ]
                  , Text " characters in the area take +2 damage, +1"
                  , Dice 1 D6
                  , Text " if they have 3 or more negative status tokens."
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing
                  [ Text "Gain attack "
                  , Power
                  , Text " at range 4+, or "
                  , Power
                  , Power
                  , Text " at range 7+."
                  ]
              ]
          }
      ]
  }
