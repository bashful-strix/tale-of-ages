module ToA.Data.Icon.Encounter
  ( Encounter(..)
  , FoeEntry(..)
  ) where

import Prelude

import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Util.Optic (key)

newtype FoeEntry = FoeEntry
  { name :: Name
  , alias :: Maybe String
  , count :: Int
  , faction :: Maybe Name
  , template :: Maybe Name
  }

newtype Encounter = Encounter
  { name :: Name
  , notes :: Markup
  , foes :: Array FoeEntry
  , reserves :: Array FoeEntry
  }

derive instance Newtype Encounter _

instance Named Encounter where
  _name = _Newtype <<< key @"name"
