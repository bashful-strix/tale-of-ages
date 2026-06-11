module ToA.Data.Icon.Foe.Job
  ( FoeJob(..)
  , FoeJobData
  , _faction
  , _chapter
  , _hp
  , _maxVigor
  , _defense
  , _move
  , _Foe
  , _Elite
  , _Mob
  , _members
  , _notes
  , _Legend
  , _tactics
  , _trophies
  , _phases
  , _specials

  , Phase(..)
  , Phases(..)

  , Special(..)
  , Specials(..)

  , class Detailed
  , _details
  ) where

import ToA.Prelude

import Data.Function (on)
import Data.Lens (Lens', view)
import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)

import ToA.Data.Icon.Ability (class Abilitied)
import ToA.Data.Icon.Chapter (Chapter)
import ToA.Data.Icon.Class (class Classed)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Name (class Named, Name, _name)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Trait (class Traited)

import ToA.Data.Icon.Foe.Ability (FoeAbility)
import ToA.Data.Icon.Foe.Trait (FoeTrait)

import ToA.Util.Optic (key)

class Detailed a b | a -> b where
  _details :: Lens' a b

newtype Phase = Phase
  { description :: Markup
  , traits :: Array FoeTrait
  , abilities :: Array FoeAbility
  }

derive instance Newtype Phase _

instance Described Phase where
  _desc = _Newtype <. key @"description"

instance Traited Phase (Array FoeTrait) where
  _trait = _Newtype <. key @"traits"

instance Abilitied Phase (Array FoeAbility) where
  _abilities = _Newtype <. key @"abilities"

newtype Phases = Phases
  { description :: Markup
  , details :: Array Phase
  }

derive instance Newtype Phases _

instance Described Phases where
  _desc = _Newtype <. key @"description"

instance Detailed Phases (Array Phase) where
  _details = _Newtype <. key @"details"

newtype Special = Special
  { name :: Name
  , description :: Markup
  , traits :: Array FoeTrait
  , abilities :: Array FoeAbility
  }

derive instance Newtype Special _

instance Named Special where
  _name = _Newtype <. key @"name"

instance Described Special where
  _desc = _Newtype <. key @"description"

instance Traited Special (Array FoeTrait) where
  _trait = _Newtype <. key @"traits"

instance Abilitied Special (Array FoeAbility) where
  _abilities = _Newtype <. key @"abilities"

newtype Specials = Specials
  { name :: Name
  , description :: Markup
  , details :: Array Special
  }

derive instance Newtype Specials _

instance Named Specials where
  _name = _Newtype <. key @"name"

instance Described Specials where
  _desc = _Newtype <. key @"description"

instance Detailed Specials (Array Special) where
  _details = _Newtype <. key @"details"

type FoeJobData r =
  ( name :: Name
  , colour :: Name
  , class :: Name
  , faction :: Maybe Name
  , chapter :: Chapter
  , description :: Markup
  , hp :: Maybe Int
  , maxVigor :: Maybe Int
  , defense :: Maybe Int
  , move :: Maybe Int
  , traits :: Array FoeTrait
  , abilities :: Array FoeAbility
  | r
  )

data FoeJob
  = Foe { | FoeJobData + () }
  | Elite { | FoeJobData + () }
  | Mob { members :: Int, notes :: Markup | FoeJobData + () }
  | Legend
      { tactics :: Markup
      , trophies :: Array Name
      , phases :: Phases
      , specials :: Maybe Specials
      | FoeJobData + ()
      }

instance Eq FoeJob where
  eq = eq `on` view _name

instance Ord FoeJob where
  compare = compare `on` view _name

instance Named FoeJob where
  _name = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"name"

instance Coloured FoeJob where
  _colour = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"colour"

instance Described FoeJob where
  _desc = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"description"

instance Classed FoeJob where
  _class = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"class"

instance Traited FoeJob (Array FoeTrait) where
  _trait = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"traits"

instance Abilitied FoeJob (Array FoeAbility) where
  _abilities = lens' case _ of
    Foe a -> map Foe <$> lensStore k a
    Elite a -> map Elite <$> lensStore k a
    Mob a -> map Mob <$> lensStore k a
    Legend a -> map Legend <$> lensStore k a
    where
    k = key @"abilities"

