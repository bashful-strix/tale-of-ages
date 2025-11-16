module ToA.Resource.Icon.Soul.Ranger
  ( ranger
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

ranger :: Soul
ranger = Soul
  { name: Name "Ranger"
  , colour: Name "Yellow"
  , class: Name "Vagabond"
  , description:
      [ Text
          """The soul of one that fights to protect the Green and
          channels its fury."""
      , Newline
      , Text
          """The forests do not care of the ways of kin. They will be
          here long after we pass from this world."""
      ]
  }
