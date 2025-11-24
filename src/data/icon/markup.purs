module ToA.Data.Icon.Markup
  ( Markup(..)
  , MarkupItem(..)
  , ListKind(..)

  , markup
  ) where

import Prelude hiding (between)
import PointFree ((~$))

import Control.Lazy (defer)
import Data.Codec (Codec', codec')
import Data.Either (Either)
import Data.Foldable (foldMap)
import Data.Tuple (fst)

import Parsing (Parser, ParseError, runParser)
import Parsing.Combinators ((<|>), advance, between, choice, lookAhead, try)
import Parsing.Combinators.Array (many, manyTill_)
import Parsing.String (anyTill, char, eof, string)
import Parsing.String.Basic (intDecimal, skipSpaces)

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Name (Name(..))

type Markup = Array MarkupItem

data MarkupItem
  = Text String
  | Power
  | Weakness
  | Newline
  | Bold Markup
  | Italic Markup
  | Dice Int Die
  | Ref Name Markup
  | List ListKind (Array Markup)

derive instance Eq MarkupItem

data ListKind
  = Ordered
  | Unordered

derive instance Eq ListKind

markup :: Codec' (Either ParseError) String Markup
markup = codec' (runParser ~$ (markupParser <* eof)) serialise

serialise :: Markup -> String
serialise = foldMap case _ of
  Text t -> t
  Power -> "[+]"
  Weakness -> "[-]"
  Newline -> "\n"
  Bold b -> "*{" <> serialise b <> "}*"
  Italic i -> "_{" <> serialise i <> "}_"
  Dice n d -> show n <> show d
  Ref (Name n) r -> "[ref=" <> n <> "]" <> serialise r <> "[/ref]"
  List k xs ->
    let
      kind = case k of
        Ordered -> "ordered"
        Unordered -> "unordered"
      items = xs # foldMap \x -> "[item]" <> serialise x <> "[/item]"
    in
      "[list=" <> kind <> "]" <> items <> "[/list]"

markupParser :: Parser String Markup
markupParser =
  let
    power = void $ string "[+]"
    weakness = void $ string "[-]"
    newline = void $ string "\n"
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
    inset = choice [ power, weakness, newline, void dice ]

    dice = do
      n <- intDecimal
      _ <- char 'd'
      Dice n <$> choice
        [ string "3" $> D3, string "6" $> D6, string "10" $> D10 ]

    ref = do
      n <- Name <<< fst <$> (ro *> anyTill (string "]"))
      Ref n <$> mu <* rc

    listKind =
      (Ordered <$ string "ordered") <|> (Unordered <$ string "unordered")
    list = do
      k <- between lo (char ']') listKind
      List k <<< fst <$>
        manyTill_ (between (skipSpaces *> lio) (lic <* skipSpaces) mu) lc

    text = Text <<< fst <$>
      anyTill (lookAhead (open <|> close <|> inset <|> eof))

    mu = defer \_ -> many $ choice
      [ Power <$ power
      , Weakness <$ weakness
      , Newline <$ newline
      , Bold <$> between bo bc mu
      , Italic <$> between io ic mu
      , try dice
      , ref
      , list
      , advance text
      ]
  in
    mu
