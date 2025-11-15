module ToA.Resource.Icon.Job.Spellblade
  ( spellblade
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

spellblade :: Job
spellblade = Job
  { name: Name "Spellblade"
  , colour: Name "Blue"
  , soul: Name "Bolt"
  , class: Name "Wright"
  , description:
      [ Text
          """Spellblades are a martial order of highly trained wrights.
          Many of them come from the Guild Academies in the great cities
          of Arden Eld, where they often take prestigious posts in the
          local militias and city watch. Other wrights tend to view
          Spellblades as stiff, unfeeling military types, but Spellblades
          themselves know they are consummate professionals and
          unparalleled masters of their art."""
      , Newline
      , Newline
      , Text
          """The lightning aether that the Spellblades wield is highly
          volatile, and requires intense training and focus to control.
          Once a Spellblade has learned their craft, however, the speed,
          power, and precision at which they can act is intoxicating,
          crossing greats spans of space in an instant, riding the
          Aetherial currents with a flash of gleaming steel."""
      ]
  , trait: Name "Klingenkunst"
  , keyword: Name "Isolate"
  , abilities:
      (I /\ Name "Gungnir")
        : (I /\ Name "Ätherwand")
        : (II /\ Name "Odinforce")
        : (IV /\ Name "Nothung")
        : empty
  , limitBreak: Name "Gran Levincross"
  , talents:
      Name "Vex"
        : Name "Fence"
        : Name "Bladework"
        : empty
  }
