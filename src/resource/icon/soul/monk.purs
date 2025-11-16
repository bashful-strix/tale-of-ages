module ToA.Resource.Icon.Soul.Monk
  ( monk
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

monk :: Soul
monk = Soul
  { name: Name "Monk"
  , colour: Name "Green"
  , class: Name "Mendicant"
  , description:
      [ Text "The soul of one bound in iron discipline."
      , Newline
      , Text
          """The fortress without is brittle and hard. The fortress
          within is gentle and open, but loses none of its strength. Its
          gates may be closed at will."""
      ]
  }
