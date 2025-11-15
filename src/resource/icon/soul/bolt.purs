module ToA.Resource.Icon.Soul.Bolt
  ( bolt
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

bolt :: Soul
bolt = Soul
  { name: Name "Bolt"
  , colour: Name "Blue"
  , class: Name "Wright"
  , description:
      [ Text "The soul of one riding the flash and the thunderclap."
      , Newline
      , Text
          """The air nourishes in brightness and movement, an eternal
          dance. Living things must be unmoored for them to flourish and
          be free."""
      ]
  }
