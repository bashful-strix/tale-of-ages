module ToA.Data.Icon.Talent.Tactician
  ( mastermind
  , spur
  , fieldwork
  ) where

import Prelude

import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

mastermind :: Talent
mastermind = Talent
  { name: Name "Mastermind"
  , description:
      "Increase all pushes and pulls against bloodied "
        <> "characters by 1, or +2 if they are in _crisis_."
  }

spur :: Talent
spur = Talent
  { name: Name "Spur"
  , description:
      "Once a round, when an ally starts their turn in range 1-3, "
        <> "you man push or pull them 2 spaces, or 4 if they're "
        <> "in crisis."
  }

fieldwork :: Talent
fieldwork = Talent
  { name: Name "Fieldwork"
  , description:
      "Once a round, when you swap places with a character, "
        <> "either deal 2 damage to them or grant them 2 vigor. "
        <> "Double these effects if they're in crisis."
  }
