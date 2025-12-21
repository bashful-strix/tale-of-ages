module ToA.Resource.Icon.Talent.Stormscale
  ( wave
  , swiftness
  , thresh
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

wave :: Talent
wave = Talent
  { name: Name "Wave"
  , colour: Name "Yellow"
  , description:
      [ Text
          """Once a round, when you pass through an ally's space, you may
          push them 2 or allow them to dash 2."""
      ]
  , subItem: Nothing
  }

swiftness :: Talent
swiftness = Talent
  { name: Name "Swiftness"
  , colour: Name "Yellow"
  , description:
      [ Text "Your free move is increased by +1 and gains "
      , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
      , Text "."
      ]
  , subItem: Nothing
  }

thresh :: Talent
thresh = Talent
  { name: Name "Thresh"
  , colour: Name "Yellow"
  , description:
      [ Text "Adjacent allies can spend your "
      , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
      , Text ". If the evasion roll is a 6+, regain "
      , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
      , Text " after it is spent this way."
      ]
  , subItem: Nothing
  }
