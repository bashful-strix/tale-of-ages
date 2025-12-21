module ToA.Resource.Icon.Job.Stormbender
  ( stormbender
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

stormbender :: Icon
stormbender =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Stormbender"
          , colour: Name "Blue"
          , soul: Name "Water"
          , class: Name "Wright"
          , description:
              [ Text
                  """The seas of Arden Eld are its most treacherous terrain.
                  Boiling over with monsters, and wracked with unnatural and
                  freakish weather, most folk prefer to give them wide berth.
                  However, there are still those brave and hardy souls that live
                  on the islands around Arden Eld, and the merchants, sailors,
                  and travelers that rely on the sea for fast passage and the
                  movement of cargo, the lifeblood of the continent’s great
                  cities."""
              , Newline
              , Newline
              , Text
                  """The Stormbenders are the great masters of the sea, the
                  supreme navigators that make sailing even possible around
                  Arden Eld. Water-attuned wrights, they are most at home on a
                  deck, or clambering the rigging. Each of them are sailors of
                  the highest caliber, coming from all over - old trade guilds,
                  islander clans, and nautical churner enclaves."""
              , Newline
              , Newline
              , Text
                  """Bending the essence of the sea to their beck and call, the
                  Stormbenders can clear the skies with a swipe of their hands,
                  feel the currents ahead for aquatic monsters, turn weather
                  away from the hull of the ship, and blow wind into its sails.
                  It doesn’t matter that many of them dabble in a little light
                  piracy on the side - they are the undisputed masters of their
                  element, and they wouldn’t have it any other way."""
              ]
          , trait: Name "Dash on the Rocks"
          , keyword: Name "Impact"
          , abilities:
              (I /\ Name "Aqua")
                : (I /\ Name "Heave-Ho")
                : (II /\ Name "Deepwrath")
                : (IV /\ Name "Waterspout")
                : empty
          , limitBreak: Name "Tsunami"
          , talents:
              Name "Trip"
                : Name "Swell"
                : Name "whirlpool"
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
