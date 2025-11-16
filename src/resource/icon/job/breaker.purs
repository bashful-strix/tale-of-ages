module ToA.Resource.Icon.Job.Breaker
  ( breaker
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

breaker :: Job
breaker = Job
  { name: Name "Breaker"
  , colour: Name "Red"
  , soul: Name "Knight"
  , class: Name "Stalwart"
  , description:
      [ Text
          """The first in the fight, breakers are a mercenary siege order
          of mythical strength and reputation. To even join the order,
          one must perform the Iron Vigil, a ten day training where a
          recruit is bound into heavy armor and ordered to wear it during
          all activities - even while sleeping. Wearing this armor, they
          are pushed to the point of exhaustion, taught to fight, sprint,
          run, climb, and even swim with it in order to transform the
          body into a living weapon of war. Once further training is
          accomplished, breakers don the heavy breaker gauntlet and can
          blow away all opposition with ease. Even the sturdy gates of
          castle walls are nothing to them."""
      ]
  , trait: Name "Shatter on the Ramparts"
  , keyword: Name "Impact"
  , abilities:
      (I /\ Name "Brazen Blow")
        : (I /\ Name "Land Waster")
        : (II /\ Name "Valiant")
        : (IV /\ Name "Battering Ram")
        : empty
  , limitBreak: Name "Gatebreaker"
  , talents:
      Name "Implacable"
        : Name "Seeker"
        : Name "Topple"
        : empty
  }
