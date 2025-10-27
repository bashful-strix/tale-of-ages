module ToA.Data.Icon.Dice
  ( Die(..)
  ) where

import Prelude

data Die
  = D3
  | D6
  | D10

instance Show Die where
  show D3 = "d3"
  show D6 = "d6"
  show D10 = "d10"
