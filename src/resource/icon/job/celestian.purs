module ToA.Resource.Icon.Job.Celestian
  ( celestian
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

celestian :: Icon
celestian =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Celestian"
          , colour: Name "Green"
          , soul: Name "Oracle"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Across Arden Eld, the great Sages have often observed and
                  written that the position of the stars affects the ebb and
                  flow of Aether, something even sung about in the great Chant.
                  Some take this a step further, believing that the stars affect
                  the fate of mortals, the providence of the gods, and the
                  fortune of those born under their sign."""
              , Newline
              , Newline
              , Text
                  """Celestians are a mix of both types - wrights and priests
                  that through diligent practice have found the ability to
                  actually tap into the unique Aether currents produced by the
                  heavenly bodies. Their power is therefore highly dependent on
                  their position, and they spend a good deal of their time
                  charting and studying the movements and energies of their
                  celestial patrons, while their mundane ones keep them busy
                  with horoscopes, fortune tellings, and portents."""
              ]
          , trait: Name "Heavenly Orrery"
          , keyword: Name "Isolate"
          , abilities:
              (I /\ Name "Astra")
                : (I /\ Name "Lunar Cleansing")
                : (II /\ Name "Polaris")
                : (IV /\ Name "Meteor")
                : empty
          , limitBreak: Name "Cosmic Doom"
          , talents:
              Name "Dissolution"
                : Name "Hearken"
                : Name "Crater"
                : empty
          }
      ]
  , traits: []
  , talents: []
  , abilities: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
