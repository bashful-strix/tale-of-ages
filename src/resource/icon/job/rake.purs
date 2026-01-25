module ToA.Resource.Icon.Job.Rake
  ( rake
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
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

rake :: Icon
rake =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Rake"
          , colour: Name "Yellow"
          , soul: Name "Thief"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Master thieves and deal-makers of the city backwaters and
                  churner camps. In such a vibrant and dangerous locale, it is
                  as important to cultivate an impressive reputation as it is to
                  gain skill with a blade. Dressing to fit the part and having
                  the coin and swagger to match is critical for survival,
                  therefore the most (in)famous Rakes are frequent participants
                  in the camp and city nightlife. Those that traffic in this
                  profession accumulate over time a supernatural skill with
                  luck, often attributed to their tributes to the multicolored
                  titan of chance."""
              , Newline
              , Newline
              , Text
                  """The core tenets of most churner thieves guilds are clear:
                  do it for the love of the game. Take from those that don’t
                  deserve it and can suffer the loss, and skim a little on the
                  side for your old mum (whether she’s alive or not). It’s only
                  fair."""
              ]
          , trait: Name "Wild Gamble"
          , keyword: Name "Gambit"
          , abilities:
              (I /\ Name "Lucky 6")
                : (I /\ Name "Bump and Lift")
                : (II /\ Name "Trick")
                : (IV /\ Name "Chaos Roulette")
                : empty
          , limitBreak: Name "Hot Streak"
          , talents:
              Name "Streak"
                : Name "Roller"
                : Name "Whirl"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Wild Gamble"
          , description: 
              [ Text
                  """Once a round, instead of rolling the effect die, you can
                  flip a lucky coin instead. Tails count as a 1, and heads count
                  as a six. Flipping a coin doesn't count as rolling a die."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "streak|talent|rake"
          , name: Name "Streak"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a round, when you roll a '6' on an effect die, you can
                  gain a lucky coin (per Wild Gamble). This stacks with Wild
                  Gamble itself, ignoring the 1/round limit."""
              ]
          }
      , Talent
          { id: Id "roller|talent|rake"
          , name: Name "Roller"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """The first time in a combat you roll a '6' on an effect die
                  or flip heads on a lucky coin, gain 6 """
              , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
              , Text
                  """ and you may clear all negative status tokens affecting
                  you."""
              ]
          }
      , Talent
          { id: Id "whirl|talent|rake"
          , name: Name "Whirl"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a round, after you swap places with a character, you
                  can dash 3 spaces. If you swapped with an ally, you can allow
                  them to dash 3 instead."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Hot Streak"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You flip aether-infused coins, drawing on the power of
                  chance to explosive results."""
              ]
          , cost: One /\ 3
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 4)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """You immediately gain and may flip up to 3 lucky coins,
                      one at a time in sequence. Each time, you must choose a
                      foe in range to be the target. You can target the same foe
                      more than once. Flipping a coin is optional."""
                  , List Unordered
                      [ [ Bold [ Text "First coin" ]
                        , Text ": "
                        , Bold [ Text "Heads" ]
                        , Text ": "
                        , Dice 2 D6
                        , Text "+4 damage and you may flip the second coin. "
                        , Bold [ Text "Tails" ]
                        , Text ": Half, and end this ability."
                        ]
                      , [ Bold [ Text "Second coin" ]
                        , Text ": "
                        , Bold [ Text "Heads" ]
                        , Text ": "
                        , Dice 2 D6
                        , Text "+4 damage and you may flip the third coin. "
                        , Bold [ Text "Tails" ]
                        , Text ": No effect, and end this ability."
                        ]
                      , [ Bold [ Text "Third coin" ]
                        , Text ": "
                        , Bold [ Text "Heads" ]
                        , Text ": "
                        , Dice 4 D6
                        , Text
                            """+4 damage, burst area effect centered on your
                            target (save for half.)"""
                        , Bold [ Text "Tails" ]
                        , Text ": You explode with the same effect, for "
                        , Dice 2 D6
                        , Text "+4 damage (save for half)."
                        ]
                      ]
                  , Text
                      """Then, gain any coins you didn't flip. You can use them
                      any time, ignoring the 1/round limit on luck coins."""
                  ]
              ]
          }
      , Ability
          { name: Name "Lucky 6"
          , colour: Name "Yellow"
          , description:
              [ Text "Some would say 'lucky shot'. To you, luck is a skill." ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 1." ]
              , AttackStep [ Text "1 damage" ] [ Text "+", Dice 1 D3]
              , Step Eff (Just D6)
                  [ Text "Your foe takes 1 damage again after the attack (6+) "
                  , Dice 2 D3
                  , Text " damage again."
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6)
                  [ Text "(1-3) "
                  , Italic [ Ref (Name "Stun") [ Text "stun" ] ]
                  , Text
                      """ yourself and end your turn (4-5): Your foe takes 2
                      damage again (6+): Your foe takes 6 damage again."""
                  ]
              ]
          }
      , Ability
          { name: Name "Bump and Lift"
          , colour: Name "Yellow"
          , description: [ Text "Lighten their pockets." ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Dash 2, then swap places with an adjacent foe. You may
                      steal up to one (4+) two or (6+) three positive status
                      tokens from them. If they have no positive tokens when you
                      would steal a token, gain """
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text " instead."
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6)
                  [ Text "(1-3) "
                  , Italic [ Ref (Name "Stun") [ Text "stun" ] ]
                  , Text
                      """ yourself and end your turn (4-5): Your foe is
                      additionally """
                  , Italic [ Ref (Name "Blinded") [ Text "blinded" ] ]
                  , Text
                      """ and takes 2 damage (6+) Gain the (4-5) effect, and you
                      may repeat the base effect of this ability again,
                      targeting a different foe."""
                  ]
              ]
          }
      , Ability
          { name: Name "Trick"
          , colour: Name "Yellow"
          , description:
              [ Text "The real trick is being one step ahead of trouble." ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ InsetStep Eff Nothing
                  [ Text "You gain "
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text
                      """ and one use of the following interrupt until the start
                      of your next turn:"""
                  ]
                  $ AbilityInset
                      { name: Name "Trick"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "A foe targets you with an ability." ]
                          , Step Eff Nothing
                              [ Text
                                  """Swap places with a character in range after
                                  the ability resolves."""
                              ]
                          , Step (KeywordStep (Name "Gambit")) (Just D6)
                              [ Text
                                  """(1-3) The ability deals +3 damage to you
                                  (4-5): gain """
                              , Italic
                                  [ Ref (Name "Stealth") [ Text "stealth" ] ]
                              , Text " (6): gain "
                              , Italic [ Text "stealth" ]
                              , Text
                                  ", and the ability deals 1/2 damage to you."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Chaos Roulette"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You send a prayer to the multicolored titan, spinning the
                  wheel of chance."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Roll the effect die, then gain one of the following
                      effects:"""
                  , List Unordered
                      [ [ Text "1: "
                        , Italic [ Ref (Name "Stun") [ Text "Stun" ] ]
                        , Text " yourself and end your turn."
                        ]
                      , [ Text
                            """2: Release a burst 2 (self) area effect. Foes in
                            the area take """
                        , Dice 1 D6
                        , Text "+4 damage (save for half) and are pushed 1."
                        ]
                      , [ Text "3: All characters in range 1-2 are teleported "
                        , Dice 1 D3
                        , Text " spaces to a space of their choice."
                        ]
                      , [ Text "4: All characters in range 1-2 are "
                        , Italic [ Ref (Name "Blinded") [ Text "blinded" ] ]
                        , Text "."
                        ]
                      , [ Text
                            """5: Swap the positions of all characters in range
                            1-2, in any order."""
                        ]
                      , [ Text
                            "6: Pick a prior effect, then this action becomes "
                        , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                        , Text ", refunding its action cost."
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text
                      """After this ability resolves, roll the above effect
                      again."""
                  ]
              ]
          }
      ]
  }
