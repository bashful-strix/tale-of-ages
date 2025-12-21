module ToA.Resource.Icon.Job.Dragoon
  ( dragoon
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

dragoon :: Icon
dragoon =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Dragoon"
          , colour: Name "Yellow"
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Aces of the guild battalions, Dragoons are masters of heavy
                  gunnery and explosives, dabbling in fiery concoctions,
                  powders, and fuses far past the point of safety or even self
                  preservation. While most of the city guilds are still working
                  their way around the musket and the sabre, Dragoons have
                  already hammered their way through soot, shrapnel, and
                  innumerable accidents into a more impressive fare: long barrel
                  rifling, multi-barrel mini-guns, explosive bullets filled with
                  liquid wyrm fire, the works. So creative and hazardous is
                  their craft that their invention has yet to pass on to the
                  wider world in reproducible form, perhaps for the better."""
              ]
          , trait: Name "Sparking Munition"
          , keyword: Name "Reckless"
          , abilities:
              (I /\ Name "Frag Shot")
                : (I /\ Name "Blast Jump")
                : (II /\ Name "Friend Maker")
                : (IV /\ Name "Maniac")
                : empty
          , limitBreak: Name "Mageza Cannon"
          , talents:
              Name "Reach"
                : Name "Breather"
                : Name "Volatile"
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
