module ToA.Data.Env
  ( Env
  , EnvAction(..)
  , initialEnv
  , reduce
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Theme (Theme(..))
import ToA.Data.Route (Route)

type Env =
  { route :: Maybe Route
  , systemTheme :: Theme
  , theme :: Maybe Theme
  }

data EnvAction
  = SetRoute (Maybe Route)
  | SetSystemTheme Theme
  | SetTheme (Maybe Theme)

initialEnv :: Env
initialEnv =
  { route: Nothing
  , systemTheme: Light
  , theme: Nothing
  }

reduce :: Env -> EnvAction -> Env
reduce env = case _ of
  SetRoute route -> env { route = route }
  SetSystemTheme theme -> env { systemTheme = theme }
  SetTheme theme -> env { theme = theme }
