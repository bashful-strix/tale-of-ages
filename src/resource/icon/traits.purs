module ToA.Resource.Icon.Traits
  ( traits
  ) where

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (ListKind(..), MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Trait (Trait(..))

traits :: Array Trait
traits =
  [ rampart
  , skirmisher
  , masterOfAether

  , pressTheFight

  , ingenuity

  , klingenkunst
  ]

rampart :: Trait
rampart = Trait
  { name: Name "Rampart"
  , description:
      [ Text
          """You are an imposing sight on the battlefield. Whether
          through gear, training, or simple toughness, you gain the
          following benefits:"""
      , Newline
      , List Unordered
          [ [ Text "You have 1 armor" ]
          , [ Text
                """Once a round, before you or an adjacent ally is
                targeted by a foe's ability, you may grant that
                character +"""
            , Dice 1 D3
            , Text " "
            , Italic [ Ref (Name "Armor") [ Text "armor" ] ]
            , Text " against the entire ability"
            ]
          , [ Text
                """Foes must spend +1 movement to exit a space adjecent
                to you"""
            ]
          ]
      ]
  }

skirmisher :: Trait
skirmisher = Trait
  { name: Name "Skirmisher"
  , description:
      [ Text
          """You are an agile fighter, able to dodge and weave around the
          battlefield with skill and precision. You gain the following
          benefits:"""
      , Newline
      , List Unordered
          [ [ Text "You can move diagonally" ]
          , [ Text
                """Once a round, when you make a single move, dash, fly, or
                teleport, you may extend it by +3"""
            ]
          , [ Text
                """You reduce all damage from missed attacks and successful
                saves to 1"""
            ]
          ]
      ]
  }

masterOfAether :: Trait
masterOfAether = Trait
  { name: Name "Master of Aether"
  , description:
      [ Text
          """You are the master of manipulating ethereal currents,
          granting the following benefits."""
      , Newline
      , List Unordered
          [ [ Bold [ Text "Aether Surge:" ]
            , Text
                """ At round 3+, you increase all area damage you deal by
                +2."""
            ]
          , [ Bold [ Text "Aether Wall:" ]
            , Text " You have automatic "
            , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
            , Text
                """ against abilities used by any character 3 or more
                spaces away.
                """
            ]
          ]
      ]
  }

pressTheFight :: Trait
pressTheFight = Trait
  { name: Name "Press the Fight"
  , description:
      [ Text
          """Once a round, after you push, pull or swap any character,
          you may allow an ally in range 1-3 to dash spaces equal to
          the round number + 1. If your ally was in """
      , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
      , Text ", they may also gain "
      , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
      , Text " equal to the distance dashed."
      ]
  }

ingenuity :: Trait
ingenuity = Trait
  { name: Name "Ingenuity"
  , description:
      [ Text
          """If you don't attack during your turn, at the end of your
          turn, you can perform one of the following effects:"""
      , List Unordered
          [ [ Text "Fly 3 spaces" ]
          , [ Text
                "Pull a character in range 1-3 two spaces. Then you may "
            , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
            , Text " them or grant them "
            , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
            ]
          , [ Text "Deal 2 damage to all adjacent foes and push them 1" ]
          ]
      ]
  }

klingenkunst :: Trait
klingenkunst = Trait
  { name: Name "Klingenkunst"
  , description:
      [ Text "Once a round, you may teleport 2 as a "
      , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
      , Text " ability. If you are "
      , Italic [ Ref (Name "Isolate") [ Text "isolated" ] ]
      , Text
          """, you may teleport 4 instead. If there are no other
          characters in range 1-2, you may teleport 6."""
      ]
  }
