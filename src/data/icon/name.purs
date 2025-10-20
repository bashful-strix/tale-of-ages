module ToA.Data.Icon.Name
  ( Name(..)
  ) where

import Prelude

newtype Name = Name String

derive newtype instance Eq Name
