module ToA.Util.Html
  ( css
  , css_
  , hr
  ) where

import Prelude

import Data.String (joinWith)

import Deku.Attribute (Attribute)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes (klass)

css
  :: forall r f
   . Functor f
  => f (Array String)
  -> f (Attribute (klass :: String | r))
css = klass <<< map (joinWith " ")

css_
  :: forall r f
   . Applicative f
  => Array String
  -> f (Attribute (klass :: String | r))
css_ = css <<< pure

hr :: Nut
hr = 
  D.hr [ css_ [ "my-1", "text-stone-500", "dark:text-stone-700" ] ] []
