module ToA.Resource.Icon.Talent.Sealer
  ( surge
  , flash
  , ascension
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

surge :: Talent
surge = Talent
  { name: Name "Surge"
  , colour: Name "Green"
  , description:
      [ Text
          """At round 3+, increase all your burst effects by +1, and +1
          again at round 5+."""
      ]
  , subItem: Nothing
  }

flash :: Talent
flash = Talent
  { name: Name "Flash"
  , colour: Name "Green"
  , description:
      [ Text
          """After you hit an attack, you may teleport 1. If you excelled
          or better, you may teleport """
      , Dice 1 D3
      , Text "+1 spaces instead."
      ]
  , subItem: Nothing
  }

ascension :: Talent
ascension = Talent
  { name: Name "Ascension"
  , colour: Name "Green"
  , description:
      [ Text
          """When you check for range to teleport an ally, you can
          increase that range by +1 and you may teleport them +1 spaces
          further."""
      ]
  , subItem: Nothing
  }
