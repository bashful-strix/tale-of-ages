module ToA.Data.Icon.Description
  ( class Described
  , _desc
  ) where

import Data.Lens (Lens')

import ToA.Data.Icon.Markup (Markup)

class Described a where
  _desc :: Lens' a Markup
