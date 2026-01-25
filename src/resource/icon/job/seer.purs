module ToA.Resource.Icon.Job.Seer
  ( seer
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

seer :: Icon
seer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Seer"
          , colour: Name "Green"
          , soul: Name "Oracle"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """The Seers are made up of all the orders of stargazers,
                  corner prophets, folk healers, shamans, and all manner of
                  individuals that find themselves attracted to reading the
                  Great Arcana, the esoteric practice of reading destiny itself,
                  the Great Wheel of Arden Eld that determines the final fate of
                  all things. Usually found tucked away in the corners of Leggio
                  caravans, in high city spires, or in the back of smoky
                  taverns, their services are usually in high demand, though
                  only the especially skilled can truly read the Arcana and
                  there are many pretenders that muddy the waters."""
              , Newline
              , Newline
              , Text
                  """Through ritual, ceremony, and unrelenting practice, Seers
                  gain the ability to predict and even defy a person’s fate,
                  using their Aether infused card decks to influence the turning
                  of the Great Wheel and empower their allies with foresight,
                  precision, and uncanny accuracy."""
              ]
          , trait: Name "The Wheel"
          , keyword: Name "Gambit"
          , abilities:
              (I /\ Name "King of Swords")
                : (I /\ Name "The Emperor")
                : (II /\ Name "Wild Card")
                : (IV /\ Name "The Ewer")
                : empty
          , limitBreak: Name "High Prophecy"
          , talents:
              Id "prophet|talent|seer"
                : Id "foresight|talent|seer"
                : Id "harbor|talent|seer"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "The Wheel"
          , description:
              [ Text
                  """Once a round, when you create an area effect, you can
                  infuse it with the power of your deck of cards."""
              , List Unordered
                  [ [ Text
                        "Allies become immune to damage from the area effect."
                    ]
                  , [ Text "Then roll "
                    , Italic [ Dice 1 D6 ]
                    , Text
                        """ and see what heppens after the triggering ability
                        resolves."""
                    , List Ordered
                        [ [ Bold [ Text "The Moon" ]
                          , Text ": Create two spaces of "
                          , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                          , Text " terrain in the area."
                          ]
                        , [ Bold [ Text "The Papessa" ]
                          , Text ": Teleport all characters in the area 1."
                          ]
                        , [ Bold [ Text "The Sun" ]
                          , Text
                              """: All foes in the area take 2 piercing damage
                              and lose """
                          , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                          , Text " or "
                          , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                          , Text "."
                          ]
                        , [ Bold [ Text "The Judge" ]
                          , Text ": "
                          , Italic [ Ref (Name "Brand") [ Text "Brand" ] ]
                          , Text " all foes in the area."
                          ]
                        , [ Bold [ Text "The Fool" ]
                          , Text ": Push one character in the area 4 spaces."
                          ]
                        , [ Bold [ Text "The Axe" ]
                          , Text ": The area effect deals +2 damage."
                          ]
                        ]
                    , Text
                        """When you roll a result, it is removed from the deck.
                        If you roll the same result again, you may choose which
                        card you draw. Once all cards have been drawn from the
                        deck, reset the table."""
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "prophet|talent|seer"
          , name: Name "Prophet"
          , colour: Name "Green"
          , description:
              [ Text
                  """At the start of combat, you may pre-roll up to two effect
                  dice. These dice are automatically the result of your nect two
                  effect rolls."""
              ]
          }
      , Talent
          { id: Id "foresight|talent|seer"
          , name: Name "Foresight"
          , colour: Name "Green"
          , description:
              [ Text "You gain effect "
              , Power
              , Text " at round 3 or alter, doubled at round 5 or later."
              ]
          }
      , Talent
          { id: Id "harbor|talent|seer"
          , name: Name "Harbor"
          , colour: Name "Green"
          , description:
              [ Text
                  """Once a round, you may grant an ally immunity to any part of
                  any area effect you create."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "High Prophecy"
          , colour: Name "Green"
          , description:
              [ Text
                  """A burning third eye of pure etheric energy appears on your
                  forehead. Possibilities unfurl before you, laid out like
                  infinite gleaming threads."""
              ]
          , cost: Quick /\ 2
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Roll "
                  , Dice 4 D6
                  , Text
                      """, then record each number rolled. For the next four
                      times you roll a d6 for an effect roll, you use those
                      exact numbers, in order. This effect only ends once all
                      numbers have been used. When you first make this roll and
                      see the result, you can defy this fate and re-roll any of
                      these numbers, taking the second result as final. However,
                      each time you do, you must """
                  , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                  , Text " the new result in hp."
                  ]
              ]
          }
      , Ability
          { name: Name "King of Swords"
          , colour: Name "Green"
          , description:
              [ Text
                  """A flash of bright color, and a card is stuck to your foe,
                  bursting into arcane fire in a flash."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step OnHit Nothing
                  [ Text
                      """You attach a card to your target. The next time your
                      target is hit by an attack, the card explodes for a blast
                      3 area effect with at least one space on your foe, dealing
                      2 damage to all foes and granting 2 vigor to all
                      allies."""
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6)
                  [ Text
                      """(1-2) Defuse the card, dealing 1 damage to your foe,
                      (3-4) increase the blast size by +1, (5+) increase the
                      blast size by +1 and you may immediately detonate the
                      card."""
                  ]
              ]
          }
      , Ability
          { name: Name "The Emperor"
          , colour: Name "Green"
          , description:
              [ Text
                  """You attach the Emperor card to your ally, granting them
                  temporary but potent martial prowess."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 3) (NumVar 5))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """You flick a beautifully illustrated card into the air
                      that attaches to an ally. That ally gains """
                  , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                  , Text
                      """. At the end of your ally's next turn, that ally
                      releases a burst 1 (self) explosion, pushing all adjacent
                      characters 1. Foes inside take 2 damage. If there were 4
                      or more characters in the area, foes take +"""
                  , Dice 1 D3
                  , Text
                      """ damage, and damage becomes """
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6)
                  [ Text
                      """You may gambit to change the shape of the area: (1-2)
                      close line 3 (3-5) cross 3 (6) blast 5, with at least one
                      space on your ally."""
                  ]
              ]
          }
      , Ability
          { name: Name "Wild Card"
          , colour: Name "Green"
          , description:
              [ Text
                  """You flick a beautifully illustrated ethereal card onto the
                  battlefield, laden with the threads of potential."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Summon")
              , End
              , RangeTag (Range (NumVar 2) (NumVar 5))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D6)
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """, and summon one or (5+) two painted cards in free
                      space in range."""
                  ]
                  $ SummonInset
                      { name: Name "Painted Card"
                      , colour: Name "Green"
                      , max: 4
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """When the card is included in your own or an
                                  allied area effect, you may cause it to
                                  explode for a burst 1 area effect centered on
                                  it, extending the total area of the triggering
                                  ability. Then """
                              , Italic [ Text "dismiss" ]
                              , Text
                                  """ it. Wild cards can trigger other wild
                                  cards."""
                              ]
                          , Step (KeywordStep (Name "Gambit")) (Just D6)
                              [ Text
                                  """Gambit only when triggered. (1-2): The card
                                  fizzles instead, dismissing it and dealing 2
                                  damage to an adjacent foe, (3-5): Increase the
                                  burst size +1, (6): Increase the burst size
                                  +2."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "The Ewer"
          , colour: Name "Green"
          , description:
              [ Text
                  """You flick a card that bursts into powerful jets of ethereal
                  water."""
              ]
          , cost: One
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """You shoot a card out along the line, releasing a cross
                      explosion centered on iether the end space or the first
                      character in the line. The size of the cross is equal to
                      the spaces the card traveled before impacting its target.
                      Foes in the area take 2 piercing damage, or """
                  , Dice 1 D3
                  , Text
                      """+1 piercing if the card traveled 5 or more spaces.
                      Allies gain the same amount of vigor, doubled on any
                      allies in crisis."""
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6)
                  [ Text
                      """(1-3) the card only flies 3 (4-5) the card may hit any
                      character on the line, (6) the card may hit any character
                      on the line, travels line +3 and phases through
                      objects."""
                  ]
              ]
          }
      ]
  }
