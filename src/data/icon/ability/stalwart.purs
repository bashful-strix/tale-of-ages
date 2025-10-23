module ToA.Data.Icon.Ability.Stalwart
  ( furor
  , interpose
  , impel
  , hook
  , mightyHew
  , secondWind
  , shatter
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Name (Name(..))

furor :: Ability
furor = Ability
  { name: Name "Furor"
  , description: "Strike with your heart."
  , action: One
  , tags: [ Attack, RangeTag Melee ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ AttackStep (Just $ Flat 2) (Just $ Roll 1 D6)
      , Step $ OnHit $
          "Gain 2 vigor. If you or your target is in _crisis_, "
            <> "deals dmaage [+] and double vigor gain."
      ]
  }

interpose :: Ability
interpose = Ability
  { name: Name "Interpose"
  , description:
      "You are able to step quickly and rapidly in the midst of "
        <> "combat."
  , action: One
  , tags: [ RangeTag (Range 1 3), TargetTag Ally ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ TriggerStep "An ally ends their turn in range."
      , Step $ Eff $
          "Dash 2. If you end this move adjacent to that ally, "
            <> "they gain _shield_."
      ]
  }

impel :: Ability
impel = Ability
  { name: Name "Impel"
  , description: "Hurl headlong into battle."
  , action: One
  , tags: [ RangeTag Melee, TargetTag Foe ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ RollStep $ Eff $
          "Dash 1, then an adjacent foe is _dazed_, and pushed 1 "
            <> "(4+) two or (6+) four spaces."
      ]
  }

hook :: Ability
hook = Ability
  { name: Name "Hook"
  , description:
      "You grab an ally and pull them from the teeth of the enemy."
  , action: Quick
  , tags: [ RangeTag (Range 2 3), TargetTag Ally ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ Eff $
          "Pull target 1. They are _unstoppable_ and _immune_ to "
            <> "all damage while moving this way."
      ]
  }

mightyHew :: Ability
mightyHew = Ability
  { name: Name "Mighty Hew"
  , description: "Finish them."
  , action: Two
  , tags: [ Attack, RangeTag Melee ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ AttackStep (Just $ Flat 3) (Just $ Roll 2 D6)
      , RollStep $ OnHit $
          "Deal a follow up blow against _afflicted_ foes, "
            <> "dealing 2 damage again (5+) and _stunning_ them."
      ]
  }

secondWind :: Ability
secondWind = Ability
  { name: Name "Second Wind"
  , description: "You brace and ready yourself for the fray."
  , action: One
  , tags: [ End, TargetTag Self ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ RollStep $ Eff $
          "Gain 2 vigor and end a negative status token. If "
            <> "you're in _crisis_, increase vigor by +1d6."
      , Step $ Eff $
          "Gain _strudy_ or grant it to an adjacent ally. Then "
            <> "*end your turn*."
      ]
  }

shatter :: Ability
shatter = Ability
  { name: Name "Shatter"
  , description:
      "Slam your weapon into the ground, sending up shockwaves."
  , action: Two
  , tags: [ Close, AreaTag (Blast 3) ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step $ AreaEff "1d6+2 damage, push 1."
      , Step $ Eff $
          "If you catch three or more characters in the area, "
            <> "increase area damage by +2."
      , Step $ Eff "One character in the area is _dazed_."
      ]
  }
