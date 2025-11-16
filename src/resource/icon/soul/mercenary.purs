module ToA.Resource.Icon.Soul.Mercenary
  ( mercenary
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

mercenary :: Soul
mercenary = Soul
  { name: Name "Mercenary"
  , colour: Name "Red"
  , class: Name "Stalwart"
  , description:
      [ Text "The soul of one tempered by suffering and avarice."
      , Newline
      , Text
          """The strength to fight on your own terms, to grasp your own
          fate through the thorns that pierce you."""
      ]
  }
