module ToA.Resource.Icon.Foe.Classes
  ( foeClasses
  ) where

import ToA.Prelude

import Color (fromInt)

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Markup (text)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Foe.Ability (Ability(..), FoeAbility(..))
import ToA.Data.Icon.Foe.Class (FoeClass(..))
import ToA.Data.Icon.Foe.Trait (FoeTrait(..))

foeClasses :: Icon
foeClasses =
  { classes: []
  , souls: []
  , jobs: []
  , traits: []
  , talents: []
  , abilities: []
  , keywords: []
  , foes: []
  , factions: []

  , colours:
      [ Colour { name: Name "Purple", value: fromInt 0x9810fa } ] -- pruple-600

  , foeClasses:
      [ FoeClass
          { name: Name "Heavy"
          , colour: Name "Red"
          , description: text
              """Slower, melee focused enemies that defend their allies with
              their higher hp and defensive traits."""
          , hp: 40
          , maxVigor: Nothing
          , defense: 3
          , move: 4
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Guard"
                  , description: text
                      """Has 1 armor and conveys 1 armor to all adjacent allies
                      with no armor. Adjacent spaces cost +1 more movement for
                      foes to exit."""
                  }
              ]
          , abilities: []
          }

      , FoeClass
          { name: Name "Skirmisher"
          , colour: Name "Yellow"
          , description: text
              """Fast, mobile, short ranged enemies that deal high damage but
              are fragile themselves."""
          , hp: 32
          , maxVigor: Nothing
          , defense: 6
          , move: 4
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Skirmisher"
                  , description: text
                      """Can move diagonally. Reduces all damage from missed
                      attacks and successful saves to 1."""
                  }
              ]
          , abilities: []
          }

      , FoeClass
          { name: Name "Leader"
          , colour: Name "Green"
          , description: text
              """Foes that improve the combat capabilities of their allies or
              heal them. Have traits or auras and effects that improve or move
              their allies."""
          , hp: 48
          , maxVigor: Nothing
          , defense: 4
          , move: 4
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Cure"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , steps:
                      [ Step Eff Nothing $ text
                          """A bloodied ally in range gains 3 vigor. Increase
                          further by +3 if they are in crisis."""
                      ]
                  }
              ]
          }

      , FoeClass
          { name: Name "Artillery"
          , colour: Name "Blue"
          , description: text
              """Long range, slow enemies that become powerful if left alone.
              Deal the highest damage but relatively little defense or
              health."""
          , hp: 32
          , maxVigor: Nothing
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Aetherwall"
                  , description: text
                      "Takes 1/2 damage from foes 3 or more spaces away."
                  }
              ]
          , abilities: []
          }

      , FoeClass
          { name: Name "Mob"
          , colour: Name "Purple"
          , description: text "Mob"
          , hp: 2
          , maxVigor: Just 6
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Mob"
                  , description: text
                      """This character doesn’t trigger effects from being
                      defeated and is removed when defeated. Max one of each mob
                      type per combat. Counts as bloodied when at 1/2 members or
                      lower, and in crisis at 1/4 members or lower."""
                  }
              ]
          , abilities: []
          }

      , FoeClass
          { name: Name "Legend"
          , colour: Name "Purple"
          , description: text "Legend"
          , hp: 40
          , maxVigor: Just 10
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Legend"
                  , description: text "Takes 1 turn for each player character."
                  }
              , RoundAction $ Trait
                  { name: Name "Juggernaut"
                  , description: text
                      """At the start of the round, this character may clear a
                      status or mark."""
                  }
              ]
          , abilities: []
          }
      ]
  }
