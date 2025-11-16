module ToA.Resource.Icon.Job.Auran
  ( auran
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

auran :: Job
auran = Job
  { name: Name "Auran"
  , colour: Name "Blue"
  , soul: Name "Earth"
  , class: Name "Wright"
  , description:
      [ Text
          """Also known as metalwrights, Aurans are a relatively new
          order of upstart earth wrights found chiefly among the churner
          camps and great cities. Flashy, technically skilled, and
          ambitious in comparison to their more slow-moving elder orders,
          they work in the guild workshops, machine factories,
          under-gangs, and churner excavation crews."""
      , Newline
      , Newline
      , Text
          """The elden civilizations revered metal, weighed it carefully,
          and worked it with skill and grace. In this age, the new
          Aether-tech cities of the guilders and the great mobile city
          camps of the churners whirr have none of this respect. They
          contort metal into new, monstrous forms, burn it into fumes,
          and hammer it into pieces that crunch and grind in an unholy
          chorus. The great machine churns and whirrs as it climbs closer
          to heaven."""
      ]
  , trait: Name "Metal Shell"
  , keyword: Name "Heavy"
  , abilities:
      (I /\ Name "Steel Thorn")
        : (I /\ Name "Metal Flash")
        : (II /\ Name "Iron Flesh")
        : (IV /\ Name "Midas")
        : empty
  , limitBreak: Name "Wrecking Ball"
  , talents:
      Name "Effigy"
        : Name "Weight"
        : Name "Stomp"
        : empty
  }
