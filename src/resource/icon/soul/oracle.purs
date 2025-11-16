module ToA.Resource.Icon.Soul.Oracle
  ( oracle
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

oracle :: Soul
oracle = Soul
  { name: Name "Oracle"
  , colour: Name "Green"
  , class: Name "Mendicant"
  , description:
      [ Text "The soul of one who reads the stars as their guide."
      , Newline
      , Text
          """Though the stars are distant, their bright and fiery trails
          form a sparkling map of the heavens."""
      ]
  }
