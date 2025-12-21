module ToA.Resource.Icon.Job.Yaman
  ( yaman
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

yaman :: Icon
yaman =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Yaman"
          , colour: Name "Green"
          , soul: Name "Monk"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Eccentric mountain hermits, the Yaman are supremely skilled
                  martial artists sought after by many from the lowlands, who
                  spend long years struggling to pry some wisdom or skill from
                  their grasp, often to no avail. The yaman draw their strength
                  from their isolation, the frigid mountain air, and their
                  (quite literal) closeness to heaven, or so they say."""
              , Newline
              , Newline
              , Text
                  """The Yaman have their origins in an order of wardens tasked
                  with protecting the great Chronicler bells, used for warning
                  and long distance communication. The few temples, meagre
                  cliffside shrines, or rocky cairns that they occupy tend to be
                  the hosts to these bells, which are treated with intense
                  reverence. A Yaman must have the strength of body, if
                  necessary, to carry the massive bronze bell itself long
                  distances, and therefore nearly all of them are the product of
                  unbelievably rigorous training regimens."""
              ]
          , trait: Name "Master's Touch"
          , keyword: Name "Impact"
          , abilities:
              (I /\ Name "Roppo")
                : (I /\ Name "Forceful Instruction")
                : (II /\ Name "Master's Eye")
                : (IV /\ Name "Peak Performance")
                : empty
          , limitBreak: Name "Great Temple Bell"
          , talents:
              Name "Victory"
                : Name "Shift"
                : Name "Sway"
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
