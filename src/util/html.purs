module ToA.Util.Html
  ( css
  , hr
  ) where

import Prelude

import Halogen.HTML as HD
import Halogen.HTML.Properties as HP

css :: ∀ r i. Array String -> HP.IProp (class :: String | r) i
css = HP.classes <<< map HD.ClassName

hr :: ∀ w i. HD.HTML w i
hr =
  HD.hr [ css [ "my-1", "text-stone-500", "dark:text-stone-700" ] ]
