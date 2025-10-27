module ToA.Data.Icon.LimitBreak.Tactician
  ( mightyCommand
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.LimitBreak (LimitBreak(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

mightyCommand :: LimitBreak
mightyCommand = LimitBreak
  { resolve: 2
  , ability: Ability
      { name: Name "Mighty Command"
      , description:
          [ Text """
              You issue an earth shattering command, breaking
              enemy morale and driving your allies on."""
          ]
      , action: One
      , tags: [ TargetTag Ally, TargetTag Foe ]
      , summon: Nothing
      , sub: Nothing
      , steps:
          [ Step Nothing $ Eff
              [ Text """
                  Every other character on the battlefield,
                  regardless of range and line of sight is pushed
                  or pulled 1 space in any direction of your
                  choice. You may move them in any order, and may
                  choose different directions for each character.
                  """
              ]
          , Step Nothing $ Eff
              [ Text "Bloodied characters or pushed +2 spaces." ]
          , Step Nothing $ Eff
              [ Text "Foes in"
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text "are additionally"
              , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
              , Text "."
              ]
          ]
      }
  }
