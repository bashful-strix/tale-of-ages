module ToA.Resource.Icon.Class.Mendicant
  ( mendicant
  ) where

import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

mendicant :: Class
mendicant = Class
  { name: Name "Mendicant"
  , colour: Name "Green"
  , tagline: [ Text "Wndering healer and storyteller." ]
  , strengths:
      [ Text
          """Strong all-rounders, with may potent effects and the ability
          to heal or move allies and lift negative statuses."""
      ]
  , weaknesses: [ Text "Low damage and reliant on allies." ]
  , complexity: [ Text "High" ]
  , description:
      [ Text
          """Mendicants are the itinerant priests, exorcists, and healers
          of Arden Eld. They travel from town to town, healing sicknesses
          of the body and soul, cleansing the damage dealt by the ruins,
          consulting with local spirits, and setting up wards against
          evil. Many mendicants are highly learned scholars, but others
          come from folk practices, temple monks, green witch circles, or
          town priesthoods. They are a highly diverse lot, and attuned to
          the land and the people that they care for."""
      , Newline
      , Newline
      , Text
          """Mendicants are good all-rounders but primarily focus on
          supporting their allies - most of their abilities help to
          bolster their team rather than helping themselves, making them
          the lynchpin of any party."""
      ]
  , hp: 48
  , defense: 4
  , move: 4
  , trait: Name "Bless"
  , basic: Name "Glia"
  , keywords:
      [ Name "Aura"
      , Name "Brand"
      , Name "Crisis"
      , Name "Pierce"
      , Name "Stance"
      , Name "Strength"
      , Name "Unstoppable"
      ]
  , apprentice:
      [ Name "Gliaga"
      , Name "Dios"
      , Name "Megi"
      , Name "Viga"
      , Name "Aegi"
      , Name "Diaga"
      ]
  }
