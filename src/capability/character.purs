module ToA.Capability.Character
  ( class Character
  , saveChar
  , deleteChar
  , readChars
  ) where

import Prelude

import Data.Codec.JSON (Codec, decode, encode)
import Data.Codec.JSON.Common (map) as CJC
import Data.Either (hush)
import Data.Lens ((^.), (.~))
import Data.Lens.At (at)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, empty, singleton)
import Data.Maybe (Maybe(..), maybe)
import JSON (parse, print)

import Halogen (HalogenM, lift)
import Halogen.Store.Monad (updateStore)

import ToA.ToAM (ToAM)
import ToA.Capability.Log (debug)
import ToA.Capability.Storage (read, write)
import ToA.Data.Icon.Character (Character, jsonCharacter)
import ToA.Data.Icon.Name (Name, _name, jsonName)

class Character m where
  saveChar :: Character -> m Unit
  deleteChar :: Character -> m Unit
  readChars :: m (Maybe (Map Name Character))

charMap :: Codec (Map Name Character)
charMap = CJC.map jsonName jsonCharacter

instance Character ToAM where
  saveChar char = do
    debug $ "save character: " <> char ^. _name <<< _Newtype
    chars <- readChars
    let
      newChars = case chars of
        Nothing -> singleton (char ^. _name) char
        Just cs -> cs # at (char ^. _name) .~ pure char
    updateStore _ { characters = newChars }
    write "characters" $ print $ encode charMap newChars

  deleteChar char = do
    debug $ "delete character: " <> char ^. _name <<< _Newtype
    chars <- readChars
    let newChars = chars # maybe empty (at (char ^. _name) .~ Nothing)
    updateStore _ { characters = newChars }
    write "characters" $ print $ encode charMap newChars

  readChars = do
    debug $ "read storage characters"
    read "characters"
      <#> (_ >>= (parse >>> hush >=> decode charMap >>> hush))

instance (Monad m, Character m) => Character (HalogenM s a sl o m) where
  saveChar = lift <<< saveChar
  deleteChar = lift <<< deleteChar
  readChars = lift readChars
