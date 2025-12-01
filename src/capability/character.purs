module ToA.Capability.Character
  ( CharacterF
  , CHAR

  , runCharacter

  , save
  , delete
  , readStorage
  ) where

import Prelude

import Data.Codec.JSON (Codec, decode, encode)
import Data.Codec.JSON.Common (map) as CJC
import Data.Either (hush)
import Data.Lens ((^.), (.~))
import Data.Lens.At (at)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, empty, singleton)
import Data.Maybe (Maybe(..))
import JSON (parse, print)

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import ToA.Capability.Log (LOG, debug)
import ToA.Capability.Storage (STORAGE, read, write)
import ToA.Data.Icon.Character (Character, jsonCharacter)
import ToA.Data.Icon.Name (Name, _name, jsonName)

data CharacterF a
  = Save Character a
  | Delete Character a
  | ReadStorage (Maybe (Map Name Character) -> a)

derive instance Functor CharacterF

type CHAR r = (char :: CharacterF | r)
_char = Proxy :: Proxy "char"

save :: ∀ r. Character -> Run (CHAR + r) Unit
save char = lift _char (Save char unit)

delete :: ∀ r. Character -> Run (CHAR + r) Unit
delete char = lift _char (Delete char unit)

readStorage :: ∀ r. Run (CHAR + r) (Maybe (Map Name Character))
readStorage = lift _char (ReadStorage identity)

charMap :: Codec (Map Name Character)
charMap = CJC.map jsonName jsonCharacter

browserChar :: ∀ r. CharacterF ~> Run (EFFECT + LOG + STORAGE + r)
browserChar = case _ of
  Save char next -> do
    debug $ "save character: " <> char ^. _name <<< _Newtype
    cs <- read "characters"
    write "characters" $ print $ encode charMap $
      case cs >>= parse >>> hush >>= decode charMap >>> hush of
        Nothing -> singleton (char ^. _name) char
        Just chars -> chars # at (char ^. _name) .~ pure char
    pure next

  Delete char next -> do
    debug $ "delete character: " <> char ^. _name <<< _Newtype
    cs <- read "characters"
    write "characters" $ print $ encode charMap $
      case cs >>= parse >>> hush >>= decode charMap >>> hush of
        Nothing -> empty
        Just chars -> chars # at (char ^. _name) .~ Nothing
    pure next

  ReadStorage reply -> do
    debug $ "read storage characters"
    read "characters"
      <#> reply <<< (_ >>= (parse >>> hush >=> decode charMap >>> hush))

runCharacter
  :: ∀ r. Run (EFFECT + LOG + STORAGE + CHAR + r) ~> Run (EFFECT + LOG + STORAGE + r)
runCharacter = interpret (on _char browserChar send)
