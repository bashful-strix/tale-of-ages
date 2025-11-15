module ToA.Resource.Icon.Talent.Spellblade
  ( vex
  , fence
  , bladework
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

vex :: Talent
vex = Talent
  { name: Name "Vex"
  , description:
      [ Text "After you attack an "
      , Italic [ Ref (Name "Isolate") [ Text "isolated" ] ]
      , Text " character, you may teleport 2 after the ability resolves."
      ]
  }

fence :: Talent
fence = Talent
  { name: Name "Fence"
  , description:
      [ Text
          """If a foe is at the very end space of one of your damaging
          line or arc effects, they take 2 damage again after the ability
          resolves."""
      ]
  }

bladework :: Talent
bladework = Talent
  { name: Name "Bladework"
  , description:
      [ Text
          """The first time in a round you take damage, after the
          triggering ability resolves, you may teleport 2."""
      ]
  }
