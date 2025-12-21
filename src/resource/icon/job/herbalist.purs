module ToA.Resource.Icon.Job.Herbalist
  ( herbalist
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

herbalist :: Icon
herbalist =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Herbalist"
          , colour: Name "Green"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """The hedge witches of the villages are invaluable to their
                  functioning, even if their reputation often that of crotchety
                  or eccentric hermits. Often living in the borders of
                  settlements, away from the hustle and bustle, they spend their
                  days cultivating and pruning forest and field to raise the
                  herbs and flowers needed for vital medicines and remedies,
                  healing not only mundane illness but also supernatural curses,
                  afflictions of the soul, and maladies of ill luck or
                  fortune."""
              , Newline
              , Newline
              , Text
                  """To an untrained eye, a Herbalist’s garden looks like any
                  other wild patch. To those tutored in the ways of the Almanac,
                  it is a bounty of blessings, carefully selected in a way that
                  is unique to each practitioner. Herbalists, regardless of age
                  or ability, often go on on long pilgrimages in search of rare
                  flowers or herbs from legend or rumor, and so nearly all keep
                  a good pair of boots handy."""
              ]
          , trait: Name "Green Almanac"
          , keyword: Name "Summon"
          , abilities:
              (I /\ Name "Cultivate")
                : (I /\ Name "Vine Wall")
                : (II /\ Name "Rot")
                : (IV /\ Name "Poison Thorn")
                : empty
          , limitBreak: Name "Essence Sap"
          , talents:
              Name "Signature"
                : Name "Fertilize"
                : Name "Nutrition"
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
