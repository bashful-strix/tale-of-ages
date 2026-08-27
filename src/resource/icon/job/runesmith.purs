module ToA.Resource.Icon.Job.Runesmith
  ( runesmith
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
  , power
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
          , sign: Sign "icon-[game-icons--rune-stone]"
          , soul: Name "Flame"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Powerful crafts-kin tutored in the old rune arts, most
                  commonly found among the Troggs, but spread amongst all kin of
                  the furnace arts of Arden Eld. The power of carving runes with
                  flame Aether is very precise and requires a brawny arm, since
                  it was originally practiced by the gigantic Jotunn. Runes must
                  be carved into tempered metal or sturdy rock by hand and tool.
                  Weapons or equipment that carry rune kennings must have a
                  proper soul, forged with care and craftsmanship, or else they
                  will shatter under the tremendous weight of imbued ethereal
                  power. Weak and mass produced armaments such as those churned
                  out in the cities cannot bear them."""
              , newline
              , newline
              , text
                  """The Runesmiths and their ancient Jotunn masters, the
                  Keepers of the Eld flame, originally made some of the most
                  powerful artifacts in Arden Eld - world altering weapons or
                  armaments. The new generations continue the work in some
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
              Id "jotunnrune|talent|runesmith"
                : Id "hobrune|talent|runesmith"
                : Id "folkrune|talent|runesmith"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Forge Heart"
          , description: seq
              [ text
                  """Once a round, when you create a zone, difficult terrain
                  space, or dangerous terrain space, you can """
              , italic $ ref (Name "Sacrifice") $ text "sacrifice"
              , text
                  """ 2 to create an additional identical space in range. If
                  part of an area (line, blast, burst, cross, etc) zone, it must
                  be placed adjacent to one space of the original zone. It obeys
                  all regular rules of the ability that created it."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "jotunnrune|talent|runesmith"
          , name: Name "Jotunnrune"
          , colour: Name "Blue"
          , description: seq
              [ text "As a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text " ability, you may create a "
              , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
              , text " terrain space in free space in range 1-3."
              ]
          }
      , Talent
          { id: Id "hobrune|talent|runesmith"
          , name: Name "Hobrune"
          , colour: Name "Blue"
          , description: seq
              [ text "As a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text
                  """ ability, you swap places with any character inside any
                  zone you have created. Foes may save to avoid this effect."""
              ]
          }
      , Talent
          { id: Id "folkrune|talent|runesmith"
          , name: Name "Folkrune"
          , colour: Name "Blue"
          , description: seq
              [ text "You gain attack "
              , power
              , text " against characters inside your zones."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Kindling of the Great Forge"
          , colour: Name "Blue"
          , description: seq
              [ text "O Earth, O Flame,"
              , newline
              , text "As I am masterful in will, bend to my command,"
              , newline
              , text "Bring me mine sword, and mine anvil,"
              , newline
              , text "Breath thy bellows, test thy fiery mettle!"
              , newline
              , text "Rune forge!"
              ]
          , cost: One /\ 3
          , tags:
              [ KeywordTag (Name "Zone")
              , KeywordTag (Name "Object")
              , RangeTag (Range (NumVar 2) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """Summon a massive rune forge from below, height 1 object
                      in range. A burst 1 area centered on the forge is a zone,
                      with the following effects:"""
                  , list Unordered
                      [ seq
                          [ bold $ text "Molten Armor"
                          , text ": Once a round, after a character "
                          , italic
                              $ ref (Name "Sacrifice") $ text "sacrifices"
                          , text " inside the forge zone, you may grant them "
                          , dice 1 D3
                          , text "+1 vigor."
                          ]
                      , seq
                          [ bold $ text "Molten Weapons"
                          , text ": Yourself and allies inside the zone may "
                          , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                          , text
                              """ 4 as a quick ability to grant damage on their
                              next ability """
                          , italic $ ref (Name "Pierce") $ text "pierce"
                          , text "."
                          ]
                      , seq
                          [ bold $ text "Molten Fury"
                          , text ": The zone of the forge is "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous"
                          , text
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
          , description: text
              """At your strike, a serpentine arc of crimson flame whips along
              the ground, then erupts beneath its targets."""
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 4)) ]
          , steps:
              [ AttackStep (text "1 damage") $ seq [ text "+", dice 1 D3 ]
              , Step AreaEff Nothing $ text "1 damage."
              , Step OnHit Nothing $ seq
                  [ text "Creates "
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text
                      """ terrain under all characters in the effect area. Deals
                      damage """
                  , power
                  , text " to characters already in dangerous terrain."
                  ]
              , Step Eff Nothing $ text
                  """If you are bloodied, increase arc by +2, or +4 if you are
                  in crisis."""
              ]
          }
      , Ability
          { name: Name "Magmotic"
          , colour: Name "Blue"
          , description: text
              """You condense fire aether into boiling, molten rock, then fling
              it like a potent grenade."""
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 6))
              , KeywordTag (Name "Zone")
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) (Just D3) $ seq
                  [ text "Create "
                  , italic $ dice 1 D3
                  , text
                      """ single space zones of boiling magma in range. These
                      could be created under characters. New zones created by
                      this ability add to the total instead of replacing
                      them."""
                  , list Unordered
                      [ seq
                          [ text "Magma zones are "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous"
                          , text " terrain."
                          ]
                      , seq
                          [ text
                              """Characters that start or end their turn in a
                              magma zone gain """
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text "."
                          ]
                      , seq
                          [ text
                              """All damage against characters with at least one
                              space inside a magma zone gains """
                          , italic $ ref (Name "Pierce") $ text "pierce"
                          , text "."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Siege Rune"
          , colour: Name "Blue"
          , description: text
              """You carve a burning rune of power into the very ground beneath
              you."""
          , cost: One
          , tags: [ KeywordTag (Name "Zone") ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ text
                  """Inscribe a siege rune on the space underneath you. While
                  you or an ally stands on this space, the max range, line, and
                  arc of all their abilities is increased by 2."""
              , Step Eff Nothing $ seq
                  [ text "If a character is bloodied, they also gain "
                  , italic $ ref (Name "Keen") $ text "keen"
                  , text " at the end of their turn. If they are in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text ", increase range, line and arc by +4 instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Rune of the Forge"
          , colour: Name "Blue"
          , description: text
              "Superheat the air around you, protecting from attackers."
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone"), AreaTag (Burst (NumVar 1) true), End ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and create a fiery ring centered on you. The zone does
                      not move with you once created."""
                  , list Unordered
                      [ seq
                          [ text "The zone is "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous terrain"
                          , text " to all other characters than you."
                          ]
                      , seq
                          [ text
                              """Characters other than you inside the zone when
                              it is created must save or take """
                          , dice 1 D6
                          , text " "
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text " damage."
                          ]
                      , seq
                          [ text "Characters inside the zone have "
                          , italic $ ref (Name "Cover") $ text "cover"
                          , text " from characters outside the zone."
                          ]
                      , seq
                          [ text "While inside the zone, you "
                          , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                          , text " 4 at the end of your turn."
                          ]
                      , text
                          """You can safely exit the zone, but it ends if you
                          exit it for any reason."""
                      ]
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing $ text
                  "Zone becomes burst 2 (self) instead."
              ]
          }
      ]
  }
