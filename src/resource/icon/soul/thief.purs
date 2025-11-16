module ToA.Resource.Icon.Soul.Thief
  ( thief
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

thief :: Soul
thief = Soul
  { name: Name "Thief"
  , colour: Name "Yellow"
  , class: Name "Vagabond"
  , description:
      [ Text "The soul of one that fights for the downtrodden."
      , Newline
      , Text
          """Kin cannot be free as long as they are crushed by the weight
          of gold."""
      ]
  }
