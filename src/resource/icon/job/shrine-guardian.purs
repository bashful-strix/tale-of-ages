module ToA.Resource.Icon.Job.ShrineGuardian
  ( shrineGuardian
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

shrineGuardian :: Job
shrineGuardian = Job
  { name: Name "Shrine Guardian"
  , colour: Name "Green"
  , soul: Name "Monk"
  , class: Name "Mendicant"
  , description:
      [ Text
          """Traveling priests, monks, judges, and doctors, the Shrine
          Guardians roam the world from village to village, performing
          necessary rituals, marriages, ceremonies, and yearly festivals.
          They are a welcome sight in most villages, especially those too
          poor to afford to maintain a temple, and most perform the
          important function of traveling judge and medium, acting as an
          impartial party translating for the will of the local spirits.
          They travel with many blessed relics of the deities of the land
          and portable shrines on their back, carrying their gods with
          them."""
      ]
  , trait: Name "Shrine of Blessing"
  , keyword: Name "Zone"
  , abilities:
      (I /\ Name "Sanctify")
        : (I /\ Name "Abjure")
        : (II /\ Name "Horse and Ox Seal")
        : (IV /\ Name "Heaven's Ward")
        : empty
  , limitBreak: Name "Great Spirit Festival"
  , talents:
      Name "Hearth"
        : Name "Festivity"
        : Name "Talisman"
        : empty
  }
