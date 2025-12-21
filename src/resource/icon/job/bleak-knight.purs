module ToA.Resource.Icon.Job.BleakKnight
  ( bleakKnight
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

bleakKnight :: Icon
bleakKnight =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Bleak Knight"
          , colour: Name "Red"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Also known as dark knights - a black-clad mercenary order
                  with a dread reputation, taught and tempered to embrace any
                  kind of suffering and pain. They fly a banner with no sigil,
                  and many will flee the battlefield when they see it coming."""
              , Newline
              , Newline
              , Text
                  """The Bleak Knights are known to be one of the stalwart
                  orders practicing limited aether manipulation, usually to
                  channel their suffering into strength. They follow an iron
                  doctrine of total, incorruptible warfare and while they take
                  captives and follow the rules of law (to the extreme letter),
                  they show no weakness or mercy to their foes, regardless of
                  circumstance. They have the infamous tradition of only
                  accepting recruits from those that have gone through
                  tremendous suffering - including the victims of their own
                  campaigns."""
              ]
          , trait: Name "Armored Agony"
          -- TODO: refactor keyword?
          , keyword: Name "No keywords."
          , abilities:
              (I /\ Name "Demise")
                : (I /\ Name "Masochism")
                : (II /\ Name "Revenge")
                : (IV /\ Name "Quietus")
                : empty
          , limitBreak: Name "Chain of Misery"
          , talents:
              Name "Tenacity"
                : Name "Torment"
                : Name "Sanguine"
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
