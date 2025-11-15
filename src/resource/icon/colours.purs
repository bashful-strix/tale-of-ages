module ToA.Resource.Icon.Colours
  ( colours
  ) where

import Color (fromInt)

import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Name (Name(..))

colours :: Array Colour
colours =
  [ Colour { name: Name "Red", value: fromInt 0xe7000b } -- red-600
  , Colour { name: Name "Yellow", value: fromInt 0xd08700 } -- yellow-600
  , Colour { name: Name "Green", value: fromInt 0x5ea500 } -- lime-600
  , Colour { name: Name "Blue", value: fromInt 0x155dfc } -- blue-600
  ]
