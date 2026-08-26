module Test.ToA.Data.Icon.Markup (spec) where

import Prelude

import Data.Codec (decode, encode)

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Name (Name(..))

import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , newline
  , power
  , ref
  , seq
  , text
  , weakness

  , markup
  )

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (AnyShow(..), shouldEqual)

spec :: Spec Unit
spec = do
  describe "markup codec" do
    it "should roundtrip markup" do
      let
        mu = seq
          [ text "before "
          , list Unordered
              [ italic $ ref (Name "test ref") $ seq [ text "italic", power ]
                  
              , bold $ ref (Name "test ref 2 ") $ seq [ text "bold", weakness ]
              , list Ordered
                  [ text "inner list"
                  , seq [ text "roll ", dice 3 D3, text "+3" ]
                  ]
              ]
          , text " break"
          , newline
          , text "after."
          ]

      (AnyShow <$> (decode markup $ encode markup mu))
        `shouldEqual` (pure (AnyShow mu))

    it "should roundtrip text" do
      let
        t =
          """before
          [list=unordered][item]
              _{[ref=test ref]italic [+][/ref]}_
            [/item][item]
              *{[ref=test ref]bold [-][/ref]}*
            [/item][item]
              [list=ordered][item]inner list[/item][item]roll 3d10 + 2[/item][/list]
            [/item][/list]
          after."""

      (encode markup <$> decode markup t) `shouldEqual` pure t

    it "should igonre whitespace around list items" do
      let
        t =
          """[list=unordered]
               [item]a[/item]
               [item]b[/item]
             [/list][list=ordered]
               [item]1[/item]
               [item]2[/item]
             [/list]"""

      (encode markup <$> decode markup t)
        `shouldEqual`
          ( pure
              "[list=unordered][item]a[/item][item]b[/item][/list][list=ordered][item]1[/item][item]2[/item][/list]"
          )
