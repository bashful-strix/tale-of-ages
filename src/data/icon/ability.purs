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

  , _action
  , _steps
  , _sub
  , _summon
  , _tags
  ) where

import Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

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

_action :: Lens' Ability Action
_action = _Newtype <<< key @"action"

_tags :: Lens' Ability (Array Tag)
_tags = _Newtype <<< key @"tags"

_summon :: Lens' Ability (Maybe Name)
_summon = _Newtype <<< key @"summon"

_sub :: Lens' Ability (Maybe Name)
_sub = _Newtype <<< key @"sub"

_steps :: Lens' Ability (Array Step)
_steps = _Newtype <<< key @"steps"

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

data Step = Step (Maybe Die) StepType
