module ToA.Resource.Icon.Job.Theurgist
  ( theurgist
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

theurgist :: Job
theurgist = Job
  { name: Name "Theurgist"
  , colour: Name "Blue"
  , soul: Name "Flame"
  , class: Name "Wright"
  , description:
      [ Text
          """Sometimes called soulblades or inquisitors, Theurgists are
          powerful and widely feared chronicler church mages from an
          esoteric order that sturdy flame aether’s powerful connection
          to the soul itself, forging it into a terrifying art that
          allows them to call scorching beams or wreathe their weapons in
          soul fire. They are relatively rare and tend have a poor
          reputation as fanatics and meddlers, given people’s wariness of
          manipulation of the soul."""
      , Newline
      , Newline
      , Text
          """Theurgists are rumored to have the power to see through lies
          through minor fluctuations in the soul’s Aether and are often
          employed as interrogators or bounty hunters by would-be rulers.
          In practice they are perhaps unfairly maligned, as when they
          are not doing battle, their unparalleled ability to diagnose
          afflictions of the soul’s Aether allows them to lift curses,
          corruptions, and illusions."""
      ]
  , trait: Name "Blazing Blade"
  , keyword: Name "Sacrifice"
  , abilities:
      (I /\ Name "Soul Cleave")
        : (I /\ Name "Soul Burn")
        : (II /\ Name "Blazing Bond")
        : (IV /\ Name "Fierce Crucible")
        : empty
  , limitBreak: Name "Transmigration of Fire"
  , talents:
      Name "Zeal"
        : Name "Bloodwell"
        : Name "Ardor"
        : empty
  }
