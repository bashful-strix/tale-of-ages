module ToA.Resource.Icon.Job.HawkKnight
  ( hawkKnight
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

hawkKnight :: Job
hawkKnight = Job
  { name: Name "Hawk Knight"
  , colour: Name "Red"
  , soul: Name "Warrior"
  , class: Name "Stalwart"
  , description:
      [ Text
          """Ferocious knights from the infamous Talon Company. The
          company has long since disbanded, but the knights persist as
          dangerous wandering mercenaries. Their philosophy is ‘soaring
          above all’, training relentlessly to become the pinnacle of
          armed combat, and fighting any and all they can, regardless of
          allegiance. As a result, they are are spectacular and vicious
          duelists, tempered only by the fact that they duel to the blood
          rather than duel to the death. Hawk Knights are much maligned
          by the generally pacifistic villages of the green, but they
          know that their era will come. Until then, they bide their time
          sharpening their blades and doing odd jobs for soft-bellied
          fools, awaiting the time of carrion."""
      ]
  , trait: Name "One Hit Kill"
  , keyword: Name "Excel"
  , abilities:
      (I /\ Name "Razor Feather")
        : (I /\ Name "Hawk's Disdain")
        : (II /\ Name "Wicked Sheath")
        : (IV /\ Name "Perfect Strike")
        : empty
  , limitBreak: Name "Bloody Talons"
  , talents:
      Name "Ferocity"
        : Name "Sinew"
        : Name "Dissect"
        : empty
  }
