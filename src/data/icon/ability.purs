module ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)

  , AbilityData

  , _Ability
  , _LimitBreak
  , _action
  , _resolve
  , _steps
  , _tags
  ) where

import Prelude

import Data.Lens (Lens', _1, _2)
import Data.Lens.AffineTraversal (AffineTraversal')
import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested (type (/\))

import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

type AbilityData a =
  { name :: Name
  , colour :: Name
  , description :: Markup
  , cost :: a
  , tags :: Array Tag
  , steps :: Array Step
  }

data Ability
  = Ability (AbilityData Action)
  | LimitBreak (AbilityData (Action /\ Int))

instance Eq Ability where
  eq (Ability { name: n }) (Ability { name: m }) = n == m
  eq (LimitBreak { name: n }) (LimitBreak { name: m }) = n == m
  eq _ _ = false

instance Named Ability where
  _name = lens' case _ of
    Ability a -> map Ability <$> lensStore k a
    LimitBreak a -> map LimitBreak <$> lensStore k a
    where
    k = key @"name"

instance Coloured Ability where
  _colour = lens' case _ of
    Ability a -> map Ability <$> lensStore k a
    LimitBreak a -> map LimitBreak <$> lensStore k a
    where
    k = key @"colour"

instance Described Ability where
  _desc = lens' case _ of
    Ability a -> map Ability <$> lensStore k a
    LimitBreak a -> map LimitBreak <$> lensStore k a
    where
    k = key @"description"

_Ability :: Prism' Ability (AbilityData Action)
_Ability = prism' Ability case _ of
  Ability a -> Just a
  _ -> Nothing

_LimitBreak :: Prism' Ability (AbilityData (Action /\ Int))
_LimitBreak = prism' LimitBreak case _ of
  LimitBreak a -> Just a
  _ -> Nothing

_action :: Lens' Ability Action
_action = lens' case _ of
  Ability a -> map Ability <$> lensStore k a
  LimitBreak a -> map LimitBreak <$> lensStore (k <<< _1) a
  where
  k = key @"cost"

_resolve :: AffineTraversal' Ability Int
_resolve = _LimitBreak <<< key @"cost" <<< _2

_tags :: Lens' Ability (Array Tag)
_tags = lens' case _ of
  Ability a -> map Ability <$> lensStore k a
  LimitBreak a -> map LimitBreak <$> lensStore k a
  where
  k = key @"tags"

_steps :: Lens' Ability (Array Step)
_steps = lens' case _ of
  Ability a -> map Ability <$> lensStore k a
  LimitBreak a -> map LimitBreak <$> lensStore k a
  where
  k = key @"steps"

data Action
  = Quick
  | One
  | Two
  | Interrupt Int

data Range
  = Range Int Int
  | Melee
  | Adjacent

data Pattern
  = Line Int
  | Arc Int
  | Blast Int
  | Burst Int Boolean
  | Cross Int

data Target
  = Self
  | Ally
  | Foe
  | Summon
  | Space
  | Object

data Tag
  = Attack
  | End
  | Close
  | RangeTag Range
  | AreaTag Pattern
  | TargetTag Target
  | KeywordTag Name

data StepType
  = Eff Markup
  | AttackStep Markup Markup
  | OnHit Markup
  | AreaEff Markup
  | KeywordStep Name Markup
  | TriggerStep Markup
  | OtherStep Markup Markup

data Step
  = Step (Maybe Die) StepType
  | SubStep (Maybe Die) Name StepType
  | SummonStep (Maybe Die) Name StepType
