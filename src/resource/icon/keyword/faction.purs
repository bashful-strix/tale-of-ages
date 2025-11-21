module ToA.Resource.Icon.Keyword.Faction
  ( horde
  , enrage
  , ferocity
  ) where

import ToA.Data.Icon.Keyword (Keyword(..), Category(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

horde :: Keyword
horde = Keyword
  { name: Name "Horde"
  , category: General
  , description:
      [ Text
          """This ability becomes more powerful when 2 or more allies are
          adjacent to the target."""
      ]
  }

enrage :: Keyword
enrage = Keyword
  { name: Name "Enrage"
  , category: General
  , description:
      [ Text "When in crisis, take 1/2 damage from all sources." ]
  }

ferocity :: Keyword
ferocity = Keyword
  { name: Name "Ferocity"
  , category: General
  , description:
      [ Text
          "Triggers additional effects while this character is bloodied."
      ]
  }
