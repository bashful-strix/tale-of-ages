module ToA.Component.Trait
  ( renderTrait
  ) where

import Prelude

import Data.Lens ((^.))
import Data.Lens.Iso.Newtype (_Newtype)

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Component.Markup (markup)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Icon.Trait (Trait)
import ToA.Util.Html (css_)
import ToA.Util.Optic ((#~))

renderTrait :: Icon -> Trait -> Nut
renderTrait icon trait =
  D.div []
    [ D.div
        [ css_ [ "font-bold" ] ]
        [ D.text_ $ trait ^. _name <<< _Newtype ]
    , trait # _desc #~ markup icon
    ]
