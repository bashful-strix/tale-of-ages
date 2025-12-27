module ToA.Resource.Icon.Class.Wright
  ( wright
  ) where

import Prelude

import Color (fromInt)

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , SubItem(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))
import ToA.Data.Icon.Trait (Trait(..))

wright :: Icon
wright =
  { classes:
      [ Class
          { name: Name "Wright"
          , colour: Name "Blue"
          , tagline: [ Text "Mage, thaumaturge, and master of the arcane" ]
          , strengths:
              [ Text "High damage and excellent range, strong area of effect" ]
          , weaknesses:
              [ Text
                  """Low durability and weak to foes that can engage them up
                  close"""
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
      ]
  , colours:
      [ Colour { name: Name "Blue", value: fromInt 0x155dfc } ] -- blue-600
  , souls:
      [ Soul
          { name: Name "Flame"
          , colour: Name "Blue"
          , class: Name "Wright"
          , description:
              [ Text "The soul of one aflame with ambition."
              , Newline
              , Text
                  """Through fire, the wheel of the world ignites, hurtling
                  onwards. All things must transmute, or perish."""
              ]
          }
      , Soul
          { name: Name "Earth"
          , colour: Name "Blue"
          , class: Name "Wright"
          , description:
              [ Text "The soul of one attuned to the land."
              , Newline
              , Text
                  """Through earth, we are anchored to our wills and the great
                  umbilical of time and matter. All things are ultimately built
                  upon a foundation."""
              ]
          }
      , Soul
          { name: Name "Bolt"
          , colour: Name "Blue"
          , class: Name "Wright"
          , description:
              [ Text "The soul of one riding the flash and the thunderclap."
              , Newline
              , Text
                  """The air nourishes in brightness and movement, an eternal
                  dance. Living things must be unmoored for them to flourish and
                  be free."""
              ]
          }
      , Soul
          { name: Name "Water"
          , colour: Name "Blue"
          , class: Name "Wright"
          , description:
              [ Text "The soul of one swaying with the wave and current."
              , Newline
              , Text
                  """The movement of the tides can wear away even solid rock.
                  All living things came from the sea, and will return to it in
                  time."""
              ]
          }
      ]
  , jobs: []
  , traits:
      [ Trait
          { name: Name "Master of Aether"
          , description:
              [ Text
                  """You are the master of manipulating ethereal currents,
                  granting the following benefits:"""
              , Newline
              , List Unordered
                  [ [ Bold [ Text "Aether Surge:" ]
                    , Text
                        """ At round 3+, you increase all area damage you deal
                        by +2."""
                    ]
                  , [ Bold [ Text "Aether Wall:" ]
                    , Text " You have automatic "
                    , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
                    , Text
                        """ against abilities used by any character 3 or more
                        spaces away."""
                    ]
                  ]
              ]
          , subItem: Nothing
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Magi"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Elementary magic, drawing on fundamental chaos, but no less
                  potent."""
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 8))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ Step Nothing $ AttackStep
                  [ Text "2 damage" ]
                  [ Text "+", Dice 1 D6 ]
              , Step Nothing $ AreaEff [ Text "2 damage" ]
              , Step (Just D6) $ Eff
                  [ Text
                      """Create a difficult and (5+) dangerous terrain space in
                      the center space, even if it's occupied."""
                  ]
              ]
          }
      , Ability
          { name: Name "Ember"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You kindle a fierce ember which explodes into a blossom of
                  energy when agitated."""
              ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 6))
              ]
          , steps:
              [ SubStep Nothing
                  ( KeywordItem
                      { name: Name "Ember"
                      , colour: Name "Blue"
                      , keyword: Name "Zone"
                      , steps:
                          [ Step Nothing $ Eff
                              [ Text
                                  """If a character voluntarily enters a primed
                                  ember's space or starts their turn there, it
                                  explodes for a burst 1 area effect, centered
                                  on it. Characters inside take """
                              , Italic
                                  [ Ref (Name "Pierce") [ Text "piercing" ] ]
                              , Text " damage equal to 2 + the round number."
                              ]
                          ]
                      }
                  )
                  $ KeywordStep (Name "Zone")
                      [ Text "Create "
                      , Dice 1 D3
                      , Text
                          """+1 ember zones in free spaces in range. You can
                          place any number of these zones without replacing
                          them. Embers prime at the end of your turn. An ember
                          cannot be placed adjacent to another ember."""
                      ]
              ]
          }
      , Ability
          { name: Name "Aero"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You mark a foe with pulsing lightning charge, reacting to
                  other's presence."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 6))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Mark")
                  [ Text
                      """Mark a foe in range. At the end of that foe's turn,
                      they take 2 """
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
      , Ability
          { name: Name "Geo"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Digging into wells of geothermic power, you will the
                  battlefield to reshape itself."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Bject")
              ]
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
      , Ability
          { name: Name "Cryo"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You loose a blast of icy air and wind, freezing foes where
                  they stand."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 3) (NumVar 5))
              , AreaTag (Line (NumVar 5))
              ]
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
      , Ability
          { name: Name "Ruin"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Potent chaos magic that draws upon the chaos fundament,
                  becoming more powerful as the battle continues."""
              ]
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 6))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ Step Nothing $ AttackStep
                  [ Text "1 damage" ]
                  [ Text "+", Dice 2 D6 ]
              , Step Nothing $ AreaEff [ Text "1 damage." ]
              , Step Nothing $ Eff
                  [ Text
                      """Increase all base damage, area damage, and blast effect
                      size by half the round number, rounded up."""
                  ]
              ]
          }
      , Ability
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
      , Ability
          { name: Name "Gleam"
          , colour: Name "Blue"
          , description:
              [ Text "Bend light into a shape that confounds the senses." ]
          , cost: Quick
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 4))
              , KeywordTag (Name "Object")
              ]
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
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
