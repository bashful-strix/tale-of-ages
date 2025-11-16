module ToA.Resource.Icon.Ability.Mendicant
  ( glia
  , gliaga
  , dios
  , megi
  , viga
  , aegi
  , diaga
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

glia :: Ability
glia = Ability
  { name: Name "Glia"
  , colour: Name "Green"
  , description: [ Text "A spark of light" ]
  , cost: One
  , tags: [ Attack, RangeTag (Range 1 5), KeywordTag (Name "Pierce") ]
  , steps:
      [ Step Nothing $ AttackStep
          [ Text "1 piercing damage" ]
          [ Text "+1 piercing damage" ]
      , Step (Just D3) $ OnHit
          [ Text "Gain "
          , Italic [ Dice 1 D3 ]
          , Text " "
          , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
          , Text ", then distribute it in any order to allies in range."
          ]
      ]
  }

gliaga :: Ability
gliaga = Ability
  { name: Name "Gliaga"
  , colour: Name "Green"
  , description:
      [ Text
          """A magnificent blaze of light aether invigorates your allies
          and scours your enemies."""
      ]
  , cost: Two
  , tags: [ Attack, AreaTag (Blast 3), RangeTag (Range 2 5) ]
  , steps:
      [ Step Nothing $ AttackStep
          [ Text "3 damage" ]
          [ Text "+", Dice 1 D6 ]
      , Step Nothing $ AreaEff [ Text "3 damage." ]
      , Step (Just D3) $ Eff
          [ Text
              """Allies in the area don't take samage but instead gain 2
              vigor. Bloodied allies gain """
          , Italic [ Dice 1 D3 ]
          , Text "+1 vigor instead."
          ]
      ]
  }

dios :: Ability
dios = Ability
  { name: Name "Dios"
  , colour: Name "Green"
  , description: [ Text "You ignite a spark of divine energy." ]
  , cost: Two
  , tags:
      [ KeywordTag (Name "Zone")
      , RangeTag (Range 1 4)
      , AreaTag (Cross 1)
      ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Zone")
          [ Text
              """Place a zone of scintillating dark or light energy down
              in free space in range. It can be placed over
              characters."""
          , List Unordered
              [ [ Italic [ Text "Dark: " ]
                , Text "The entire space is "
                , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                , Text " and "
                , Italic
                    [ Ref
                        (Name "Difficult Terrain")
                        [ Text "difficult terrain" ]
                    ]
                , Text "."
                ]
              , [ Italic [ Text "Light: " ]
                , Text
                    "Foes that start or end their turn in the area gain "
                , Italic [ Ref (Name "Brand") [ Text "brand" ] ]
                , Text
                    """. Allies that either start or end their turn there
                    may clear 1 negative status, then save, ending one
                    more on a success."""
                ]
              ]
          ]
      ]
  }

megi :: Ability
megi = Ability
  { name: Name "Megi"
  , colour: Name "Green"
  , description: [ Text "Sear a mark of your divinity into your foe." ]
  , cost: One
  , tags: [ KeywordTag (Name "Mark"), RangeTag (Range 1 4) ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Mark")
          [ Text
              """Mark a foe in range. While marked, abilities that target
              the foe gain effect """
          , Power
          , Text " and that foe's abilities gain effect "
          , Weakness
          , Text
              """. If the foe is defeated, you may transfer this ability
              to a new foe in range as a """
          , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
          , Text " ability during your turn."
          ]
      ]
  }

viga :: Ability
viga = Ability
  { name: Name "Viga"
  , colour: Name "Green"
  , description: [ Text "Spur your allies to action." ]
  , cost: One
  , tags: [ RangeTag (Range 1 4) ]
  , steps:
      [ Step (Just D6) $ Eff
          [ Text "An ally in range gains one (6+) two "
          , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
          , Text " and may immediately make a free move."
          ]
      ]
  }

aegi :: Ability
aegi = Ability
  { name: Name "Aegi"
  , colour: Name "Green"
  , description: [ Text "You coalesce a divine shield over your ally." ]
  , cost: Two
  , tags: [ KeywordTag (Name "Mark"), RangeTag (Range 1 4) ]
  , steps:
      [ Step (Just D6) $ KeywordStep (Name "Mark")
          [ Text "Marked character gains "
          , Dice 2 D3
          , Text
              """+4 vigor upon being marked, then takes half damage while 
              marked. The first time in a turn an ability that damages
              them resolves, roll the effect die. On a 5+, keep this
              mark. Otherwise, they lose the mark and all vigor."""
          ]
      ]
  }

diaga :: Ability
diaga = Ability
  { name: Name "Diaga"
  , colour: Name "Green"
  , description:
      [ Text "Purge toxins, curses, and brands from your ally." ]
  , cost: One
  , tags: [ RangeTag (Range 1 4) ]
  , steps:
      [ Step Nothing $ Eff
          [ Text
              """A character in range can immediately save. They get rid
              of one negative status token of their choice, and may get
              rid of one more on a successful save."""
          ]
      , Step Nothing $ Eff
          [ Text "If they are bloodied, they gain "
          , Power
          , Text " on the save. If they are in "
          , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
          , Text ", they may remove one more token on a successful save."
          ]
      ]
  }
