module ToA.Component.Talent
  ( renderTalent
  ) where

import Prelude

import CSS (color, render, renderedInline)

import Data.Lens ((^.), (^?), view, filtered, traversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (fromMaybe)

import Halogen.HTML as HD
import Halogen.HTML.Properties as HP

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Name (_name)

import ToA.Data.Icon.Pc.Talent (Talent)

import ToA.Component.Markup (markup)
import ToA.Util.Html (css)
import ToA.Util.Optic ((#~))

renderTalent :: ∀ w i. Icon -> Talent -> HD.HTML w i
renderTalent icon@{ colours } talent =
  HD.div []
    [ HD.div
        [ css [ "font-bold" ]
        , HP.style $ fromMaybe "" $ renderedInline $ render =<<
            color <$> colours
              ^? traversed
                <<< filtered (view _name >>> eq (talent ^. _colour))
                <<< _value
        ]
        [ HD.text $ talent ^. _name <<< _Newtype ]
    , talent # _desc #~ markup icon
    ]
