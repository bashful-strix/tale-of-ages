module ToA.Data.Icon.Ability
  ( Action(..)
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

  , class Abilitied
  , _abilities
  ) where

import Prelude

import Data.Array.NonEmpty (NonEmptyArray)
import Data.Lens (Lens')
import Data.Lens.AffineTraversal (AffineTraversal')
import Data.Maybe (Maybe)

import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name)

type AbilityData a r =
  ( name :: Name
  , cost :: a
  , tags :: Array Tag
  , steps :: Array Step
  | r
  )

data Variable
  = NumVar Int
  | RollVar Int Die
  | OtherVar String

derive instance Eq Variable
derive instance Ord Variable

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
derive instance Ord Action

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
  | Character

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

class Abilitied a b | a -> b where
  _abilities :: Lens' a b
