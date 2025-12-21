module ToA.Resource.Icon.Job.Alchemist
  ( alchemist
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

alchemist :: Icon
alchemist =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Alchemist"
          , colour: Name "Blue"
          , soul: Name "Earth"
          , class: Name "Wright"
          , description:
              [ Text
                  """Members of the Invisible Chain, the secretive order of
                  warrior-sages seeking to untangle the mysteries of the
                  physical world, and in turn, life itself. Aether creates form.
                  Form creates Aether. Nothingness and solidity are
                  intertwined."""
              , Newline
              , Newline
              , Text
                  """As Alchemists are generally forbidden from most medical
                  practice in the city guilds, they often act as traveling
                  surgeons, pharmacologists, and doctors to ply their living.
                  Their meetings take place in secret refuges, where they share
                  advanced medical knowledge, secrets of the physical form, and
                  attempt to commander the resources of the order towards some
                  project or another of staggering ambition."""
              , Newline
              , Newline
              , Text
                  """All things can be broken into their elements, and in turn,
                  purified and reformed. The body is no different."""
              ]
          , trait: Name "Master of Fundaments"
          , keyword: Name "Weave"
          , abilities:
              (I /\ Name "Bio")
                : (I /\ Name "Realignment")
                : (II /\ Name "Transmute")
                : (IV /\ Name "Power Pill")
                : empty
          , limitBreak: Name "Homunculus"
          , talents:
              Name "Elixir"
                : Name "Effuse"
                : Name "Purity"
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
