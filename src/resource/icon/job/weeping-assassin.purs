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
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , SubItem(..)
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

weepingAssassin :: Icon
weepingAssassin =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Weeping Assassin"
          , colour: Name "Yellow"
          , soul: Name "Shadow"
          , class: Name "Vagabond"
          , description:
              [ Text
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
              , Newline
              , Newline
              , Text
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
              Name "Commiserate"
                : Name "Infiltrate"
                : Name "Shimmer"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Tears of the Weeper"
          , description:
              [ Text
                  """Your common abilities (dash, interact, rescue, etc.) do not
                  remove """
              , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
              , Text "."
              , Newline
              , Text
                  """If you end your turn with no other characters adjacent,
                  gain """
              , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      ]
  , talents:
      [ Talent
          { name: Name "Commiserate"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You can ignore up to one ally in range 1-2 for the purposes
                  of """
              , Italic [ Ref (Name "Isolate") [ Text "isolate" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Infiltrate"
          , colour: Name "Yellow"
          , description:
              [ Text "As a quick ability, you can spend "
              , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
              , Text " on yourself to teleport 3."
              , Newline
              , Italic [ Ref (Name "Isolate") [ Text "Isolate" ] ]
              , Text
                  """: if you end this teleport with no other characters in
                  range 1-2, regain """
              , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Shimmer"
          , colour: Name "Yellow"
          , description:
              [ Text "If an ability ends your turn, it grants you "
              , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Hollow"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You draw the night around you, becoming a shadowy being of
                  pure, writhing darkness."""
              ]
          , cost: Quick /\ 3
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing
                  [ Text "You gain 3 "
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text
                      """, then take on a shadowy form. While in this form, you
                      are immune to all damage, gain """
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text ", and may "
                  , Italic [ Ref (Name "Fly") [ Text "fly" ] ]
                  , Text
                      """ when you take your free move. You exit this form when
                      you enter any space in range 1-2 of a foe, or when a foe
                      enters any space in range 1-2 of you, but re-enter as soon
                      as either of these cease to be true. It ends completely at
                      the end of your next turn."""
                  ]
              , Step Eff Nothing
                  [ Text
                      """You can transfer this effect to an ally instead. If you
                      do, """
                  , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                  , Text
                      """ 25% of you maximum hp, and it lasts until the end of
                      their next turn."""
                  ]
              ]
          }
      , Ability
          { name: Name "Harien"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You strike from the darkness. When your opponent turns, you
                  have faded into the night."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 2." ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text "Dash 2, then gain "
                  , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                  , Text
                      """. If there are no characters other than you in range
                      1-2, increase dash to 4."""
                  ]
              ]
          }
      , Ability
          { name: Name "Shadow Cloak"
          , colour: Name "Yellow"
          , description: [ Text "Pull the shadows tighter around you." ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """Mark self or an ally in range and set out a d6 power
                      die, starting at 6. The marked character has """
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text " and permanent "
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text
                      """. After evasion triggers, successful or not, tick the
                      power die down by 2. When the die is 0, discard it and end
                      this mark, and the marked character may teleport 2 and
                      gain """
                  , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing
                  [ Text
                      """If the marked character ends their turn with no other
                      characters adjacent, they may tick the die up by 2, or by
                      +4 if there are no characters other then you in range
                      2."""
                  ]
              ]
          }
      , Ability
          { name: Name "Night's Caress"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You relentlessly hunt your prey, following them through a
                  shadowy rift even if they flee."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ SubStep (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """Mark a foe then gain the following interrupt at the
                      start of each round while they are marked."""
                  ]
                  $ AbilityItem
                      { name: Name "Sudden Strike"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "Your marked foe end their turn." ]
                          , Step Eff Nothing
                              [ Text
                                  """If your foe is in range 1-3, teleport to a
                                  free space adjacent to them. They must save or
                                  take """
                              , Dice 3 D3
                              , Text
                                  """ or just 3 damage on a successful save.
                                  Then end your mark. Otherwise, teleport 1 and
                                  keep the mark."""
                              ]
                          , Step (KeywordStep (Name "Isolate")) Nothing
                              [ Text
                                  """Deal +2 damage, or +4 if there are no
                                  characters other than you in range 1-2."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Swallow the Stars"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Dark aether coats your blade, preparing final rest for you
                  foe."""
              ]
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing
                  [ Bold [ Text "End you turn" ]
                  , Text " and gain "
                  , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                  , Text ". Your next attack gains:"
                  , List Unordered
                      [ [ Italic [ Text "On hit" ]
                        , Text ": If your foe is in "
                        , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                        , Text ", they must save or take "
                        , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                        , Text " damage equal to 25% hp of their max hp, or 2 "
                        , Italic [ Text "piercing" ]
                        , Text
                            """ damage on a successful save. If they are not in
                            crisis, they take 2 """
                        , Italic [ Text "piercing" ]
                        , Text " damage instead."
                        ]
                      , [ Italic [ Text "Effect" ]
                        , Text ": Legend characters take 2 "
                        , Italic [ Text "piercing" ]
                        , Text
                            " damage on hit instead of the above effect, or 6 "
                        , Italic [ Text "piercing" ]
                        , Text " damage on a failed save if they are in crisis."
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text "Foe gains ", Weakness, Text " on the save." ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
