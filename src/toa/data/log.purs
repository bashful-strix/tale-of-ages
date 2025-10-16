module ToA.Data.Log (Level(..)) where

import Prelude

data Level
  = Error
  | Warn
  | Info
  | Debug

derive instance Eq Level
derive instance Ord Level

instance Show Level where
  show Error = "[error]"
  show Warn = "[warn]"
  show Info = "[info]"
  show Debug = "[debug]"
