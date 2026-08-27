module ToA.Resource.Icon.Class.Vagabond
  ( vagabond
  ) where

import Prelude

import Color (fromInt)

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
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
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
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Class (Class(..))
import ToA.Data.Icon.Pc.Soul (Soul(..))

vagabond :: Icon
vagabond =
  { classes:
      [ Class
          { name: Name "Vagabond"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--crossed-sabres]"
          , tagline: text "Cunning Wanderer"
          , strengths: text
              """High mobility and damage, strong summons and marks, and strong
              against isolated foes."""
          , weaknesses: text "Relatively low durability, relies on support."
          , complexity: text "Medium"
          , description: text
              """Vagabonds are the mercenaries and master scouts of Arden Eld.
              They know how to aim a crossbow bolt through the visor of a knight
              or the weak spot of a monster, how to move quietly and quickly,
              and how to fling a knife with deadly precision. They are very
              mobile compared to other jobs and are able to get where they need
              to go faster than most, using their follow up abilities to beat
              down injured or isolated foes."""
          , hp: 32
          , defense: 6
          , move: 4
          , trait: Name "Skirmisher"
          , basic: Name "Wind's Kiss"
          , keywords:
              [ Name "Blind"
              , Name "Evasion"
              , Name "Haste"
              , Name "Mark"
              , Name "Stealth"
              , Name "Summon"
              ]
          , apprentice:
              [ Name "Track"
              , Name "Quick Step"
              , Name "Flash Powder"
              , Name "Gouge"
              , Name "Smoke Bomb"
              , Name "Death Trap"
              ]
          }
      ]
  , colours:
      [ Colour { name: Name "Yellow", value: fromInt 0xd08700 }
      ] -- yellow-600
  , souls:
      [ Soul
          { name: Name "Shadow"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--cloak-dagger]"
          , class: Name "Vagabond"
          , description: seq
              [ text "The soul of one at home in the darkness."
              , newline
              , text
                  """The darkness is a warm mother that holds many mysteries,
                    and can hide many weapons."""
              ]
          }
      , Soul
          { name: Name "Gunner"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--crossed-pistols]"
          , class: Name "Vagabond"
          , description: seq
              [ text "The soul of one ignited with flint and spark."
              , newline
              , text "The power of war is the power of change, after all."
              ]
          }
      , Soul
          { name: Name "Thief"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--daggers]"
          , class: Name "Vagabond"
          , description: seq
              [ text "The soul of one that fights for the downtrodden."
              , newline
              , text
                  """Kin cannot be free as long as they are crushed by the
                  weight of gold."""
              ]
          }
      , Soul
          { name: Name "Ranger"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--falling-leaf]"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """The soul of one that fights to protect the Green and
                  channels its fury."""
              , newline
              , text
                  """The forests do not care of the ways of kin. They will be
                  here long after we pass from this world."""
              ]
          }
      ]
  , jobs: []
  , traits:
      [ Trait
          { name: Name "Skirmisher"
          , description: seq
              [ text
                  """You are an agile fighter, able to dodge and weave around
                  the battlefield with skill and precision. You gain the
                  following benefits:"""
              , newline
              , list Unordered
                  [ text "You can move diagonally"
                  , text
                      """Once a round, when you make a single move, dash, fly,
                      or teleport, you may extend it by +3"""
                  , text
                      """You reduce all damage from missed attacks and
                      successful saves to 1"""
                  ]
              ]
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Wind's Kiss"
          , colour: Name "Yellow"
          , description: text "A flash of blades."
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step Eff Nothing $ text "Dash 1."
              , AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step OnHit Nothing $ seq
                  [ text "Gain "
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text "."
                  ]
              , Step Eff Nothing $ text "Dash 1."
              ]
          }
      , Ability
          { name: Name "Track"
          , colour: Name "Yellow"
          , description: text "Pick your quarry carefully."
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text "Mark your foe."
                  , list Unordered
                      [ seq
                          [ text "While marked, your attacks gain attack "
                          , power
                          , text
                              """ against them and they cannot gain cover from
                              you."""
                          ]
                      , text
                          """If they are bloodied, these bonuses apply to all
                          your allies as well."""
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Quick Step"
          , colour: Name "Yellow"
          , description: text "You move with surprising agility and speed."
          , cost: Quick
          , tags: []
          , steps:
              [ Step Eff (Just D3) $ seq
                  [ text "Dash "
                  , italic $ dice 1 D3
                  , text " spaces. You can "
                  , italic $ ref (Name "Phase") $ text "phase"
                  , text " through foes during this movement."
                  ]
              ]
          }
      , Ability
          { name: Name "Flash Powder"
          , colour: Name "Yellow"
          , description: text "Throw sparking powder that confounds the eyes."
          , cost: One
          , tags: [ RangeTag Melee, AreaTag (Burst (NumVar 1) true) ]
          , steps:
              [ Step AreaEff (Just D6) $ seq
                  [ text "One, (4+) two or (6+) all foes in the area are "
                  , italic $ ref (Name "Blind") $ text "blinded"
                  , text "."
                  ]
              , Step Eff Nothing $ text "Then teleport 3."
              ]
          }
      , Ability
          { name: Name "Gouge"
          , colour: Name "Yellow"
          , description: text
              """You unleash multiple slashes, shot or stabs against your foe,
              hitting weak spots."""
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ text "Dash 1."
              , AttackStep (text "3 damage") (seq [ text "+", dice 3 D3 ])
              , Step OnHit Nothing $ seq
                  [ text "If your foe is "
                  , italic $ ref (Name "Bloodied") $ text "bloodied"
                  , text
                      """, strike your target again, dealing 3 damage. If your
                      foe is in """
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text ", deal 3 damage twice instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Smoke Bomb"
          , colour: Name "Yellow"
          , description: text "Prepare for the worst."
          , cost: One
          , tags: [ TargetTag Self, End ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ bold $ text "End your turn."
                  , text " Create an "
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text " space under you (4+) and gain "
                  , italic $ ref (Name "Stealth") $ text "stealth"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Death Trap"
          , colour: Name "Yellow"
          , description: text
              """You place a carefully crafted trap: flechette bomb, shard net,
              razor wire - the possibilities are endless."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D6)
                  ( text
                      """Summon one or (5+) two death traps in a free space in
                      range. Traps arm at the end of your turn."""
                  )
                  $ SummonInset
                      { name: Name "Death Trap"
                      , colour: Name "Yellow"
                      , max: 1
                      , abilities:
                          [ Step SummonEff Nothing $ text
                              """Mark out a cross 1 area centered on the trap
                              when it arms. When a foe starts their turn in the
                              area, or voluntarily enters the area, it explodes
                              for an area effect, dismissing it. Characters
                              inside must save or take 4 damage, twice, or just
                              once on a successful save."""
                          ]
                      }
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
