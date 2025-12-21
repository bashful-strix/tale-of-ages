module ToA.Resource.Icon.Job.Runesmith
  ( runesmith
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

runesmith :: Icon
runesmith =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Runesmith"
          , colour: Name "Blue"
          , soul: Name "Flame"
          , class: Name "Wright"
          , description:
              [ Text
                  """Powerful crafts-kin tutored in the old rune arts, mostly
                  commonly found among the Troggs, but spread amongst all kin of
                  the furnace arts of Arden Eld. The power of carving runes with
                  flame Aether is very precise and requires a brawny arm, since
                  it was originally practiced by the gigantic Jotunn. Runes must
                  be carved into tempered metal or sturdy rock by hand and tool.
                  Weapons or equipment that carry rune kennings must have a
                  proper soul, forged with care and craftsmanship, or else they
                  will shatter under the tremendous weight of imbued ethereal
                  power. Weak and mass produced armament such as those churned
                  out in the cities cannot bear them."""
              , Newline
              , Newline
              , Text
                  """The Runesmiths and their ancient jotunn masters, the
                  Keepers of the Eld flame, originally made some of the most
                  powerful artifacts in Arden Eld - world altering weapons or
                  armament. The new generations continue the work in some
                  manner, recovering lost knowledge and continually improving
                  their craft as the hammer slowly bends out hot metal."""
              ]
          , trait: Name "Forge Heart"
          , keyword: Name "Zone"
          , abilities:
              (I /\ Name "Strike the Anvil")
                : (I /\ Name "Magmotic")
                : (II /\ Name "Siege Rune")
                : (IV /\ Name "Rune of the Forge")
                : empty
          , limitBreak: Name "Kindling of the Great Forge"
          , talents:
              Name "Jotunnrune"
                : Name "Hobrune"
                : Name "Folkrune"
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
