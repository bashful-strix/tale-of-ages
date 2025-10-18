module ToA.Capability.Env
  ( ENV

  , runEnv

  , env
  , envs
  ) where

import Prelude

import Run (Run)
import Run.Reader (Reader, askAt, asksAt, runReaderAt)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Data.Env (Env)

type ENV r = (env :: Reader Env | r)
_env = Proxy :: Proxy "env"

env :: ∀ r. Run (ENV + r) Env
env = askAt _env

envs :: ∀ r a. (Env -> a) -> Run (ENV + r) a
envs = asksAt _env

runEnv :: ∀ r. Env -> Run (ENV + r) ~> Run r
runEnv = runReaderAt _env
