module ToA.Util.Html (css, css_) where

import Prelude

import Data.String (joinWith)

import Deku.Attribute (Attribute)
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
