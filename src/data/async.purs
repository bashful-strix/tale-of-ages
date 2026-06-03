module ToA.Data.Async
  ( AsyncData(..)
  , fromEither
  ) where

import Prelude
import Data.Either (Either(..))

data AsyncData e a
  = NotAsked
  | Loading
  | Error e
  | Success a

instance Functor (AsyncData e) where
  map f (Success a) = Success (f a)
  map _ NotAsked = NotAsked
  map _ Loading = Loading
  map _ (Error e) = Error e

instance Apply (AsyncData e) where
  apply (Success f) a = f <$> a
  apply NotAsked _ = NotAsked
  apply Loading _ = Loading
  apply (Error e) _ = Error e

instance Applicative (AsyncData e) where
  pure = Success

instance Bind (AsyncData e) where
  bind (Success a) f = f a
  bind NotAsked _ = NotAsked
  bind Loading _ = Loading
  bind (Error e) _ = Error e

instance Monad (AsyncData e)

fromEither :: ∀ e a. Either e a -> AsyncData e a
fromEither (Left e) = Error e
fromEither (Right e) = Success e
