module ToA.Data.Icon.LimitBreak.Tactician
  ( mightyCommand
  ) where

import Prelude

import ToA.Data.Icon.Ability (Ability(..))
import ToA.Data.Icon.LimitBreak (LimitBreak(..))
import ToA.Data.Icon.Name (Name(..))

mightyCommand :: LimitBreak
mightyCommand = LimitBreak 2 (Ability $ Name "Mighty Command")
