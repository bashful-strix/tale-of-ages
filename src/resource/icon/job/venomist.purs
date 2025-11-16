module ToA.Resource.Icon.Job.Venomist
  ( venomist
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

venomist :: Job
venomist = Job
  { name: Name "Venomist"
  , colour: Name "Yellow"
  , soul: Name "Shadow"
  , class: Name "Vagabond"
  , description:
      [ Text
          """Night-walkers, shadow-steppers, and masters of secret venom
          arts, the Venomists are spies, scouts, and assassins of
          unparalleled skill. Joining their order is presumed to be
          extremely difficult, but they tend to open their ranks to
          anyone that has been lost or abandoned. Their number forms a
          secret and deadly society of Vermin Clans spread across Arden
          Eld, each practicing and refining the Night Venom Techniques.
          They are known for hunting and drawing out poisons from the
          deadliest creatures in Arden Eld, which which they coat their
          weapons and even ingest to build up immunity and practice toxic
          enlightenment. As poison can fell anything, whether lord or
          beast, it is a great leveler."""
      ]
  , trait: Name "Shadow Venom"
  , keyword: Name "Afflicted"
  , abilities:
      (I /\ Name "Venom Lash")
        : (I /\ Name "Fume Slice")
        : (II /\ Name "Centipede Dash")
        : (IV /\ Name "Choking Cloud")
        : empty
  , limitBreak: Name "Abyssal Ecstacy"
  , talents:
      Name "Taste"
        : Name "Slither"
        : Name "Pressure"
        : empty
  }
