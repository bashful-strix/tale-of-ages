module ToA.Resource.Icon.Job.Geomancer
  ( geomancer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

geomancer :: Job
geomancer = Job
  { name: Name "Geomancer"
  , colour: Name "Blue"
  , soul: Name "Earth"
  , class: Name "Wright"
  , description:
      [ Text
          """Geomancers belong to an old order of mystics and esoteric
          martial artists called the Keepers of the Elden Gate. These
          scholarly wrights are concerned with health and the flow of
          energy, not just through the body, but through the very earth
          itself. They consider themselves physicians of the highest
          order - their patient being the eternal land of Arden Eld."""
      , Newline
      , Newline
      , Text
          """These studious wrights attune themselves to earth Aether,
          aligning the energy channels of their body to crystalline
          perfection with vigorous exercise and sometimes bizarre health
          regimes. In battle, the land itself is their ally, spitting
          forth poisonous gases, cavernous upheavals of earth, and great
          spires of rock to crush their foes."""
      , Newline
      , Newline
      , Text
          """None are more concerned with the Churn than the Geomancers,
          who view it as the greatest sickness known to Kin, and will
          take any opportunity to fight or study it with exuberance."""
      ]
  , trait: Name "Aftershock"
  , keyword: Name "Dominant"
  , abilities:
      (I /\ Name "Geotic")
        : (I /\ Name "Helix Heel")
        : (II /\ Name "Bones of the Earth")
        : (IV /\ Name "Terraforming")
        : empty
  , limitBreak: Name "Cataclysm"
  , talents:
      Name "Earthmeld"
        : Name "Boulder"
        : Name "Surf"
        : empty
  }
