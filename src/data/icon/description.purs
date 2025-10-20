module ToA.Data.Icon.Description
  ( class Described
  , getDesc
  , setDesc
  , _desc
  ) where

import Data.Lens (Lens', lens)

class Described a where
  getDesc :: a -> String
  setDesc :: a -> String -> a

_desc :: ∀ a. Described a => Lens' a String
_desc = lens getDesc setDesc
