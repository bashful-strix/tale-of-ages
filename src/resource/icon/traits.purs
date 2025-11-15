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
  , pressTheFight
  , ingenuity
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
