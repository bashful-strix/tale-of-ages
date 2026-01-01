module ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)

  , AbilityData

  , class Inseted
  , _inset

  , _Ability
  , _LimitBreak
  , _action
  , _resolve
  , _steps
  , _tags
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
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

data Variable
  = NumVar Int
  | RollVar Int Die
  | OtherVar String

derive instance Eq Variable

instance Show Variable where
  show (NumVar n) = show n
  show (RollVar n d) = show n <> show d
  show (OtherVar t) = t

data Action
  = Quick
  | One
  | Two
  | Interrupt Variable

derive instance Eq Action

data Range
  = Range Variable Variable
  | Close
  | Melee
  | Adjacent

derive instance Eq Range

data Pattern
  = Line Variable
  | Arc Variable
  | Blast Variable
  | Burst Variable Boolean
  | Cross Variable

derive instance Eq Pattern

data Target
  = Self
  | Ally
  | Foe
  | Summon
  | Space
  | Object

derive instance Eq Target

data Tag
  = Attack
  | End
  | RangeTag Range
  | AreaTag Pattern
  | TargetTag Target
  | KeywordTag Name
  | LimitTag Int String

derive instance Eq Tag

data Inset
  = SummonInset
      { name :: Name
      , colour :: Name
      , max :: Int
      , abilities :: Array Step
      }
  | AbilityInset
      { name :: Name
      , colour :: Name
      , cost :: Action
      , tags :: Array Tag
      , steps :: Array Step
      }
  | KeywordInset
      { name :: Name
      , colour :: Name
      , keyword :: Name
      , steps :: Array Step
      }

class Inseted a where
  _inset :: AffineTraversal' a Inset

data StepType
  = Eff
  | OnHit
  | AreaEff
  | TriggerStep
  | KeywordStep Name
  | VariableKeywordStep Name Variable
  | AltStep (NonEmptyArray StepType)
  | SummonEff
  | SummonAction
  | OtherStep Markup

data Step
  = Step StepType (Maybe Die) Markup
  | AttackStep Markup Markup
  | InsetStep StepType (Maybe Die) Markup Inset
