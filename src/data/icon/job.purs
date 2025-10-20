module ToA.Data.Icon.Job
  ( Job(..)
  , JobLevel(..)
  ) where

import Prelude

import Data.FastVect.FastVect (Vect)
import Data.Tuple.Nested (type (/\))

import ToA.Data.Icon.Name (Name)

data Job = Job
  { name :: Name
  , soul :: Name
  , class :: Name
  , description :: String
  , trait :: Name
  , keyword :: Name
  , abilities :: Vect 4 (JobLevel /\ Name)
  , limitBreak :: Name
  , talents :: Vect 3 Name
  }

instance Eq Job where
  eq (Job { name: n }) (Job { name: m }) = n == m

data JobLevel
  = One
  | Two
  | Three
  | Four
