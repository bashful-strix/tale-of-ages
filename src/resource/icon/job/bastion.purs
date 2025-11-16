module ToA.Resource.Icon.Job.Bastion
  ( bastion
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

bastion :: Job
bastion = Job
  { name: Name "Bastion"
  , colour: Name "Red"
  , soul: Name "Knight"
  , class: Name "Stalwart"
  , description:
      [ Text
          """The Bastions are the shield lords of Arden Eld, wandering
          knights and larger then life figures that tread the ancient
          imperial roads with their heads held high and armor gleaming.
          From town to town they act as errant knights and mercenaries,
          protecting the weak and vulnerable, and driving back the
          Blights with hammer-like blows from their weapons and
          great-shields. The imperious and mighty presence of a Bastion
          in town is a stabilizing force and can become an event for a
          whole village. All Bastions follow an ancient and
          long-forgotten hero’s code, an old oath to stand against chaos
          in all its forms. The names of the Bastions are recorded in the
          White Peak Citadel on the Eastern frontier, and they are
          interred there in their armor when they pass from this life."""
      ]
  , trait: Name "Endless Battlement"
  , keyword: Name "Overdrive"
  , abilities:
      (I /\ Name "Heracule")
        : (I /\ Name "Catapult")
        : (II /\ Name "Implacable Shield")
        : (IV /\ Name "Entrench")
        : empty
  , limitBreak: Name "Perfect Parry"
  , talents:
      Name "Perseus"
        : Name "Supernova"
        : Name "Presence"
        : empty
  }
