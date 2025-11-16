module ToA.Resource.Icon.Job.Zephyr
  ( zephyr
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

zephyr :: Job
zephyr = Job
  { name: Name "Zephyr"
  , colour: Name "Green"
  , soul: Name "Bard"
  , class: Name "Mendicant"
  , description:
      [ Text
          """All the islands rely on the currents and breezes and listen
          to them like a respected grandmother. Traveling over the water,
          with its treacherous tidal shifts and frequent monster
          infestations, is fickle and dangerous, and requires patience.
          When more alacrity is required, the islands call on their
          resident Zephyr."""
      , Newline
      , Newline
      , Text
          """The Zephyrs are tight knight priesthood of messengers to
          which the wind is an old and familiar song. In quiet times,
          they tend to the flocks of messenger birds and maintain the
          (sometimes very mundane) aerial flow of letters, mail, and
          small goods between islands and the mainland. In more pressing
          times, they take to the skies, whether for emergency or battle,
          soaring with incredible speed and skill, no matter the weather.
          It is rumored that the oldest Zephyrs can whisper into the wind
          itself and have it heard miles away, but if they can, it is a
          secret art they do not divulge to land-bound outsiders."""
      ]
  , trait: Name "Fair Winds"
  , keyword: Name "Dominant"
  , abilities:
      (I /\ Name "Gust")
        : (I /\ Name "Cyclone")
        : (II /\ Name "Tempest Shot")
        : (IV /\ Name "Pandaemonium")
        : empty
  , limitBreak: Name "Grandmother Gale"
  , talents:
      Name "Stormborn"
        : Name "Alacrity"
        : Name "Squall"
        : empty
  }
