module ToA.Component.Markup
  ( markup
  ) where

import Prelude

import Data.Foldable (foldMap)
import Data.Lens ((^.))
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

import ToA.Data.Icon.Markup (Markup, MarkupItem(..), ListKind(..))
import ToA.Util.Html (css_)

markup :: Markup -> Nut
markup = foldMap $ case _ of
  Text text -> D.span [] [ D.text_ text ]

  List kind items -> case kind of
    Ordered ->
      D.ol [] $ items <#> \item ->
        D.li [ css_ [ "list-decimal" ] ] [ markup item ]
    Unordered ->
      D.ul [] $ items <#> \item ->
        D.li [ css_ [ "list-disc" ] ] [ markup item ]

  Ref ref text ->
    D.span [ DA.title_ (ref ^. simple _Newtype) ] [ markup text ]

  Power -> D.span [] [ D.text_ "[+]" ]
  Weakness -> D.span [] [ D.text_ "[-]" ]

  Dice n d ->
    D.span [ css_ [ "font-bold" ] ] [ D.text_ $ show n <> show d ]

  Bold text -> D.span [ css_ [ "font-bold" ] ] [ markup text ]
  Italic text -> D.span [ css_ [ "italic" ] ] [ markup text ]

  Newline -> D.br [] []
