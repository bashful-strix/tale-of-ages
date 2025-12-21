module ToA.Resource.Icon.Job.Corvidian
  ( corvidian
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

corvidian :: Icon
corvidian =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Corvidian"
          , colour: Name "Red"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Also known as Raven Knights, the Corvidian orders are an
                  ill-reputed Churner organization that are known primarily for
                  being traveling peddlers and battlefield scavengers. Once the
                  fighting is over, be it between monsters or kin, they descend
                  on the battlefield with their black, tattered cloaks, and
                  leaving strapped with pouches full of loot."""
              , Newline
              , Newline
              , Text
                  """Despite their dismal reputation, many of them operate as
                  vital lifelines to local communities impacted by war, blights,
                  or monster activity, acting as fences and suppliers when
                  nobody else will dare brave a conflict area."""
              ]
          , trait: Name "Way of the Crow"
          , keyword: Name "Finishing Blow"
          , abilities:
              (I /\ Name "Demoralize")
                : (I /\ Name "Kidney Shot")
                : (II /\ Name "Intimidate")
                : (IV /\ Name "Execute")
                : empty
          , limitBreak: Name "Bloodbath"
          , talents:
              Name "Cruelty"
                : Name "Mortality"
                : Name "Camraderie"
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
