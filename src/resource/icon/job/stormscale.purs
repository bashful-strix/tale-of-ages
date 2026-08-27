module ToA.Resource.Icon.Job.Stormscale
  ( stormscale
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

stormscale :: Icon
stormscale =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Stormscale"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--lightning-slashes]"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """The Stormscales are the ancient keepers and protectors of
                  the island causeways, seaside caves, and underwater caverns
                  traditionally reserved for sheltering the populace in times of
                  crisis or catastrophic weather, crucial for survival on the
                  islands. In disuse most of the seasons, these holy shrines
                  require tending and defending from would-be plunderers and
                  defilers."""
              , newline
              , newline
              , text
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
              Id "wave|talent|stormscale"
                : Id "swiftness|talent|stormscale"
                : Id "thresh|talent|stormscale"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Soul of the Sea"
          , description: seq
              [ text
                  """Once a round, after you move 3 or more spaces with an
                  ability, after that ability resolves, you may summon a surge
                  of supernatural water. You gain """
              , italic $ ref (Name "Phasing") $ text "phasing"
              , text
                  """ during the remainder of the movement, and shape shift
                  briefly after it resolves. Increase these effects (in
                  parentheses) if you moved 6 or more spaces.
                  """
              , list Unordered
                  [ seq
                      [ italic $ text "Storm Eel"
                      , text ": Fly 2, (then "
                      , italic $ ref (Name "Blind") $ text "blind"
                      , text " an adjacent foe)"
                      ]
                  , seq
                      [ italic $ text "Thresher Shark"
                      , text ": Gain "
                      , italic $ ref (Name "Haste") $ text "haste"
                      , text " (and gain "
                      , italic $ ref (Name "Stealth") $ text "stealth"
                      , text ")"
                      ]
                  , seq
                      [ italic $ text "Titan Seal"
                      , text
                          """: Push an adjacent foe 2 spaces (then deal 2 damage
                          to that foe)"""
                      ]
                  ]
              ]
          }
      ]
  , talents:
      [ Talent
          { id: Id "wave|talent|stormscale"
          , name: Name "Wave"
          , colour: Name "Yellow"
          , description: text
              """Once a round, when you pass through an ally's space, you may
              push them 2 or allow them to dash 2."""
          }
      , Talent
          { id: Id "swiftness|talent|stormscale"
          , name: Name "Swiftness"
          , colour: Name "Yellow"
          , description: seq
              [ text "Your free move is increased by +1 and gains "
              , italic $ ref (Name "Phasing") $ text "phasing"
              , text "."
              ]
          }
      , Talent
          { id: Id "thresh|talent|stormscale"
          , name: Name "Thresh"
          , colour: Name "Yellow"
          , description: seq
              [ text "Adjacent allies can spend your "
              , italic $ ref (Name "Evasion") $ text "evasion"
              , text ". If the evasion roll is a 6+, regain "
              , italic $ ref (Name "Evasion") $ text "evasion"
              , text " after it is spent this way."
              ]
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Fury of the Deeps"
          , colour: Name "Yellow"
          , description: text
              """Your form transforms, becoming rippling and sinuous, as you
              mantle the form of the most powerful apex predators of the deep
              ocean."""
          , cost: Quick /\ 3
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """For the rest of combat, you mantle the old gods of the
                      deeps, transforming into a titanic ocean creature
                      surrounded by surging water aether. You gain a greatly
                      enhanced dash, with the following benefits:"""
                  , list Unordered
                      [ seq
                          [ text "All your movement gains "
                          , italic $ ref (Name "Phasing") $ text "phasing"
                          , text "."
                          ]
                      , text "The basic dash ability becomes a quick ability."
                      , text "All dashes you gain or grant are increased by +2."
                      , seq
                          [ text
                              """Once a round, after you pass through a foe's
                              space or swap places with them, you can shred
                              them. They take """
                          , dice 2 D3
                          , text " damage and are pushed half as many spaces."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Lightning Claw"
          , colour: Name "Yellow"
          , description: text
              """You strike with the power of thunder, a fierce flash that can
              splinter the masts of ships."""
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Dash 4 with "
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text
                      """. Then attack one character you passed through,
                      regardless of range. Damage from this ability ignores
                      cover and line of sight."""
                  ]
              , AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , Step OnHit Nothing $ seq
                  [ text
                      """Then deal 2 damage again if your target is 3 or more
                      spaces away, or """
                  , dice 2 D3
                  , text
                      """ again if they are 6 or more. Double this damage if
                      they're in """
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Ride the Wave"
          , colour: Name "Yellow"
          , description: text
              """You share some of the power of your mantle, rapidly shifting
              yourself or an ally into an animal and back again."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , TargetTag Self
              , TargetTag Ally
              ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Self or an ally in range shape shifts into an animal
                      and dashes 3 or (5+) 6 spaces in a straight line with """
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text ", then gains "
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text
                      """. If they dash the maximum range possible, they also
                      gain """
                  , italic $ ref (Name "Evasion") $ text "evasion"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Spirit Sea"
          , colour: Name "Yellow"
          , description: text
              """You let a portion of the deep ocean manifest, a roiling black
              sea."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """Create a cross 1 roiling bubble of black water in free
                      space in range, with the following effects:"""
                  , list Unordered
                      [ seq
                          [ text "Yourself and allies have "
                          , italic $ ref (Name "Phasing") $ text "phasing"
                          , text " in the area."
                          ]
                      , seq
                          [ text "The center space is an "
                          , italic $ ref (Name "Obscured") $ text "obscured"
                          , text " space."
                          ]
                      , text
                          """Once a round, when a character of your choice
                          starts a voluntary movement is pushed or pulled in the
                          area, they are buffeted by a wave, and increase it by
                          +2."""
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Sparking Storm"
          , colour: Name "Yellow"
          , description: text
              """You call on the power of the old gods of the storm, bringing
              forth deep sea spirits in the shape of lightning."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D6)
                  ( text
                      """You summon one or (5+) two spirit sparks in range. The
                      sparks prime after your turn passes."""
                  )
                  $ SummonInset
                      { name: Name "Spirit Spark"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text
                                  """When you or an ally enter a primed spark's
                                  space, it is struck by a massive lightning
                                  bolt, dealing 2 damage to all adjacent foes,
                                  then pushing them 1. If you or your ally
                                  moved 3 or more spaces in a straight line
                                  without stopping before entering the spark,
                                  increase this damage by +2 and push by +1, or
                                  by +"""
                              , dice 2 D3
                              , text
                                  """ and push by +2 if they moved 6 or more
                                  spaces. Then dismiss the spark. Foes can only
                                  take this damage once a turn."""
                              ]
                          , Step SummonEff Nothing $ text
                              "Double this damage against foes in crisis."
                          ]
                      }
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Summon +2 more sparks."
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
