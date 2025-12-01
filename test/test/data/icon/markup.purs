module Test.ToA.Data.Icon.Markup (spec) where

import Prelude

import Data.Codec (decode, encode)

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Name (Name(..))

import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..), markup)

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (AnyShow(..), shouldEqual)

spec :: Spec Unit
spec = do
  describe "markup codec" do
    it "should roundtrip markup" do
      let
        mu =
          [ Text "before "
          , List Unordered
              [ [ Italic [ Ref (Name "test ref") [ Text "italic", Power ] ] ]
              , [ Bold [ Ref (Name "test ref 2 ") [ Text "bold", Weakness ] ] ]
              , [ List Ordered
                    [ [ Text "inner list" ]
                    , [ Text "roll ", Dice 3 D3, Text "+3" ]
                    ]
                ]
              ]
          , Text " break"
          , Newline
          , Text "after."
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
