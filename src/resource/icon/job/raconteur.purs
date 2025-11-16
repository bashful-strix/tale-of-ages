module ToA.Resource.Icon.Job.Raconteur
  ( raconteur
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

raconteur :: Job
raconteur = Job
  { name: Name "Raconteur"
  , colour: Name "Green"
  , soul: Name "Bard"
  , class: Name "Mendicant"
  , description:
      [ Text
          """Across the broad land of Arden Eld, no profession is more
          respected than storytelling, even if its practitioners range
          widely in their methods and audiences. From the churner camps,
          to the village longhall, to the tavern of the great cities,
          there are none who can dispute the power of gathering around a
          warm hearth, listening to a retelling of one of the old
          greats."""
      , Newline
      , Newline
      , Text
          """There are some in the profession, whether with instrument or
          with well tempered voice, whose skill with their craft is more
          than talent. Drawing on the aether in the wind, they can infuse
          their performances with flair - sound effects, or dancing
          shadows or light. This power is equally as effective at
          entertaining villagers and children as it is a potent tool for
          self defense - and humiliating the cruel and malicious."""
      ]
  , trait: Name "Ballad Master"
  , keyword: Name "Weave"
  , abilities:
      (I /\ Name "Withering Insult")
        : (I /\ Name "Pithy Retort")
        : (II /\ Name "Spirited Retort")
        : (IV /\ Name "Fantasia")
        : empty
  , limitBreak: Name "Amp Up"
  , talents:
      Name "Finale"
        : Name "Pity"
        : Name "Echo"
        : empty
  }
