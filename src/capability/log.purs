module ToA.Capability.Log
  ( class Log
  , log
  , error
  , warn
  , info
  , debug
  ) where

import ToA.Prelude

import Effect.Class (liftEffect)
import Effect.Console as Console

import Halogen (HalogenM, lift)
import Halogen.Store.Monad (getStore)

import ToA.ToAM (ToAM)
import ToA.Data.Log (Level(..))

class Log m where
  log :: Level -> String -> m Unit

error :: ∀ m. Log m =>  String -> m Unit
error = log Error

warn :: ∀ m. Log m => String -> m Unit
warn = log Warn

info :: ∀ m. Log m => String -> m Unit
info = log Info

debug :: ∀ m. Log m => String -> m Unit
debug = log Debug

instance Log ToAM where
  log lvl msg = do
    { logLevel } <- getStore
    when
      (lvl >= logLevel)
      $ liftEffect
      $ show lvl <> " " <> msg # case lvl of
          Debug -> Console.debug
          Info -> Console.info
          Warn -> Console.warn
          Error -> Console.error

instance (Monad m, Log m) => Log (HalogenM s a sl o m) where
  log = lift <.. log
