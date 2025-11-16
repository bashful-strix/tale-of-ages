module ToA.Resource.Icon.Job.Harvester
  ( harvester
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

harvester :: Job
harvester = Job
  { name: Name "Harvester"
  , colour: Name "Green"
  , soul: Name "Witch"
  , class: Name "Mendicant"
  , description:
      [ Text
          """Servants of Tsumi, the Moon Titan, the Harvesters are the
          death priests of Arden Eld. They travel from land to land,
          sanctifying burial sites, performing funeral rites, and helping
          lingering spirits move on. The land is full of the malice and
          unfulfilled wishes of the long suffering dead, and so the
          services of the Harvesters are in high demand."""
      , Newline
      , Newline
      , Text
          """Tsumi is the protector of cycles, and so the Harvesters also
          perform fertility blessings, oversee harvest festivals, and see
          to the cultivation and protection of the land and nature. They
          plant flowers over battlefields, and tend groves of beautiful
          fruit trees planted over graveyards. This dual nature makes
          Harvesters fierce warriors, able to make the battle bloom or
          rot with a single swipe of their greatscythes."""
      ]
  , trait: Name "Booming Death"
  , keyword: Name "Finishing Blow"
  , abilities:
      (I /\ Name "Reap")
        : (I /\ Name "Sanguine Thicket")
        : (II /\ Name "Hulk")
        : (IV /\ Name "Walking Dead")
        : empty
  , limitBreak: Name "Death Sentence"
  , talents:
      Name "Cycle"
        : Name "Necromancer"
        : Name "Sanguinity"
        : empty
  }
