module ToA.Resource.Icon.Job.Enochian
  ( enochian
  ) where

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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
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
          , soul: Name "Flame"
          , class: Name "Wright"
          , description:
              [ Text
                  """The Enochian Orders of pyromancers are the most chaotic of
                  the wright orders. Though sometimes associated with Chuners,
                  they have no official organization, most of their members
                  being hedge wizards or self taught. Many Enochians disdain
                  authority and work for hire, sleeping and eating where they
                  can and relying on the communities they work for to support
                  them. Those that work on contract with guilds, armies, or
                  mercenary companies tend to value their independence."""
              , Newline
              , Newline
              , Text
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
              Name "Megiddo"
                : Name "Melt"
                : Name "Phoenix"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Inner Furnace"
          , description:
              [ Text
                  """Once a round, at the start of your turn, you may stoke your
                  soul aether, performing one of the following:"""
              , List Unordered
                  [ [ Bold [ Text "Heat" ]
                    , Text ": Gain "
                    , Italic [ Ref (Name "Reckless") [ Text "reckless" ] ]
                    , Text
                        """. Your next damaging ability increases its area sizes
                        by +1 and its base attack and area damage by +2."""
                    ]
                  , [ Bold [ Text "Cool" ]
                    , Text ": "
                    , Italic [ Ref (Name "Sacrifice") [ Text "Sacrifice" ] ]
                    , Text " 6, then end all negative statuses affecting you."
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Megiddo"
          , colour: Name "Blue"
          , description:
              [ Text
                  """At round 4+, all area abilities you create deal +2 area
                  damage."""
              ]
          }
      , Talent
          { name: Name "Melt"
          , colour: Name "Blue"
          , description:
              [ Text "You increase the effects of "
              , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
              , Text " tokens "
              , Italic [ Text "you" ]
              , Text
                  """ inflict to -3 spaces. When you critical hit, you can
                  inflict """
              , Italic [ Text "slow" ]
              , Text "."
              ]
          }
      , Talent
          { name: Name "Phoenix"
          , colour: Name "Blue"
          , description:
              [ Text "When you are defeated, you deal "
              , Dice 1 D6
              , Text
                  """+2 piercing damage to all adjacent foes and push them 1.
                  You may then automatically """
              , Italic [ Ref (Name "Rescue") [ Text "rescue" ] ]
              , Text " yourself at the start of your next turn."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Gigaflare"
          , colour: Name "Blue"
          , description:
              [ Text "I, who stand at the apex of things,"
              , Newline
              , Text "Condemn thee to the deepest pits of despair."
              , Newline
              , Text "Let thy very bones become ash!"
              , Newline
              , Text "O Flame, let the air become death!"
              , Newline
              , Text "Ignote, and be banished to Hell! Gigaflare!"
              ]
          , cost: Two /\ 4
          , tags: []
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """You summon the Eldflame, the primeval force of
                      creation, dealing piercing damage equal to """
                  , Dice 1 D6
                  , Text " + the round number to "
                  , Italic [ Text "every" ]
                  , Text
                      """ character on the battlefield, ignoring line of sight
                      and cover. Characters in range 1-2 of you are exempt from
                      this ability."""
                  ]
              , Step Eff Nothing
                  [ Text "This limit break upgrades."
                  , List Unordered
                      [ [ Text "If you're bloodied, it becomes "
                        , Bold [ Text "Megaloflare" ]
                        , Text ", and deals damage twice."
                        ]
                      , [ Text "If you're in crisis, it becomes "
                        , Bold [ Text "Megiddoflare" ]
                        , Text ", dealing damage three times instead."
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Pyro"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Power curls into a writhing ball in your hand, before it's
                  unleashed on your enemies."""
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 8))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step (KeywordStep (Name "Reckless")) (Just D6)
                  [ Text "Gains damage "
                  , Power
                  , Text
                      """. After the ability resolves, the area explodes,
                      igniting """
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text
                      """ terrain under all characters inside (5+) then dealing
                      2 piercing damage to those characters."""
                  ]
              ]
          }
      , Ability
          { name: Name "Ignite"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You spark a hungry flame in the soul aether of your foe,
                  burning them from the inside."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , TargetTag Foe
              , RangeTag (Range (NumVar 1) (NumVar 6))
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """While marked, set out a power die, starting at 6. Your
                      target takes 2 piercing damage at the end of their turn,
                      then tick the die down by 2. If the die ticks to 0, or
                      your marked character is defeated, your target explodes in
                      burst 1 area effect centered on them, """
                  , Italic [ Ref (Name "Stun") [ Text "stunning" ] ]
                  , Text " them, dealing "
                  , Dice 1 D6
                  , Text
                      """+4 piercing damage to all characters in the area (save
                      for half), and pushing those characters 1. Then end this
                      mark."""
                  ]
              , Step (KeywordStep (Name "Reckless")) (Just D3)
                  [ Text "Immediately tick the die down by "
                  , Italic [ Dice 1 D3 ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Implode"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You burn away the air itself, creating a sucking void that
                  rips your foes into its howling embrace."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 6))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """Pull all characters, objects, and summons at the
                      outside edge of the targeted area 1 space into the area.
                      One a character in the area then gains """
                  , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text "Becomes "
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Blackstar"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You burn and condense your own aether into super consdensed
                  form, creating a crackling black orb that inflicts maximum
                  desctruction. Without the time to stabilize this attack, its
                  use can rip away your very life force."""
              ]
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 8))
              , AreaTag (Blast (NumVar 4))
              ]
          , steps:
              [ AttackStep [ Text "4 damage" ] [ Text "+", Dice 2 D6 ]
              , Step AreaEff Nothing [ Dice 1 D6, Text "+2" ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text "Deals +2 attack and area damage, creates "
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text
                      """ terrain under the attack target, and lowers terrain
                      under them by 1."""
                  ]
              , Step Eff Nothing
                  [ Text "Then "
                  , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice 999" ] ]
                  , Text
                      """ unless the round number is 4 or higher. All allies can
                      choose to lend their life force instead. If they are all
                      willing, each ally """
                  , Italic [ Text "sacrifices 4" ]
                  , Text " instead, and you don't sacrifice anything."
                  ]
              ]
          }
      ]
  }
