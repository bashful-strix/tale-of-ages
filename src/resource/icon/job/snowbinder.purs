module ToA.Resource.Icon.Job.Snowbinder
  ( snowbinder
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

snowbinder :: Icon
snowbinder =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Snowbinder"
          , colour: Name "Blue"
          , soul: Name "Water"
          , class: Name "Wright"
          , description:
              [ Text
                  """Guides, leaders, and folk mages of the far northern lands,
                  where the land is blanketed with a thick layer of snow most of
                  the year. These distant lands have retained many of their old
                  ways, and were never truly conquered by the Arken. Even in
                  times of deep summer, they are covered in a thick layer of
                  frost that confounds the weaponry, soldiery, and war machines
                  of would-be conquerors."""
              , Newline
              , Newline
              , Text
                  """To their inhabitants, these lands are a demanding but
                  comforting home. The Snowbinders are an honored caste that
                  keep the roads clear, the storms from biting too much, and
                  create warm refuges for settlements. To travelers and
                  visitors, the hospitality of the northern lands is legendary.
                  To invaders, it offers only a bone-biting chill."""
              ]
          , trait: Name "Icy Gust"
          , keyword: Name "Conserve"
          , abilities:
              (I /\ Name "Rime")
                : (I /\ Name "Freeze Solid")
                : (II /\ Name "Sleet Slide")
                : (IV /\ Name "Snow Siege")
                : empty
          , limitBreak: Name "Great Blizzion"
          , talents:
              Name "Crystalline"
                : Name "Spin"
                : Name "Slide"
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
