module ToA.Resource.Icon.Job.Pathfinder
  ( pathfinder
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
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (bold, dice, italic, newline, power, ref, seq, text)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

pathfinder :: Icon
pathfinder =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Pathfinder"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--crosshair-arrow]"
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description: text
              """Highly skilled scouts and wayfinders that keep the paths
              between the mountain Chamber monasteries clear of obstacles,
              monsters, and banditry. They are exceptionally skilled with great
              bows and long rifles, able to make breathtaking shots in the
              mountain wind and cold air. Typically working alone for many
              months, they are a solitary lot, but value company and keep many
              small comforts with them on their long journeys between the
              monasteries, such as sweets, books, or coffee."""
          , trait: Name "Clear Skies"
          , keyword: Name "Precision"
          , abilities:
              (I /\ Name "Spiral Shot")
                : (I /\ Name "Swift Shots")
                : (II /\ Name "Hunting Eagle")
                : (IV /\ Name "Steady Aim")
                : empty
          , limitBreak: Name "Heavenly Rain"
          , talents:
              Id "footholds|talent|pathfinder"
                : Id "horizon|talent|pathfinder"
                : Id "vantage|talent|pathfinder"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Clear Skies"
          , description: seq
              [ text
                  """Your abilities gain +2 max range and increase all line
                  effects by +2 for every positive level of elevation above 0
                  (max bonus +6)."""
              , newline
              , text
                  """If you attack a target at 4 or more spaces away from you,
                  you ignore cover."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "footholds|talent|pathfinder"
          , name: Name "Footholds"
          , colour: Name "Yellow"
          , description: text
              """You ignore up to 3 levels of movement penalties for moving up
              elevation."""
          }
      , Talent
          { id: Id "horizon|talent|pathfinder"
          , name: Name "Horizon"
          , colour: Name "Yellow"
          , description: seq
              [ text
                  "Your attacks against characters at range 4-6 gain: attack "
              , power
              , text ". At range 7+, they also deal damage "
              , power
              , text "."
              ]
          }
      , Talent
          { id: Id "vantage|talent|pathfinder"
          , name: Name "Vantage"
          , colour: Name "Yellow"
          , description: seq
              [ text "You gain attack "
              , power
              , power
              , text " instead of attack "
              , power
              , text " when attacking a target on a lower elevation."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Heavenly Rain"
          , colour: Name "Yellow"
          , description: text
              """In the cold mountain air, many a villain has met their end from
              a flurry of bolts from the blue."""
          , cost: Two /\ 4
          , tags: []
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """You draw and release a massive blast of projectiles.
                      Choose a range from 2-8. All characters at """
                  , italic $ text "exactly"
                  , text
                      """ that range and in line of sight from you are struck by
                      an intense barrage and take 4 damage (4+) and again (6+)
                      and again. This damage ignores cover."""
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing $ text
                  """Increase each instance of damage by +2 if the chosen range
                  was at 4+. Increase each by +4 instead if the chosen range was
                  at range 7+."""
              ]
          }
      , Ability
          { name: Name "Spiral Shot"
          , colour: Name "Yellow"
          , description: text "Your shot picks up momentum the longer it flies."
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ Step Eff Nothing $ text "Fly 1."
              , Step Eff Nothing $ text "Must attack the first foe in the line."
              , AttackStep (text "3 damage") $ seq [ text "+", dice 1 D3 ]
              , Step (KeywordStep (Name "Precision")) Nothing $ seq
                  [ text "Deals +"
                  , dice 1 D3
                  , text " damage on hit. Increase to +"
                  , dice 2 D3
                  , text " at 7+ spaces."
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing $ text
                  "All remaining characters in the line take 3 damage."
              ]
          }
      , Ability
          { name: Name "Swift Shots"
          , colour: Name "Yellow"
          , description: text
              "Your deft hands make quick work of multiple foes."
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 3) (NumVar 6))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) (Just D6) $ seq
                  [ text
                      """Mark your foe. While your foe is marked, they take 2
                      damage once or (5+) twice after you attack any """
                  , italic $ text "other"
                  , text
                      """ foe, ignoring cover. If your marked foe is defeated,
                      you may transfer this mark to a new foe in range as a """
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text
                      """ ability on your turn. This mark is only removed when a
                      foe is defeated or when it is moved."""
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing $ seq
                  [ text "Increase damage to "
                  , dice 1 D3
                  , text "+1. If at range 7+, increase damage to "
                  , dice 1 D3
                  , text "+3."
                  ]
              ]
          }
      , Ability
          { name: Name "Hunting Eagle"
          , colour: Name "Yellow"
          , description: text
              """A soaring leap, used to fight and traverse the chasms in the
              high mountain passes."""
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ italic $ ref (Name "Fly") $ text "Fly"
                  , text
                      """ 1, then fly 1. In between, you may use another
                      ability. That ability counts as being one or (5+) two
                      spaces higher than your current level of elevation."""
                  ]
              ]
          }
      , Ability
          { name: Name "Steady Aim"
          , colour: Name "Yellow"
          , description: text
              """Your breath doesn't leave your body until the bullet leaves the
              barrel or the arrow escapes the string."""
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ bold $ text "End your turn."
                  , text
                      """ Your next attack with a listed range or line gains
                      attack """
                  , power
                  , text ", +3 max range, and +3 max line."
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing $ seq
                  [ text "The attack also gains: "
                  , italic $ text "On hit"
                  , text ": +2 damage and push 1, increased to +"
                  , dice 2 D3
                  , text " and push 2 at range 7+."
                  ]
              ]
          }
      ]
  }
