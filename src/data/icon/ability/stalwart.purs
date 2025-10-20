module ToA.Data.Icon.Ability.Stalwart
  ( furor
  , interpose
  , impel
  , hook
  , mightyHew
  , secondWind
  , shatter
  ) where

import Prelude

import ToA.Data.Icon.Ability (Ability(..))
import ToA.Data.Icon.Name (Name(..))

furor :: Ability
furor = Ability $ Name "Furor"

interpose :: Ability
interpose = Ability $ Name "Interpose"

impel :: Ability
impel = Ability $ Name "Impel"

hook :: Ability
hook = Ability $ Name "Hook"

mightyHew :: Ability
mightyHew = Ability $ Name "Mighty Hew"

secondWind :: Ability
secondWind = Ability $ Name "Second Wind"

shatter :: Ability
shatter = Ability $ Name "Shatter"
