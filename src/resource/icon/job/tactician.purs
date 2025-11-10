module ToA.Resource.Icon.Job.Tactician
  ( tactician
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

tactician :: Job
tactician = Job
  { name: Name "Tactician"
  , soul: Name "Knight"
  , class: Name "Stalwart"
  , description:
      [ Text
          """Veterans, advisors, and upstart geniuses, tacticians wield
          their understanding of battle like a well balanced blade.
          The hammering of metal on metal and cries of men and horses
          beat like a drum for them, an instrument that they have
          learned to play deftly and with keen precision. The few that
          become known by this moniker generally go on to become
          generals of incredible repute, and are well sought after by
          the city guilds."""
      , Newline
      , Newline
      , Text
          """They are a relatively new sight in Arden Eld, which has
          seen little need for warfare until the current era."""
      ]
  , trait: Name "Press the Fight"
  , keyword: Name "Crisis"
  , abilities:
      (I /\ Name "Pincer Attack")
        : (I /\ Name "Bait and Switch")
        : (II /\ Name "Hold the Center")
        : (IV /\ Name "Mighty Standard")
        : empty
  , limitBreak: Name "Mighty Command"
  , talents:
      Name "Mastermind"
        : Name "Spur"
        : Name "Fieldwork"
        : empty
  }
