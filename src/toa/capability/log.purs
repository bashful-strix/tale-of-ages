module ToA.Capability.Log
  ( LogF
  , LOG

  , runLog

  , log
  , error
  , warn
  , info
  , debug
  ) where

import Prelude

import Effect.Class (liftEffect)
import Effect.Console as Console

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Data.Log (Level(..))

data LogF a = Log Level String a

derive instance Functor LogF

type LOG r = (log :: LogF | r)
_log = Proxy :: Proxy "log"

log :: ∀ r. Level -> String -> Run (LOG + r) Unit
log lvl msg = lift _log (Log lvl msg unit)

error :: ∀ r. String -> Run (LOG + r) Unit
error = log Error

warn :: ∀ r. String -> Run (LOG + r) Unit
warn = log Warn

info :: ∀ r. String -> Run (LOG + r) Unit
info = log Info

debug :: ∀ r. String -> Run (LOG + r) Unit
debug = log Debug

consoleLog :: ∀ r. Level -> LogF ~> Run (EFFECT + r)
consoleLog logLevel (Log lvl msg next) = do
  when
    (lvl >= logLevel)
    $ liftEffect
    $ show lvl <> " " <> msg # case lvl of
        Error -> Console.error
        Warn -> Console.warn
        Info -> Console.info
        Debug -> Console.debug
  pure next

runLog :: ∀ r. Level -> Run (EFFECT + LOG + r) ~> Run (EFFECT + r)
runLog logLevel = interpret (on _log (consoleLog logLevel) send)
