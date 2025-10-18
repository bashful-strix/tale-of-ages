module ToA.Capability.Theme
  ( ThemeF
  , THEME

  , runTheme

  , save
  , readStorage
  , readSystem
  ) where

import Prelude

import Data.Codec (encode, decode)
import Data.Maybe (Maybe, maybe)
import Effect.Class (liftEffect)

import Run (Run, EFFECT, interpret, lift, on, send)
import Type.Proxy (Proxy(..))
import Type.Row (type (+))

import Web.CSSOMView.Window (matchMedia)
import Web.CSSOMView.MediaQueryList (matches)
import Web.HTML (window)

import ToA.Capability.Log (LOG, debug)
import ToA.Capability.Storage (STORAGE, read, write, delete)
import ToA.Data.Theme (Theme(..), themeCodec)

data ThemeF a
  = Save (Maybe Theme) a
  | ReadStorage (Maybe Theme -> a)
  | ReadSystem (Theme -> a)

derive instance Functor ThemeF

type THEME r = (theme :: ThemeF | r)
_theme = Proxy :: Proxy "theme"

save :: ∀ r. Maybe Theme -> Run (THEME + r) Unit
save theme = lift _theme (Save theme unit)

readStorage :: ∀ r. Run (THEME + r) (Maybe Theme)
readStorage = lift _theme (ReadStorage identity)

readSystem :: ∀ r. Run (THEME + r) Theme
readSystem = lift _theme (ReadSystem identity)

browserTheme :: ∀ r. ThemeF ~> Run (EFFECT + LOG + STORAGE + r)
browserTheme = case _ of
  Save theme next -> do
    let t = encode themeCodec <$> theme
    debug $ "save theme: " <> show t
    t # maybe (delete "theme") (write "theme")
    pure next

  ReadStorage reply -> do
    debug $ "read storage theme"
    read "theme"
      <#> reply <<< (decode themeCodec =<< _)

  ReadSystem reply -> do
    debug $ "read system theme"
    liftEffect $ window
      >>= matchMedia "(prefers-color-scheme: dark)"
      >>= matches
      <#> reply <<< if _ then Dark else Light

runTheme
  :: ∀ r. Run (EFFECT + LOG + STORAGE + THEME + r) ~> Run (EFFECT + LOG + STORAGE + r)
runTheme = interpret (on _theme browserTheme send)
