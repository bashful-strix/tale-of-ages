module ToA.Resource.Icon.Ability.Stalwart
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
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

furor :: Ability
furor = Ability
  { name: Name "Furor"
  , description: [ Text "Strike with your heart." ]
  , action: One
  , tags: [ Attack, RangeTag Melee ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ AttackStep (Just $ Flat 2) (Just $ Roll 1 D6)
      , Step Nothing $ OnHit
          [ Text "Gain 2 vigor. If you or your target is in "
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text ", deals damage"
          , Power
          , Text " and double vigor gain."
          ]
      ]
  }

interpose :: Ability
interpose = Ability
  { name: Name "Interpose"
  , description:
      [ Text
          """You are able to step quickly and rapidly in the midst of
          combat."""
      ]
  , action: One
  , tags: [ RangeTag (Range 1 3), TargetTag Ally ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ TriggerStep
          [ Text "An ally ends their turn in range." ]
      , Step Nothing $ Eff
          [ Text
              """Dash 2. If you end this move adjacent to that ally,
              they gain """
          , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
          , Text "."
          ]
      ]
  }

impel :: Ability
impel = Ability
  { name: Name "Impel"
  , description: [ Text "Hurl headlong into battle." ]
  , action: One
  , tags: [ RangeTag Melee, TargetTag Foe ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step (Just D6) $ Eff
          [ Text "Dash 1, then an adjacent foe is "
          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
          , Text " and pushed 1 (4+) two or (6+) four spaces."
          ]
      ]
  }

hook :: Ability
hook = Ability
  { name: Name "Hook"
  , description:
      [ Text
          "You grab an ally and pull them from the teeth of the enemy."
      ]
  , action: Quick
  , tags: [ RangeTag (Range 2 3), TargetTag Ally ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ Eff
          [ Text "Pull target 1. They are "
          , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
          , Text " and "
          , Italic [ Ref (Name "Immune") [ Text "immune" ] ]
          , Text " to all damage while moving this way."
          ]
      ]
  }

mightyHew :: Ability
mightyHew = Ability
  { name: Name "Mighty Hew"
  , description: [ Text "Finish them." ]
  , action: Two
  , tags: [ Attack, RangeTag Melee ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ AttackStep (Just $ Flat 3) (Just $ Roll 2 D6)
      , Step (Just D6) $ OnHit
          [ Text "Deal a follow up blow against "
          , Italic [ Ref (Name "Afflicted") [ Text "afflicted" ] ]
          , Text " foes, dealing 2 damage again (5+) and "
          , Italic [ Ref (Name "Stun") [ Text "stunning" ] ]
          , Text " them."
          ]
      ]
  }

secondWind :: Ability
secondWind = Ability
  { name: Name "Second Wind"
  , description:
      [ Text "You brace and ready yourself for the fray." ]
  , action: One
  , tags: [ End, TargetTag Self ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step (Just D6) $ Eff
          [ Text
              """Gain 2 vigor and end a negative status token. If
              you're in """
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text " increase vigor by +"
          , Dice 1 D6
          , Text "."
          ]
      , Step Nothing $ Eff
          [ Text "Gain "
          , Italic [ Ref (Name "Sturdy") [ Text "sturdy" ] ]
          , Text " or grant it to an adjacent ally. Then "
          , Bold [ Text "end your turn" ]
          , Text "."
          ] 
      ]
  }

shatter :: Ability
shatter = Ability
  { name: Name "Shatter"
  , description:
      [ Text
          "Slam your weapon into the ground, sending up shockwaves."
      ]
  , action: Two
  , tags: [ Close, AreaTag (Blast 3) ]
  , summon: Nothing
  , sub: Nothing
  , steps:
      [ Step Nothing $ AreaEff [ Dice 1 D6, Text "+2 damage, push 1." ]
      , Step Nothing $ Eff
          [ Text
              """If you catch three or more characters in the area,
              increase area damage by +2."""
          ]
      , Step Nothing $ Eff
          [ Text "One character in the area is "
          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
          , Text "."
          ]
      ]
  }
