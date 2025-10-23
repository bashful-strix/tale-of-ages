module ToA.Data.Icon.Ability.Tactician
  ( pincerAttack
  , baitAndSwitch
  , holdTheCenter
  , mightyStandard
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Name (Name(..))

pincerAttack :: Ability
pincerAttack = Ability
  { name: Name "Pincer Attack"
  , description:
      "Your weapon finds every weakness, driving your foe "
        <> "straight into your waiting ally."
  , action: One
  , tags: [ Attack, RangeTag Melee ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ AttackStep (Just $ Flat 1) (Just $ Roll 1 D3)
      , Step $ OnHit $
          "Push 1. If your foe would be pushed into an ally's "
            <> "space, that ally deals 2 _piercing_ damage to "
            <> "that foe and gains _shield_. Double these "
            <> "effects if your ally or you target is in "
            <> "_crisis_."
      ]
  }

baitAndSwitch :: Ability
baitAndSwitch = Ability
  { name: Name "Bait and Switch"
  , description:
      "You lay a trap for your foe, striking when they "
        <> "overextend themselves."
  , action: One
  , tags: [ RangeTag (Range 1 2), TargetTag Ally ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ Eff "Swap places with an ally in range."
      , Step $ Eff $
          "If your ally was adjacent to at least one foe, you "
          <> "may then deal 2 damage to one of those foes after "
          <> "swapping and _daze_ them."
      ]
  }

holdTheCenter :: Ability
holdTheCenter = Ability
  { name: Name "Hold the Center"
  , description:
      "You brace with a shield or armor, strengthening your "
        <> "formation against incoming blows."
  , action: Interrupt 1
  , tags: [ TargetTag Ally, RangeTag Adjacent ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ TriggerStep "An adjacent ally is damaged."
      , RollStep $ Eff $
          "Reduce that damage by the number of adjacent allies "
            <> "to you, then push all adjacent foes 1, (4+) "
            <> "two, or (6+) four spaces."
      , Step $ Eff $
          "If that ally was in _crisis_, double damage "
            <> "reduction and push."
      ]
  }

mightyStandard :: Ability
mightyStandard = Ability
  { name: Name "Mighty Standard"
  , description:
      "You place your banner, striking fear into the hearts of "
        <> "your foes."
  , action: One
  , tags: [ KeywordTag (Name "Zone"), RangeTag (Range 1 3), End ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ KeywordStep (Name "Zone") $
          "*End your turn* and designate a blast 3 zone with at "
            <> "one space in range, which could overlap "
            <> "characters. Allies that end their turn inside "
            <> "the zone gain _shield_. If they are in "
            <> "_crisis_, they also gain +1 armor while inside "
            <> "the zone."
      , RollStep $ Eff $
          "While inside the zone, you can pick up the banner as "
            <> "a *quick* ability and swing it, pushing all "
            <> "other characters inside _1d3_, but removing the "
            <> "zone. Foes pushed are _dazed_."
      ]
  }
