module ToA.Data.Icon.Description
  ( class Described
  , getDesc
  , setDesc
  , _desc
  ) where

import Data.Lens (Lens', lens)

class Described a b where
  getDesc :: a -> b
  setDesc :: a -> b -> a

_desc :: ∀ a b. Described a b => Lens' a b
_desc = lens getDesc setDesc
