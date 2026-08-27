module ToA.Resource.Icon.Job.Rake
  ( rake
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
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
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))

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
          , sign: Sign "icon-[game-icons--rolling-dices]"
          , soul: Name "Thief"
          , class: Name "Vagabond"
          , description: seq
              [ text
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
              , newline
              , newline
              , text
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
              Id "streak|talent|rake"
                : Id "roller|talent|rake"
                : Id "whirl|talent|rake"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Wild Gamble"
          , description: text
              """Once a round, instead of rolling the effect die, you can flip
              a lucky coin instead. Tails count as a 1, and heads count as a
              six. Flipping a coin doesn't count as rolling a die."""
          }
      ]

  , talents:
      [ Talent
          { id: Id "streak|talent|rake"
          , name: Name "Streak"
          , colour: Name "Yellow"
          , description: text
              """Once a round, when you roll a '6' on an effect die, you can
              gain a lucky coin (per Wild Gamble). This stacks with Wild Gamble
              itself, ignoring the 1/round limit."""
          }
      , Talent
          { id: Id "roller|talent|rake"
          , name: Name "Roller"
          , colour: Name "Yellow"
          , description: seq
              [ text
                  """The first time in a combat you roll a '6' on an effect die
                  or flip heads on a lucky coin, gain 6 """
              , italic $ ref (Name "Vigor") $ text "vigor"
              , text
                  """ and you may clear all negative status tokens affecting
                  you."""
              ]
          }
      , Talent
          { id: Id "whirl|talent|rake"
          , name: Name "Whirl"
          , colour: Name "Yellow"
          , description: text
              """Once a round, after you swap places with a character, you can
              dash 3 spaces. If you swapped with an ally, you can allow them to
              dash 3 instead."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Hot Streak"
          , colour: Name "Yellow"
          , description: text
              """You flip aether-infused coins, drawing on the power of chance
              to explosive results."""
          , cost: One /\ 3
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 4)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """You immediately gain and may flip up to 3 lucky coins,
                      one at a time in sequence. Each time, you must choose a
                      foe in range to be the target. You can target the same foe
                      more than once. Flipping a coin is optional."""
                  , list Unordered
                      [ seq
                          [ bold $ text "First coin"
                          , text ": "
                          , bold $ text "Heads"
                          , text ": "
                          , dice 2 D6
                          , text "+4 damage and you may flip the second coin. "
                          , bold $ text "Tails"
                          , text ": Half, and end this ability."
                          ]
                      , seq
                          [ bold $ text "Second coin"
                          , text ": "
                          , bold $ text "Heads"
                          , text ": "
                          , dice 2 D6
                          , text "+4 damage and you may flip the third coin. "
                          , bold $ text "Tails"
                          , text ": No effect, and end this ability."
                          ]
                      , seq
                          [ bold $ text "Third coin"
                          , text ": "
                          , bold $ text "Heads"
                          , text ": "
                          , dice 4 D6
                          , text
                              """+4 damage, burst area effect centered on your
                              target (save for half.)"""
                          , bold $ text "Tails"
                          , text ": You explode with the same effect, for "
                          , dice 2 D6
                          , text "+4 damage (save for half)."
                          ]
                      ]
                  , text
                      """Then, gain any coins you didn't flip. You can use them
                      any time, ignoring the 1/round limit on luck coins."""
                  ]
              ]
          }
      , Ability
          { name: Name "Lucky 6"
          , colour: Name "Yellow"
          , description: text
              "Some would say 'lucky shot'. To you, luck is a skill."
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing $ text "Dash 1."
              , AttackStep (text "1 damage") $ seq [ text "+", dice 1 D3 ]
              , Step Eff (Just D6) $ seq
                  [ text "Your foe takes 1 damage again after the attack (6+) "
                  , dice 2 D3
                  , text " damage again."
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6) $ seq
                  [ text "(1-3) "
                  , italic $ ref (Name "Stun") $ text "stun"
                  , text
                      """ yourself and end your turn (4-5): Your foe takes 2
                      damage again (6+): Your foe takes 6 damage again."""
                  ]
              ]
          }
      , Ability
          { name: Name "Bump and Lift"
          , colour: Name "Yellow"
          , description: text "Lighten their pockets."
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Dash 2, then swap places with an adjacent foe. You may
                      steal up to one (4+) two or (6+) three positive status
                      tokens from them. If they have no positive tokens when you
                      would steal a token, gain """
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text " instead."
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6) $ seq
                  [ text "(1-3) "
                  , italic $ ref (Name "Stun") $ text "stun"
                  , text
                      """ yourself and end your turn (4-5): Your foe is
                      additionally """
                  , italic $ ref (Name "Blinded") $ text "blinded"
                  , text
                      """ and takes 2 damage (6+) Gain the (4-5) effect, and you
                      may repeat the base effect of this ability again,
                      targeting a different foe."""
                  ]
              ]
          }
      , Ability
          { name: Name "Trick"
          , colour: Name "Yellow"
          , description: text
              "The real trick is being one step ahead of trouble."
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ text "You gain "
                      , italic $ ref (Name "Evasion") $ text "evasion"
                      , text
                          """ and one use of the following interrupt until the
                          start of your next turn:"""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Trick"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "A foe targets you with an ability."
                          , Step Eff Nothing $ text
                              """Swap places with a character in range after the
                              ability resolves."""
                          , Step (KeywordStep (Name "Gambit")) (Just D6) $ seq
                              [ text
                                  """(1-3) The ability deals +3 damage to you
                                  (4-5): gain """
                              , italic $ ref (Name "Stealth") $ text "stealth"
                              , text " (6): gain "
                              , italic $ text "stealth"
                              , text
                                  ", and the ability deals 1/2 damage to you."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Chaos Roulette"
          , colour: Name "Yellow"
          , description: text
              """You send a prayer to the multicolored titan, spinning the wheel
              of chance."""
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Roll the effect die, then gain one of the following
                      effects:"""
                  , list Unordered
                      [ seq
                          [ text "1: "
                          , italic $ ref (Name "Stun") $ text "Stun"
                          , text " yourself and end your turn."
                          ]
                      , seq
                          [ text
                              """2: Release a burst 2 (self) area effect. Foes
                              in the area take """
                          , dice 1 D6
                          , text "+4 damage (save for half) and are pushed 1."
                          ]
                      , seq
                          [ text
                              "3: All characters in range 1-2 are teleported "
                          , dice 1 D3
                          , text " spaces to a space of their choice."
                          ]
                      , seq
                          [ text "4: All characters in range 1-2 are "
                          , italic $ ref (Name "Blinded") $ text "blinded"
                          , text "."
                          ]
                      , text
                          """5: Swap the positions of all characters in range
                          1-2, in any order."""
                      , seq
                          [ text
                              """6: Pick a prior effect, then this action
                              becomes """
                          , italic $ ref (Name "Quick") $ text "quick"
                          , text ", refunding its action cost."
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing $ text
                  "After this ability resolves, roll the above effect again."
              ]
          }
      ]
  }
