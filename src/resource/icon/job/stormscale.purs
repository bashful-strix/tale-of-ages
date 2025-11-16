module ToA.Resource.Icon.Job.Stormscale
  ( stormscale
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

stormscale :: Job
stormscale = Job
  { name: Name "Stormscale"
  , colour: Name "Yellow"
  , soul: Name "Ranger"
  , class: Name "Vagabond"
  , description:
      [ Text
          """The Stormscales are the ancient keepers and protectors of
          the island causeways, seaside caves, and underwater caverns
          traditionally reserved for sheltering the populace in times of
          crisis or catastrophic weather, crucial for survival on the
          islands. In disuse most of the seasons, these holy shrines
          require tending and defending from would-be plunderers and
          defilers."""
      , Newline
      , Newline
      , Text
          """Each wielder of this power is bestowed with a cape of
          shimmering power, woven from the hides of powerful ancient sea
          beasts, that they may use to shape-shift and swim deftly
          beneath the waves. The old gods of the storm and surf do not
          lightly bestow such gifts and often ask much of their wielders,
          who are often called away to some distant task on the land or
          in the deep sea, where some forget their human shape for long
          periods of time."""
      ]
  , trait: Name "Soul of the Sea"
  , keyword: Name "Phasing"
  , abilities:
      (I /\ Name "Lightning Claw")
        : (I /\ Name "Ride the Wave")
        : (II /\ Name "Spirit Sea")
        : (IV /\ Name "Sparking Storm")
        : empty
  , limitBreak: Name "Fury of the Deeps"
  , talents:
      Name "Wave"
        : Name "Swiftness"
        : Name "Thresh"
        : empty
  }
