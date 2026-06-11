module ToA.Component.Trait
  ( renderTrait
  ) where

import Prelude

import Data.Lens ((^.))
import Data.Lens.Iso.Newtype (_Newtype)

import Halogen.HTML as HD

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Icon.Trait (Trait)

import ToA.Component.Markup (markup)
import ToA.Util.Html (css)
import ToA.Util.Optic ((#~))

renderTrait :: ∀ w i. Icon -> Trait -> HD.HTML w i
renderTrait icon trait =
  HD.div []
    [ HD.div
        [ css [ "font-bold" ] ]
        [ HD.text $ trait ^. _name <<< _Newtype ]
    , trait # _desc #~ markup icon
    ]
