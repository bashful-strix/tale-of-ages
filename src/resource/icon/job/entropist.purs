module ToA.Resource.Icon.Job.Entropist
  ( entropist
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

entropist :: Icon
entropist =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Entropist"
          , colour: Name "Blue"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description:
              [ Text
                  """Lightning Aether is a connective force, bringing all matter
                  together. The Arken manipulated this force to create
                  technological marvels - bridges that hung in the air, gates of
                  light, or communication networks that could send signals over
                  long distances. Among the Arken, however, there were those
                  that studied this force obsessively, concluding ultimately
                  that it could be strengthened to incredible levels or even
                  reversed. It was this use of lightning aether that led to the
                  most fiendish weapons in the late stages of their empire -
                  weapons capable of obliterating cities, tearing apart matter,
                  and slaying gods. The studies of these heretic
                  scholar-priests, written on cuneiform scroll-cylinders, were
                  sealed in one of the great Chambers and forbidden by Kin,
                  deemed too dangerous and too destructive."""
              , Newline
              , Newline
              , Text
                  """That chamber was burst open by a legendary but very foolish
                  thief-lord. Ignorant of its contents, is liberator spilled
                  them unfettered into the world, where they were sifted and
                  split apart by a select few. Now, that knowledge has its
                  students."""
              ]
          , trait: Name "Unmooring"
          , keyword: Name "Afflicted"
          , abilities:
              (I /\ Name "Magnabolt")
                : (I /\ Name "Magnetism")
                : (II /\ Name "Stop")
                : (IV /\ Name "Disintegrate")
                : empty
          , limitBreak: Name "Howling Viod"
          , talents:
              Name "Energize"
                : Name "Halt"
                : Name "Align"
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
