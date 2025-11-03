module ToA.Resource.Icon.Soul.Knight
  ( knight
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

knight :: Soul
knight = Soul
  { name: Name "Knight"
  , class: Name "Stalwart"
  , description:
      [ Text
          """The soul of one affected by strife and embedded with
          steel. An unbending, iron will, and the power to lead from
          the front."""
      ]
  }
