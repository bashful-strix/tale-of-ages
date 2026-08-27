module ToA.Resource.Icon.Job.Chanter
  ( chanter
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
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
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

chanter :: Icon
chanter =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Chanter"
          , colour: Name "Green"
          , sign: Sign "icon-[game-icons--bookmarklet]"
          , soul: Name "Bard"
          , class: Name "Mendicant"
          , description: seq
              [ text
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
              , newline
              , newline
              , text
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
              Id "poise|talent|chanter"
                : Id "elegance|talent|chanter"
                : Id "peace|talent|chanter"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Book of Ages"
          , description: seq
              [ text
                  """You automatically enter the Book of Ages stance at the
                  start of combat. If you aren't in the stance, you enter it
                  again automatically if you end your turn without attacking."""
              , list Unordered
                  [ text "This stance stacks with other stances."
                  , seq
                      [ text
                          """While in this stance, once a round, you may choose
                          one of the following effects:"""
                      , list Unordered
                          [ text
                              """when you grant a positive token, grant an
                              identical token to the same character."""
                          , text
                              """when you grant vigor, grant 3 more vigor to the
                              same character."""
                          ]
                      ]
                  , text "You exit the stance after attacking."
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "poise|talent|chanter"
          , name: Name "Poise"
          , colour: Name "Green"
          , description: text
              """At the start of combat, you may enter a stance that costs 1
              action or less as a quick action, or reduce the cost of a stance
              that costs 2 actions this turn to 1 action. If you do, you cannot
              attack that turn."""
          }
      , Talent
          { id: Id "elegance|talent|chanter"
          , name: Name "Elegance"
          , colour: Name "Green"
          , description: text
              """When you enter a stance for the first time in a round, you may
              fly 3."""
          }
      , Talent
          { id: Id "peace|talent|chanter"
          , name: Name "Peace"
          , colour: Name "Green"
          , description: text
              """You take half damage in the first round of combat. This effect
              breaks if you attack."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Monogatari"
          , colour: Name "Green"
          , description: text
              """You sing a choice passage from the Great Chant, letting its
              words resonate in the air and bring hope to your companions."""
          , cost: One /\ 2
          , tags: []
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "You sing a short passage from the book of ages. Roll "
                  , italic $ dice 1 D6
                  , text
                      """ and consult the following table to see which song you
                      sing. The song resonates in the air until the start of
                      your next turn. You then sing a new passage, rolling
                      again. At the end of their turn, any friendly character
                      (including yourself) that fulfilled the condition of the
                      passage gains """
                  , italic $ ref (Name "Strength") $ text "strength"
                  , text " and 2 "
                  , italic $ ref (Name "Vigor") $ text "vigor"
                  , text "."
                  , newline
                  , newline
                  , list Ordered
                      [ seq
                          [ bold $ text "A Tale of Fury"
                          , text
                              """: Reduced a character to 0 hp or reduced them
                              below 50% hp if above."""
                          ]
                      , seq
                          [ bold $ text "A Tale of Travels"
                          , text
                              """: Moved more than 4 spaces from your starting
                              point on your turn."""
                          ]
                      , seq
                          [ bold $ text "A Tale of Green and Pleasant Times"
                          , text ": Did not attack."
                          ]
                      , seq
                          [ bold $ text "A Tale of Cunning"
                          , text
                              ": Used a mark, stance, aura, or combo ability."
                          ]
                      , seq
                          [ bold $ text "A Tale of Boon Companions"
                          , text ": Ended your turn adjacent to an ally."
                          ]
                      , seq
                          [ bold $ text "A Tale of Triumph"
                          , text ": Used an ability on an ally."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Holy"
          , colour: Name "Green"
          , description: text
              """You chant a word of making, and the world explodes with holy
              light."""
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 3) (NumVar 5))
              , AreaTag (Cross (NumVar 3))
              ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text "Foes take 2 "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage, or "
                  , dice 2 D3
                  , text
                      """ piercing if there was a defeated ally in the area. All
                      allies in the area gain vigor depending on their hp
                      amount:"""
                  , list Unordered
                      [ text "Above 50%: 1 vigor."
                      , seq [ text "Bloodied: ", dice 1 D3, text "+1." ]
                      , seq
                          [ text "Crisis: "
                          , dice 3 D3
                          , text
                              """+3. May heal over vigor maximum. At the end of
                              an ally's turn, reduce down to their maximum if
                              higher."""
                          ]
                      , seq
                          [ text "Defeated: Automatically "
                          , italic $ text "rescued"
                          , text "."
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing $ seq
                  [ text "Any foe in the center space is "
                  , italic $ ref (Name "Brand") $ text "branded"
                  , text " and must save or be "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Magnasancti"
          , colour: Name "Green"
          , description: text
              """You sanctify an area with passages of peace, the inscriptions
              over the doors of the Highest House."""
          , cost: Two
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """Create a shimmering cross 1 zone of light, which can be
                      created over characters. While inside the zone, you and
                      allies have """
                  , italic $ ref (Name "Fly") $ text "flying"
                  , text " when moving and gain "
                  , italic $ ref (Name "Strength") $ text "strength"
                  , text " if they end their turn there."
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing $ text
                  "Reduce action cost to 1."
              ]
          }
      , Ability
          { name: Name "Gentle Prayer"
          , colour: Name "Green"
          , description: text
              """You radiate an aura of such powerful peace that all close to
              you, monster or man, find it impossible to raise a hand in
              violence."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Aura") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text "While in this stance, gain aura 1:"
                  , list Unordered
                      [ seq
                          [ text "Attacks from and against "
                          , italic $ text "all"
                          , text " characters in the area gain "
                          , weakness
                          , text "."
                          ]
                      , text
                          """Characters that attack in the aura immediately end
                          their turn after attacking."""
                      , text
                          """Immediately exit this stance and end your turn if
                          you attack."""
                      ]
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing $ text
                  """Increase the base size of the aura by +1 (max base aura
                  3). This effect stacks, but ends and resets if you exit the
                  aura."""
              ]
          }
      , Ability
          { name: Name "Esper"
          , colour: Name "Green"
          , description: text
              """You chant from the hermetic passages, turning the healing
              magics of the chant into a terrifying soul-cutting force.
              Forbidden to all but the most experienced chanters."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text "While in this stance, gain aura 2:"
                  , list Unordered
                      [ seq
                          [ text
                              """when you grant vigor to an ally in the aura,
                              you can deal 2 """
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text
                              """ damage to a foe in the aura. If your ally was
                              in crisis, you deal damage to all foes in the aura
                              instead."""
                          ]
                      , seq
                          [ text
                              """when you rescue an ally in the aura, you can
                              deal """
                          , dice 3 D3
                          , text
                              """ piercing damage to a foe in the aura. They
                              must save or be """
                          , italic $ ref (Name "Stun") $ text "stunned"
                          , text "."
                          ]
                      ]
                  , text
                      """Each effect can only trigger once a turn, but any
                      number of times a round."""
                  ]
              ]
          }
      ]
  }
