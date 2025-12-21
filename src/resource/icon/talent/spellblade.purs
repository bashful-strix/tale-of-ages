module ToA.Resource.Icon.Talent.Spellblade
  ( vex
  , fence
  , bladework
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

vex :: Talent
vex = Talent
  { name: Name "Vex"
  , colour: Name "Blue"
  , description:
      [ Text "After you attack an "
      , Italic [ Ref (Name "Isolate") [ Text "isolated" ] ]
      , Text " character, you may teleport 2 after the ability resolves."
      ]
  , subItem: Nothing
  }

fence :: Talent
fence = Talent
  { name: Name "Fence"
  , colour: Name "Blue"
  , description:
      [ Text
          """If a foe is at the very end space of one of your damaging
          line or arc effects, they take 2 damage again after the ability
          resolves."""
      ]
  , subItem: Nothing
  }

bladework :: Talent
bladework = Talent
  { name: Name "Bladework"
  , colour: Name "Blue"
  , description:
      [ Text
          """The first time in a round you take damage, after the
          triggering ability resolves, you may teleport 2."""
      ]
  , subItem: Nothing
  }
