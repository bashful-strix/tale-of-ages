module ToA.Component.Talent
  ( renderTalent
  ) where

import Prelude

import CSS (color, render, renderedInline)

import Data.Lens ((^.), (^?), view, filtered, traversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (fromMaybe)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

import ToA.Component.Markup (markup)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Icon.Talent (Talent)
import ToA.Util.Html (css_)
import ToA.Util.Optic ((#~))

renderTalent :: Icon -> Talent -> Nut
renderTalent icon@{ colours } talent =
  D.div []
    [ D.div
        [ css_ [ "font-bold" ]
        , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
            color <$> colours
              ^? traversed
                <<< filtered (view _name >>> eq (talent ^. _colour))
                <<< _value
        ]
        [ D.text_ $ talent ^. _name <<< _Newtype ]
    , talent # _desc #~ markup icon
    ]
