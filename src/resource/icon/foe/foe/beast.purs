module ToA.Resource.Icon.Foe.Foe.Beast
  ( halitoad
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  )
import ToA.Data.Icon.Chapter (Chapter(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Foe
  ( Foe(..)
  , FoeAbility(..)
  , FoeInsert(..)
  , FoeTrait(..)
  )
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

halitoad :: Foe
halitoad = Foe
  { name: Name "Halitoad"
  , colour: Name "Red"
  , class: Name "Heavy"
  , faction: Just $ Name "Beast"
  , chapter: Just I
  , description:
      [ Text
          """The enormous and foul-smelling Halitoad uses its long tongue
          to strangle and digest its prey"""
      ]
  , notes: []
  , traits:
      [ FoeTrait
          { name: Name "Stench"
          , description: [ Text "Adjacent foes deal damage ", Weakness ]
          }
      ]
  , abilities:
      [ FoeAbility
          { name: Name "Buffeting Burp"
          , cost: Two
          , tags: [ Attack, Close, AreaTag (Blast 2) ]
          , description:
              [ Text "3 damage. "
              , Italic [ Text "Hit" ]
              , Text " +"
              , Dice 1 D6
              , Text ". "
              , Italic [ Text "Area effect" ]
              , Text ": 3 damage and push 1. "
              , Italic [ Text "Ferocity" ]
              , Text ": Base damage and area damage +1, close blast 4."
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Gob Spit"
          , cost: One
          , tags: [ RangeTag (Range 1 3) ]
          , description:
              [ Text
                  """A character in range has a difficult terrain space
                  created under them, then must save or become """
              , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
              , Text
                  """. If it's an ally, they additionally gain 2 vigor,
                  + """
              , Dice 1 D6
              , Text " if they are in crisis."
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Tongue Flick"
          , cost: One
          , tags:
              [ RangeTag (Range 2 3), KeywordTag (Name "Repeatable") ]
          , description:
              [ Text "The Halitoad pulls a character in range 1." ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Bulky Block"
          , cost: One
          , tags: [ End ]
          , description:
              [ Text "Gain "
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text
                  """ and the following interrupt until the start of its
                  next turn. """
              , Italic [ Text "Ferocity" ]
              , Text ": Interrupt 2."
              ]
          , chain: Nothing
          , insert: Just $ AbilityInsert
              { name: Name "Block"
              , colour: Name "Red"
              , cost: Interrupt 1
              , tags: []
              , steps:
                  [ Step Nothing $ TriggerStep
                      [ Text
                          """This character or an adjacent ally is
                          attacked."""
                      ]
                  , Step Nothing $ Eff
                      [ Text "The attack deals 1/2 damage." ]
                  ]
              }
          }
      ]
  }
