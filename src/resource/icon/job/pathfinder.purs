module ToA.Resource.Icon.Job.Pathfinder
  ( pathfinder
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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
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
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Highly skilled scouts and wayfinders that keep the paths
                  between the mountain Chamber monasteries clear of obstacles,
                  monsters, and banditry. They are exceptionally skilled with
                  great bows and long rifles, able to make breathtaking shots in
                  the mountain wind and cold air. Typically working along for
                  many months, they are a solitary lot, but value company and
                  keep many small comforts with them on their long journeys
                  between the monasteries, such as sweets, books, or coffee."""
              ]
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
              Name "Footholds"
                : Name "Horizon"
                : Name "Vantage (Pathfinder)"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Clear Skies"
          , description:
              [ Text
                  """Your abilities gain +2 max range and increase all line
                  effects by +2 for every positive level of elevation above 0
                  (max bonus +6)."""
              , Newline
              , Text
                  """If you attack a target at 4 or more spaces away from you,
                  you ignore cover."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Footholds"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You ignore up to 3 levels of movement penalties for moving
                  up elevation."""
              ]
          }
      , Talent
          { name: Name "Horizon"
          , colour: Name "Yellow"
          , description:
              [ Text
                  "Your attacks against characters at range 4-6 gain: attack "
              , Power
              , Text ". At range 7+, they also deal damage "
              , Power
              , Text "."
              ]
          }
      , Talent
          { name: Name "Vantage (Pathfinder)"
          , colour: Name "Yellow"
          , description:
              [ Text "You gain attack "
              , Power
              , Power
              , Text " instead of attack "
              , Power
              , Text " when attacking a target on a lower elevation."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Heavenly Rain"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """In the cold mountain air, many a villain has met their end
                  from a flurry of bolts from the blue."""
              ]
          , cost: Two /\ 4
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """You draw and release a massive blast of projectiles.
                      Choose a range from 2-8. All characters at """
                  , Italic [ Text "exactly" ]
                  , Text
                      """ that range and in line of sight from you are struck by
                      an intense barrage and take 4 damage (4+) and again (6+)
                      and again. This damage ignores cover."""
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing
                  [ Text
                      """Increase each instance of damage by +2 if the chosen
                      range was at 4+. Increase each by +4 instead if the chosen
                      range was at range 7+."""
                  ]
              ]
          }
      , Ability
          { name: Name "Spiral Shot"
          , colour: Name "Yellow"
          , description:
              [ Text "Your shot picks up momentum the longer it flies." ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ Step Eff Nothing [ Text "Fly 1." ]
              , Step Eff Nothing
                  [ Text "Must attack the first foe in the line." ]
              , AttackStep [ Text "3 damage"] [ Text "+", Dice 1 D3 ]
              , Step (KeywordStep (Name "Precision")) Nothing
                  [ Text "Deals +"
                  , Dice 1 D3
                  , Text " damage on hit. Increase to +"
                  , Dice 2 D3
                  , Text " at 7+ spaces."
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing
                  [ Text "All remaining characters in the line take 3 damage."
                  ]
              ]
          }
      , Ability
          { name: Name "Swift Shots"
          , colour: Name "Yellow"
          , description:
              [ Text "Your deft hands make quick work of multiple foes." ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 3) (NumVar 6))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) (Just D6)
                  [ Text
                      """Mark your foe. While your foe is marked, they take 2
                      damage once or (5+) twice after you attack any """
                  , Italic [ Text "other" ]
                  , Text
                      """ foe, ignoring cover. If your marked foe is defeated,
                      you may transfer this mark to a new foe in range as a """
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text
                      """ ability on your turn. This mark is only removed when a
                      foe is defeated or when it is moved."""
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing
                  [ Text "Increase damage to "
                  , Dice 1 D3
                  , Text "+1. If at range 7+, increase damage to "
                  , Dice 1 D3
                  , Text "+3."
                  ]
              ]
          }
      , Ability
          { name: Name "Hunting Eagle"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """A soaring leap, used to fight and traverse the chasms in
                  the high mountain passes."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Italic [ Ref (Name "Fly") [ Text "Fly" ] ]
                  , Text
                      """ 1, then fly 1. In between, you may use another
                      ability. That ability counts as being one or (5+) two
                      spaces higher than your current level of elevation."""
                  ]
              ]
          }
      , Ability
          { name: Name "Steady Aim"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Your breath doesn't leave your body until the bullet leaves
                  the barrel or the arrow escapes the string."""
              ]
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing
                  [ Bold [ Text "End your turn." ]
                  , Text
                      """ Your next attack with a listed range or line gains
                      attack """
                  , Power
                  , Text ", +3 max range, and +3 max line."
                  ]
              , Step (KeywordStep (Name "Precision")) Nothing
                  [ Text "The attack also gains: "
                  , Italic [ Text "On hit" ]
                  , Text ": +2 damage and push 1, increased to +"
                  , Dice 2 D3
                  , Text " and push 2 at range 7+."
                  ]
              ]
          }
      ]
  }
