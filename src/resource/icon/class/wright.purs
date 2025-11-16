module ToA.Resource.Icon.Class.Wright
  ( wright
  ) where

import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

wright :: Class
wright = Class
  { name: Name "Wright"
  , colour: Name "Blue"
  , tagline: [ Text "Mage, thaumaturge, and master of the arcane" ]
  , strengths:
      [ Text "High damage and excellent range, strong area of effect" ]
  , weaknesses:
      [ Text
          "Low durability and weak to foes that can engage them up close"
      ]
  , complexity: [ Text "Medium" ]
  , description:
      [ Text
          """Wrights are mages who have mastered the manipulation of the
          raw power of creation: Aether. All souls are connected to
          Aether, and everyone is able to feel it to some degree. Those
          with training, potential and ability can learn to form and
          shape Aether as naturally as they move their own flesh and
          blood. Wrights wield terrifying power - and they know it."""
      ]
  , hp: 32
  , defense: 4
  , move: 4
  , trait: Name "Master of Aether"
  , basic: Name "Magi"
  , keywords:
      [ Name "Keen"
      , Name "Slow"
      , Name "Stance"
      ]
  , apprentice:
      [ Name "Ember"
      , Name "Aero"
      , Name "Geo"
      , Name "Cryo"
      , Name "Ruin"
      , Name "Shift"
      , Name "Gleam"
      ]
  }
