module ToA.Resource.Icon.Soul.Gunner
  ( gunner
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

gunner :: Soul
gunner = Soul
  { name: Name "Gunner"
  , colour: Name "Yellow"
  , class: Name "Vagabond"
  , description:
      [ Text "The soul of one ignited with flint and spark."
      , Newline
      , Text "The power of war is the power of change, after all."
      ]
  }
