module ToA.Resource.Icon.Job.FairyWright
  ( fairyWright
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

fairyWright :: Icon
fairyWright =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Fairy Wright"
          , colour: Name "Green"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Trafficking with hobs and other forest spirits is an
                  incredibly fraught business. The nature gods do not see time
                  and season the same as kin. They move with the breeze and the
                  bough, the slow turn of changing leaves, the raging storm and
                  the gentle rain, the hot breezes of summer and the singing of
                  the cicadas. What may seem fixed and reliable to kin is
                  effervescent and changing to the denizens of the deep forest,
                  and a small slight or oversight as little as dipping a toe in
                  the wrong pool may instead be taken as a deep injury."""
              , Newline
              , Newline
              , Text
                  """Nevertheless, the villages of the Green rely on the
                  blessings of the Aesi and the hobs for good harvest, weather,
                  and fortune. Some honor them through the old priesthood,
                  others by accidents of faery-blessed birth, and yet others
                  through long stints surviving in the wilds. Maintaining these
                  relationships is a matter of patience, respect, and a little
                  old fashioned trickery."""
              ]
          , trait: Name "Fae Charm"
          , keyword: Name "Arua"
          , abilities:
              (I /\ Name "Summer's Blaze")
                : (I /\ Name "Spring's Bounty")
                : (II /\ Name "Autumn's Rain")
                : (IV /\ Name "Winter's Grip")
                : empty
          , limitBreak: Name "Eternal Renewal"
          , talents:
              Name "Mulch"
                : Name "Recycle"
                : Name "Incant"
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
