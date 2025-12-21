module ToA.Resource.Icon.Job.Warden
  ( warden
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

warden :: Icon
warden =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Warden"
          , colour: Name "Yellow"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """The Wardens are the protectors and keepers of the Deep
                  Green, the old and untamed parts of Arden Eld, lorded over by
                  the beasts and the ancient trees. They are both the keepers
                  and the servants of the herd and root, tending to their
                  health, and culling them when it becomes necessary. They sleep
                  under the stars and make their home under bough and root,
                  making staunch allies of the ferocious beasts of the deep
                  wilds through a combination of rigorous training and mutual
                  respect."""
              , Newline
              , Newline
              , Text
                  """Wardens are the keepers of the green kenning, the old
                  ranger arts, that allow one to travel noiselessly, hide in
                  plain sight, live off the land, and become immune to even the
                  most deadly of toxins. Their fierce defense of the wild
                  sometimes puts them at odds with civilization, which they tend
                  to have a distaste for."""
              ]
          , trait: Name "Beast Companion"
          , keyword: Name "Heavy"
          , abilities:
              (I /\ Name "Apex")
                : (I /\ Name "Gwynt")
                : (II /\ Name "Oak Splitter")
                : (IV /\ Name "Strength of the Pack")
                : empty
          , limitBreak: Name "Stampede"
          , talents:
              Name "Boost"
                : Name "Hunters"
                : Name "Corner"
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
