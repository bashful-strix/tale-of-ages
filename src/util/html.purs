module ToA.Util.Html
  ( css
  , css_
  , style
  , style_

  , hr
  ) where

import Prelude

import CSS (CSS, render, renderedInline)
import Data.Maybe (fromMaybe)
import Data.String (joinWith)

import Deku.Attribute (Attribute)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes (klass, style) as DA

css
  :: forall r f
   . Functor f
  => f (Array String)
  -> f (Attribute (klass :: String | r))
css = DA.klass <<< map (joinWith " ")

css_
  :: forall r f
   . Applicative f
  => Array String
  -> f (Attribute (klass :: String | r))
css_ = css <<< pure

style
  :: ∀ r f
   . Functor f
  => f CSS
  -> f (Attribute (style :: String | r))
style = DA.style <<< map (fromMaybe "" <<< renderedInline <<< render)

style_
  :: ∀ r f
   . Applicative f
  => CSS
  -> f (Attribute (style :: String | r))
style_ = style <<< pure

hr :: Nut
hr =
  D.hr [ css_ [ "my-1", "text-stone-500", "dark:text-stone-700" ] ] []
