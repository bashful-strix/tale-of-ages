module ToA.Resource.Icon.Job.Enochian
  ( enochian
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

enochian :: Icon
enochian =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Enochian"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--fire-ray]"
          , soul: Name "Flame"
          , class: Name "Wright"
          , description: seq
              [ text
                  """The Enochian Orders of pyromancers are the most chaotic of
                  the wright orders. Though sometimes associated with Churners,
                  they have no official organization, most of their members
                  being hedge wizards or self taught. Many Enochians disdain
                  authority and work for hire, sleeping and eating where they
                  can and relying on the communities they work for to support
                  them. Those that work on contract with guilds, armies, or
                  mercenary companies tend to value their independence."""
              , newline
              , newline
              , text
                  """The power that condenses inside an Enochian is related to
                  the element of fire, a wild spark that grows and wanes with
                  their emotions and energy, but with control can be focused
                  into power that can carve mountains, scorch forests, and boil
                  rivers. In times of desperation, the Enochians can feed this
                  power with their own life force, a dangerous practice that the
                  other orders of wrights look down upon. The Enochians, for
                  their part, see other wrights as stiff and uncreative. They’d
                  rather do it their way, after all."""
              ]
          , trait: Name "Inner Furnace"
          , keyword: Name "Reckless"
          , abilities:
              (I /\ Name "Pyro")
                : (I /\ Name "Ignite")
                : (II /\ Name "Implode")
                : (IV /\ Name "Blackstar")
                : empty
          , limitBreak: Name "Gigaflare"
          , talents:
              Id "megiddo|talent|enochian"
                : Id "melt|talent|enochian"
                : Id "phoenix|talent|enochian"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Inner Furnace"
          , description: seq
              [ text
                  """Once a round, at the start of your turn, you may stoke your
                  soul aether, performing one of the following:"""
              , list Unordered
                  [ seq
                      [ bold $ text "Heat"
                      , text ": Gain "
                      , italic $ ref (Name "Reckless") $ text "reckless"
                      , text
                          """. Your next damaging ability increases its area
                          sizes by +1 and its base attack and area damage by
                          +2."""
                      ]
                  , seq
                      [ bold $ text "Cool"
                      , text ": "
                      , italic $ ref (Name "Sacrifice") $ text "Sacrifice"
                      , text " 6, then end all negative statuses affecting you."
                      ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "megiddo|talent|enochian"
          , name: Name "Megiddo"
          , colour: Name "Blue"
          , description: text
              "At round 4+, all area abilities you create deal +2 area damage."
          }
      , Talent
          { id: Id "melt|talent|enochian"
          , name: Name "Melt"
          , colour: Name "Blue"
          , description: seq
              [ text "You increase the effects of "
              , italic $ ref (Name "Slow") $ text "slow"
              , text " tokens "
              , italic $ text "you"
              , text
                  """ inflict to -3 spaces. When you critical hit, you can
                  inflict """
              , italic $ text "slow"
              , text "."
              ]
          }
      , Talent
          { id: Id "phoenix|talent|enochian"
          , name: Name "Phoenix"
          , colour: Name "Blue"
          , description: seq
              [ text "When you are defeated, you deal "
              , dice 1 D6
              , text
                  """+2 piercing damage to all adjacent foes and push them 1.
                  You may then automatically """
              , italic $ ref (Name "Rescue") $ text "rescue"
              , text " yourself at the start of your next turn."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Gigaflare"
          , colour: Name "Blue"
          , description: seq
              [ text "I, who stand at the apex of things,"
              , newline
              , text "Condemn thee to the deepest pits of despair."
              , newline
              , text "Let thy very bones become ash!"
              , newline
              , text "O Flame, let the air become death!"
              , newline
              , text "Ignote, and be banished to Hell! Gigaflare!"
              ]
          , cost: Two /\ 4
          , tags: []
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text
                      """You summon the Eldflame, the primeval force of
                      creation, dealing piercing damage equal to """
                  , dice 1 D6
                  , text " + the round number to "
                  , italic $ text "every"
                  , text
                      """ character on the battlefield, ignoring line of sight
                      and cover. Characters in range 1-2 of you are exempt from
                      this ability."""
                  ]
              , Step Eff Nothing $ seq
                  [ text "This limit break upgrades."
                  , list Unordered
                      [ seq
                          [ text "If you're bloodied, it becomes "
                          , bold $ text "Megaloflare"
                          , text ", and deals damage twice."
                          ]
                      , seq
                          [ text "If you're in crisis, it becomes "
                          , bold $ text "Megiddoflare"
                          , text ", dealing damage three times instead."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Pyro"
          , colour: Name "Blue"
          , description: text
              """Power curls into a writhing ball in your hand, before it's
              unleashed on your enemies."""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 8))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step AreaEff Nothing $ text "2 damage."
              , Step (KeywordStep (Name "Reckless")) (Just D6) $ seq
                  [ text "Gains damage "
                  , power
                  , text
                      """. After the ability resolves, the area explodes,
                      igniting """
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text
                      """ terrain under all characters inside (5+) then dealing
                      2 piercing damage to those characters."""
                  ]
              ]
          }
      , Ability
          { name: Name "Ignite"
          , colour: Name "Blue"
          , description: text
              """You spark a hungry flame in the soul aether of your foe,
              burning them from the inside."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , TargetTag Foe
              , RangeTag (Range (NumVar 1) (NumVar 6))
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """While marked, set out a power die, starting at 6. Your
                      target takes 2 piercing damage at the end of their turn,
                      then tick the die down by 2. If the die ticks to 0, or
                      your marked character is defeated, your target explodes in
                      burst 1 area effect centered on them, """
                  , italic $ ref (Name "Stun") $ text "stunning"
                  , text " them, dealing "
                  , dice 1 D6
                  , text
                      """+4 piercing damage to all characters in the area (save
                      for half), and pushing those characters 1. Then end this
                      mark."""
                  ]
              , Step (KeywordStep (Name "Reckless")) (Just D3) $ seq
                  [ text "Immediately tick the die down by "
                  , italic $ dice 1 D3
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Implode"
          , colour: Name "Blue"
          , description: text
              """You burn away the air itself, creating a sucking void that rips
              your foes into its howling embrace."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 6))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text
                      """Pull all characters, objects, and summons at the
                      outside edge of the targeted area 1 space into the area.
                      One character in the area then gains """
                  , italic $ ref (Name "Slow") $ text "slow"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text "Becomes "
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Blackstar"
          , colour: Name "Blue"
          , description: text
              """You burn and condense your own aether into super condensed
              form, creating a crackling black orb that inflicts maximum
              destruction. Without the time to stabilize this attack, its use
              can rip away your very life force."""
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 8))
              , AreaTag (Blast (NumVar 4))
              ]
          , steps:
              [ AttackStep (text "4 damage") (seq [ text "+", dice 2 D6 ])
              , Step AreaEff Nothing $ seq [ dice 1 D6, text "+2" ]
              , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text "Deals +2 attack and area damage, creates "
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text
                      """ terrain under the attack target, and lowers terrain
                      under them by 1."""
                  ]
              , Step Eff Nothing $ seq
                  [ text "Then "
                  , italic $ ref (Name "Sacrifice") $ text "sacrifice 999"
                  , text
                      """ unless the round number is 4 or higher. All allies can
                      choose to lend their life force instead. If they are all
                      willing, each ally """
                  , italic $ text "sacrifices 4"
                  , text " instead, and you don't sacrifice anything."
                  ]
              ]
          }
      ]
  }
