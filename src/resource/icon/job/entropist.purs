module ToA.Resource.Icon.Job.Entropist
  ( entropist
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
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
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , dice
  , list
  , italic
  , newline
  , power
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
          , description: seq
              [ text
                  """When your turn ends, the character that inflicted this
                  status teleports you """
              , italic $ dice 1 D3
              , text "+1 spaces."
              ]
          }
      ]

  , jobs:
      [ Job
          { name: Name "Entropist"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--lightning-dissipation]"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description: seq
              [ text
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
              , newline
              , newline
              , text
                  """That chamber was burst open by a legendary but very foolish
                  thief-lord. Ignorant of its contents, its liberator spilled
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
              Id "energize|talent|entropist"
                : Id "halt|talent|entropist"
                : Id "align|talent|entropist"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Unmooring"
          , description: seq
              [ text
                  """Once a round, when you damage a foe, you can inflict them
                  with the """
              , italic $ ref (Name "Unmooring") $ text "unmooring (-)"
              , text
                  """ unique status. At the end of that foe's turn, teleport
                  them """
              , italic $ dice 1 D3
              , text "+1, then remove a stack of this status."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "energize|talent|entropist"
          , name: Name "Energize"
          , colour: Name "Blue"
          , description: text
              """At round 3+, increase all your teleports by +1, or +2 at round
              5+."""
          }
      , Talent
          { id: Id "halt|talent|entropist"
          , name: Name "Halt"
          , colour: Name "Blue"
          , description: seq
              [ italic $ ref (Name "Afflicted") $ text "Afflicted"
              , text " characters that end their turn adjacent to you gain "
              , italic $ ref (Name "Slow") $ text "slow"
              , text
                  """. If they have 3 or more negative statuses, they treat all
                  spaces adjacent to you as """
              , italic $ ref (Name "Difficult Terrain") $ text "difficult"
              , text " terrain."
              ]
          }
      , Talent
          { id: Id "align|talent|entropist"
          , name: Name "Align"
          , colour: Name "Blue"
          , description: seq
              [ text "The first time in a round you mark an ally, they gain "
              , italic $ ref (Name "Keen") $ text "keen"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Howling Void"
          , colour: Name "Blue"
          , description: text
              """A black bead streaks from your fingertips, ripping a screaming
              hole in space."""
          , cost: Two /\ 4
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 5))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """You rip a massive tear in the gravitational aether of
                      the world, creating a black hole in range, with the
                      following effects:"""
                  , list Unordered
                      [ seq
                          [ text "the black hole is "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous"
                          , text " and "
                          , italic
                              $ ref (Name "Difficult Terrain")
                              $ text "difficult"
                          , text " terrain."
                          ]
                      , seq
                          [ text "this "
                          , italic $ text "dangerous"
                          , text
                              """ terrain deals additional damage equal to half
                              the round number, rounded up."""
                          ]
                      , text
                          """any character that starts or ends their turn in
                          the black hole's spaces is teleported 3 to a space
                          of your choice."""
                      , text
                          """objects that enter the black hole's space are
                          destroyed, and summons are dismissed."""
                      , seq
                          [ text
                              """any character, summon, or object in range 2 of
                              the black hole is pulled """
                          , italic $ dice 1 D3
                          , text
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
          , description: text "Dark lightning scathes your target."
          , cost: One
          , tags: [ Attack, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D3 ])
              , Step AreaEff Nothing $ text "2 damage."
              , Step OnHit Nothing $ seq
                  [ text
                      """Your target releases a burst 1 (self) area effect,
                      dealing 2 damage to all characters inside. This damage
                      becomes piercing if your target is """
                  , italic $ ref (Name "Afflicted") $ text "afflicted"
                  , text "."
                  ]
              , Step Eff Nothing $ text
                  """If your targeted character is inside a zone, extend the
                  above area effect to all characters inside the zone."""
              ]
          }
      , Ability
          { name: Name "Magnetism"
          , colour: Name "Blue"
          , description: text
              "You charge your target with unstable magnetic energy."
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 5))
              , TargetTag Self
              , TargetTag Ally
              , TargetTag Foe
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """At the end of target's turn, one of the following
                      effects takes place:"""
                  , list Unordered
                      [ seq
                          [ italic $ text "Positive"
                          , text ": Push all adjacent characters "
                          , italic $ dice 1 D3
                          , text " spaces."
                          ]
                      , seq
                          [ italic $ text "Negative"
                          , text ": Pull all characters in range 1-3 "
                          , italic $ dice 1 D3
                          , text " spaces."
                          ]
                      , seq
                          [ italic $ text "Dissolution"
                          , text ": Teleport all characters 1."
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing $ seq
                  [ italic $ ref (Name "Afflicted") $ text "Afflicted"
                  , text
                      """ characters are pushed, pulled, or teleported +1 more
                      spaces, or +2 more spaces if they have 3 or more negative
                      status tokens."""
                  ]
              ]
          }
      , Ability
          { name: Name "Stop"
          , colour: Name "Blue"
          , description: text
              """You intensify gravity's effect in an area, pulling foes to
              their knees."""
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 5))
              , AreaTag (Blast (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """You create a crackling zone of strong gravitational
                      collapse in free space in range, with the following
                      effects."""
                  , list Unordered
                      [ seq
                          [ text "The space is "
                          , italic
                              $ ref (Name "Difficult Terrain")
                              $ text "difficult"
                          , text " terrain."
                          ]
                      , seq
                          [ text
                              """Foes that willingly enter the zone for the
                              first time in a turn or start their turn there
                              gain """
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text "."
                          ]
                      , seq
                          [ italic $ ref (Name "Afflicted") $ text "Afflicted"
                          , text
                              """ foes cannot voluntarily dash, fly, swap, or
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
          , description: text
              """You reverse matter's bond, ripping your targets apart at
              the fundamental level."""
          , cost: Two
          , tags: [ Attack, AreaTag (Line (NumVar 8)) ]
          , steps:
              [ Step Eff Nothing $ text
                  "Passes through and destroys all objects on the line."
              , AttackStep
                  (text "2 piercing damage")
                  (seq [ text "+", dice 1 D6, text " piercing" ])
              , Step AreaEff Nothing $ text "2 piercing damage."
              , Step OnHit Nothing $ seq
                  [ text "All "
                  , italic $ ref (Name "Afflicted") $ text "afflicted"
                  , text " characters in the area take +2 damage, +"
                  , dice 1 D6
                  , text " if they have 3 or more negative status tokens."
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing $ seq
                  [ text "Gain attack "
                  , power
                  , text " at range 4+, or "
                  , power
                  , power
                  , text " at range 7+."
                  ]
              ]
          }
      ]
  }
