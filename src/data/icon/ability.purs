module ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)

newtype Ability = Ability
  { name :: Name
  , description :: Markup
  , action :: Action
  , tags :: Array Tag
  , summon :: Maybe Name
  , sub :: Maybe Name
  , steps :: Array Step
  }

derive instance Newtype Ability _
instance Eq Ability where
  eq (Ability { name: n }) (Ability { name: m }) = n == m

instance Named Ability where
  getName (Ability { name }) = name
  setName (Ability a) n = Ability a { name = n }

instance Described Ability Markup where
  getDesc (Ability { description }) = description
  setDesc (Ability a) d = Ability a { description = d }

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
  | Close
  | End
  | RangeTag Range
  | AreaTag Pattern
  | TargetTag Target
  | KeywordTag Name

data Damage
  = Flat Int
  | Roll Int Die

data StepType
  = Eff Markup
  | AttackStep (Maybe Damage) (Maybe Damage)
  | OnHit Markup
  | AreaEff Markup
  | KeywordStep Name Markup
  | TriggerStep Markup
  | OtherStep Markup Markup

data Step
  = Step StepType
  | RollStep StepType
