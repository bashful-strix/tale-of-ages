module ToA.Data.Icon.Markup
  ( Markup(..)
  , MarkupItem(..)
  , ListKind(..)
  ) where

import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Name (Name)

type Markup = Array MarkupItem

data MarkupItem
  = Text String
  | List ListKind (Array Markup)
  | Ref Name Markup
  | Power
  | Weakness
  | Dice Int Die
  | Bold Markup
  | Italic Markup
  | Newline

data ListKind
  = Ordered
  | Unordered
