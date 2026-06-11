module ToA.Capability.Theme
  ( class Theme
  , saveTheme
  , readTheme
  , systemTheme
  ) where

import Prelude

import Data.Codec (encode, decode)
import Data.Maybe (Maybe, maybe)

import Effect.Class (liftEffect)

import Halogen (HalogenM, lift)
import Halogen.Store.Monad (updateStore)

import Web.CSSOMView.Window (matchMedia)
import Web.CSSOMView.MediaQueryList (matches)
import Web.HTML (window)

import ToA.ToAM (ToAM)
import ToA.Capability.Log (debug)
import ToA.Capability.Storage (read, write, delete)
import ToA.Data.Theme (Theme(..), themeCodec)

class Theme m where
  saveTheme :: Maybe Theme -> m Unit
  readTheme :: m (Maybe Theme)
  systemTheme :: m Theme

instance Theme ToAM where
  saveTheme theme = do
    updateStore _ { theme = theme }
    let t = encode themeCodec <$> theme
    debug $ "save theme: " <> show t
    t # maybe (delete "theme") (write "theme")

  readTheme = do
    debug $ "read storage theme"
    read "theme" <#> (decode themeCodec =<< _)

  systemTheme = do
    debug $ "read system theme"
    liftEffect $ window
      >>= matchMedia "(prefers-color-scheme: dark)"
      >>= matches
      <#> if _ then Dark else Light

instance (Monad m, Theme m) => Theme (HalogenM s a sl o m) where
  saveTheme = lift <<< saveTheme
  readTheme = lift readTheme
  systemTheme = lift systemTheme