_faction :: Lens' FoeJob (Maybe Name)
_faction = lens' case _ of
  Foe a -> map Foe <$> lensStore k a
  Elite a -> map Elite <$> lensStore k a
  Mob a -> map Mob <$> lensStore k a
  Legend a -> map Legend <$> lensStore k a
  where
  k = key @"faction"

_chapter :: Lens' FoeJob Chapter
_chapter = lens' case _ of
  Foe a -> map Foe <$> lensStore k a
  Elite a -> map Elite <$> lensStore k a
  Mob a -> map Mob <$> lensStore k a
  Legend a -> map Legend <$> lensStore k a
  where
  k = key @"chapter"

_hp :: Lens' FoeJob (Maybe Int)
_hp = lens' case _ of
  Foe a -> map Foe <$> lensStore k a
  Elite a -> map Elite <$> lensStore k a
  Mob a -> map Mob <$> lensStore k a
  Legend a -> map Legend <$> lensStore k a
  where
  k = key @"hp"

_maxVigor :: Lens' FoeJob (Maybe Int)
_maxVigor = lens' case _ of
  Foe a -> map Foe <$> lensStore k a
  Elite a -> map Elite <$> lensStore k a
  Mob a -> map Mob <$> lensStore k a
  Legend a -> map Legend <$> lensStore k a
  where
  k = key @"maxVigor"

_defense :: Lens' FoeJob (Maybe Int)
_defense = lens' case _ of
  Foe a -> map Foe <$> lensStore k a
  Elite a -> map Elite <$> lensStore k a
  Mob a -> map Mob <$> lensStore k a
  Legend a -> map Legend <$> lensStore k a
  where
  k = key @"defense"

_move :: Lens' FoeJob (Maybe Int)
_move = lens' case _ of
  Foe a -> map Foe <$> lensStore k a
  Elite a -> map Elite <$> lensStore k a
  Mob a -> map Mob <$> lensStore k a
  Legend a -> map Legend <$> lensStore k a
  where
  k = key @"move"

_Foe :: Prism' FoeJob { | FoeJobData + () }
_Foe = prism' Foe case _ of
  Foe f -> Just f
  _ -> Nothing

_Elite
  :: Prism' FoeJob { | FoeJobData + () }
_Elite = prism' Elite case _ of
  Elite f -> Just f
  _ -> Nothing

_Mob :: Prism' FoeJob { members :: Int, notes :: Markup | FoeJobData + () }
_Mob = prism' Mob case _ of
  Mob f -> Just f
  _ -> Nothing

_members :: Lens' { members :: Int, notes :: Markup | FoeJobData + () } Int
_members = key @"members"

_notes :: Lens' { members :: Int, notes :: Markup | FoeJobData + () } Markup
_notes = key @"notes"

_Legend
  :: Prism' FoeJob
       { tactics :: Markup
       , trophies :: Array Name
       , phases :: Phases
       , specials :: Maybe Specials
       | FoeJobData + ()
       }
_Legend = prism' Legend case _ of
  Legend f -> Just f
  _ -> Nothing

_tactics
  :: Lens'
       { tactics :: Markup
       , trophies :: Array Name
       , phases :: Phases
       , specials :: Maybe Specials
       | FoeJobData + ()
       }
       Markup
_tactics = key @"tactics"

_trophies
  :: Lens'
       { tactics :: Markup
       , trophies :: Array Name
       , phases :: Phases
       , specials :: Maybe Specials
       | FoeJobData + ()
       }
       (Array Name)
_trophies = key @"trophies"

_phases
  :: Lens'
       { tactics :: Markup
       , trophies :: Array Name
       , phases :: Phases
       , specials :: Maybe Specials
       | FoeJobData + ()
       }
       Phases
_phases = key @"phases"

_specials
  :: Lens'
       { tactics :: Markup
       , trophies :: Array Name
       , phases :: Phases
       , specials :: Maybe Specials
       | FoeJobData + ()
       }
       (Maybe Specials)
_specials = key @"specials"
