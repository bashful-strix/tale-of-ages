module ToA.Resource.Icon.Talent.Tactician
  ( mastermind
  , spur
  , fieldwork
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

mastermind :: Talent
mastermind = Talent
  { name: Name "Mastermind"
  , description:
      [ Text
          """Increase all pushes and pulls against bloodied
          characters by 1, or +2 if they are in """
      , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
      , Text "."
      ]
  }

spur :: Talent
spur = Talent
  { name: Name "Spur"
  , description:
      [ Text
          """Once a round, when an ally starts their turn in range 1-3,
          you may push or pull them 2 spaces, or 4 if they're in """
      , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
      , Text "."
      ]
  }

fieldwork :: Talent
fieldwork = Talent
  { name: Name "Fieldwork"
  , description:
      [ Text
          """Once a round, when you swap places with a character,
          either deal 2 damage to them or grant them 2 vigor. Double
          these effects if they're in """
      , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
      , Text "."
      ]
  }
