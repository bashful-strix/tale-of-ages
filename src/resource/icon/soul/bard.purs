module ToA.Resource.Icon.Soul.Bard
  ( bard
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

bard :: Soul
bard = Soul
  { name: Name "Bard"
  , colour: Name "Green"
  , class: Name "Mendicant"
  , description:
      [ Text "The soul of one abrim with legend and song."
      , Newline
      , Text
          """After all we have done, someone will carry the fire forward.
          They shall see it burning."""
      ]
  }
