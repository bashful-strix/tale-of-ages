module ToA.Resource.Icon.Job.Rake
  ( rake
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

rake :: Job
rake = Job
  { name: Name "Rake"
  , colour: Name "Yellow"
  , soul: Name "Thief"
  , class: Name "Vagabond"
  , description:
      [ Text
          """Master thieves and deal-makers of the city backwaters and
          churner camps. In such a vibrant and dangerous locale, it is as
          important to cultivate an impressive reputation as it is to
          gain skill with a blade. Dressing to fit the part and having
          the coin and swagger to match is critical for survival,
          therefore the most (in)famous Rakes are frequent participants
          in the camp and city nightlife. Those that traffic in this
          profession accumulate over time a supernatural skill with luck,
          often attributed to their tributes to the multicolored titan of
          chance."""
      , Newline
      , Newline
      , Text
          """The core tenets of most churner thieves guilds are clear: do
          it for the love of the game. Take from those that don’t deserve
          it and can suffer the loss, and skim a little on the side for
          your old mum (whether she’s alive or not). It’s only fair."""
      ]
  , trait: Name "Wild Gamble"
  , keyword: Name "Gambit"
  , abilities:
      (I /\ Name "Lucky 8")
        : (I /\ Name "Bump and Lift")
        : (II /\ Name "Trick")
        : (IV /\ Name "Chaos Roulette")
        : empty
  , limitBreak: Name "Hot Streak"
  , talents:
      Name "Streak"
        : Name "Roller"
        : Name "Whirl"
        : empty
  }
