module ToA.Resource.Icon.Job.Blightrunner
  ( blightrunner
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

blightrunner :: Icon
blightrunner =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Blightrunner"
          , colour: Name "Yellow"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Few souls are brave or foolhardy enough to brave the blight
                  lands alone. The Blightrunners make a career out of it.
                  Couriers for churner camps, caravans, and city bigwigs, they
                  are ardent trekkers and survivalists, who thrive on the thrill
                  of outrunning foes too monstrous to describe. The paths of the
                  runners are recorded and kept in a great hide skin journal,
                  updated at their meeting every five years, and updated to
                  match current accounts - part of the only reason the
                  blightlands are traversable by ordinary kin at all."""
              , Newline
              , Newline
              , Text
                  """Especially brave runners will make it their duty to forge
                  new and long pathways through toxic and inhospitable lands
                  teeming with monsters - daring each other to match the
                  impossibility of their travels."""
              ]
          , trait: Name "Adrenaline"
          , keyword: Name "Overdrive"
          , abilities:
              (I /\ Name "Baton Pass")
                : (I /\ Name "Toxic Spike")
                : (II /\ Name "Zipline")
                : (IV /\ Name "Viper String")
                : empty
          , limitBreak: Name "Burning Sands"
          , talents:
              Name "Twitch"
                : Name "Pulse"
                : Name "Turbo"
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
