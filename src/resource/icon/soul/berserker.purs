module ToA.Resource.Icon.Soul.Berserker
  ( berserker
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

berserker :: Soul
berserker = Soul
  { name: Name "Berserker"
  , colour: Name "Red"
  , class: Name "Stalwart"
  , description:
      [ Text "The soul of one fueled by a heart of rage."
      , Newline
      , Text
          """The terrifying power to fight on even when the body is
          broken and the blood is boiled away."""
      ]
  }
