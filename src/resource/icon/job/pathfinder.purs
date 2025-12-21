module ToA.Resource.Icon.Job.Pathfinder
  ( pathfinder
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

pathfinder :: Icon
pathfinder =
  { classes: []
  , colours: []
  , souls: []
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
                : (I /\ Name "Swit Shots")
                : (II /\ Name "Hunting Eagle")
                : (IV /\ Name "Steady Aim")
                : empty
          , limitBreak: Name "Heavenly Rain"
          , talents:
              Name "Footholds"
                : Name "Horizon"
                : Name "Vantage"
                : empty
          }
      ]
  , traits: []
  , talents: []
  , abilities: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
