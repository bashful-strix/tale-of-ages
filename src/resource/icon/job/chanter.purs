module ToA.Resource.Icon.Job.Chanter
  ( chanter
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

chanter :: Job
chanter = Job
  { name: Name "Chanter"
  , colour: Name "Green"
  , soul: Name "Bard"
  , class: Name "Mendicant"
  , description:
      [ Text
          """Descending from numerous holy orders that have their roots
          high in the chronicler monasteries, the Chanters are part
          singer, part storyteller, and part priest. At the time of the
          Doom, when all knowledge was deemed lost and everything put to
          page was transformed into ash, the only thing that persisted
          was the power of song, poetry, and the spirit of survival. A
          select order of priests committed all the great and necessary
          knowledge of Kin to memory, creating a single, continuous song,
          known as the Great Chant. In myths, stories, and histories,
          they recorded the knowledge of the ancients, transforming it
          into liturgy."""
      , Newline
      , Newline
      , Text
          """The Chant performed its role, and it was through its power
          that the early bands of Kin survived and persevered through the
          darkest days. Today, however, it is so archaic, convoluted, and
          long that many dispute the meaning of its dogma, though none
          can deny its value as a mythic text. The Old Church of the
          chroniclers has splintered into factions that mostly squabble
          over its meaning and try to draw some angle from its numerous
          and sometimes contradictory adaptions into holy texts.
          Nevertheless, the Chant still holds power - real, tangible
          power - to heal, mend, and uplift."""
      ]
  , trait: Name "Book of Ages"
  , keyword: Name "Conserve"
  , abilities:
      (I /\ Name "Holy")
        : (I /\ Name "Magnasancti")
        : (II /\ Name "Gentle Prayer")
        : (IV /\ Name "Esper")
        : empty
  , limitBreak: Name "Monogatari"
  , talents:
      Name "Poise"
        : Name "Elegance"
        : Name "Peace"
        : empty
  }
