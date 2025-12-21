module ToA.Resource.Icon.Job.Chanter
  ( chanter
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

chanter :: Icon
chanter =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Chanter"
          , colour: Name "Green"
          , soul: Name "Bard"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Descending from numerous holy orders that have their roots
                  high in the chronicler monasteries, the Chanters are part
                  singer, part storyteller, and part priest. At the time of the
                  Doom, when all knowledge was deemed lost and everything put to
                  page was transformed into ash, the only thing that persisted
                  was the power of song, poetry, and the spirit of survival. A
                  select order of priests committed all the great and necessary
                  knowledge of Kin to memory, creating a single, continuous
                  song, known as the Great Chant. In myths, stories, and
                  histories, they recorded the knowledge of the ancients,
                  transforming it into liturgy."""
              , Newline
              , Newline
              , Text
                  """The Chant performed its role, and it was through its power
                  that the early bands of Kin survived and persevered through
                  the darkest days. Today, however, it is so archaic,
                  convoluted, and long that many dispute the meaning of its
                  dogma, though none can deny its value as a mythic text. The
                  Old Church of the chroniclers has splintered into factions
                  that mostly squabble over its meaning and try to draw some
                  angle from its numerous and sometimes contradictory adaptions
                  into holy texts. Nevertheless, the Chant still holds power -
                  real, tangible power - to heal, mend, and uplift."""
              ]
          , trait: Name "Book of Ages"
          , keyword: Name "Conserve"
          , abilities:
              (I /\ Name "Holy")
                : (I /\ Name "Magnasancti")
                : (II /\ Name "Gentle Prayer")
                : (IV /\ Name "Esper")
                : empty
          , limitBreak: Name "Monogatari"
          , talents:
              Name "Poise"
                : Name "Elegance"
                : Name "Peace"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Book of Ages"
          , description:
              [ Text
                  """You automatically enter the Book of Ages stance at the
                  start of combat. If you aren't in the stance, you enter it
                  again automatically if you end your turn without attacking."""
              , List Unordered
                  [ [ Text "This stance stacks with other stances." ]
                  , [ Text
                        """While in this stance, once a round, you may choose
                        one of the following effects:"""
                    , List Unordered
                        [ [ Text
                              """when you grant a positive token, grant an
                              identical token to the same character."""
                          ]
                        , [ Text
                              """when you grant vigor, grant 3 more vigor to the
                              same character."""
                          ]
                        ]
                    ]
                  , [ Text "You exit the stance after attacking." ]
                  ]
              ]
          , subItem: Nothing
          }
      ]
  , talents:
      [ Talent
          { name: Name "Poise"
          , colour: Name "Green"
          , description:
              [ Text
                  """At the start of combat, you may enter a stance that costs 1
                  action or less as a quick action, or reduce the cost of a
                  stance that costs 2 actions this turn to 1 action. If you do,
                  you cannot attack that turn."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Elegance"
          , colour: Name "Green"
          , description:
              [ Text
                  """When you enter a stance for the first time in a round, you
                  may fly 3."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Peace"
          , colour: Name "Green"
          , description:
              [ Text
                  """You take half damage in the first round of combat. This
                  effect breaks if you attack."""
              ]
          , subItem: Nothing
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Monogatari"
          , colour: Name "Green"
          , description:
              [ Text
                  """You sing a choice passage from the Great Chant, letting its
                  words resonate in the air and bring hope to your
                  companions."""
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
                      sing. The song resonates in the air until the start of
                      your next turn. You then sing a new passage, rolling
                      again. At the end of their turn, any friendly character
                      (including yourself) that fulfilled the condition of the
                      passage gains """
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
      , Ability
          { name: Name "Holy"
          , colour: Name "Green"
          , description:
              [ Text
                  """You chant a word of making, and the world explodes with
                  holy light."""
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
      , Ability
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
      , Ability
          { name: Name "Gentle Prayer"
          , colour: Name "Green"
          , description:
              [ Text
                  """You radiate an aura of such powerful peace that all close
                  to you, monster or man, find it impossible to raise a hand in
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
      , Ability
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
                      """Each effect can only trigger once a turn, but any
                      number of times a round."""
                  ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
