module ToA.Resource.Icon.Ability.Wright
  ( magi
  , ember
  , emberZone
  , aero
  , geo
  , cryo
  , ruin
  , shift
  , gleam
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Damage(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

magi :: Ability
magi = Ability
  { name: Name "Magi"
  , colour: Name "Blue"
  , description:
      [ Text
          """Elementary magic, drawing on fundamental chaos, but no less
          potent."""
      ]
  , cost: One
  , tags: [ Attack, RangeTag (Range 2 8), AreaTag (Cross 1) ]
  , steps:
      [ Step Nothing $ AttackStep (Just $ Flat 2) (Just $ Roll 1 D6)
      , Step Nothing $ AreaEff [ Text "2 damage" ]
      , Step (Just D6) $ Eff
          [ Text
              """Create a difficult and (5+) dangerous terrain space in
              the center space, even if it's occupied."""
          ]
      ]
  }

ember :: Ability
ember = Ability
  { name: Name "Ember"
  , colour: Name "Blue"
  , description:
      [ Text
          """You kindle a fierce ember which explodes into a blossom of
          energy when agitated."""
      ]
  , cost: Two
  , tags: [ KeywordTag (Name "Zone"), RangeTag (Range 2 6) ]
  , steps:
      [ SubStep Nothing (Name "Ember Zone") $ KeywordStep (Name "Zone")
          [ Text "Create "
          , Dice 1 D3
          , Text
              """+1 ember zones in free spaces in range. You can place
              any number of these zones without replacing them. Embers
              prime at the end of your turn. An ember cannot be placed
              adjacent to another ember."""
          ]
      ]
  }

emberZone :: Ability
emberZone = Ability
  { name: Name "Ember Zone"
  , colour: Name "Blue"
  , description: []
  , cost: Quick
  , tags: [ KeywordTag (Name "Zone") ]
  , steps:
      [ Step Nothing $ Eff
          [ Text
              """If a character voluntarily enters a primed ember's
              space or starts their turn there, it explodes for a burst 1
              area effect, centered on it. Characters inside take """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage equal to 2 + the round number."
          ]
      ]
  }

aero :: Ability
aero = Ability
  { name: Name "Aero"
  , colour: Name "Blue"
  , description:
      [ Text
          """You mark a foe with pulsing lightning charge, reacting to
          other's presence."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 6), KeywordTag (Name "Mark") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Mark")
          [ Text
              """Mark a foe in range. At the end of that foe's turn, they
              take 2 """
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text
              """ damage, then may save to end the mark. If they are
              adjacent to two or more other characters, they take """
          , Dice 2 D3
          , Text " "
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " instead, gain "
          , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
          , Text " and may not save to end the mark."
          ]
      ]
  }

geo :: Ability
geo = Ability
  { name: Name "Geo"
  , colour: Name "Blue"
  , description:
      [ Text
          """Digging into wells of geothermic power, you will the
          battlefield to reshape itself."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 4), KeywordTag (Name "Bject") ]
  , steps:
      [ Step (Just D6) $ KeywordStep (Name "Object")
          [ Text "Create one or (5+) two height 1 boulder "
          , Italic [ Ref (Name "Object") [ Text "objects" ] ]
          , Text
              """ in free space in range. When you create an object, you
              may push an adjacent character 1 space away from it."""
          ]
      ]
  }

cryo :: Ability
cryo = Ability
  { name: Name "Cryo"
  , colour: Name "Blue"
  , description:
      [ Text
          """You loose a blast of icy air and wind, freezing foes where
          they stand."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 3 5), AreaTag (Line 5) ]
  , steps:
      [ Step Nothing $ AreaEff
          [ Text "2 "
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage"
          ]
      , Step (Just D3) $ Eff
          [ Text "Create "
          , Italic [ Dice 1 D3, Text "+1" ]
          , Text
              """ slippery ice spaces of difficult terrain in the area.
              These could be created under characters."""
          ]
      ]
  }

ruin :: Ability
ruin = Ability
  { name: Name "Ruin"
  , colour: Name "Blue"
  , description:
      [ Text
          """Potent chaos magic that draws upon the chaos fundament,
          becoming more powerful as the battle continues."""
      ]
  , cost: Two
  , tags: [ Attack, RangeTag (Range 2 6), AreaTag (Blast 2) ]
  , steps:
      [ Step Nothing $ AttackStep (Just $ Flat 1) (Just $ Roll 2 D6)
      , Step Nothing $ AreaEff [ Text "1 damage." ]
      , Step Nothing $ Eff
          [ Text
              """Increase all base damage, area damage, and blast effect
              size by half the round number, rounded up."""
          ]
      ]
  }

shift :: Ability
shift = Ability
  { name: Name "Shift"
  , colour: Name "Blue"
  , description:
      [ Text
          """Slip between spaces using soul transposition: a miracle for
          most, but mundane for wrights."""
      ]
  , cost: One
  , tags: [ TargetTag Self ]
  , steps:
      [ Step (Just D6) $ Eff
          [ Text "Teleport 3 spaces, then gain one or (4+) two "
          , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
          , Text "."
          ]
      ]
  }

gleam :: Ability
gleam = Ability
  { name: Name "Gleam"
  , colour: Name "Blue"
  , description:
      [ Text "Bend light into a shape that confounds the senses." ]
  , cost: Quick
  , tags: [ RangeTag (Range 2 4), KeywordTag (Name "Object") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Object")
          [ Text
              """Create a height 1 illusory object in free space in
              range. The object does not obstruct or block line of sight
              but does grant cover. It disappears and is removed if a
              character moves into its space or if you use this ability
              again."""
          ]
      ]
  }
