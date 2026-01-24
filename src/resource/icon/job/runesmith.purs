module ToA.Resource.Icon.Job.Runesmith
  ( runesmith
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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

runesmith :: Icon
runesmith =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Runesmith"
          , colour: Name "Blue"
          , soul: Name "Flame"
          , class: Name "Wright"
          , description:
              [ Text
                  """Powerful crafts-kin tutored in the old rune arts, mostly
                  commonly found among the Troggs, but spread amongst all kin of
                  the furnace arts of Arden Eld. The power of carving runes with
                  flame Aether is very precise and requires a brawny arm, since
                  it was originally practiced by the gigantic Jotunn. Runes must
                  be carved into tempered metal or sturdy rock by hand and tool.
                  Weapons or equipment that carry rune kennings must have a
                  proper soul, forged with care and craftsmanship, or else they
                  will shatter under the tremendous weight of imbued ethereal
                  power. Weak and mass produced armament such as those churned
                  out in the cities cannot bear them."""
              , Newline
              , Newline
              , Text
                  """The Runesmiths and their ancient jotunn masters, the
                  Keepers of the Eld flame, originally made some of the most
                  powerful artifacts in Arden Eld - world altering weapons or
                  armament. The new generations continue the work in some
                  manner, recovering lost knowledge and continually improving
                  their craft as the hammer slowly bends out hot metal."""
              ]
          , trait: Name "Forge Heart"
          , keyword: Name "Zone"
          , abilities:
              (I /\ Name "Strike the Anvil")
                : (I /\ Name "Magmotic")
                : (II /\ Name "Siege Rune")
                : (IV /\ Name "Rune of the Forge")
                : empty
          , limitBreak: Name "Kindling of the Great Forge"
          , talents:
              Name "Jotunnrune"
                : Name "Hobrune"
                : Name "Folkrune"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Forge Heart"
          , description:
              [ Text
                  """Once a round, when you create a zone, difficult terrain
                  space, or dangerous terrain space, you can """
              , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
              , Text
                  """ 2 to create an additional identical space in range. If
                  part of an area (line, blast, burst, cross, etc) zone, it must
                  be placed adjacent to one space of the original zone. It obeys
                  all regular rules of the ability that created it."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Jotunnrune"
          , colour: Name "Blue"
          , description:
              [ Text "As a "
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text " ability, you may create a "
              , Italic [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
              , Text " terrain space in free space in range 1-3."
              ]
          }
      , Talent
          { name: Name "Hobrune"
          , colour: Name "Blue"
          , description:
              [ Text "As a "
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text
                  """ ability, you swap places with any character inside any
                  zone you have created. Foes may save to avoid ths effect."""
              ]
          }
      , Talent
          { name: Name "Folkrune"
          , colour: Name "Blue"
          , description:
              [ Text "You gain attack "
              , Power
              , Text " against characters inside your zones."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Kindling of the Great Forge"
          , colour: Name "Blue"
          , description:
              [ Text "O Earth, O Flame,"
              , Newline
              , Text "As I am masterful in will, bend to my command,"
              , Newline
              , Text "Bring me mine sword, and mine anvil,"
              , Newline
              , Text "Breath thy bellows, test thy fiery mettle!"
              , Newline
              , Text "Rune forge!"
              ]
          , cost: One /\ 3
          , tags:
              [ KeywordTag (Name "Zone")
              , KeywordTag (Name "Object")
              , RangeTag (Range (NumVar 2) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """Summon a massive run forge from below, height 1 object
                      in range. A burst 1 area centered on the forge is a zone,
                      with the following effects:"""
                  , List Unordered
                      [ [ Bold [ Text "Molten Armor" ]
                        , Text ": Once a round, after a character "
                        , Italic
                            [ Ref (Name "Sacrifice") [ Text "sacrifices" ] ]
                        , Text " inside the forge zone, you may grant them "
                        , Dice 1 D3
                        , Text "+1 vigor."
                        ]
                      , [ Bold [ Text "Molten Weapons" ]
                        , Text ": Yourself and allies inside the zone may "
                        , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                        , Text
                            """ 4 as a quick ability to grant damage on their
                            next ability """
                        , Italic [ Ref (Name "Pierce") [ Text "pierce" ] ]
                        , Text "."
                        ]
                      , [ Bold [ Text "Molten Fury" ]
                        , Text ": The zone of the forge is "
                        , Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "dangerous" ]
                            ]
                        , Text
                            """ terrain to foes. This dangerous terrain deals
                            additional damage equal to half the round number,
                            rounded up."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Strike the Anvil"
          , colour: Name "Blue"
          , description:
              [ Text
                  """At your strike, a serpentine arc of crimson flame whips
                  along the ground, then erupts beneath its targets."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 4)) ]
          , steps:
              [ AttackStep [ Text "1 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "1 damage." ]
              , Step OnHit Nothing
                  [ Text "Creates "
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text
                      """ terrain under all characters in the effect area. Deals
                      damage """
                  , Power
                  , Text " to characters already in dangerous terrain."
                  ]
              , Step Eff Nothing
                  [ Text
                      """If you are bloodied, increase arc by +2, or +4 if you
                      are in crisis."""
                  ]
              ]
          }
      , Ability
          { name: Name "Magmotic"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You condense fire aether into boiling, molten rock, then
                  fling it like a potent grenade."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 6))
              , KeywordTag (Name "Zone")
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) (Just D3)
                  [ Text "Create "
                  , Italic [ Dice 1 D3 ]
                  , Text
                      """ single space zones of boiling magma in range. These
                      could be created under characters. New zones created by
                      this ability add to the total instead of replacing
                      them."""
                  , List Unordered
                      [ [ Text "Magma zones are "
                        , Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "danagerous" ]
                            ]
                        , Text " terrain."
                        ]
                      , [ Text
                            """Characters that start or end their turn in a
                            magma zone gain """
                        , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                        , Text "."
                        ]
                      , [ Text
                            """All damage against characters with at least one
                            space inside a magma zone gains """
                        , Italic [ Ref (Name "Pierce") [ Text "pierce" ] ]
                        , Text "."
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Siege Rune"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You carve a burning run of power into the very ground
                  beneath you."""
              ]
          , cost: One
          , tags: [ KeywordTag (Name "Zone") ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """Inscribe a siege rune on the space underneath you.
                      While you or an ally stands on this space, the max range,
                      line, and arc of all their abilities is increased by 2."""
                  ]
              , Step Eff Nothing
                  [ Text "If a character is bloodied, they also gain "
                  , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
                  , Text " at the end of their turn. If they are in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text ", increase range, line and arc by +4 instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Rune of the Forge"
          , colour: Name "Blue"
          , description:
              [ Text "Superheat the air around you, protecting from attackers."
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone"), AreaTag (Burst (NumVar 1) true), End ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and create a fiery ring centered on you. The zone does
                      not move with you once created."""
                  , List Unordered
                      [ [ Text "The zone is "
                        , Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "dangerous terrain" ]
                            ]
                        , Text " to all other characters than you."
                        ]
                      , [ Text
                            """Characters other than you inside the zone when it
                            is created must save or take """
                        , Dice 1 D6
                        , Text " "
                        , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                        , Text " damage."
                        ]
                      , [ Text "Characters inside the zone have "
                        , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
                        , Text " from characters outside the zone."
                        ]
                      , [ Text "While inside the zone, you "
                        , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                        , Text " 4 at the end of your turn."
                        ]
                      , [ Text
                            """You can safely exit the zone, but it ends if you
                            exit it for any reason."""
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text "Zone becomes burst 2 (self) instead." ]
              ]
          }
      ]
  }
