module ToA.Resource.Icon.Job.Partizan
  ( partizan
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

partizan :: Icon
partizan =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Partizan"
          , colour: Name "Red"
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Riding along the Leggio caravans, Partizans are warriors of
                  extreme daring and incredible skill. They are the elite of the
                  caravan watch guard, who use the hafts of their long spears as
                  vaulting poles to leap from roof to roof, even when the
                  caravan is in motion. They are prodigious monster hunters,
                  using the motions of their poles to leap to breathtaking
                  heights in order to plunge their blades every deeper. Once the
                  path of the Paritzan is taken up, a warrior does not expect to
                  live a long life, and will throw themselves at all threats to
                  the caravan with the poise and bravado of those closest to the
                  sun and closest to death."""
              ]
          , trait: Name "Vault"
          , keyword: Name "Dominant"
          , abilities:
              (I /\ Name "Valkyrion")
                : (I /\ Name "Spiral Impaler")
                : (II /\ Name "Meteon")
                : (IV /\ Name "Vaulting Pole")
                : empty
          , limitBreak: Name "Drill Dive"
          , talents:
              Name "Eagle"
                : Name "Soar"
                : Name "Vantage"
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
