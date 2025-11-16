module ToA.Resource.Icon.Class.Vagabond
  ( vagabond
  ) where

import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

vagabond :: Class
vagabond = Class
  { name: Name "Vagabond"
  , colour: Name "Yellow"
  , tagline: [ Text "Cunning Wanderer" ]
  , strengths:
      [ Text
          """High mobility and damage, strong summons and marks, and
          strong against isolated foes."""
      ]
  , weaknesses: [ Text "Relatively low durability, relies on support." ]
  , complexity: [ Text "Medium" ]
  , description:
      [ Text
          """Vagabonds are the mercanaries and master scouts of Arden
          Eld. They know how to aim a crossbow bolt through the visor of
          a knight or the weak spot of a monster, how to move quietly and
          quickly, and how to fling a knife with deadly precision. They
          are very mobile compared to other jobs and are able to get
          where they need to go faster than most, using their follow up
          abilities to beat down injured or isolated foes."""
      ]
  , hp: 32
  , defense: 6
  , move: 4
  , trait: Name "Skirmisher"
  , basic: Name "Wind's Kiss"
  , keywords:
      [ Name "Blind"
      , Name "Evasion"
      , Name "Haste"
      , Name "Mark"
      , Name "Stealth"
      , Name "Summon"
      ]
  , apprentice:
      [ Name "Track"
      , Name "Quick Step"
      , Name "Flash Powder"
      , Name "Gouge"
      , Name "Smoke Bomb"
      , Name "Death Trap"
      ]
  }
