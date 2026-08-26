module ToA.Resource.Icon.Job.Theurgist
  ( theurgist
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
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , newline
  , power
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

theurgist :: Icon
theurgist =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Theurgist"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--shard-sword]"
          , soul: Name "Flame"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Sometimes called soulblades or inquisitors, Theurgists are
                  powerful and widely feared chronicler church mages from an
                  esoteric order that sturdy flame aether’s powerful connection
                  to the soul itself, forging it into a terrifying art that
                  allows them to call scorching beams or wreathe their weapons
                  in soul fire. They are relatively rare and tend have a poor
                  reputation as fanatics and meddlers, given people’s wariness
                  of manipulation of the soul."""
              , newline
              , newline
              , text
                  """Theurgists are rumored to have the power to see through
                  lies through minor fluctuations in the soul’s Aether and are
                  often employed as interrogators or bounty hunters by would-be
                  rulers. In practice they are perhaps unfairly maligned, as
                  when they are not doing battle, their unparalleled ability to
                  diagnose afflictions of the soul’s Aether allows them to lift
                  curses, corruptions, and illusions."""
              ]
          , trait: Name "Blazing Blade"
          , keyword: Name "Sacrifice"
          , abilities:
              (I /\ Name "Soul Cleave")
                : (I /\ Name "Soul Burn")
                : (II /\ Name "Blazing Bond")
                : (IV /\ Name "Fierce Crucible")
                : empty
          , limitBreak: Name "Transmigration of Fire"
          , talents:
              Id "zeal|talent|theurgist"
                : Id "bloodwell|talent|theurgist"
                : Id "ardor|talent|theurgist"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Blazing Blade"
          , description: seq
              [ text
                  """Once a round, you may attempt one of the following, rolling
                  a d6 and attempting to roll equal to or under the round
                  number, and gaining the following on success:"""
              , list Unordered
                  [ seq
                      [ bold $ text "Blade cleave"
                      , text
                          """: When you hit an attack, cut deeply into your
                          target's soul, forcing them to """
                      , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                      , text " 4 hp."
                      ]
                  , seq
                      [ bold $ text "Blade parry"
                      , text ": When you are damaged, gain 4 "
                      , italic $ text "vigor"
                      , text " before being damaged."
                      ]
                  ]
              , text "If you are bloodied, roll "
              , dice 2 D6
              , text " and pick the lowest. If you are in crisis, roll "
              , dice 3 D6
              , text " and pick the lowest instead."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "zeal|talent|theurgist"
          , name: Name "Zeal"
          , colour: Name "Blue"
          , description: text
              """Once per combat, you can count yourself as bloodied from the
              start of your turn until the start of your next turn, even if
              you're above 50% hp."""
          }
      , Talent
          { id: Id "bloodwell|talent|theurgist"
          , name: Name "Bloodwell"
          , colour: Name "Blue"
          , description: text
              "If you're in crisis, reduce all sacrifice costs to 2 if higher."
          }
      , Talent
          { id: Id "ardor|talent|theurgist"
          , name: Name "Ardor"
          , colour: Name "Blue"
          , description: seq
              [ text "Increase the effect of "
              , italic $ ref (Name "Keen") $ text "keen"
              , text " for yourself and adjacent allies to "
              , power
              , power
              , text
                  """. When you are bloodied for the first time in a combat,
                  gain """
              , italic $ text "keen"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Transmigration of Fire"
          , colour: Name "Blue"
          , description: seq
              [ text "O Flame, I command thee,"
              , newline
              , text "Make a pyre of our souls,"
              , newline
              , text "And a crucible of our sin,"
              , newline
              , text "Great Transmigration!"
              ]
          , cost: One /\ 3
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Choose yourself and a willing ally in range, or two
                      willing allies in range. Exchange the hp totals of each
                      character. Any bloodied character after the swap gains 3
                      vigor. And character in crisis gains """
                  , dice 3 D3
                  , text " vigor instead, or "
                  , dice 3 D6
                  , text " if they're at 1 hp."
                  ]
              ]
          }
      , Ability
          { name: Name "Soul Cleave"
          , colour: Name "Blue"
          , description: text
              """Your weapon bursts into flame, a lash extending far beyond its
              natural reach. It scorches only the soul, leaving flesh and metal
              untouched."""
          , cost: Two
          , tags: [ Attack, RangeTag Melee, AreaTag (Line (NumVar 4)) ]
          , steps:
              [ AttackStep
                  ( seq
                      [ text "Target "
                      , italic $ ref (Name "Sacrifice") $ text "sacrifices"
                      , text " 2"
                      ]
                  )
                  $ seq
                      [ text "Target "
                      , italic $ text "sacrifices"
                      , text " +"
                      , dice 3 D3
                      ]
              , Step AreaEff Nothing $ seq
                  [ text "Characters "
                  , italic $ text "sacrifice"
                  , text " 2 hp."
                  ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 8)) Nothing
                  $ text "Reduce action cost to 1."
              ]
          }
      , Ability
          { name: Name "Soul Burn"
          , colour: Name "Blue"
          , description: text
              "You stoke the furnace with the very essence of your being."
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), TargetTag Self ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text
                      """Burn your own life force into a fierce blaze. In this
                      stance:"""
                  , list Unordered
                      [ seq
                          [ text "You may "
                          , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                          , text " 2 at the end of your turn."
                          ]
                      , seq
                          [ text "Once a turn, when you "
                          , italic $ text "sacrifice"
                          , text
                              """, you may shoot a soul spark at a foe in range
                              2-5, igniting """
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous"
                          , text
                              """ terrain under them. Foes already in dangerous
                              terrain take 1 piercing damage and gain """
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text "."
                          ]
                      , seq
                          [ text
                              """If you're bloodied, shoot a spark at a
                              different foe. If you're in crisis, shoot another
                              spark at a different foe. If you're at 1 hp, shoot
                              a spark at """
                          , italic $ text "all"
                          , text " foes in range."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Blazing Bond"
          , colour: Name "Blue"
          , description: text
              """You link the soul Aether of you and a companion with a chain of
              pure fire aether, drawing from the strength of one to bolster the
              other."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Mark")
              , TargetTag Ally
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Mark")) Nothing
                  ( text
                      """gain the following interrupt at the start of your turns
                      while your target is marked."""
                  )
                  $ AbilityInset
                      { name: Name "Heartfire"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ seq
                              [ text "You or your marked ally takes damage or "
                              , italic
                                  $ ref (Name "Sacrifice")
                                  $ text "sacrifices"
                              , text
                                  """ hp, and are in range and line of sight of
                                  each other."""
                              ]
                          , Step Eff Nothing $ seq
                              [ text
                                  """You can choose to grant 3 vigor to the
                                  target before they take the damage, or reduce
                                  the sacrifice cost by 3. If you do, the other
                                  partner """
                              , italic $ text "sacrifices"
                              , text " 3, then gains "
                              , italic $ ref (Name "Keen") $ text "keen"
                              , text "."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Fierce Crucible"
          , colour: Name "Blue"
          , description: text
              """You ignite a fierce blaze in the soul of your target, purging
              them of deadly maladies, but scorching their very essence in the
              process."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 5))
              , TargetTag Self
              , TargetTag Ally
              ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ bold $ text "Burst 1 (target)"
                  , text ": "
                  , dice 2 D3
                  , text " piercing damage to all other characters and push 1."
                  ]
              , Step Eff Nothing $ seq
                  [ text "Target may clear all negative statuses, then gains 2 "
                  , italic $ ref (Name "Keen") $ text "keen"
                  , text "."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """At the start of your target's next turn, if they are
                      not bloodied, they """
                  , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                  , text
                      """ hp until they are bloodied. If they are below
                      bloodied, they """
                  , italic $ text "sacrifice"
                  , text " until they are at 1 hp."
                  ]
              ]
          }
      ]
  }
