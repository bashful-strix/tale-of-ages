module ToA.Resource.Icon.Ability.Spellblade
  ( granLevincross
  , gungnir
  , atherwand
  , odinforce
  , nothung
  , tenThousandCuts
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

granLevincross :: Ability
granLevincross = LimitBreak
  { name: Name "Gran Levincross"
  , colour: Name "Blue"
  , description:
      [ Text "I summon thee, bloody gods of the cutting art,"
      , Newline
      , Text
          """Let the might of the divine realm crash upen the piteous
          earth,"""
      , Newline
      , Text "Strike eighty thousand blows at once,"
      , Newline
      , Text "And split the air asunder!"
      ]
  , cost: Two /\ 4
  , tags: [ KeywordTag (Name "Zone") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Zone")
          [ Text
              """Your blade extends and you make two massive cuts
              across the map, splitting the walls between worlds. Draw
              a cross section across the map, splitting it into four
              sections of any size. Deal 4 """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text
              """ damage to all characters caught in the cross, then
              remove all characters out of the affected area and place
              them in the nearest fere space of your choice. Characters
              may pass a save to choose to the space themselves."""
          , Newline
          , Newline
          , Text
              """ The affected area becomes a crackling wall of
              lightning. Each space is an """
          , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
          , Text
              """ space. Characters that voluntarily enter the space or
              start their turn there must save or take """
          , Dice 6 D3
          , Text " damage and become "
          , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
          , Text ", or half and no slow on a successful save."
          ]
      ]
  }

gungnir :: Ability
gungnir = Ability
  { name: Name "Gungnir"
  , colour: Name "Blue"
  , description:
      [ Text
          "A thousand spears of light, each striking a perfect blow."
      ]
  , cost: One
  , tags: [ Attack, Close, AreaTag (Line 6) ]
  , steps:
      [ Step Nothing $ AttackStep (Just $ Flat 3) (Just $ Roll 1 D3)
      , Step Nothing $ AreaEff [ Text "3 damage." ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text
              """Isolated foes in the area are struck by a lightning
              bolt, taking 2 damage again. You may then teleport
              adjacent to one of those characters."""
          ]
      ]
  }

atherwand :: Ability
atherwand = Ability
  { name: Name "Ätherwand"
  , colour: Name "Blue"
  , description:
      [ Text
          """You summon the highwinds, swirling around your weapon to
          banish your foes."""
      ]
  , cost: One
  , tags: [ End ]
  , steps:
      [ Step (Just D3) $ Eff
          [ Text "End your turn. Your next attack gains:"
          , List Unordered
              [ [ Text "+2 damage on hit" ]
              , [ Text "You may teleport 3 spaces before the attack" ]
              , [ Italic [ Text "On hit: " ]
                , Text "teleport your foe "
                , Dice 1 D3
                , Text "+1. "
                , Italic [ Text "Miss: " ]
                , Text "1 space"
                ]
              ]
          ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text "Teleport your foe +2 on hit." ]
      ]
  }

odinforce :: Ability
odinforce = Ability
  { name: Name "Odinforce"
  , colour: Name "Blue"
  , description:
      [ Text
          """You slash, and phantom images of your blade linger over your
          shoulder."""
      ]
  , cost: One
  , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Power die") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Stance")
          [ Text "Gain "
          , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
          , Text
              """ and six lingering lightning infused copies of your
              weapon, represented by a power die, starting at 6."""
          , List Unordered
              [ [ Text
                    """At the end of your turn you may tick down the die
                    to fire a weapon at one or two foes in range 1-4,
                    dealing 1 """
                , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                , Text " damage and ticking the die down by 1 each time."
                ]
              , [ Text "The last sword deals an extra "
                , Dice 1 D6
                , Text " "
                , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                , Text "."
                ]
              , [ Text "If the die ticks to 0, exit this stance." ]
              ]
          ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text
              """If you end your turn with no other characters adjacent,
              regain two swords."""
          ]
      , Step (Just D3) $ KeywordStep (Name "Isolate")
          [ Text "You may fire "
          , Italic [ Dice 1 D3 ]
          , Text " swords at a foe instead if they are isolated."
          ]
      ]
  }

nothung :: Ability
nothung = Ability
  { name: Name "Nothung"
  , colour: Name "Blue"
  , description:
      [ Text
          """You slash through your target, then cause slashes of damage
          built up within their body to explode. A difficult technique,
          not for the faint of heart."""
      ]
  , cost: Two
  , tags: [ Attack, KeywordTag (Name "Mark"), RangeTag Melee ]
  , steps:
      [ Step Nothing $ Eff [ Text "Teleport 2." ]
      , Step Nothing $ AttackStep (Just $ Flat 2) (Just $ Roll 1 D3)
      , SubStep Nothing (Name "Ten Thousand Cuts") $ OnHit
          [ Bold [ Ref (Name "Mark") [ Text "Mark" ] ]
          , Text
              """ your foe. then gain the following interrupt at the end
              of your turns while your foe is marked. You can choose not
              to trigger it."""
          ]
      ]
  }

tenThousandCuts :: Ability
tenThousandCuts = Ability
  { name: Name "Ten Thousand Cuts"
  , colour: Name "Blue"
  , description: []
  , cost: Interrupt 1
  , tags: []
  , steps:
      [ Step Nothing $ TriggerStep [ Text "The end of your foe's turn." ]
      , Step (Just D6) $ Eff
          [ Text
              """Call a number between 1 and 6, then roll the effect die.
              If you roll equal to or over your number, deal 2 damage a
              number of times to your target equal to the number chosen.
              If you roll under your number, deal just 1 """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage to them. Then end this mark."
          ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text
              """Increase each instance of damage to 3 damage. If there
              are no other characters in range 1-2, destroy all vigor on
              your foe before dealing damage."""
          ]
      ]
  }
