module ToA.Resource.Icon.Class.Vagabond
  ( vagabond
  ) where

import Prelude

import Color (fromInt)

import Data.Maybe (Maybe(..))

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
  , Variable(..)
  )
import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))
import ToA.Data.Icon.Trait (Trait(..))

vagabond :: Icon
vagabond =
  { classes:
      [ Class
          { name: Name "Vagabond"
          , colour: Name "Yellow"
          , tagline: [ Text "Cunning Wanderer" ]
          , strengths:
              [ Text
                  """High mobility and damage, strong summons and marks, and
                    strong against isolated foes."""
              ]
          , weaknesses:
              [ Text "Relatively low durability, relies on support." ]
          , complexity: [ Text "Medium" ]
          , description:
              [ Text
                  """Vagabonds are the mercanaries and master scouts of Arden
                    Eld. They know how to aim a crossbow bolt through the visor
                    of a knight or the weak spot of a monster, how to move
                    quietly and quickly, and how to fling a knife with deadly
                    precision. They are very mobile compared to other jobs and
                    are able to get where they need to go faster than most,
                    using their follow up abilities to beat down injured or
                    isolated foes."""
              ]
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
          , class: Name "Vagabond"
          , description:
              [ Text "The soul of one at home in the darkness."
              , Newline
              , Text
                  """The darkness is a warm mother that holds many mysteries,
                    and can hide many weapons."""
              ]
          }
      , Soul
          { name: Name "Gunner"
          , colour: Name "Yellow"
          , class: Name "Vagabond"
          , description:
              [ Text "The soul of one ignited with flint and spark."
              , Newline
              , Text "The power of war is the power of change, after all."
              ]
          }
      , Soul
          { name: Name "Thief"
          , colour: Name "Yellow"
          , class: Name "Vagabond"
          , description:
              [ Text "The soul of one that fights for the downtrodden."
              , Newline
              , Text
                  """Kin cannot be free as long as they are crushed by the
                  weight of gold."""
              ]
          }
      , Soul
          { name: Name "Ranger"
          , colour: Name "Yellow"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """The soul of one that fights to protect the Green and
                  channels its fury."""
              , Newline
              , Text
                  """The forests do not care of the ways of kin. They will be
                  here long after we pass from this world."""
              ]
          }
      ]
  , jobs: []
  , traits:
      [ Trait
          { name: Name "Skirmisher"
          , description:
              [ Text
                  """You are an agile fighter, able to dodge and weave around
                  the battlefield with skill and precision. You gain the
                  following benefits:"""
              , Newline
              , List Unordered
                  [ [ Text "You can move diagonally" ]
                  , [ Text
                        """Once a round, when you make a single move, dash, fly,
                        or teleport, you may extend it by +3"""
                    ]
                  , [ Text
                        """You reduce all damage from missed attacks and
                        successful saves to 1"""
                    ]
                  ]
              ]
          , subItem: Nothing
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Wind's Kiss"
          , colour: Name "Yellow"
          , description: [ Text "A flash of blades." ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step Nothing $ Eff [ Text "Dash 1." ]
              , Step Nothing $ AttackStep
                  [ Text "2 damage" ]
                  [ Text "+", Dice 1 D6 ]
              , Step Nothing $ OnHit
                  [ Text "Gain "
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text "."
                  ]
              , Step Nothing $ Eff [ Text "Dash 1." ]
              ]
          }
      , Ability
          { name: Name "Track"
          , colour: Name "Yellow"
          , description: [ Text "Pick your quarry carefully." ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Mark")
                  [ Text "Mark your foe."
                  , List Unordered
                      [ [ Text "While marked, your attacks gain attack "
                        , Power
                        , Text
                            " against them and they cannot gain cover from you."
                        ]
                      , [ Text
                            """If they are bloodied, these bonuses apply to all
                            your allies as well."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Quick Step"
          , colour: Name "Yellow"
          , description: [ Text "You move with surprising agility and speed." ]
          , cost: Quick
          , tags: []
          , steps:
              [ Step (Just D3) $ Eff
                  [ Text "Dash "
                  , Italic [ Dice 1 D3 ]
                  , Text " spaces. You can "
                  , Italic [ Ref (Name "Phase") [ Text "phase" ] ]
                  , Text " through foes during this movement."
                  ]
              ]
          }
      , Ability
          { name: Name "Flash Powder"
          , colour: Name "Yellow"
          , description:
              [ Text "Throw sparking powder that confounds the eyes." ]
          , cost: One
          , tags: [ RangeTag Melee, AreaTag (Burst (NumVar 1) true) ]
          , steps:
              [ Step (Just D6) $ AreaEff
                  [ Text "One, (4+) two or (6+) all foes in the area are "
                  , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                  , Text "."
                  ]
              , Step Nothing $ Eff [ Text "Then teleport 3." ]
              ]
          }
      , Ability
          { name: Name "Gouge"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You unleash multiple slashes, shot or stabs against your
                  foe, hitting weak spots."""
              ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Nothing $ Eff [ Text "Dash 1." ]
              , Step Nothing $ AttackStep
                  [ Text "3 damage" ]
                  [ Text "+", Dice 3 D3 ]
              , Step Nothing $ OnHit
                  [ Text "If your foe is "
                  , Italic [ Ref (Name "Bloodied") [ Text "bloodied" ] ]
                  , Text
                      """, strike your target again, dealing 3 damage. If your
                      foe is in """
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text ", deal 3 damage twice instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Smoke Bomb"
          , colour: Name "Yellow"
          , description: [ Text "Prepare for the worst." ]
          , cost: One
          , tags: [ TargetTag Self, End ]
          , steps:
              [ Step (Just D6) $ Eff
                  [ Bold [ Text "End your turn." ]
                  , Text " Create an "
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text " space under you (4+) and gain "
                  , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Death Trap"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You place a carefully crafted trap: flechette bomb, shard
                  net, razor wire - the possibilities are endless."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ SubStep (Just D6)
                  ( SummonItem
                      { name: Name "Death Trap"
                      , colour: Name "Yellow"
                      , max: 1
                      , actions: []
                      , effects:
                          [ [ Text
                                """Mark out a cross 1 area centered on the trap
                                when it arms. When a foe starts their turn in
                                the area, or voluntarily enters the area, it
                                explodes for an area effect, dismissing it.
                                Characters inside must save or take 4 damage,
                                twice, or just once on a successful save."""
                            ]
                          ]
                      }
                  )
                  $ KeywordStep
                      (Name "Summon")
                      [ Text
                          """Summon one or (5+) two death traps in a free space
                          in range. Traps arm at the end of your turn."""
                      ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
