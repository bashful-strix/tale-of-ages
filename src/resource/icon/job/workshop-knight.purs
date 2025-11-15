module ToA.Resource.Icon.Job.WorkshopKnight
  ( workshopKnight
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

workshopKnight :: Job
workshopKnight = Job
  { name: Name "Workshop Knight"
  , soul: Name "Warrior"
  , class: Name "Stalwart"
  , description:
      [ Text
          """Warriors of the great guild workshops lodged in the high
          city spires. They are known as much for their genius as their
          bravery, and wield arkentech, clockwork, and black powder as
          easily as they wield a blade. They work fervently on new
          contraptions meant nor only to better warfare but the lives of
          kin - automated farm equipment, message delivery systems,
          combustion powered gondolas and the like, often under the
          skeptical gaze of the citizenry. Many of them find employ with
          the great airship companies as engineers and carpenters. The
          orders are especially open to those that have suffered
          accidents of birth or battlefield and are well known for their
          well crafted arkentech prosthetics.
          """
      ]
  , trait: Name "Ingenuity"
  , keyword: Name "Conserve"
  , abilities:
      (I /\ Name "Rocket Punch")
        : (I /\ Name "Ripper Claw")
        : (II /\ Name "Weapon Vault")
        : (IV /\ Name "Arsenal")
        : empty
  , limitBreak: Name "Masterstroke"
  , talents:
      Name "Alloy"
        : Name "Endure"
        : Name "Bolster"
        : empty
  }
