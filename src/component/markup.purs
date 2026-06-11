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

import Halogen.HTML as HD
import Halogen.HTML.Properties as HP

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Markup (Markup, MarkupF(..), ListKind(..))
import ToA.Data.Icon.Name (_name)

import ToA.Util.Html (css)
import ToA.Util.Optic ((#~))

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

markup :: ∀ w i. Icon -> Markup -> HD.HTML w i
markup { keywords } = cata case _ of
  Text text -> HD.span [] [ HD.text text ]
  Bold text -> HD.span [ css [ "font-bold" ] ] [ text ]
  Italic text -> HD.span [ css [ "italic" ] ] [ text ]
  Newline -> HD.br []

  Power -> HD.span [] [ HD.text "[+]" ]
  Weakness -> HD.span [] [ HD.text "[-]" ]
  Dice n d -> HD.span [] [ HD.text $ show n <> show d ]

  List kind items ->
    HD.ol
      [ css
          [ "ml-4"
          , case kind of
              Ordered -> "list-decimal"
              Unordered -> "list-disc"
          ]
      ] $ items <#> \item ->  HD.li [] [ item ]

  Ref ref text ->
    let
      k = keywords ^? traversed <<< filtered (view _name >>> eq ref)
    in
      HD.span
        [ css [ "underline" ]
        , HP.title $ k # maybe
            (ref ^. simple _Newtype)
            (_desc #~ printMarkup)
        ]
        [ text ]
  Seq texts -> HD.span [] texts
