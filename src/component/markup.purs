module ToA.Component.Markup
  ( markup
  , printMarkup
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

import Matryoshka (cata)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Markup (Markup, MarkupF(..), ListKind(..))
import ToA.Data.Icon.Name (_name)
import ToA.Util.Html (css_)
import ToA.Util.Optic ((#~))

markup :: Icon -> Markup -> Nut
markup { keywords } = cata case _ of
  Text text -> D.span [] [ D.text_ text ]
  Bold text -> D.span [ css_ [ "font-bold" ] ] [ text ]
  Italic text -> D.span [ css_ [ "italic" ] ] [ text ]
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
      ] $ items <#> \item -> D.li [] [ item ]

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
        [ text ]
  Seq texts -> D.span [] texts

printMarkup :: Markup -> String
printMarkup = cata case _ of
  Text text ->
    text
      # replaceAll (Pattern "\n") (Replacement mempty)
      # split (Pattern " ")
      # filter (not <<< eq mempty)
      # intercalate " "
  Bold text -> text
  Italic text -> text
  Newline -> "\n"

  Power -> "[+]"
  Weakness -> "[-]"
  Dice n d -> show n <> show d

  List _kind items ->
    items # foldMap \item -> "- " <> item <> "\n"
  Ref _ text -> text
  Seq texts -> intercalate " " texts
