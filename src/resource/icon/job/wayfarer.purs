module ToA.Resource.Icon.Job.Wayfarer
  ( wayfarer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

wayfarer :: Icon
wayfarer =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Wayfarer"
          , colour: Name "Blue"
          , soul: Name "Bolt"
          , class: Name "Wright"
          , description:
              [ Text
                  """Fast-moving, fast talking wrights that are part of the
                  Wayfarer’s guild, easily recognizable by their large rings of
                  golden keys. The guild uses and maintains the
                  semi-mythological Paths, passages that cut through old ruins
                  and use ancient Arken (or some say pre-Arken) aether
                  technology to compress journeys that would take days into mere
                  hours. During these treks, the wayfarers use their keys and
                  manipulate air Aether to open short passageways through spaces
                  beyond Arden Eld. Use of the Paths is extremely restrictive,
                  little studied, and reaching them is very dangerous, so they
                  are not traversed by most kin, and most of them lie in disuse
                  and ruin."""
              , Newline
              , Newline
              , Text
                  """The Wayfarers mostly use the paths themselves to act as
                  couriers for those that can pay them - usually for light cargo
                  and information. On foot, they lightly make their treks
                  through sunless reaches beyond the stretch of time and
                  space."""
              ]
          , trait: Name "Master Key"
          , keyword: Name "Precision"
          , abilities:
              (I /\ Name "Dimio")
                : (I /\ Name "Dimensional Anchor")
                : (II /\ Name "The Door")
                : (IV /\ Name "Palace of a Thousand Doors")
                : empty
          , limitBreak: Name "Infinite Horizon"
          , talents:
              Name "Shock"
                : Name "Pinpoint"
                : Name "Hyper"
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
