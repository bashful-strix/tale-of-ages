module ToA.Resource.Icon.Ability.Chanter
  ( monogatari
  , holy
  , magnasancti
  , gentlePrayer
  , esper
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

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

monogatari :: Ability
monogatari = LimitBreak
  { name: Name "Monogatari"
  , colour: Name "Green"
  , description:
      [ Text
          """You sing a choice passage from the Great Chant, letting its
          words resonate in the air and bring hope to your companions."""
      ]
  , cost: One /\ 2
  , tags: []
  , steps:
      [ Step Nothing $ Eff
          [ Text
              "You sing a short passage from the book of ages. Roll "
          , Italic [ Dice 1 D6 ]
          , Text
              """ and consult the following table to see which song you
              sing. The song resonates in the air until the start of your
              next turn. You then sing a new passage, rolling again. At
              the end of their turn, any friendly character (including
              yourself) that fulfilled the condition of the passage
              gains """
          , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
          , Text " and 2 "
          , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
          , Text "."
          , Newline
          , Newline
          , List Ordered
              [ [ Bold [ Text "A Tale of Fury" ]
                , Text
                    """: Reduced a character to 0 hp or reduced them
                    below 50% hp if above."""
                ]
              , [ Bold [ Text "A Tale of Travels" ]
                , Text
                    """: Moved more than 4 spaces from your starting
                    point on your turn."""
                ]
              , [ Bold [ Text "A Tale of Green and Pleasant Times" ]
                , Text ": Did not attack."
                ]
              , [ Bold [ Text "A Tale of Cunning" ]
                , Text ": Used a mark, stance, aura, or combo ability."
                ]
              , [ Bold [ Text "A Tale of Boon Companions" ]
                , Text ": Ended your turn adjacent to an ally."
                ]
              , [ Bold [ Text "A Tale of Triumph" ]
                , Text ": Used an ability on an ally."
                ]
              ]
          ]
      ]
  }

holy :: Ability
holy = Ability
  { name: Name "Holy"
  , colour: Name "Green"
  , description:
      [ Text
          """You chant a word of making, and the world explodes with holy
          light."""
      ]
  , cost: Two
  , tags: [ RangeTag (Range 3 5), AreaTag (Cross 3) ]
  , steps:
      [ Step Nothing $ AreaEff
          [ Text "Foes take 2 "
          , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
          , Text " damage, or "
          , Dice 2 D3
          , Text
              """ piercing if there was a defeated ally in the area. All
              allies in the area gain vigor depending on their hp
              amount:"""
          , List Unordered
              [ [ Text "Above 50%: 1 vigor." ]
              , [ Text "Bloodied: ", Dice 1 D3, Text "+1." ]
              , [ Text "Crisis: "
                , Dice 3 D3
                , Text
                    """+3. May heal over vigor maximum. At the end of an
                    ally's turn, reduc down to their maximum if
                    higher."""
                ]
              , [ Text "Defeated: Automatically "
                , Italic [ Text "rescued" ]
                , Text "."
                ]
              ]
          ]
      , Step Nothing $ KeywordStep (Name "Conserve")
          [ Text "Any foe in the center space is "
          , Italic [ Ref (Name "Brand") [ Text "branded" ] ]
          , Text " and must save or be "
          , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
          , Text "."
          ]
      ]
  }

magnasancti :: Ability
magnasancti = Ability
  { name: Name "Magnasancti"
  , colour: Name "Green"
  , description:
      [ Text
          """You sanctify an area with passages of peace, the
          inscriptions over the doors of the Highest House."""
      ]
  , cost: Two
  , tags: [ RangeTag (Range 2 5) ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Zone")
          [ Text
              """Create a shimmering cross 1 zone of light, which can be
              created over characters. While inside the zone, you and
              allies have """
          , Italic [ Ref (Name "Fly") [ Text "flying" ] ]
          , Text " when moving and gain "
          , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
          , Text " if you end their turn there."
          ]
      , Step Nothing $ KeywordStep (Name "Conserve")
          [ Text "Reduce action cost to 1." ]
      ]
  }

gentlePrayer :: Ability
gentlePrayer = Ability
  { name: Name "Gentle Prayer"
  , colour: Name "Green"
  , description:
      [ Text
          """You radiate an aura of such powerful peace that all close to
          you, monster or man, find it impossible to raise a hand in
          violence."""
      ]
  , cost: One
  , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Aura") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Stance")
          [ Text "While in this stance, gain aura 1:"
          , List Unordered
              [ [ Text "Attacks from and against "
                , Italic [ Text "all" ]
                , Text " characters in the area gain "
                , Weakness
                , Text "."
                ]
              , [ Text
                    """Characters that attack in the aura immediately end
                    their turn after attacking."""
                ]
              , [ Text
                    """Immediately exit this stance and end your turn if
                    you attack."""
                ]
              ]
          ]
      , Step Nothing $ KeywordStep (Name "Conserve")
          [ Text
              """Increase the base size of the aura by +1 (max base aura
              3). This effect stacks, by ends and resets if you exit the
              aura."""
          ]
      ]
  }

esper :: Ability
esper = Ability
  { name: Name "Esper"
  , colour: Name "Green"
  , description:
      [ Text
          """You chant from the hermetic passages, turning the healing
          magics of the chant into a terrifying soul-cutting force.
          Forbidden to all but the most experienced chanters."""
      ]
  , cost: One
  , tags: [ KeywordTag (Name "Stance") ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Stance")
          [ Text "While in this stance, gain aura 2:"
          , List Unordered
              [ [ Text
                    """when you grant vigor to an ally in the aura, you
                    can deal 2 """
                , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                , Text
                    """ damage to a foe in the aura. If you ally was in
                    crisis, you deal damage to all foes in the aura
                    instead."""
                ]
              , [ Text
                    "when you rescue an ally in the aura, you can deal "
                , Dice 3 D3
                , Text
                    """ piercing damage to a foe in the aura. They must
                    save or be """
                , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                , Text "."
                ]
              ]
          , Text
              """Each effect can only trigger once a turn, but any number
              of times a round."""
          ]
      ]
  }
