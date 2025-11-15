module ToA.Resource.Icon.Soul.Warrior
  ( warrior
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

warrior :: Soul
warrior = Soul
  { name: Name "Warrior"
  , colour: Name "Red"
  , class: Name "Stalwart"
  , description:
      [ Text "The soul of one who seeks power at all ends."
      , Newline
      , Text
          """The will to cut down all before you with impossible
          strength, and the hand to carry it out."""
      ]
  }
