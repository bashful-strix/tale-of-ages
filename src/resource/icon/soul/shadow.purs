module ToA.Resource.Icon.Soul.Shadow
  ( shadow
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

shadow :: Soul
shadow = Soul
  { name: Name "Shadow"
  , colour: Name "Yellow"
  , class: Name "Vagabond"
  , description:
      [ Text "The soul of one at home in the darkness."
      , Newline
      , Text
          """The darkness is a warm mother that holds many mysteries, and
          can hide many weapons."""
      ]
  }
