module ToA.Resource.Icon.Job.Slayer
  ( slayer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

slayer :: Icon
slayer =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Slayer"
          , colour: Name "Red"
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Warriors of impossible strength and insane bravado, Slayers
                  are warriors that specialize in fighting the largest and most
                  dangerous monsters to crawl out of the pits that riddle the
                  land. They relish in fighting against impossible odds,
                  training themselves in forbidden techniques, arcane arts, and
                  oversized weaponry that normal Kin would quake at wielding.
                  They organize themselves into loose orders and train and hunt
                  together, sharing tales and trophies of the colossal horrors
                  they have slain. Some say in order to fight their quarries,
                  the Slayers must ingest monster blood to gain their strength,
                  giving them dark and forbidden power that makes other Kin fear
                  and respect them in equal measure."""
              ]
          , trait: Name "Hot Blooded"
          , keyword: Name "Heavy"
          , abilities:
              (I /\ Name "Demon Splitter")
                : (I /\ Name "Barge")
                : (II /\ Name "Bravado")
                : (IV /\ Name "Jotunn Crusher")
                : empty
          , limitBreak: Name "God Waster"
          , talents:
              Name "Bulk"
                : Name "Hale"
                : Name "Deflect"
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
