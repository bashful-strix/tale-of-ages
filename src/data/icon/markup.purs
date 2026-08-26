module ToA.Data.Icon.Markup
  ( Markup
  , MarkupF(..)
  , ListKind(..)

  , text
  , power
  , weakness
  , newline
  , bold
  , italic
  , dice
  , ref
  , list
  , seq

  , length

  , markup
  ) where

import ToA.Prelude hiding (between)

import Control.Lazy (defer)
import Data.Codec (Codec', codec')
import Data.Either (Either)
import Data.Eq (class Eq1)
import Data.Foldable (fold, foldMap, sum)
import Data.Functor.Mu (Mu)
import Data.String (length) as S
import Data.Tuple (fst)

import Matryoshka (class Corecursive, class Recursive, embed, cata)

import Parsing (Parser, ParseError, runParser)
import Parsing.Combinators (advance, between, choice, lookAhead, try)
import Parsing.Combinators.Array (many, manyTill_)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Name (Name(..))

data MarkupF f
  = Text String
  | Power
  | Weakness
  | Newline
  | Bold f
  | Italic f
  | Dice Int Die
  | Ref Name f
  | List ListKind (Array f)
  | Seq (Array f)

derive instance Eq f => Eq (MarkupF f)
derive instance Eq1 MarkupF
derive instance Functor MarkupF

text :: ∀ f. Corecursive f MarkupF => String -> f
text = embed <<< Text

power :: ∀ f. Corecursive f MarkupF => f
power = embed Power

weakness :: ∀ f. Corecursive f MarkupF => f
weakness = embed Weakness

newline :: ∀ f. Corecursive f MarkupF => f
newline = embed Newline

bold :: ∀ f. Corecursive f MarkupF => f -> f
bold = embed <<< Bold

italic :: ∀ f. Corecursive f MarkupF => f -> f
italic = embed <<< Italic

dice :: ∀ f. Corecursive f MarkupF => Int -> Die -> f
dice = embed <.. Dice

ref :: ∀ f. Corecursive f MarkupF => Name -> f -> f
ref = embed <.. Ref

list :: ∀ f. Corecursive f MarkupF => ListKind -> Array f -> f
list = embed <.. List

seq :: ∀ f. Corecursive f MarkupF => Array f -> f
seq = embed <<< Seq

data ListKind
  = Ordered
  | Unordered

derive instance Eq ListKind

type Markup = Mu MarkupF

length :: ∀ f. Recursive f MarkupF => f -> Int
length = cata case _ of
  Text t -> S.length t
  Power -> 1
  Weakness -> 1
  Newline -> 1
  Bold b -> b
  Italic i -> i
  Dice _ _ -> 1
  Ref _ r -> r
  List _ xs -> sum xs
  Seq xs -> sum xs

markup :: Codec' (Either ParseError) String Markup
markup = codec' (runParser ~$ (markupParser <* eof)) serialise

serialise :: ∀ f. Recursive f MarkupF => f -> String
serialise = cata case _ of
  Text t -> t
  Power -> "[+]"
  Weakness -> "[-]"
  Newline -> "\n"
  Bold b -> "*{" <> b <> "}*"
  Italic i -> "_{" <> i <> "}_"
  Dice n d -> show n <> show d
  Ref (Name n) r -> "[ref=" <> n <> "]" <> r <> "[/ref]"
  List k xs ->
    let
      kind = case k of
        Ordered -> "ordered"
        Unordered -> "unordered"
      items = xs # foldMap \x -> "[item]" <> x <> "[/item]"
    in
      "[list=" <> kind <> "]" <> items <> "[/list]"
  Seq xs -> fold xs

markupParser :: Parser String Markup
markupParser =
  let
    powerP = void $ string "[+]"
    weaknessP = void $ string "[-]"
    newlineP = void $ string "\n"
    bo = void $ string "*{"
    bc = void $ string "}*"
    io = void $ string "_{"
    ic = void $ string "}_"
    ro = void $ string "[ref="
    rc = void $ string "[/ref]"
    lo = void $ string "[list="
    lc = void $ string "[/list]"
    lio = void $ string "[item]"
    lic = void $ string "[/item]"
    open = choice [ bo, io, ro, lo, lio ]
    close = choice [ bc, ic, rc, lc, lic ]
    inset = choice [ powerP, weaknessP, newlineP, void diceP ]

    diceP = do
      n <- intDecimal
      _ <- char 'd'
      dice n <$> choice
        [ string "3" $> D3, string "6" $> D6, string "10" $> D10 ]

    refP = do
      n <- Name <<< fst <$> (ro *> anyTill (string "]"))
      ref n <$> mu <* rc

    listKindP =
      (Ordered <$ string "ordered") <|> (Unordered <$ string "unordered")
    listP = do
      k <- between lo (char ']') listKindP
      list k <<< fst <$>
        manyTill_ (between (skipSpaces *> lio) (lic <* skipSpaces) mu) lc

    textP = text <<< fst <$>
      anyTill (lookAhead (open <|> close <|> inset <|> eof))

    mu = defer \_ ->
      ( many $ choice
          [ power <$ powerP
          , weakness <$ weaknessP
          , newline <$ newlineP
          , bold <$> between bo bc mu
          , italic <$> between io ic mu
          , try diceP
          , refP
          , listP
          , advance textP
          ]
      ) <#> case _ of
        [ x ] -> x
        xs -> seq xs
  in
    mu
