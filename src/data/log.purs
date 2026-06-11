module ToA.Data.Log (Level(..)) where

import Prelude

data Level
  = Debug
  | Info
  | Warn
  | Error

derive instance Eq Level
derive instance Ord Level

instance Show Level where
  show Debug = "[debug]"
  show Info = "[info]"
  show Warn = "[warn]"
  show Error = "[error]"
