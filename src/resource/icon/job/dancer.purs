module ToA.Resource.Icon.Job.Dancer
  ( dancer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

dancer :: Job
dancer = Job
  { name: Name "Dancer"
  , colour: Name "Yellow"
  , soul: Name "Thief"
  , class: Name "Vagabond"
  , description:
      [ Text
          """Ritual sword dancers of the villages, a quasi-priesthood
          that has survived from ancient times. Whenever there is a major
          shrine found somewhere in the Green, there was assuredly a
          Dancer tasked to protect it and perform the proper ceremonies
          to satisfy the local spirits."""
      , Newline
      , Newline
      , Text
          """Nowadays, true Dancers are few and far between. Dancing was 
          a way to commune with the gods and transmit the wishes, dreams,
          and hopes of the common people. With their departure and death,
          it is now a way to commune with their essences or spirits, a
          far more trying and risky venture. Though they still serve the
          common people, Dancers can now only be found where the crimson
          lilies bloom and boundaries between life and death are
          blurred."""
      ]
  , trait: Name "Masterful Step"
  , keyword: Name "Weave"
  , abilities:
      (I /\ Name "Six Veils")
        : (I /\ Name "Danse Macabre")
        : (II /\ Name "Tumble")
        : (IV /\ Name "Crimson Blossoms")
        : empty
  , limitBreak: Name "Dance of the Crimson Lily"
  , talents:
      Name "Flow"
        : Name "Perfection"
        : Name "Untouchable"
        : empty
  }
