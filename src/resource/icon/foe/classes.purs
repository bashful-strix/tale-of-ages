module ToA.Resource.Icon.Foe.Classes
  ( foeClasses
  ) where

import Color (fromInt)

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability (Action(..), Range(..), Tag(..))
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Foe (FoeAbility(..), FoeClass(..), FoeTrait(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

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
          , description:
              [ Text
                  """Slower, melee focused enemies that defend their allies with
                  their higher hp and defensive traits."""
              ]
          , hp: 40
          , defense: 3
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Guard"
                  , description:
                      [ Text
                          """Has 1 armor and conveys 1 armor to all adjacent
                          allies with no armor. Adjacent spaces cost +1 more
                          movement for foes to exit."""
                      ]
                  }
              ]
          , roundActions: []
          , abilities: []
          }
      , FoeClass
          { name: Name "Skirmisher"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Fast, mobile, short ranged enemies that deal high damage
                  but are fragile themselves."""
              ]
          , hp: 32
          , defense: 6
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Skirmisher"
                  , description:
                      [ Text
                          """Can move diagonally. Reduces all damage from missed
                          attacks and successful saves to 1."""
                      ]
                  }
              ]
          , roundActions: []
          , abilities: []
          }
      , FoeClass
          { name: Name "Leader"
          , colour: Name "Green"
          , description:
              [ Text
                  """Foes that improve the combat capabilities of their allies
                  or heal them. Have traits or auras and effects that improve or
                  move their allies."""
              ]
          , hp: 48
          , defense: 4
          , move: 4
          , traits: []
          , roundActions: []
          , abilities:
              [ FoeAbility
                  { name: Name "Cure"
                  , cost: One
                  , tags: [ RangeTag (Range 1 4) ]
                  , description:
                      [ Text
                          """A bloodied ally in range gains 3 vigor. Increase
                          further by +3 if they are in crisis."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , FoeClass
          { name: Name "Artillery"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Long range, slow enemies that become powerful if left
                  alone. Deal the highest damage but relatively little defense
                  or health."""
              ]
          , hp: 32
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Aetherwall"
                  , description:
                      [ Text "Takes 1/2 damage from foes 3 or more spaces away."
                      ]
                  }
              ]
          , roundActions: []
          , abilities: []
          }
      , FoeClass
          { name: Name "Mob"
          , colour: Name "Purple"
          , description: [ Text "Mob" ]
          , hp: 2
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Mob"
                  , description:
                      [ Text
                          """This character doesn’t trigger effects from being
                          defeated and is removed when defeated. Max one of
                          each mob type per combat. Counts as bloodied when at
                          1/2 members or lower, and in crisis at 1/4 members or
                          lower."""
                      ]
                  }
              ]
          , roundActions: []
          , abilities: []
          }
      , FoeClass
          { name: Name "Elite"
          , colour: Name "Purple"
          , description: [ Text "Elite" ]
          , hp: 40
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Elite", description: [ Text "Takes 2 turns." ] }
              ]
          , roundActions: []
          , abilities: []
          }
      , FoeClass
          { name: Name "Legend"
          , colour: Name "Purple"
          , description: [ Text "Legend" ]
          , hp: 40
          , defense: 4
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Legend"
                  , description:
                      [ Text "Takes 1 turn for each player character." ]
                  }
              ]
          , roundActions:
              [ FoeTrait
                  { name: Name "Juggernaut"
                  , description:
                      [ Text
                          """At the start of the round, this character may
                          clear a status or mark."""
                      ]
                  }
              ]
          , abilities: []
          }
      ]
  }
