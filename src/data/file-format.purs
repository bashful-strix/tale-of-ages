module ToA.Data.FileFormat
  ( FileFormat(..)
  ) where

import Prelude

data FileFormat = Text | Json

derive instance Eq FileFormat

instance Show FileFormat where
  show Text = "Text"
  show Json = "JSON"
