module ToA.Data.Icon.Foe.Ability
  ( FoeAbility(..)
  , Ability(..)
  , _action
  , _steps
  , _tags
  ) where

import ToA.Prelude

import Data.Lens (Lens')
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (AbilityData, Action, Step, Tag)
import ToA.Data.Icon.Name (class Named)

import ToA.Util.Optic (key)

data FoeAbility
  = FoeAbility Ability
  | ChainAbility (Array Ability)

newtype Ability = Ability { | AbilityData Action + () }

derive instance Newtype Ability _

instance Named Ability where
  _name = _Newtype <. key @"name"

_action :: Lens' Ability Action
_action = _Newtype <. key @"cost"

_tags :: Lens' Ability (Array Tag)
_tags = _Newtype <. key @"tags"

_steps :: Lens' Ability (Array Step)
_steps = _Newtype <. key @"steps"
