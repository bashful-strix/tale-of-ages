module ToA.Resource.Icon.Job.Colossus
  ( colossus
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

colossus :: Job
colossus = Job
  { name: Name "Colossus"
  , colour: Name "Red"
  , soul: Name "Berserker"
  , class: Name "Stalwart"
  , description:
      [ Text
          """Ferocious followers of Arenheir, the Wolf Titan, the Colossi
          are a martial order of grapplers and pankrationists that
          reaches across all of Arden Eld. They largely forgo the use of
          all weaponry in return for training their bodies to perfection,
          forging their very hands and feat into killing implements, and
          using grappling techniques that can liquify rock. Colossi
          travel throughout the land seeking powerful foes, and taking
          trophies to return to their great lodges to offer in tribute to
          Arenheir in fierce hope of resurrecting their god. At their
          lodges they feast and drink to their deeds, companions, and
          boasts. They seek glory and challenge through battle, and will
          often go for only the absolute strongest warriors and monsters,
          heedless of their own safety."""
      ]
  , trait: Name "Blood of the Wolf Soul"
  , keyword: Name "Sacrifice"
  , abilities:
      (I /\ Name "Megalo Buster")
        : (I /\ Name "Megaton Suplex")
        : (II /\ Name "Grendel")
        : (IV /\ Name "War God's Step")
        : empty
  , limitBreak: Name "Gigantas Crusher"
  , talents:
      Name "Grit"
        : Name "Adrenaline"
        : Name "Surge"
        : empty
  }
