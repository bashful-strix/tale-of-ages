module ToA.Resource.Icon.Job.Wayfarer
  ( wayfarer
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
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

wayfarer :: Icon
wayfarer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Wayfarer"
          , colour: Name "Blue"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description:
              [ Text
                  """Fast-moving, fast talking wrights that are part of the
                  Wayfarer’s guild, easily recognizable by their large rings of
                  golden keys. The guild uses and maintains the
                  semi-mythological Paths, passages that cut through old ruins
                  and use ancient Arken (or some say pre-Arken) aether
                  technology to compress journeys that would take days into mere
                  hours. During these treks, the wayfarers use their keys and
                  manipulate air Aether to open short passageways through spaces
                  beyond Arden Eld. Use of the Paths is extremely restrictive,
                  little studied, and reaching them is very dangerous, so they
                  are not traversed by most kin, and most of them lie in disuse
                  and ruin."""
              , Newline
              , Newline
              , Text
                  """The Wayfarers mostly use the paths themselves to act as
                  couriers for those that can pay them - usually for light cargo
                  and information. On foot, they lightly make their treks
                  through sunless reaches beyond the stretch of time and
                  space."""
              ]
          , trait: Name "Master Key"
          , keyword: Name "Precision"
          , abilities:
              (I /\ Name "Dimio")
                : (I /\ Name "Dimensional Anchor")
                : (II /\ Name "The Door")
                : (IV /\ Name "Palace of a Thousand Doors")
                : empty
          , limitBreak: Name "Infinite Horizon"
          , talents:
              Name "Shock"
                : Name "Pinpoint"
                : Name "Hyper"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Master Key"
          , description:
              [ Text "Once a round, at the start of "
              , Italic [ Text "any" ]
              , Text
                  """ turn, you may swap places with any ally, regardless of
                  distance or line of sight. If that ally was 4+ spaces away,
                  both you and your ally gain """
              , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
              , Text "."
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Shock"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Once a round, when you create a zone, you can deal 2
                  piercing samage to a foe adjacent to that zone."""
              ]
          }
      , Talent
          { name: Name "Pinpoint"
          , colour: Name "Blue"
          , description:
              [ Text "Gain attack "
              , Power
              , Text
                  """ against characters 4 or more spaces away. Against
                  characters 7 or more spaces away, also ignore """
              , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
              , Text "."
              ]
          }
      , Talent
          { name: Name "Hyper"
          , colour: Name "Blue"
          , description:
              [ Text "Once a combat, you can teleport yourself or an ally "
              , Dice 4 D3
              , Text " spaces as a "
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text " ability."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Infinite Horizon"
          , colour: Name "Blue"
          , description:
              [ Text "Light of the foreign suns,"
              , Newline
              , Text "Scorch my path with thy fiery rays"
              , Newline
              , Text "O air! Become parted!"
              , Newline
              , Text "Rip open the gates of heaven!"
              ]
          , cost: Quick /\ 3
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  [ Text
                      """For the rest of combat, gain the following interrupt at
                      the start of your turn."""
                  ]
                  $ AbilityInset
                      { name: Name "Keys to the House"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 3)
                      , tags:
                          [ TargetTag Self
                          , TargetTag Ally
                          , RangeTag (Range (NumVar 0) (NumVar 999))
                          ]
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "The start of "
                              , Italic [ Text "any" ]
                              , Text " turn."
                              ]
                          , Step Eff Nothing
                              [ Text
                                  """Teleport target spaces equal to 1+ the
                                  round number."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Dimio"
          , colour: Name "Blue"
          , description:
              [ Text "You cut the air in such a way that space itself is split."
              ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep
                  [ Text "2 piercing damage" ]
                  [ Text "+", Dice 1 D3, Text " piercing" ]
              , Step Eff (Just D3)
                  [ Text "You may teleport one character in the line "
                  , Italic [ Dice 1 D3 ]
                  , Text "+1 spaces, but they must stay on the line."
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing
                  [ Text
                      """If your attack target is 4+ spaces away from you,
                      increase damage on hit by +2. If they are 7+, you may
                      teleport them to """
                  , Italic [ Text "any" ]
                  , Text " space on the line."
                  ]
              ]
          }
      , Ability
          { name: Name "Dimensional Anchor"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You drop a small totem or key in place, where it stands
                  bolt upright, wreathed in lightning and keeping you
                  tethered."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  [ Text "Summon a dimensional anchor into free space in range."
                  ]
                  $ SummonInset
                      { name: Name "Anchor"
                      , colour: Name "Blue"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text "Counts as "
                              , Italic
                                  [ Ref
                                      (Name "Dangerous Terrain")
                                      [ Text "dangerous" ]
                                  ]
                              , Text
                                  """ terrain. You or any ally may teleport
                                  adjacent to this anchor from within range 1-5
                                  as a """
                              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                              , Text " ability, then dismiss it."
                              ]
                          , Step (KeywordStep (Name "Precision")) Nothing
                              [ Text
                                  """If you teleported from 4+ spaces away,
                                  release a burst 1 (self) explosion """
                              , Italic [ Text "area effect" ]
                              , Text
                                  """, dealing 2 piercing damage. If you
                                  teleported from 7+ spaces away, increase this
                                  damage to """
                              , Dice 2 D3
                              , Text " piercing."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "The Door"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You turn a key in an invisible door, and the aether-bright
                  outline of one suddenly opens up, joining two spaces."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              , End
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and create two 1 space zones in range. Characters that
                      willingly exit either space can teleport into another of
                      these spaces, as long as it is not occupied, but no more
                      than once a turn."""
                  ]
              , Step Eff Nothing
                  [ Text
                      """Line effects that enter the zone can be drawn from any
                      other space of this zone as if it were an adjacent space,
                      and can chaneg direction."""
                  ]
              ]
          }
      , Ability
          { name: Name "Palace of a Thousand Doors"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You turn a key and banish a character to a space beyond
                  space. Where you send them in unknown even to you."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Remove target from the battlefield. They return in
                      their same space at the start of their next turn, or the
                      closest space of their choice if that space is
                      obstructed."""
                  , List Unordered
                      [ [ Text "Allies returned may then teleport 3." ]
                      , [ Text "Foes returned gain "
                        , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                        , Text "."
                        ]
                      , [ Text
                          "Foes may pass a save to avoid this effect, but gain "
                        , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                        , Text " on success and you may teleport them 1."
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text "Foe gains "
                  , Weakness
                  , Text " on the save."
                  ]
              ]
          }
      ]
  }
