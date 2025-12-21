module ToA.Resource.Icon.Job.Mistwalker
  ( mistwalker
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

mistwalker :: Icon
mistwalker =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Mistwalker"
          , colour: Name "Blue"
          , soul: Name "Water"
          , class: Name "Wright"
          , description:
              [ Text
                  """Spies and informants of the highest caliber, trained at
                  secretive guild academies. Mistwalkers use the suffused water
                  Aether in their own bodies to evaporate and re-appear where
                  they will, and use the water in other’s bodies to jerk them
                  around like puppet. They can meld into the low lying fog
                  around the rooftops, or by the riverbanks at morning, always
                  listening and watching."""
              , Newline
              , Newline
              , Text
                  """At their best, members of this order act as a secretive
                  vigilante force, striking from the fog in service of the
                  dispossessed or desperate. At their worst, they act as secret
                  police for guild barons, their name whispered in hushed tones
                  and writ in furtive glances."""
              ]
          , trait: Name "Lurker in the Fog"
          , keyword: Name "Phasing"
          , abilities:
              (I /\ Name "Steal Breath")
                : (I /\ Name "Evaporate")
                : (II /\ Name "Writhing Wall")
                : (IV /\ Name "Withering Tendrils")
                : empty
          , limitBreak: Name "Vapor Form"
          , talents:
              Name "Foundations"
                : Name "Vanish"
                : Name "Thirst"
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
