module ToA.Data.Env
  ( Env
  , EnvAction(..)
  , initialEnv
  , reduce
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Theme (Theme(..))

type Env =
  { systemTheme :: Theme
  , theme :: Maybe Theme
  }

data EnvAction
  = SetSystemTheme Theme
  | SetTheme (Maybe Theme)

initialEnv :: Env
initialEnv =
  { systemTheme: Light
  , theme: Nothing
  }

reduce :: Env -> EnvAction -> Env
reduce env = case _ of
  SetSystemTheme theme -> env { systemTheme = theme }
  SetTheme theme -> env { theme = theme }
