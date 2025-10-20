module ToA.Data.Icon.Class
  ( Class
  ) where

import ToA.Data.Icon.Name (Name)
import ToA.Data.Icon.Trait (Trait)

type Class =
  { name :: Name
  , tagline :: String
  , strengths :: String
  , weaknesses :: String
  , complexity :: String
  , description :: String
  , move :: Int
  , hp :: Int
  , defense :: Int
  , trait :: Trait
  , basic :: Name
  , keywords :: Array Name
  , apprentice :: Array Name
  }
