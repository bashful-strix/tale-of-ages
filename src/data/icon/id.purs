module ToA.Data.Icon.Id
  ( Id(..)
  , class Identified
  , _id
  , jsonId
  ) where

import Prelude

import Data.Codec.JSON (Codec, coercible, string)
import Data.Lens (Lens')
import Data.Newtype (class Newtype)


-- convention: name|type|modifier

newtype Id = Id String

derive instance Newtype Id _
derive newtype instance Eq Id
derive newtype instance Ord Id

class Identified a where
  _id :: Lens' a Id

jsonId :: Codec Id
jsonId = coercible "Id" string
