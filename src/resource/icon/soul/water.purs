module ToA.Resource.Icon.Soul.Water
  ( water
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

water :: Soul
water = Soul
  { name: Name "Water"
  , colour: Name "Blue"
  , class: Name "Wright"
  , description:
      [ Text "The soul of one swaying with the wave and current."
      , Newline
      , Text
          """The movement of the tides can wear away even solid rock. All
          living things came from the sea, and will return to it in
          time."""
      ]
  }
