module ToA.Resource.Icon.Talent.Chanter
  ( poise
  , elegance
  , peace
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

poise :: Talent
poise = Talent
  { name: Name "Poise"
  , colour: Name "Green"
  , description:
      [ Text
          """At the start of combat, you may enter a stance that costs 1
          action or less as a quick action, or reduce the cost of a stance
          that costs 2 actions this turn to 1 action. If you do, you
          cannot attack that turn."""
      ]
  , subItem: Nothing
  }

elegance :: Talent
elegance = Talent
  { name: Name "Elegance"
  , colour: Name "Green"
  , description:
      [ Text
          """When you enter a stance for the first time in a round, you
          may fly 3."""
      ]
  , subItem: Nothing
  }

peace :: Talent
peace = Talent
  { name: Name "Peace"
  , colour: Name "Green"
  , description:
      [ Text
          """You take half damage in the first round of combat. This
          effect breaks if you attack."""
      ]
  , subItem: Nothing
  }
