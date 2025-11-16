module ToA.Resource.Icon.Soul.Flame
  ( flame
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

flame :: Soul
flame = Soul
  { name: Name "Flame"
  , colour: Name "Blue"
  , class: Name "Wright"
  , description:
      [ Text "The soul of one aflame with ambition."
      , Newline
      , Text
          """Through fire, the wheel of the world ignites, hurtling
          onwards. All things must transmute, or perish."""
      ]
  }
