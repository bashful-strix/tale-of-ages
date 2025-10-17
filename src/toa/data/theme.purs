module ToA.Data.Theme (Theme(..), themeCodec) where

import Prelude

import Data.Codec (Codec', codec')
import Data.Maybe (Maybe(..))

data Theme = Light | Dark

derive instance Eq Theme

themeCodec :: Codec' Maybe String Theme
themeCodec = codec' dec enc
  where
  dec = case _ of
    "light" -> Just Light
    "dark" -> Just Dark
    _ -> Nothing
  enc = case _ of
    Light -> "light"
    Dark -> "dark"
