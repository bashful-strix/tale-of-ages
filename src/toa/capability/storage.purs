module ToA.Capability.Storage
  ( StorageF
  , STORAGE

  , runStorage

  , read
  , write
  , delete
  ) where

import Prelude

import Data.Maybe (Maybe)
import Effect.Class (liftEffect)

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import Web.Storage.Storage (Storage, getItem, removeItem, setItem)

import ToA.Capability.Log (LOG, debug)

data StorageF a
  = Read String (Maybe String -> a)
  | Write String String a
  | Delete String a

derive instance Functor StorageF

type STORAGE r = (storage :: StorageF | r)
_storage = Proxy :: Proxy "storage"

read :: ∀ r. String -> Run (STORAGE + r) (Maybe String)
read key = lift _storage (Read key identity)

write :: ∀ r. String -> String -> Run (STORAGE + r) Unit
write key value = lift _storage (Write key value unit)

delete :: ∀ r. String -> Run (STORAGE + r) Unit
delete key = lift _storage (Delete key unit)

localStorage :: ∀ r. Storage -> StorageF ~> Run (EFFECT + LOG + r)
localStorage storage = case _ of
  Read key reply -> do
    debug $ "read storage: " <> key
    item <- liftEffect $ getItem key storage
    pure $ reply item

  Write key value next -> do
    debug $ "write storage: " <> key <> " | " <> value
    liftEffect $ setItem key value storage
    pure next

  Delete key next -> do
    debug $ "delete storage: " <> key
    liftEffect $ removeItem key storage
    pure next

runStorage
  :: ∀ r
   . Storage
  -> Run (EFFECT + LOG + STORAGE + r) ~> Run (EFFECT + LOG + r)
runStorage storage = interpret (on _storage (localStorage storage) send)
