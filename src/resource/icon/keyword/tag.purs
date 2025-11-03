module ToA.Resource.Icon.Keyword.Tag
  ( immobile
  , push
  , stance
  , unstoppable
  , zone
  ) where

import ToA.Data.Icon.Keyword (Keyword(..), Category(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

immobile :: Keyword
immobile = Keyword
  { name: Name "Immobile"
  , category: Tag
  , description: [ Text "Can't voluntarily move" ]
  }

push :: Keyword
push = Keyword
  { name: Name "Push"
  , category: Tag
  , description: [ Text "Move a character X spaces away from you" ]
  }

stance :: Keyword
stance = Keyword
  { name: Name "Stance"
  , category: Tag
  , description:
      [ Text
          """A powerful ongoing effect. You can only maintain one
          stance at a time. You may exit any stance vonuntarily at the
          start of your turn."""
      ]
  }

unstoppable :: Keyword
unstoppable = Keyword
  { name: Name "Unstoppable"
  , category: Tag
  , description:
      [ Text
          """Can't be forcibly moved. Immune to the effects of all
          negative statuses. Movement cannot be reduced or stopped
          for any reason."""
      ]
  }

zone :: Keyword
zone = Keyword
  { name: Name "Zone"
  , category: Tag
  , description:
      [ Text
          """Changes or affects an area of the battlefield, causing
          persistent effects. Unless specified, placing a new zone
          replaces the last one placed. Zones from self or allies
          cannot overlap each other. You can dismiss a zone as a
          quick ability."""
      ]
  }
