module ToA.Resource.Icon.Job.Cleaver
  ( cleaver
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

cleaver :: Icon
cleaver =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Cleaver"
          , colour: Name "Red"
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Arden Eld is home to wild and dangerous frontiers, some of
                  which border on inhospitable climes, undersea monster dens, or
                  even Blightlands. The rough and tumble warriors that make
                  their homes there in the wilds are built of a different sort,
                  eschewing armor and even traditional weaponry. Instead, they
                  build their own weapons and armament from the most durable
                  materials around - monster parts. Using anything from Wyrm
                  jawbones the size of a man, to blast beetle shell casings, to
                  sawshark teeth, they construct anything from massive longblade
                  to trick spears, serrated daggers, bone great swords, or even
                  buzzsaws. The Cleavers, as they are known, are proud of their
                  craftsmanship. They wield their monstrous and oversized
                  weaponry with a reckless abandon, unbelievable strength, and a
                  ferocious bloodlust, a terrifying sight to witness in
                  battle."""
              ]
          , trait: Name "Berserkergang"
          , keyword: Name "Reckless"
          , abilities:
              (I /\ Name "Thirsting Edge")
                : (I /\ Name "Pound")
                : (II /\ Name "Seismic Smasher")
                : (IV /\ Name "Wild Swing")
                : empty
          , limitBreak: Name "Last Stand"
          , talents:
              Name "Massive"
                : Name "Shred"
                : Name "Rage"
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
