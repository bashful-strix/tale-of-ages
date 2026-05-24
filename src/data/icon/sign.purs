module ToA.Data.Icon.Sign
  ( class Signed
  , Sign(..)
  , _sign
  , jsonSign
  ) where

import Prelude

import Data.Codec.JSON (Codec, coercible, string)
import Data.Lens (Lens')
import Data.Newtype (class Newtype)

newtype Sign = Sign String

derive instance Newtype Sign _
derive newtype instance Eq Sign
derive newtype instance Ord Sign

class Signed a where
  _sign :: Lens' a Sign

jsonSign :: Codec Sign
jsonSign = coercible "Sign" string
