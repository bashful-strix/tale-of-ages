module ToA.ToAM
  ( ToAM
  , runToAM
  ) where

import Prelude

import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)

import Halogen.Component (Component)
import Halogen.Store.Monad (class MonadStore, StoreT, runStoreT)

import Safe.Coerce (coerce)

import ToA.Data.Store (Store, StoreAction, reduce)

newtype ToAM a = ToAM (StoreT StoreAction Store Aff a)

derive newtype instance Functor ToAM
derive newtype instance Apply ToAM
derive newtype instance Applicative ToAM
derive newtype instance Bind ToAM
derive newtype instance Monad ToAM
derive newtype instance MonadEffect ToAM
derive newtype instance MonadAff ToAM
derive newtype instance MonadStore StoreAction Store ToAM

runToAM
  :: ∀ q i o
   . Store
  -> Component q i o ToAM
  -> Aff (Component q i o Aff)
runToAM store = runStoreT store reduce <<< coerce
