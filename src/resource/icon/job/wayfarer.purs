module ToA.Resource.Icon.Job.Wayfarer
  ( wayfarer
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
  , Target(..)
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
  , power
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))

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
          , sign: Sign "icon-[game-icons--three-keys]"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description: seq
              [ text
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
              , newline
              , newline
              , text
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
              Id "shock|talent|wayfarer"
                : Id "pinpoint|talent|wayfarer"
                : Id "hyper|talent|wayfarer"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Master Key"
          , description: seq
              [ text "Once a round, at the start of "
              , italic $ text "any"
              , text
                  """ turn, you may swap places with any ally, regardless of
                  distance or line of sight. If that ally was 4+ spaces away,
                  both you and your ally gain """
              , italic $ ref (Name "Keen") $ text "keen"
              , text "."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "shock|talent|wayfarer"
          , name: Name "Shock"
          , colour: Name "Blue"
          , description: text
              """Once a round, when you create a zone, you can deal 2 piercing
              damage to a foe adjacent to that zone."""
          }
      , Talent
          { id: Id "pinpoint|talent|wayfarer"
          , name: Name "Pinpoint"
          , colour: Name "Blue"
          , description: seq
              [ text "Gain attack "
              , power
              , text
                  """ against characters 4 or more spaces away. Against
                  characters 7 or more spaces away, also ignore """
              , italic $ ref (Name "Cover") $ text "cover"
              , text "."
              ]
          }
      , Talent
          { id: Id "hyper|talent|wayfarer"
          , name: Name "Hyper"
          , colour: Name "Blue"
          , description: seq
              [ text "Once a combat, you can teleport yourself or an ally "
              , dice 4 D3
              , text " spaces as a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text " ability."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Infinite Horizon"
          , colour: Name "Blue"
          , description: seq
              [ text "Light of the foreign suns,"
              , newline
              , text "Scorch my path with thy fiery rays"
              , newline
              , text "O air! Become parted!"
              , newline
              , text "Rip open the gates of heaven!"
              ]
          , cost: Quick /\ 3
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  ( text
                      """For the rest of combat, gain the following interrupt at
                      the start of your turn."""
                  )
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
                          [ Step TriggerStep Nothing $ seq
                              [ text "The start of "
                              , italic $ text "any"
                              , text " turn."
                              ]
                          , Step Eff Nothing $ text
                              """Teleport target spaces equal to 1+ the round
                              number."""
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Dimio"
          , colour: Name "Blue"
          , description: text
              "You cut the air in such a way that space itself is split."
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep
                  (text "2 piercing damage")
                  $ seq [ text "+", dice 1 D3, text " piercing" ]
              , Step Eff (Just D3) $ seq
                  [ text "You may teleport one character in the line "
                  , italic $ dice 1 D3
                  , text "+1 spaces, but they must stay on the line."
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing $ seq
                  [ text
                      """If your attack target is 4+ spaces away from you,
                      increase damage on hit by +2. If they are 7+, you may
                      teleport them to """
                  , italic $ text "any"
                  , text " space on the line."
                  ]
              ]
          }
      , Ability
          { name: Name "Dimensional Anchor"
          , colour: Name "Blue"
          , description: text
              """You drop a small totem or key in place, where it stands bolt
              upright, wreathed in lightning and keeping you tethered."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  (text "Summon a dimensional anchor into free space in range.")
                  $ SummonInset
                      { name: Name "Anchor"
                      , colour: Name "Blue"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text "Counts as "
                              , italic
                                  $ ref (Name "Dangerous Terrain")
                                  $ text "dangerous"
                              , text
                                  """ terrain. You or any ally may teleport
                                  adjacent to this anchor from within range 1-5
                                  as a """
                              , italic $ ref (Name "Quick") $ text "quick"
                              , text " ability, then dismiss it."
                              ]
                          , Step (KeywordStep (Name "Precision")) Nothing $ seq
                              [ text
                                  """If you teleported from 4+ spaces away,
                                  release a burst 1 (self) explosion """
                              , italic $ text "area effect"
                              , text
                                  """, dealing 2 piercing damage. If you
                                  teleported from 7+ spaces away, increase this
                                  damage to """
                              , dice 2 D3
                              , text " piercing."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "The Door"
          , colour: Name "Blue"
          , description: text
              """You turn a key in an invisible door, and the aether-bright
              outline of one suddenly opens up, joining two spaces."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              , End
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and create two 1 space zones in range. Characters that
                      willingly exit either space can teleport into another of
                      these spaces, as long as it is not occupied, but no more
                      than once a turn."""
                  ]
              , Step Eff Nothing $ text
                  """Line effects that enter the zone can be drawn from any
                  other space of this zone as if it were an adjacent space, and
                  can change direction."""
              ]
          }
      , Ability
          { name: Name "Palace of a Thousand Doors"
          , colour: Name "Blue"
          , description: text
              """You turn a key and banish a character to a space beyond space.
              Where you send them in unknown even to you."""
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Remove target from the battlefield. They return in
                      their same space at the start of their next turn, or the
                      closest space of their choice if that space is
                      obstructed."""
                  , list Unordered
                      [ text "Allies returned may then teleport 3."
                      , seq
                          [ text "Foes returned gain "
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text "."
                          ]
                      , seq
                          [ text
                              """Foes may pass a save to avoid this effect, but
                              gain """
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text " on success and you may teleport them 1."
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing $ seq
                  [ text "Foe gains ", weakness, text " on the save." ]
              ]
          }
      ]
  }
