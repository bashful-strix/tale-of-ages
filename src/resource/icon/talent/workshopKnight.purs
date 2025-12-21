module ToA.Resource.Icon.Talent.WorkshopKnight
  ( alloy
  , endure
  , bolster
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

alloy :: Talent
alloy = Talent
  { name: Name "Alloy"
  , colour: Name "Red"
  , description:
      [ Text "You improve the effect of "
      , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
      , Text " to +3 defense for yourself and adjacent allies. You gain "
      , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
      , Text " when you are first bloodied in a combat."
      ]
  , subItem: Nothing
  }

endure :: Talent
endure = Talent
  { name: Name "Endure"
  , colour: Name "Red"
  , description:
      [ Text "If you don't attack during your turn, gain "
      , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
      , Text ". At round 3+, also gain 2 "
      , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
      , Text "."
      ]
  , subItem: Nothing
  }

bolster :: Talent
bolster = Talent
  { name: Name "Bolster"
  , colour: Name "Red"
  , description:
      [ Text
          """Once a round, then you swap places with an ally, they may
          clear a negative status. If they have no negative statuses,
          they gain """
      , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
      , Text "."
      ]
  , subItem: Nothing
  }
