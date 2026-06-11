module ToA.Data.Store
  ( Store
  , StoreAction
  , reduce
  ) where

import Data.Map (Map)
import Data.Maybe (Maybe)

import Routing.PushState (PushStateInterface)

import ToA.Data.Log (Level)
import ToA.Data.Route (Route)
import ToA.Data.Theme (Theme)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Character (Character)
import ToA.Data.Icon.Encounter (Encounter)
import ToA.Data.Icon.Name (Name)

type Store =
  { icon :: Icon
  , characters :: Map Name Character
  , encounters :: Map Name Encounter
  , route :: Maybe Route
  , systemTheme :: Theme
  , theme :: Maybe Theme

  , logLevel :: Level
  , history :: PushStateInterface
  }
type StoreAction = Store -> Store

reduce :: Store -> StoreAction -> Store
reduce s f = f s
