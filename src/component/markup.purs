module ToA.Component.Markup
  ( markup
  ) where

import Prelude

import Data.Filterable (filter)
import Data.Foldable (foldMap, intercalate)
import Data.Lens ((^.), (^?), filtered, traversed, view)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (maybe)
import Data.String.Common (replaceAll, split)
import Data.String.Pattern (Pattern(..), Replacement(..))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Markup (Markup, MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (_name)
import ToA.Util.Html (css_)
import ToA.Util.Optic ((#~))

markup :: Icon -> Markup -> Nut
markup icon@{ keywords } = foldMap $ case _ of
  Text text -> D.span [] [ D.text_ text ]
  Bold text -> D.span [ css_ [ "font-bold" ] ] [ markup icon text ]
  Italic text -> D.span [ css_ [ "italic" ] ] [ markup icon text ]
  Newline -> D.br [] []

  Power -> D.span [] [ D.text_ "[+]" ]
  Weakness -> D.span [] [ D.text_ "[-]" ]
  Dice n d -> D.span [] [ D.text_ $ show n <> show d ]

  List kind items ->
    D.ol
      [ css_
          [ "ml-4"
          , case kind of
              Ordered -> "list-decimal"
              Unordered -> "list-disc"
          ]
      ] $ items <#> \item -> D.li [] [ markup icon item ]

  Ref ref text ->
    let
      k = keywords ^? traversed <<< filtered (view _name >>> eq ref)
    in
      D.span
        [ css_ [ "underline" ]
        , DA.title_ $ k # maybe
            (ref ^. simple _Newtype)
            (_desc #~ printMarkup)
        ]
        [ markup icon text ]

printMarkup :: Markup -> String
printMarkup = intercalate " " <<< map case _ of
  Text text ->
    text
      # replaceAll (Pattern "\n") (Replacement mempty)
      # split (Pattern " ")
      # filter (not <<< eq mempty)
      # intercalate " "
  Bold text -> printMarkup text
  Italic text -> printMarkup text
  Newline -> "\n"

  Power -> "[+]"
  Weakness -> "[-]"
  Dice n d -> show n <> show d

  List _kind items ->
    items # foldMap \item -> "- " <> printMarkup item <> "\n"
  Ref _ text -> printMarkup text
