module ToA.Data.Icon.Class
  ( Class(..)
  ) where

import Prelude

import ToA.Data.Icon.Name (Name)

data Class = Class
  { name :: Name
  , tagline :: String
  , strengths :: String
  , weaknesses :: String
  , complexity :: String
  , description :: String
  , move :: Int
  , hp :: Int
  , defense :: Int
  , trait :: Name
  , basic :: Name
  , keywords :: Array Name
  , apprentice :: Array Name
  }

instance Eq Class where
  eq (Class { name: n }) (Class { name: m }) = n == m
