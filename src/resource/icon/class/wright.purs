module ToA.Resource.Icon.Class.Wright
  ( wright
  ) where

import Prelude

import Color (fromInt)

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , newline
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Class (Class(..))
import ToA.Data.Icon.Pc.Soul (Soul(..))

wright :: Icon
wright =
  { classes:
      [ Class
          { name: Name "Wright"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--spell-book]"
          , tagline: text "Mage, thaumaturge, and master of the arcane"
          , strengths: text
              "High damage and excellent range, strong area of effect"
          , weaknesses: text
              "Low durability and weak to foes that can engage them up close"
          , complexity: text "Medium"
          , description: text
              """Wrights are mages who have mastered the manipulation of the raw
              power of creation: Aether. All souls are connected to Aether, and
              everyone is able to feel it to some degree. Those with training,
              potential and ability can learn to form and shape Aether as
              naturally as they move their own flesh and blood. Wrights wield
              terrifying power - and they know it."""
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
          , sign: Sign "icon-[game-icons--small-fire]"
          , class: Name "Wright"
          , description: seq
              [ text "The soul of one aflame with ambition."
              , newline
              , text
                  """Through fire, the wheel of the world ignites, hurtling
                  onwards. All things must transmute, or perish."""
              ]
          }
      , Soul
          { name: Name "Earth"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--peaks]"
          , class: Name "Wright"
          , description: seq
              [ text "The soul of one attuned to the land."
              , newline
              , text
                  """Through earth, we are anchored to our wills and the great
                  umbilical of time and matter. All things are ultimately built
                  upon a foundation."""
              ]
          }
      , Soul
          { name: Name "Bolt"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--lightning-helix]"
          , class: Name "Wright"
          , description: seq
              [ text "The soul of one riding the flash and the thunderclap."
              , newline
              , text
                  """The air nourishes in brightness and movement, an eternal
                  dance. Living things must be unmoored for them to flourish and
                  be free."""
              ]
          }
      , Soul
          { name: Name "Water"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--water-drop]"
          , class: Name "Wright"
          , description: seq
              [ text "The soul of one swaying with the wave and current."
              , newline
              , text
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
          , description: seq
              [ text
                  """You are the master of manipulating ethereal currents,
                  granting the following benefits:"""
              , newline
              , list Unordered
                  [ seq
                      [ bold $ text "Aether Surge:"
                      , text
                          """ At round 3+, you increase all area damage you deal
                          by +2."""
                      ]
                  , seq
                      [ bold $ text "Aether Wall:"
                      , text " You have automatic "
                      , italic $ ref (Name "Cover") $ text "cover"
                      , text
                          """ against abilities used by any character 3 or more
                          spaces away."""
                      ]
                  ]
              ]
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Magi"
          , colour: Name "Blue"
          , description: text
              """Elementary magic, drawing on fundamental chaos, but no less
              potent."""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 8))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step AreaEff Nothing $ text "2 damage"
              , Step Eff (Just D6) $ text
                  """Create a difficult and (5+) dangerous terrain space in the
                  center space, even if it's occupied."""
              ]
          }
      , Ability
          { name: Name "Ember"
          , colour: Name "Blue"
          , description: text
              """You kindle a fierce ember which explodes into a blossom of
              energy when agitated."""
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 6))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Zone")) Nothing
                  ( seq
                      [ text "Create "
                      , dice 1 D3
                      , text
                          """+1 ember zones in free spaces in range. You can
                          place any number of these zones without replacing
                          them. Embers prime at the end of your turn. An ember
                          cannot be placed adjacent to another ember."""
                      ]
                  )
                  $ KeywordInset
                      { name: Name "Ember"
                      , colour: Name "Blue"
                      , keyword: Name "Zone"
                      , steps:
                          [ Step Eff Nothing $ seq
                              [ text
                                  """If a character voluntarily enters a primed
                                  ember's space or starts their turn there, it
                                  explodes for a burst 1 area effect, centered
                                  on it. Characters inside take """
                              , italic $ ref (Name "Pierce") $ text "piercing"
                              , text " damage equal to 2 + the round number."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Aero"
          , colour: Name "Blue"
          , description: text
              """You mark a foe with pulsing lightning charge, reacting to
              other's presence."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 6))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """Mark a foe in range. At the end of that foe's turn,
                      they take 2 """
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text
                      """ damage, then may save to end the mark. If they are
                      adjacent to two or more other characters, they take """
                  , dice 2 D3
                  , text " "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " instead, gain "
                  , italic $ ref (Name "Slow") $ text "slow"
                  , text " and may not save to end the mark."
                  ]
              ]
          }
      , Ability
          { name: Name "Geo"
          , colour: Name "Blue"
          , description: text
              """Digging into wells of geothermic power, you will the
              battlefield to reshape itself."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Object")
              ]
          , steps:
              [ Step (KeywordStep (Name "Object")) (Just D6) $ seq
                  [ text "Create one or (5+) two height 1 boulder "
                  , italic $ ref (Name "Object") $ text "objects"
                  , text
                      """ in free space in range. When you create an object, you
                      may push an adjacent character 1 space away from it."""
                  ]
              ]
          }
      , Ability
          { name: Name "Cryo"
          , colour: Name "Blue"
          , description: text
              """You loose a blast of icy air and wind, freezing foes where they
              stand."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 3) (NumVar 5))
              , AreaTag (Line (NumVar 5))
              ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text "2 "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage"
                  ]
              , Step Eff (Just D3) $ seq
                  [ text "Create "
                  , italic $ seq [ dice 1 D3, text "+1" ]
                  , text
                      """ slippery ice spaces of difficult terrain in the area.
                      These could be created under characters."""
                  ]
              ]
          }
      , Ability
          { name: Name "Ruin"
          , colour: Name "Blue"
          , description: text
              """Potent chaos magic that draws upon the chaos fundament,
              becoming more powerful as the battle continues."""
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 6))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ AttackStep (text "1 damage") (seq [ text "+", dice 2 D6 ])
              , Step AreaEff Nothing $ text "1 damage."
              , Step Eff Nothing $ text
                  """Increase all base damage, area damage, and blast effect
                  size by half the round number, rounded up."""
              ]
          }
      , Ability
          { name: Name "Shift"
          , colour: Name "Blue"
          , description: text
              """Slip between spaces using soul transposition: a miracle for
              most, but mundane for wrights."""
          , cost: One
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text "Teleport 3 spaces, then gain one or (4+) two "
                  , italic $ ref (Name "Keen") $ text "keen"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Gleam"
          , colour: Name "Blue"
          , description: text
              "Bend light into a shape that confounds the senses."
          , cost: Quick
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 4))
              , KeywordTag (Name "Object")
              ]
          , steps:
              [ Step (KeywordStep (Name "Object")) Nothing $ text
                  """Create a height 1 illusory object in free space in range.
                  The object does not obstruct or block line of sight but does
                  grant cover. It disappears and is removed if a character moves
                  into its space or if you use this ability again."""
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
