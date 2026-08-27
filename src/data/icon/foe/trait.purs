module ToA.Data.Icon.Foe.Trait
  ( FoeTrait(..)
  , _FoeTrait
  , _RoundAction
  ) where

import ToA.Prelude

import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Trait (class Traited, Trait)

data FoeTrait
  = FoeTrait Trait
  | RoundAction Trait

instance Traited FoeTrait Trait where
  _trait = lens' case _ of
    FoeTrait t -> map FoeTrait <$> lensStore identity t
    RoundAction a -> map RoundAction <$> lensStore identity a

_FoeTrait :: Prism' FoeTrait Trait
_FoeTrait = prism' FoeTrait case _ of
  FoeTrait t -> Just t
  _ -> Nothing

_RoundAction :: Prism' FoeTrait Trait
_RoundAction = prism' RoundAction case _ of
  RoundAction t -> Just t
  _ -> Nothing
