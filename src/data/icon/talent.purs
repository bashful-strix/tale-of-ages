module ToA.Data.Icon.Talent
  ( Talent(..)
  , TalentData
  , _Talent
  , _InsetTalent
  ) where

import Prelude

import Data.Lens.Lens (lens', lensStore)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))

import Type.Row (type (+))

import ToA.Data.Icon.Ability (class Inseted, Inset)
import ToA.Data.Icon.Colour (class Coloured)
import ToA.Data.Icon.Description (class Described)
import ToA.Data.Icon.Id (class Identified, Id)
import ToA.Data.Icon.Markup (Markup)
import ToA.Data.Icon.Name (class Named, Name)
import ToA.Util.Optic (key)

type TalentData r =
  ( id :: Id
  , name :: Name
  , colour :: Name
  , description :: Markup
  | r
  )

data Talent
  = Talent { | TalentData + ()}
  | InsetTalent { inset :: Inset | TalentData + () }

instance Eq Talent where
  eq (Talent { id: a }) (Talent { id: b }) = a == b
  eq (InsetTalent { id: a }) (InsetTalent { id: b }) = a == b
  eq _ _ = false

instance Identified Talent where
  _id = lens' case _ of
    Talent a -> map Talent <$> lensStore k a
    InsetTalent a -> map InsetTalent <$> lensStore k a
    where
    k = key @"id"

instance Named Talent where
  _name = lens' case _ of
    Talent a -> map Talent <$> lensStore k a
    InsetTalent a -> map InsetTalent <$> lensStore k a
    where
    k = key @"name"

instance Coloured Talent where
  _colour = lens' case _ of
    Talent a -> map Talent <$> lensStore k a
    InsetTalent a -> map InsetTalent <$> lensStore k a
    where
    k = key @"colour"

instance Described Talent where
  _desc = lens' case _ of
    Talent a -> map Talent <$> lensStore k a
    InsetTalent a -> map InsetTalent <$> lensStore k a
    where
    k = key @"description"

instance Inseted Talent where
  _inset = _InsetTalent <<< key @"inset"

_Talent :: Prism' Talent ({ | TalentData + () })
_Talent = prism' Talent case _ of
  Talent a -> Just a
  _ -> Nothing

_InsetTalent :: Prism' Talent ({ inset :: Inset | TalentData + () })
_InsetTalent = prism' InsetTalent case _ of
  InsetTalent a -> Just a
  _ -> Nothing
