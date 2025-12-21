module ToA.Resource.Icon.Job.Chronomancer
  ( chronomancer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

chronomancer :: Icon
chronomancer =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Chronomancer"
          , colour: Name "Green"
          , soul: Name "Oracle"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Of those that tinker with fundamental forces in the great
                  Guild academies, the Chronomancers are perhaps the most
                  feared. Their quarry is mastery over the flow of time, a dread
                  goal sought by many masters of the mortal world. At great
                  lengths, and with tremendous machinery, the chronomancers
                  examine every strand of Aether to determine the power of its
                  ebb and flow."""
              , Newline
              , Newline
              , Text
                  """In theory, chronomancy is a terrifying power. In practice,
                  chronomancy is an extremely ill-understood corner of the
                  Aetheric arts with very difficult conditions for its practice.
                  Even those that consider itself masters of its practice can
                  only manage the reversal or acceleration of time for a few
                  moments at a time."""
              ]
          , trait: Name "Chronal Echo"
          , keyword: Name "Overdrive"
          , abilities:
              (I /\ Name "Chronoripple")
                : (I /\ Name "The Chariot")
                : (II /\ Name "Sisyphus")
                : (IV /\ Name "Chronotemper")
                : empty
          , limitBreak: Name "Rewind"
          , talents:
              Name "Stutter"
                : Name "Chronodouble"
                : Name "Tick"
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
