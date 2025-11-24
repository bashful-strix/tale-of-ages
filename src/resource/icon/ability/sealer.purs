module ToA.Resource.Icon.Ability.Sealer
  ( passageToTheAfterlife
  , godHand
  , matsuri
  , evilCrushingFist
  , condemn
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

passageToTheAfterlife :: Ability
passageToTheAfterlife = LimitBreak
  { name: Name "Passage to the Afterlife"
  , colour: Name "Green"
  , description:
      [ Text
          """You unleash the supreme Sealer war art, inflicting ten
          thousand blows and shattering the connections of your foe's
          vital energy to their body, hurrying on the transmigration of
          immortal souls."""
      ]
  , cost: Two /\ 4
  , tags: [ Attack ]
  , steps:
      [ Step Nothing $ Eff
          [ Text "You cannot unleash this ability before round 4." ]
      , Step Nothing $ Eff [ Text "Teleport 4." ]
      , Step Nothing $ AttackStep
          [ Text "4 damage" ]
          [ Text "+", Dice 2 D6, Text " damage." ]
      , Step Nothing $ KeywordStep (Name "Excel")
          [ Text
              """All allies in range 1-2 of your foe may teleport into
              free adjacent space to your foe. Then your foe takes """
          , Dice 2 D6
          , Text " damage from each ally that teleported this way."
          ]
      , Step Nothing $ KeywordStep (Name "Critical Hit")
          [ Text "Excel effect has no maximum range." ]
      ]
  }

godHand :: Ability
godHand = Ability
  { name: Name "God Hand"
  , colour: Name "Green"
  , description:
      [ Text
          """Divine energy infuses you, allowing hammer-like blows that
          would fell a demon with even your bare hands."""
      ]
  , cost: One
  , tags: [ RangeTag Melee ]
  , steps:
      [ Step Nothing $ Eff [ Text "Teleport 1." ]
      , Step Nothing $ AttackStep
          [ Text "2 damage" ]
          [ Text "+", Dice 1 D3 ]
      , Step Nothing $ KeywordStep (Name "Excel")
          [ Text
              """The target of your attack explodes with divine energy
              with a burst 1 (target) area effect. All foes in the area
              take 2 damage, and allies in the area gain 2 vigor."""
          ]
      , Step Nothing $ KeywordStep (Name "Critical Hit")
          [ Text
              "Increase burst area by help the round number, rounded up."
          ]
      ]
  }

matsuri :: Ability
matsuri = Ability
  { name: Name "Matsuri"
  , colour: Name "Green"
  , description:
      [ Text
          """You and allies teleport in a display that sends sprays of
          bright fire, lighting up the sky."""
      ]
  , cost: Two
  , tags: [ RangeTag (Range 2 5) ]
  , steps:
      [ Step Nothing $ Eff
          [ Text
              """Choose a blast 3 area in range. You an all adjacent
              allies may teleport into free space in the area, in any
              order, then all foes in the area take 2 """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage and must save of be "
          , Italic [ Ref (Name "Brand") [ Text "branded" ] ]
          , Text " and pushed 1 away from the center."
          ]
      , Step Nothing $ Eff
          [ Text
              """If you excelled this turn, reduce the action cost of
              this ability to 1 action. If you critical hit, it
              becomes """
          , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
          , Text "."
          ]
      ]
  }

evilCrushingFist :: Ability
evilCrushingFist = Ability
  { name: Name "Evil Crushing Fist"
  , colour: Name "Green"
  , description:
      [ Text
          "Your blows are redoubled by those of your righteous allies."
      ]
  , cost: One
  , tags: [ KeywordTag (Name "Stance"), End ]
  , steps:
      [ Step (Just D6) $ KeywordStep (Name "Stance")
          [ Bold [ Text "End your turn" ]
          , Text
              """ and enter this stance. While in this stance, you can
              teleport 2 before any attack, and your attacks gain """
          , Power
          , Text "."
          , List Unordered
              [ [ Text
                    """When you excel or critical hit with an attack, an
                    ally in range 1-2 of your target may teleport 1. Then
                    if they are adjacent to your target, they deal 2
                    damage (4+) then you may repeat this effect on a new
                    ally (6+) and again."""
                ]
              ]
          ]
      ]
  }

condemn :: Ability
condemn = Ability
  { name: Name "Condemn"
  , colour: Name "Green"
  , description:
      [ Text
          """Brand your foe with a hellish seal, condemning them and
          crushing them under the weight of their own evil."""
      ]
  , cost: One
  , tags:
      [ KeywordTag (Name "Mark")
      , RangeTag (Range 2 5)
      , KeywordTag (Name "Power Die")
      ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Mark")
          [ Text
              """Mark a foe in range, then set out a power die at 1. When
              you or an ally attacks your foe, they gain """
          , Power
          , Text
              """ on the attack roll, then tick the die up by 2. At 3 or
              more ticks, increase this attack to
              """
          , Power
          , Power
          , Text " and "
          , Power
          , Power
          , Power
          , Text
              """ at 5 or more ticks. At 6 ticks, when your foe is hit by
              an attack, they explode, with the following effects: """
          , List Unordered
              [ [ Bold [ Text "Hit" ]
                , Text
                    """: Burst 1 (target). 2 damage and push 1 to foes,
                    2 vigor to allies."""
                ]
              , [ Bold [ Text "Excel" ], Text ": Burst +1." ]
              , [ Bold [ Text "Critical Hit" ]
                , Text ": +2 damage, vigor, and push."
                ]
              ]
          , Text "Then the mark ends."
          ]
      ]
  }
