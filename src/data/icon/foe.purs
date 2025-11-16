module ToA.Data.Icon.Foe
  ( Foe(..)
  , FoeAbility(..)
  , FoeTrait(..)
  , FoeClass(..)
  , FoeInsert(..)
  , Faction(..)
  ) where

import Prelude

import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (Action, Step, Tag)
import ToA.Data.Icon.Chapter (Chapter)
import ToA.Data.Icon.Name (Name, class Named)
import ToA.Data.Icon.Markup (Markup)
import ToA.Util.Optic (key)

data Foe
  = Foe
      { name :: Name
      , colour :: Name
      , class :: Name
      , faction :: Maybe Name
      , chapter :: Maybe Chapter
      , description :: Markup
      , notes :: Markup
      , traits :: Array FoeTrait
      , abilities :: Array FoeAbility
      }
  | Mob
      { name :: Name
      , colour :: Name
      , class :: Name
      , faction :: Maybe Name
      , description :: Markup
      , notes :: Markup
      , traits :: Array FoeTrait
      , abilities :: Array FoeAbility
      }
  | Elite
      { name :: Name
      , colour :: Name
      , class :: Name
      , faction :: Maybe Name
      , chapter :: Maybe Chapter
      , description :: Markup
      , notes :: Markup
      , hp :: Int
      , defense :: Int
      , move :: Int
      , traits :: Array FoeTrait
      , abilities :: Array FoeAbility
      }
  | Legend
      { name :: Name
      , colour :: Name
      , class :: Name
      , faction :: Maybe Name
      , chapter :: Maybe Chapter
      , description :: Markup
      , notes :: Markup
      , tactics :: Markup
      , traits :: Array FoeTrait
      , roundActions :: Array FoeTrait
      , phases ::
          { description :: Markup
          , details :: Array
              { description :: Markup
              , traits :: Array FoeTrait
              , roundActions :: Array FoeTrait
              , abilities :: Array FoeAbility
              }
          }
      }

instance Named Foe where
  _name = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"name"

newtype FoeClass = FoeClass
  { name :: Name
  , colour :: Name
  , description :: Markup
  , hp :: Int
  , defense :: Int
  , move :: Int
  , traits :: Array FoeTrait
  , roundActions :: Array FoeTrait
  , abilities :: Array FoeAbility
  }

derive instance Newtype FoeClass _

instance Named FoeClass where
  _name = _Newtype <<< key @"name"

data FoeInsert
  = AbilityInsert
      { name :: Name
      , colour :: Name
      , cost :: Action
      , tags :: Array Tag
      , steps :: Array Step
      }
  | SummonInsert
      { name :: Name
      , colour :: Name
      , max :: Int
      , effects :: Array Markup
      }

newtype FoeAbility = FoeAbility
  { name :: Name
  , cost :: Action
  , tags :: Array Tag
  , description :: Markup
  , chain :: Maybe FoeAbility
  , insert :: Maybe FoeInsert
  }

newtype FoeTrait = FoeTrait
  { name :: Name
  , description :: Markup
  }

derive instance Newtype FoeTrait _

newtype Faction = Faction
  { name :: Name
  , description :: Markup
  , template ::
      { description :: Markup
      , traits :: Array Name
      }
  , mechanic ::
      { name :: Name
      , description :: Markup
      }
  , keywords :: Array Name
  }

derive instance Newtype Faction _

instance Named Faction where
  _name = _Newtype <<< key @"name"
