module ToA.Resource.Icon.Job.Enochian
  ( enochian
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

enochian :: Job
enochian = Job
  { name: Name "Enochian"
  , colour: Name "Blue"
  , soul: Name "Flame"
  , class: Name "Wright"
  , description:
      [ Text
          """The Enochian Orders of pyromancers are the most chaotic of
          the wright orders. Though sometimes associated with Chuners,
          they have no official organization, most of their members being
          hedge wizards or self taught. Many Enochians disdain authority
          and work for hire, sleeping and eating where they can and
          relying on the communities they work for to support them. Those
          that work on contract with guilds, armies, or mercenary
          companies tend to value their independence."""
      , Newline
      , Newline
      , Text
          """The power that condenses inside an Enochian is related to
          the element of fire, a wild spark that grows and wanes with
          their emotions and energy, but with control can be focused into
          power that can carve mountains, scorch forests, and boil
          rivers. In times of desperation, the Enochians can feed this
          power with their own life force, a dangerous practice that the
          other orders of wrights look down upon. The Enochians, for
          their part, see other wrights as stiff and uncreative. They’d
          rather do it their way, after all."""
      ]
  , trait: Name "Inner Furnace"
  , keyword: Name "Reckless"
  , abilities:
      (I /\ Name "Pyro")
        : (I /\ Name "Ignite")
        : (II /\ Name "Implode")
        : (IV /\ Name "Blackstar")
        : empty
  , limitBreak: Name "Gigaflare"
  , talents:
      Name "Megiddo"
        : Name "Melt"
        : Name "Phoenix"
        : empty
  }
