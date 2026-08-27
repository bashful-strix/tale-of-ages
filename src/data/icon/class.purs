module ToA.Data.Icon.Class
  ( class Classed
  , _class
  ) where

import Data.Lens (Lens')

import ToA.Data.Icon.Name (Name)

class Classed a where
  _class :: Lens' a Name
