module ToA.Resource.Icon.Job.Seer
  ( seer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

seer :: Job
seer = Job
  { name: Name "Seer"
  , colour: Name "Green"
  , soul: Name "Oracle"
  , class: Name "Mendicant"
  , description:
      [ Text
          """The Seers are made up of all the orders of stargazers,
          corner prophets, folk healers, shamans, and all manner of
          individuals that find themselves attracted to reading the Great
          Arcana, the esoteric practice of reading destiny itself, the
          Great Wheel of Arden Eld that determines the final fate of all
          things. Usually found tucked away in the corners of Leggio
          caravans, in high city spires, or in the back of smoky taverns,
          their services are usually in high demand, though only the
          especially skilled can truly read the Arcana and there are many
          pretenders that muddy the waters."""
      , Newline
      , Newline
      , Text
          """Through ritual, ceremony, and unrelenting practice, Seers
          gain the ability to predict and even defy a person’s fate,
          using their Aether infused card decks to influence the turning
          of the Great Wheel and empower their allies with foresight,
          precision, and uncanny accuracy."""
      ]
  , trait: Name "The Wheel"
  , keyword: Name "Gambit"
  , abilities:
      (I /\ Name "King of Swords")
        : (I /\ Name "The Emperor")
        : (II /\ Name "Wild Card")
        : (IV /\ Name "The Ewer")
        : empty
  , limitBreak: Name "High Prophecy"
  , talents:
      Name "Prophet"
        : Name "Foresight"
        : Name "Harbor"
        : empty
  }
