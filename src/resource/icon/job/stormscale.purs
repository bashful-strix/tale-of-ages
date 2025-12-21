module ToA.Resource.Icon.Job.Stormscale
  ( stormscale
  ) where

import Prelude

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
  , SubItem(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

stormscale :: Icon
stormscale =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Stormscale"
          , colour: Name "Yellow"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """The Stormscales are the ancient keepers and protectors of
                  the island causeways, seaside caves, and underwater caverns
                  traditionally reserved for sheltering the populace in times of
                  crisis or catastrophic weather, crucial for survival on the
                  islands. In disuse most of the seasons, these holy shrines
                  require tending and defending from would-be plunderers and
                  defilers."""
              , Newline
              , Newline
              , Text
                  """Each wielder of this power is bestowed with a cape of
                  shimmering power, woven from the hides of powerful ancient sea
                  beasts, that they may use to shape-shift and swim deftly
                  beneath the waves. The old gods of the storm and surf do not
                  lightly bestow such gifts and often ask much of their
                  wielders, who are often called away to some distant task on
                  the land or in the deep sea, where some forget their human
                  shape for long periods of time."""
              ]
          , trait: Name "Soul of the Sea"
          , keyword: Name "Phasing"
          , abilities:
              (I /\ Name "Lightning Claw")
                : (I /\ Name "Ride the Wave")
                : (II /\ Name "Spirit Sea")
                : (IV /\ Name "Sparking Storm")
                : empty
          , limitBreak: Name "Fury of the Deeps"
          , talents:
              Name "Wave"
                : Name "Swiftness"
                : Name "Thresh"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Soul of the Sea"
          , description:
              [ Text
                  """Once a round, after you move 3 or more spaces with an
                  ability, after that ability resolves, you may summon a surge
                  of supernatural water. You gain """
              , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
              , Text
                  """ during the remainder of the movement, and shape shift
                  briefly after it resolves. Increase these effects (in
                  parentheses) if you moved 6 or more spaces.
                  """
              , List Unordered
                  [ [ Italic [ Text "Storm Eel" ]
                    , Text ": Fly 2, (then "
                    , Italic [ Ref (Name "Blind") [ Text "blind" ] ]
                    , Text " an adjacent foe)"
                    ]
                  , [ Italic [ Text "Thresher Shark" ]
                    , Text ": Gain "
                    , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                    , Text " (and gain "
                    , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                    , Text ")"
                    ]
                  , [ Italic [ Text "Titan Seal" ]
                    , Text
                        """: Push an adjacent foe 2 spaces (then deal 2 damage
                        to that foe)"""
                    ]
                  ]
              ]
          , subItem: Nothing
          }
      ]
  , talents:
      [ Talent
          { name: Name "Wave"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a round, when you pass through an ally's space, you
                  may push them 2 or allow them to dash 2."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Swiftness"
          , colour: Name "Yellow"
          , description:
              [ Text "Your free move is increased by +1 and gains "
              , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Thresh"
          , colour: Name "Yellow"
          , description:
              [ Text "Adjacent allies can spend your "
              , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
              , Text ". If the evasion roll is a 6+, regain "
              , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
              , Text " after it is spent this way."
              ]
          , subItem: Nothing
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Fury of the Deeps"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Your form transforms, becoming rippling and sinuous, as you
                  mantle the form of the most powerful apex predators of the
                  deep ocean."""
              ]
          , cost: Quick /\ 2
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Nothing $ Eff
                  [ Text
                      """For the rest of combat, you mantle the old gods of the
                      deeps, transforming into a titanic ocean creature
                      surrounded by surging water aether. Tou gain a greatly
                      enhanced dash, with the following benefits:"""
                  , List Unordered
                      [ [ Text "All your movement gains "
                        , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                        , Text "."
                        ]
                      , [ Text "The basic dash ability becomes a quick ability."
                        ]
                      , [ Text
                            "All dashes you gain or grant are increased by +2."
                        ]
                      , [ Text
                            """Once a round, after you pass through a foe's
                            space or swap places with them, you can shred them.
                            They take """
                        , Dice 2 D3
                        , Text " damage and are pushed half as many spaces."
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Lightning Claw"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You strike with the power of thunder, a fierce flash that
                  can splinter the masts of ships."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Nothing $ Eff
                  [ Text "Dash 4 with "
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text
                      """. Then attack one character you passed through,
                      regardless of range. Damage from this ability ignores
                      cover and line of sight."""
                  ]
              , Step Nothing $ AttackStep
                  [ Text "2 damage" ]
                  [ Text "+", Dice 1 D3 ]
              , Step Nothing $ OnHit
                  [ Text
                      """Then deal 2 damage again if your target is 3 or more
                      spaces away, or """
                  , Dice 2 D3
                  , Text
                      """ again if they are 6 or more. Double this damage if
                      they're in """
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Ride the Wave"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You share some of the power of your mantle, rapidly
                  shifting yourself or an ally into an animal and back again."""
              ]
          , cost: One
          , tags: [ RangeTag (Range 1 2), TargetTag Self, TargetTag Ally ]
          , steps:
              [ Step (Just D6) $ Eff
                  [ Text
                      """Self or an ally in range shape shifts into an animal
                      and dashes 3 or (5+) 6 spaces in a straight line with """
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text ", then gains "
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text
                      """. If they dash the maximum range possible, they also
                      gain """
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Spirit Sea"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You let a portion of the deep ocean manifest, a roiling
                  black sea."""
              ]
          , cost: One
          , tags: [ RangeTag (Range 1 2), AreaTag (Cross 1) ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Zone")
                  [ Text
                      """Create a cross 1 roiling bubble of black water in free
                      space in range, with the following effects:"""
                  , List Unordered
                      [ [ Text "Yourself and allies have "
                        , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                        , Text " in the area."
                        ]
                      , [ Text "The center space is an "
                        , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                        , Text " space."
                        ]
                      , [ Text
                            """Once a round, when a character of your choice
                            starts a voluntary movement is pushed or pulled in
                            the area, they are buffeted by a wave, and increase
                            it by +2."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Sparking Storm"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You call on the power of the old gods of the storm,
                  bringing forth deep sea spirits in the shape of lightning."""
              ]
          , cost: One
          , tags: [ KeywordTag (Name "Mark"), RangeTag (Range 1 2) ]
          , steps:
              [ SubStep (Just D6)
                  ( SummonItem
                      { name: Name "Spirit Spark"
                      , colour: Name "Yellow"
                      , max: 4
                      , actions: []
                      , effects:
                          [ [ Text
                                """When you or an ally enter a primed spark's
                                space, it is struck by a massive lightning bolt,
                                dealing 2 damage to all adjacent foes, then
                                pushing them 1. If you or your ally moved 3 or
                                more spaces in a straight line without stopping
                                before entering the spark, increased this damage
                                by +2 and push by +1, or by +"""
                            , Dice 2 D3
                            , Text
                                """ and push by +2 if they moved 6 or more
                                spaces. Then dismiss the spark. Foes can only
                                take this damage once a turn."""
                            ]
                          , [ Text "Double this damage against foes in crisis."
                            ]
                          ]
                      }
                  )
                  $ KeywordStep (Name "Summon")
                      [ Text
                          """You summon one or (5+) two spirit sparks in range.
                          The sparks prime after your turn passes."""
                      ]
              , Step Nothing $ KeywordStep (Name "Heavy")
                  [ Text "Summon +2 more sparks." ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
