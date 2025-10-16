module ToA.Util.Html
  ( css
  ) where

import Prelude

import Halogen.HTML.Core (ClassName(..))
import Halogen.HTML.Properties (IProp, classes)

css
  :: ∀ r i
   . Array String
  -> IProp (class ∷ String | r) i
css = classes <<< map ClassName
