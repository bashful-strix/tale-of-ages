module ToA.Resource.Icon.Job.WeepingAssassin
  ( weepingAssassin
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
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

weepingAssassin :: Icon
weepingAssassin =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Weeping Assassin"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--droplets]"
          , soul: Name "Shadow"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """The Weeper is the titan of night, the poor, and untimely
                  death. Her Tears can be found in black springs in lightless
                  shrines underground, sealed in some forgotten era. The journey
                  to these shrines is perilous and haunting, and only the most
                  determined make the journey - those that are set on joining
                  the Weeping Assassins. These disciples of the departed titan
                  have undertaken communion by drinking her tears. This gives
                  them the uncanny ability to sense when someone is in deep
                  sorrow, an effect that sometimes also causes an assassin to
                  weep sympathetic black tears."""
              , newline
              , newline
              , text
                  """As night is a mother to all, it accepts all grief and
                  answers all prayers. Sometimes, comfort is only found in
                  absolute vengeance."""
              ]
          , trait: Name "Tears of the Weeper"
          , keyword: Name "Isolate"
          , abilities:
              (I /\ Name "Harien")
                : (I /\ Name "Shadow Cloak")
                : (II /\ Name "Night's Caress")
                : (IV /\ Name "Swallow the Stars")
                : empty
          , limitBreak: Name "Hollow"
          , talents:
              Id "commiserate|talent|weeping-assassin"
                : Id "infiltrate|talent|weeping-assassin"
                : Id "shimmer|talent|weeping-assassin"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Tears of the Weeper"
          , description: seq
              [ text
                  """Your common abilities (dash, interact, rescue, etc.) do not
                  remove """
              , italic $ ref (Name "Stealth") $ text "stealth"
              , text "."
              , newline
              , text
                  """If you end your turn with no other characters adjacent,
                  gain """
              , italic $ ref (Name "Stealth") $ text "stealth"
              , text "."
              ]
          }
      ]
  , talents:
      [ Talent
          { id: Id "commiserate|talent|weeping-assassin"
          , name: Name "Commiserate"
          , colour: Name "Yellow"
          , description: seq
              [ text
                  """You can ignore up to one ally in range 1-2 for the purposes
                  of """
              , italic $ ref (Name "Isolate") $ text "isolate"
              , text "."
              ]
          }
      , Talent
          { id: Id "infiltrate|talent|weeping-assassin"
          , name: Name "Infiltrate"
          , colour: Name "Yellow"
          , description: seq
              [ text "As a quick ability, you can spend "
              , italic $ ref (Name "Stealth") $ text "stealth"
              , text " on yourself to teleport 3."
              , newline
              , italic $ ref (Name "Isolate") $ text "Isolate"
              , text
                  """: if you end this teleport with no other characters in
                  range 1-2, regain """
              , italic $ ref (Name "Stealth") $ text "stealth"
              , text "."
              ]
          }
      , Talent
          { id: Id "shimmer|talent|weeping-assassin"
          , name: Name "Shimmer"
          , colour: Name "Yellow"
          , description: seq
              [ text "If an ability ends your turn, it grants you "
              , italic $ ref (Name "Stealth") $ text "stealth"
              , text "."
              ]
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Hollow"
          , colour: Name "Yellow"
          , description: text
              """You draw the night around you, becoming a shadowy being of
              pure, writhing darkness."""
          , cost: Quick /\ 3
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "You gain 3 "
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text
                      """, then take on a shadowy form. While in this form, you
                      are immune to all damage, gain """
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text ", and may "
                  , italic $ ref (Name "Fly") $ text "fly"
                  , text
                      """ when you take your free move. You exit this form when
                      you enter any space in range 1-2 of a foe, or when a foe
                      enters any space in range 1-2 of you, but re-enter as soon
                      as either of these cease to be true. It ends completely at
                      the end of your next turn."""
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """You can transfer this effect to an ally instead. If you
                      do, """
                  , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                  , text
                      """ 25% of you maximum hp, and it lasts until the end of
                      their next turn."""
                  ]
              ]
          }
      , Ability
          { name: Name "Harien"
          , colour: Name "Yellow"
          , description: text
              """You strike from the darkness. When your opponent turns, you
              have faded into the night."""
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing $ text "Dash 2."
              , AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , Step AreaEff Nothing $ text "2 damage."
              , Step (KeywordStep (Name "Isolate")) Nothing $ seq
                  [ text "Dash 2, then gain "
                  , italic $ ref (Name "Stealth") $ text "stealth"
                  , text
                      """. If there are no characters other than you in range
                      1-2, increase dash to 4."""
                  ]
              ]
          }
      , Ability
          { name: Name "Shadow Cloak"
          , colour: Name "Yellow"
          , description: text "Pull the shadows tighter around you."
          , cost: Two
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """Mark self or an ally in range and set out a d6 power
                      die, starting at 6. The marked character has """
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text " and permanent "
                  , italic $ ref (Name "Evasion") $ text "evasion"
                  , text
                      """. After evasion triggers, successful or not, tick the
                      power die down by 2. When the die is 0, discard it and end
                      this mark, and the marked character may teleport 2 and
                      gain """
                  , italic $ ref (Name "Stealth") $ text "stealth"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing $ text
                  """If the marked character ends their turn with no other
                  characters adjacent, they may tick the die up by 2, or by +4
                  if there are no characters other then you in range 2."""
              ]
          }
      , Ability
          { name: Name "Night's Caress"
          , colour: Name "Yellow"
          , description: text
              """You relentlessly hunt your prey, following them through a
              shadowy rift even if they flee."""
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ InsetStep (KeywordStep (Name "Mark")) Nothing
                  ( text
                      """Mark a foe then gain the following interrupt at the
                      start of each round while they are marked."""
                  )
                  $ AbilityInset
                      { name: Name "Sudden Strike"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "Your marked foe ends their turn."
                          , Step Eff Nothing $ seq
                              [ text
                                  """If your foe is in range 1-3, teleport to a
                                  free space adjacent to them. They must save or
                                  take """
                              , dice 3 D3
                              , text
                                  """ or just 3 damage on a successful save.
                                  Then end your mark. Otherwise, teleport 1 and
                                  keep the mark."""
                              ]
                          , Step (KeywordStep (Name "Isolate")) Nothing $ text
                              """Deal +2 damage, or +4 if there are no
                              characters other than you in range 1-2."""
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Swallow the Stars"
          , colour: Name "Yellow"
          , description: text
              "Dark aether coats your blade, preparing final rest for your foe."
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ bold $ text "End you turn"
                  , text " and gain "
                  , italic $ ref (Name "Stealth") $ text "stealth"
                  , text ". Your next attack gains:"
                  , list Unordered
                      [ seq
                          [ italic $ text "On hit"
                          , text ": If your foe is in "
                          , italic $ ref (Name "Crisis") $ text "crisis"
                          , text ", they must save or take "
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text
                              " damage equal to 25% hp of their max hp, or 2 "
                          , italic $ text "piercing"
                          , text
                              """ damage on a successful save. If they are not
                              in crisis, they take 2 """
                          , italic $ text "piercing"
                          , text " damage instead."
                          ]
                      , seq
                          [ italic $ text "Effect"
                          , text ": Legend characters take 2 "
                          , italic $ text "piercing"
                          , text
                              """ damage on hit instead of the above effect, or
                              6 """
                          , italic $ text "piercing"
                          , text
                              " damage on a failed save if they are in crisis."
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing $ seq
                  [ text "Foe gains ", weakness, text " on the save." ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
