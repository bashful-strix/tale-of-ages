module ToA.Resource.Icon.Soul.Witch
  ( witch
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

witch :: Soul
witch = Soul
  { name: Name "Witch"
  , colour: Name "Green"
  , class: Name "Mendicant"
  , description:
      [ Text "The soul of one bathed in moonlight."
      , Newline
      , Text
          """The moon is a harbinger of birth and death. Old growth must
          be cut away to make room for the new."""
      ]
  }
