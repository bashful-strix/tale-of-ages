module ToA.ToAM
  ( ToAM
  , Store
  , StoreAction
  , runToAM
  , liftRun
  ) where

import Prelude

import Control.Monad.Trans.Class (lift)
import Data.Map (Map)
import Data.Maybe (Maybe)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Effect.Class (class MonadEffect)
import Halogen (HalogenM, hoist)
import Halogen.Component (Component)
import Halogen.Store.Monad (class MonadStore, StoreT, runStoreT)
import Run (Run, AFF, EFFECT, runBaseAff')
import Type.Row (type (+))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Character (Character)
import ToA.Data.Icon.Encounter (Encounter)
import ToA.Data.Icon.Name (Name)
import ToA.Data.Route (Route)
import ToA.Data.Theme (Theme)

type Store =
  { icon :: Icon
  , characters :: Map Name Character
  , encounters :: Map Name Encounter
  , route :: Maybe Route
  , systemTheme :: Theme
  , theme :: Maybe Theme
  }
type StoreAction = Store -> Store

reduce :: Store -> StoreAction -> Store
reduce s f = f s

newtype ToAM r a = ToAM (StoreT StoreAction Store (Run (AFF + EFFECT + r)) a)

derive newtype instance Functor (ToAM r)
derive newtype instance Apply (ToAM r)
derive newtype instance Applicative (ToAM r)
derive newtype instance Bind (ToAM r)
derive newtype instance Monad (ToAM r)
derive newtype instance MonadEffect (ToAM r)
derive newtype instance MonadAff (ToAM r)
derive newtype instance MonadStore StoreAction Store (ToAM r)

liftRun
  :: ∀ r st act sl o
   . Run (AFF + EFFECT + r) ~> HalogenM st act sl o (ToAM r)
liftRun = lift <<< ToAM <<< lift

runToAM
  :: ∀ r q i o
   . Store
  -> (Run (AFF + EFFECT + r) ~> Run (AFF + EFFECT + ()))
  -> Component q i o (ToAM r)
  -> Aff (Component q i o Aff)
runToAM store runEffects =
  hoist (\(ToAM m) -> m)
    >>> runStoreT store reduce
    >>> map (hoist (runBaseAff' <<< runEffects))
