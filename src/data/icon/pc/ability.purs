module ToA.Data.Icon.Pc.Ability
  ( Ability(..)
  , _Ability
  , _LimitBreak
  , _action
  , _resolve
  , _steps
  , _tags
  ) where

import ToA.Prelude

import Data.Lens (Lens', view, _1, _2)
import Data.Lens.AffineTraversal (AffineTraversal')
import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability (AbilityData, Action, Step, Tag)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (class Named, Name, _name)

import ToA.Util.Optic (key)

data Ability
  = Ability
      { colour :: Name
      , description :: Markup
      | AbilityData Action + ()
      }
  | LimitBreak
      { colour :: Name
      , description :: Markup
      | AbilityData (Action /\ Int) + ()
      }

instance Eq Ability where
  eq (Ability { name: n }) (Ability { name: m }) = n == m
  eq (LimitBreak { name: n }) (LimitBreak { name: m }) = n == m
  eq _ _ = false

instance Ord Ability where
  compare a b =
    let
      ac = comparing (view _action) a b
    in
      if ac == EQ then comparing (view _name) a b
      else ac

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

_Ability
  :: Prism'
       Ability
       { colour :: Name
       , description :: Markup
       | AbilityData Action + ()
       }
_Ability = prism' Ability case _ of
  Ability a -> Just a
  _ -> Nothing

_LimitBreak
  :: Prism'
       Ability
       { colour :: Name
       , description :: Markup
       | AbilityData (Action /\ Int) + ()
       }
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
