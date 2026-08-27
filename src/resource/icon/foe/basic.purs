module ToA.Resource.Icon.Foe.Basic
  ( basic
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(Self)
  , Variable(..)
  )
import ToA.Data.Icon.Chapter (Chapter(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , dice
  , list
  , italic
  , power
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Foe.Ability (Ability(..), FoeAbility(..))
import ToA.Data.Icon.Foe.Faction
  ( Faction(..)
  , FactionMechanic(..)
  , FactionTemplate(..)
  )
import ToA.Data.Icon.Foe.Job (FoeJob(..), Phases(..), Phase(..))
import ToA.Data.Icon.Foe.Trait (FoeTrait(..))

basic :: Icon
basic =
  { classes: []
  , colours: []
  , souls: []
  , jobs: []
  , traits: []
  , talents: []
  , abilities: []
  , keywords: []
  , foeClasses: []

  , factions:
      [ Faction
          { name: Name "Basic"
          , description: seq []
          , template: FactionTemplate { description: seq [], traits: [] }
          , mechanic: FactionMechanic { name: Name "", description: seq [] }
          , keywords: []
          }
      ]

  , foes:
      [ Foe
          { name: Name "Sledge"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: I
          , description: text
              "Hard hitting foe that inflicts stun with a heavy blow."
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Yank"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 3) (NumVar 4)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "A character in range is pulled "
                          , dice 1 D3
                          , text ". If pulled adjacent, they take 3 "
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text " damage."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Block"
                  , cost: One
                  , tags: [ End ]
                  , steps:
                      [ InsetStep Eff Nothing
                          ( seq
                              [ text "Gain "
                              , italic $ ref (Name "Shield") $ text "shield"
                              , text
                                  """ and the following interrupt until the
                                  start of its next turn."""
                              ]
                          ) $ AbilityInset
                          { name: Name "Shield Block"
                          , colour: Name "Red"
                          , cost: Interrupt (NumVar 1)
                          , tags: []
                          , steps:
                              [ Step TriggerStep Nothing $ text
                                  """This character or an adjacent ally is
                                    attacked."""
                              , Step Eff Nothing $ text
                                  "The attack deals 1/2 damage."
                              ]
                          }
                      ]
                  }
              , ChainAbility
                  [ Ability
                      { name: Name "Shoulder Check"
                      , cost: One
                      , tags: [ KeywordTag (Name "Chain") ]
                      , steps:
                          [ Step Eff Nothing $ seq
                              [ text
                                  "Dash 1, then gain 2 vigor. Increase both by "
                              , dice 1 D3
                              , text " if bloodied."
                              ]
                          ]
                      }
                  , Ability
                      { name: Name "Crushing Overhead"
                      , cost: Two
                      , tags: [ Attack, KeywordTag (Name "Chain") ]
                      , steps:
                          [ AttackStep
                              ( seq
                                  [ text "6 damage and the foe is "
                                  , italic $ ref (Name "Daze") $ text "dazed"
                                  ]
                              )
                              ( seq
                                  [ text "+"
                                  , dice 2 D6
                                  , text
                                      " and foe must save or additionally be "
                                  , italic $ ref (Name "Stun") $ text "stunned"
                                  , text "."
                                  ]
                              )
                          ]
                      }
                  ]
              ]
          }

      , Foe
          { name: Name "Soldier"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: I
          , description: text
              """Basic melee fighter, controls the flow of combat with deft
              strikes and slashes."""
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Deft Strike"
                  , cost: One
                  , tags: [ Attack ]
                  , steps:
                      [ AttackStep
                          (text "2 damage")
                          (seq [ text "+", dice 1 D6 ])
                      , Step (KeywordStep (Name "Afflicted")) Nothing $ text
                          "Foes take +2 base damage."
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Bash"
                  , cost: One
                  , tags: [ KeywordTag (Name "Repeatable") ]
                  , steps:
                      [ Step Eff Nothing $ text
                          "An adjacent foe takes 2 damage and is pushed 1."
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Block"
                  , cost: One
                  , tags: [ End ]
                  , steps:
                      [ InsetStep Eff Nothing
                          ( seq
                              [ text "Gain "
                              , italic $ ref (Name "Shield") $ text "shield"
                              , text
                                  """ and the following interrupt until the
                                  start of its next turn."""
                              ]
                          ) $ AbilityInset
                          { name: Name "Shield Block"
                          , colour: Name "Red"
                          , cost: Interrupt (NumVar 1)
                          , tags: []
                          , steps:
                              [ Step TriggerStep Nothing $ text
                                  """This character or an adjacent ally is
                                    attacked."""
                              , Step Eff Nothing $ text
                                  "The attack deals 1/2 damage."
                              ]
                          }
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Warrior"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: I
          , description: text
              """Straightforward, hard hitting foe that attacks with sweeping,
              heavy attacks."""
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ ChainAbility
                  [ Ability
                      { name: Name "Giant Slice"
                      , cost: One
                      , tags:
                          [ Attack
                          , RangeTag Close
                          , AreaTag (Line (NumVar 3))
                          , KeywordTag (Name "Chain")
                          ]
                      , steps:
                          [ AttackStep
                              (text "2 damage")
                              (seq [ text "+", dice 1 D3 ])
                          , Step AreaEff Nothing $ text "2 damage."
                          , Step Eff Nothing $ text
                              """Gains +2 base damage and area damage if
                              catching two or more foes in the area."""
                          ]
                      }
                  , Ability
                      { name: Name "Whirlwind"
                      , cost: Two
                      , tags: [ RangeTag Melee, KeywordTag (Name "Chain") ]
                      , steps:
                          [ Step Eff Nothing $ seq
                              [ text "The Warrior "
                              , italic $ text "dashes"
                              , text " 1 space, "
                              , italic $ dice 1 D3
                              , text
                                  """+1 times. After it moves, each time, it
                                  deals 3 damage to adjacent characters and
                                  pushes them 1."""
                              ]
                          ]
                      }
                  ]
              , FoeAbility $ Ability
                  { name: Name "Bulk Up"
                  , cost: One
                  , tags: [ TargetTag Self, End ]
                  , steps:
                      [ Step Eff Nothing $ text
                          """Remove a negative token from self, then gain 2
                          vigor. Repeat this effect if in crisis."""
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Battle Cry"
                  , cost: One
                  , tags:
                      [ AreaTag (Burst (NumVar 1) true), LimitTag 1 "combat" ]
                  , steps:
                      [ Step Eff Nothing $ text
                          """Grant self and each ally in the area 3 vigor. Those
                          characters can also clear a negative condition if this
                          character is bloodied."""
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Dervish"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: I
          , description: text "A fighter that attacks in sweeping bursts."
          , traits: []
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Razor Wind"
                  , cost: One
                  , tags: []
                  , steps:
                      [ Step Eff (Just D3) $ seq
                          [ text "Repeat the following effect "
                          , italic $ dice 1 D3
                          , text
                              """ times: Dash 2, then burst 1 (self): 2 damage.
                              Increase damage by +1 against bloodied foes, or +2
                              against foes in crisis."""
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Western Wind"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "The Dervish or an ally in range may fly "
                          , italic $ dice 1 D3
                          , text "+1 and gain "
                          , italic $ ref (Name "Evasion") $ text "evasion"
                          , text "."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Fan of Knives"
                  , cost: Two
                  , tags: [ RangeTag Close, AreaTag (Blast (NumVar 3)) ]
                  , steps:
                      [ Step AreaEff Nothing $ seq
                          [ dice 1 D6
                          , text
                              """+4, save for half. Deals +4 damage against foes
                              with no allies adjacent."""
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Blinding Wind"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 3))
                      , LimitTag 2 "combat"
                      ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              """A foe in range must save. On a successful
                              save, they become """
                          , italic $ ref (Name "Blind") $ text "blinded"
                          , text
                              """. On a failed save, they also become marked and
                              unable to draw line of sight to any space that is
                              not adjacent. They can ignore this mark if they
                              are adjacent to any ally, and repeat a save to end
                              it at the end of their turn."""
                          ]
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Gunner"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: I
          , description: text
              "A mobile ranged attacker that hits multiple times."
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Riddle"
                  , cost: One
                  , tags: [ Attack, RangeTag (Range (NumVar 3) (NumVar 5)) ]
                  , steps:
                      [ AttackStep
                          (text "2 damage")
                          (text "3 damage again, then 3 damage again.")
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Strafe"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 2) (NumVar 3)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              """The Gunner dashes 2, then deals 2 damage to a
                              foe in range. If a foe is at exactly range 3, they
                              take """
                          , dice 1 D3
                          , text "+1 damage instead."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Overwatch"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 3) (NumVar 5)), End ]
                  , steps:
                      [ InsetStep Eff Nothing
                          ( text
                              """Target a blast 3 area in range, which could be
                              placed over characters. Then gain the following
                              interrupt until the start of this character's next
                              turn."""
                          ) $ AbilityInset
                          { name: Name "Overwatch"
                          , colour: Name "Yellow"
                          , cost: Interrupt (NumVar 1)
                          , tags: []
                          , steps:
                              [ Step TriggerStep Nothing $ text
                                  "A foe voluntarily moves in the ares."
                              , Step Eff Nothing $ text
                                  """All foes in the area must save. Foes take 2
                                  damage. On a failed save, they take 2 damage
                                  again, three more times."""
                              ]
                          }
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Flash Bomb"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 2) (NumVar 3))
                      , AreaTag (Cross (NumVar 2))
                      , LimitTag 1 "combat"
                      ]
                  , steps:
                      [ Step AreaEff Nothing $ seq
                          [ text ": All foes take "
                          , dice 1 D6
                          , text "+4 damage (save for half) and are "
                          , italic $ ref (Name "Blind") $ text "blinded"
                          , text ". The center space then becomes an "
                          , italic $ ref (Name "Obscured") $ text "obscured"
                          , text " space. "
                          ]
                      , Step Eff Nothing $ seq
                          [ text
                              """If the Gunner catches itself or allies in the
                              area, they gain """
                          , italic $ ref (Name "Stealth") $ text "stealth"
                          , text "."
                          ]
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Skulk"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: I
          , description: text
              "A sneaky foe that hits hard against weakened foes."
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Shank"
                  , cost: One
                  , tags: [ Attack, RangeTag Melee ]
                  , steps:
                      [ AttackStep
                          (text "2 damage")
                          (seq [ text "+", dice 1 D6 ])
                      , Step Eff Nothing $ seq
                          [ text "Deals damage "
                          , power
                          , text " to bloodied foes, and a further damage "
                          , power
                          , text " against afflicted foes."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Throwing Blade"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 2) (NumVar 3)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              """A foe in range takes 2 damage, ignoring cover,
                              increased by +"""
                          , dice 1 D6
                          , text " if target is in crisis."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Prowl"
                  , cost: One
                  , tags: []
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "Dash 3, then gain "
                          , italic $ ref (Name "Stealth") $ text "stealth"
                          , text "."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Dirty Trick"
                  , cost: One
                  , tags: [ End, LimitTag 2 "combat" ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "An adjacent foe is "
                          , italic $ ref (Name "Blind") $ text "blinded"
                          , text " and must save or first lose "
                          , dice 1 D3
                          , text
                              """ positive status tokens. The Skulk may then
                              teleport 3."""
                          ]
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Priest"
          , colour: Name "Green"
          , class: Name "Leader"
          , faction: Nothing
          , chapter: I
          , description: text
              "Divinely infused foes with the power to shield allies from harm."
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Griholy"
                  , cost: One
                  , tags:
                      [ Attack
                      , AreaTag (Cross (NumVar 1))
                      , RangeTag (Range (NumVar 2) (NumVar 4))
                      ]
                  , steps:
                      [ AttackStep
                          (text "2 damaga")
                          (seq [ text "+", dice 1 D3 ])
                      , Step AreaEff Nothing $ seq
                          [ text
                              """Allies in the area gain 2 vigor. Foes take 2
                              damage. Increase all damage or vigor by +"""
                          , dice 1 D3
                          , text " for bloodied characters."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Purge"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "A foe in range chooses: either take "
                          , dice 1 D3
                          , text
                              """+1 piercing damage or lose a positive status.
                              If they have no positive status, they
                              automatically take the damage."""
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Diaga"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              """An ally in range may immediately save to end
                              all stacks of a status. They gain """
                          , power
                          , text " on the save if they are bloodied."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Aegi"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 2))
                      , KeywordTag (Name "Mark")
                      , LimitTag 2 "combat"
                      ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "Allied character in range gains "
                          , italic $ seq [ dice 1 D6, text "+4" ]
                          , text
                              """ vigor and becomes marked. When marked, they
                              take take 1/2 damage. The first time in a turn the
                              marked character is damaged by an ability, they
                              must save or lose all vigor and the mark after the
                              tirggering ability resolves."""
                          ]
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Sergeant"
          , colour: Name "Green"
          , class: Name "Leader"
          , faction: Nothing
          , chapter: I
          , description: text
              "Martial leaders that are excellent at moving allies around."
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Aura of Command"
                  , description: seq
                      [ text "Aura 1. Allies in the area have attack "
                      , power
                      , text "."
                      ]
                  }
              ]
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Leader's Strike"
                  , cost: One
                  , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 3)) ]
                  , steps:
                      [ AttackStep
                          (text "3 damage")
                          (seq [ text "+", dice 1 D3 ])
                      , Step Eff Nothing $ seq
                          [ text
                              ": Up to three allies in range can dash 2 with "
                          , italic
                              $ ref (Name "Unstoppable")
                              $ text "unstoppable"
                          , text "."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Marching Orders"
                  , cost: Two
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "The Sergeant and all allies in range dash "
                          , dice 2 D3
                          , text " and gain 1 "
                          , italic $ ref (Name "Strength") $ text "strength"
                          , text
                              """. If the Sergeant is bloodied, they are immune
                              to all damage and """
                          , italic
                              $ ref (Name "Unstoppable")
                              $ text "unstoppable"
                          , text " during this movement."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Takedown"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , steps:
                      [ Step Eff Nothing $ text
                          """A foe in range must save. They take 1 damage once
                          for every ally of the Sergeant adjacent to them, up to
                          three times. On a failed save, they take 3 damage for
                          each ally instead."""
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Justicar"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Nothing
          , chapter: I
          , description: text
              """A rare wright using the power of light aether to punish foes
              trying to flee."""
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Judgement Bolt"
                  , cost: One
                  , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 8)) ]
                  , steps:
                      [ AttackStep
                          (text "2 damage")
                          (seq [ text "+", dice 1 D6 ])
                      , Step Eff Nothing $ seq
                          [ text "Gains attack "
                          , power
                          , text " and damage "
                          , power
                          , text
                              """ against foes 4 or more spaces away. Deals +2
                              base damage against foes 7 or more spaces away."""
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Mighty Summoning"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 4) (NumVar 6)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "An ally in range is pulled "
                          , italic $ dice 1 D6
                          , text " spaces and gains "
                          , italic $ ref (Name "Keen") $ text "keen"
                          , text ". Alternatively, pull self "
                          , italic $ dice 1 D6
                          , text
                              """ spaces towards an ally or object in range and
                              gain """
                          , italic $ ref (Name "Keen") $ text "keen"
                          , text "."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Punishment of Cowards"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 3) (NumVar 6)) ]
                  , steps:
                      [ InsetStep Eff Nothing
                          ( text
                              """The Justicar prepares for action and gains the
                              following interrupt until the start of their next
                              turn."""
                          ) $ AbilityInset
                          { name: Name "Punish Cowards"
                          , colour: Name "Blue"
                          , cost: Interrupt (NumVar 1)
                          , tags: []
                          , steps:
                              [ Step TriggerStep Nothing $ text
                                  "A foe ends movement 4 or more spaces away."
                              , Step Eff Nothing $ seq
                                  [ text
                                      """The foe is pulled 1, then must save or
                                      be pulled an additional +"""
                                  , dice 1 D3
                                  , text " and become "
                                  , italic $ ref (Name "Slow") $ text "slow"
                                  , text "."
                                  ]
                              ]
                          }
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Riven"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 2) (NumVar 6))
                      , End
                      , KeywordTag (Name "Mark")
                      ]
                  , steps:
                      [ Step Eff Nothing $ text
                          """Choose a foe in range. At the end of that
                          character's turn, as long as they're in range, they
                          must save or take piercing damage equal to double the
                          distance between this character and the marked foe, or
                          just 2 piercing damage on a successful save. Then end
                          the mark."""
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Pyromancer"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Nothing
          , chapter: I
          , description: text
              """A wright of pure fire aether, summoning it to eradicate their
              foes."""
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits: []
          , abilities:
              [ ChainAbility
                  [ Ability
                      { name: Name "Flame Burst"
                      , cost: One
                      , tags:
                          [ Attack
                          , RangeTag (Range (NumVar 3) (NumVar 6))
                          , AreaTag (Blast (NumVar 2))
                          , KeywordTag (Name "Chain")
                          ]
                      , steps:
                          [ AttackStep (text "3 damage") (text "3 damage again")
                          , Step AreaEff Nothing $ text "3 damage."
                          , Step OnHit Nothing $ text
                              """Create dangerous terrain under the attack
                              target."""
                          ]
                      }
                  , Ability
                      { name: Name "Gripyre"
                      , cost: Two
                      , tags:
                          [ Attack
                          , RangeTag (Range (NumVar 3) (NumVar 8))
                          , AreaTag (Blast (NumVar 3))
                          , KeywordTag (Name "Chain")
                          ]
                      , steps:
                          [ AttackStep
                              (text "3 damage")
                              (seq [ text "+", dice 2 D6 ])
                          , Step AreaEff Nothing $ text "3 damage."
                          , Step Eff Nothing $ text
                              """Deals +2 base or area damage to characters
                              standing in adverse terrain."""
                          ]
                      }
                  ]
              , FoeAbility $ Ability
                  { name: Name "Emberflash"
                  , cost: One
                  , tags:
                      [ AreaTag (Cross (RollVar 1 D3))
                      , RangeTag (Range (NumVar 1) (NumVar 6))
                      ]
                  , steps:
                      [ Step AreaEff Nothing $ seq
                          [ text "2 piercing damage and create a "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous terrain"
                          , text " space in the center."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Flash Fire"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 6)) ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              """A character in range takes 2 damage, then must
                              save or become """
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text ". "
                          , italic $ ref (Name "Afflicted") $ text "Afflicted"
                          , text
                              """ foes also explode for a burst 1 (target)
                              explosion for 3 piercing damage."""
                          ]
                      ]
                  }
              ]
          }

      , Foe
          { name: Name "Scourer"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Nothing
          , chapter: I
          , description: text
              """A foe using water and fire aether together to create
              pressurized bursts of steam and boiling vapor."""
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Vaporsight"
                  , description: text "Ignores cover from obscured spaces."
                  }
              ]
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Scour"
                  , cost: One
                  , tags:
                      [ Attack
                      , RangeTag Close
                      , AreaTag (Line (NumVar 6))
                      , KeywordTag (Name "Mark")
                      ]
                  , steps:
                      [ AttackStep
                          (text "3 damage")
                          (seq [ text "+", dice 1 D3 ])
                      , Step AreaEff Nothing $ text "3 damage."
                      , Step Eff Nothing $ seq
                          [ text
                              """: Mark the attack target. Attacks against the
                              marked target for the rest of combat combat gain
                              attack """
                          , power
                          , text
                              """ and deal +2 damage on hit. This effect stacks.
                              Lose all stacks if a new target is marked."""
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Steam Vent"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 6))
                      , AreaTag (Burst (NumVar 1) false)
                      ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "2 piercing damage, and create an "
                          , italic $ ref (Name "Obscured") $ text "obscured"
                          , text " space in the center space."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Vaporize"
                  , cost: One
                  , tags: []
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "Teleport self and all adjacent allies "
                          , dice 2 D3
                          , text "+1."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Boiling Bolus"
                  , cost: One
                  , tags:
                      [ KeywordTag (Name "Zone")
                      , RangeTag (Range (NumVar 2) (NumVar 6))
                      , AreaTag (Cross (NumVar 1))
                      , LimitTag 1 "combat"
                      ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text "The zone is "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous"
                          , text " and "
                          , italic
                              $ ref (Name "Difficult Terrain")
                              $ text "difficult"
                          , text
                              """ terrain. Increase to cross 2 at round 3+, even
                              if already placed, and cross 4 at round 5+. This
                              could cause the zone to grow under characters."""
                          ]
                      ]
                  }
              ]
          }

      , Elite
          { name: Name "Archon"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: I
          , description: text
              """Archons are armored, tough warriors that can be used to
              represent particularly hardy fighters, military leaders, or
              warlords. Alternately, they can be used to represent particularly
              ruthless or tough monsters."""
          , hp: Just 80
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Enrage"
                  , description: text
                      "In crisis, takes 1/2 damage from all sources."
                  }
              ]
          , abilities:
              [ ChainAbility
                  [ Ability
                      { name: Name "Blackheart"
                      , cost: One
                      , tags: [ Attack, KeywordTag (Name "Chain") ]
                      , steps:
                          [ AttackStep
                              (text "2 damage. ")
                              (seq [ text ": +", dice 1 D6 ])
                          , Step Eff Nothing $ seq
                              [ text ": Gains attack "
                              , power
                              , text
                                  """ and deals +3 damage on hit against
                                  afflicted characters."""
                              ]
                          ]
                      }
                  , Ability
                      { name: Name "Dark Edge"
                      , cost: Two
                      , tags:
                          [ Attack
                          , RangeTag Close
                          , AreaTag (Blast (NumVar 2))
                          , KeywordTag (Name "Chain")
                          ]
                      , steps:
                          [ AttackStep (text "3 damage and shove 1") $ seq
                              [ text "+"
                              , dice 2 D6
                              , text " and shove "
                              , italic $ dice 1 D3
                              ]
                          , Step AreaEff Nothing $ seq
                              [ text
                                  """3 damage. If foes are shoved into an
                                  obstruction, they must save or be """
                              , italic $ ref (Name "Stun") $ text "stunned"
                              , text "."
                              ]
                          ]
                      }
                  ]
              , FoeAbility $ Ability
                  { name: Name "Hamstring"
                  , cost: One
                  , tags: [ KeywordTag (Name "Mark") ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text ": An adjacent foe is "
                          , italic $ ref (Name "Mark") $ text "marked"
                          , text
                              """. If that foe voluntarily moves while marked,
                              they take """
                          , dice 2 D3
                          , text " "
                          , italic $ ref (Name "Pierce") $ text "piercing"
                          , text
                              """ damage. Remove this mark if they end their
                              turn without moving voluntarily."""
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Great Slam"
                  , cost: One
                  , tags: []
                  , steps:
                      [ Step Eff (Just D6) $ seq
                          [ text
                              """Dash 2 spaces, then one adjacent foe is either
                              (1-3) shoved 1 space (4+) or """"
                          , italic $ ref (Name "Daze") $ text "dazed"
                          , text ". While moving, become "
                          , italic
                              $ ref (Name "Unstoppable")
                              $ text "unstoppable"
                          , text " and "
                          , italic $ ref (Name "Immune") $ text "immune"
                          , text " to all damage."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Great Shieldwall"
                  , cost: One
                  , tags: [ KeywordTag (Name "only usable when bloodied"), End ]
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              "Until start of the Archon's next turn, becomes "
                          , italic $ ref (Name "Immobile") $ text "immobile"
                          , text
                              """, but the Archon grants cover to allies, and
                              attacks against all adjacent allies deal
                              damage """
                          , weakness
                          , text " and have attack "
                          , weakness
                          , text "."
                          ]
                      ]
                  }
              ]
          }

      , Elite
          { name: Name "Rogue"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: I
          , description: text
              """Rogues are quick witted and quick on their feet. They can
              be used to represent skilled thieves, scouts, or assassins, or
              particularly agile or bloodthirsty monsters."""
          , hp: Just 64
          , maxVigor: Nothing
          , defense: Nothing
          , move: Just 5
          , traits: []
          , abilities:
              [ FoeAbility $ Ability
                  { name: Name "Disappearing Act"
                  , cost: Interrupt (NumVar 1)
                  , tags: []
                  , steps:
                      [ Step TriggerStep Nothing $ text "When bloodied."
                      , Step Eff Nothing $ seq
                          [ text
                              """Remove self from the battlefield. At the end of
                              the next player turn, return them to the
                              battlefield anywhere in range 1-3 of a character,
                              with """
                          , italic $ ref (Name "Stealth") $ text "stealth"
                          , text "."
                          ]
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Dire Gouge"
                  , cost: One
                  , tags: [ Attack, RangeTag (Melee) ]
                  , steps:
                      [ AttackStep (text "2 damage. ") (seq [])
                      , Step OnHit (Just D6) $ text
                          "Deal 3 damage (4+) then 3 damage again."
                      ]
                  }
              , FoeAbility $ Ability
                  { name: Name "Blinding Dust"
                  , cost: One
                  , tags: []
                  , steps:
                      [ Step Eff Nothing $ seq
                          [ text
                              """An adjacent foe takes 2 damage, then must save
                              or become """
                          , italic $ ref (Name "Blind") $ text "blinded"
                          , text ". The Rogue may then dash 4 spaces."
                          ]
                      ]
                  }
              , ChainAbility
                  [ Ability
                      { name: Name "Dirty Fighting"
                      , cost: One
                      , tags:
                          [ RangeTag (Range (NumVar 1) (NumVar 2))
                          , KeywordTag (Name "Chain")
                          ]
                      , steps:
                          [ Step Eff Nothing $ seq
                              [ text
                                  """Swap two characters in range (including
                                  self), then gain """
                              , italic $ ref (Name "Evasion") $ text "evasion"
                              , text "."
                              ]
                          ]
                      }
                  , Ability
                      { name: Name "Foul Play"
                      , cost: One
                      , tags:
                          [ RangeTag (Range (NumVar 1) (NumVar 3))
                          , KeywordTag (Name "Chain")
                          ]
                      , steps:
                          [ Step Eff Nothing $ text
                              """Teleport adjacent to a foe in range, then deal
                              3 damage to that foe. Can repeat the effect, but
                              must choose a different foe in range each time
                              unless a foe has already been chosen by the
                              ability, or this effect has triggered three
                              times."""
                          ]
                      }
                  ]
              ]
          }

      , Legend
          { name: Name "Nocturnal"
          , colour: Name "Purple"
          , class: Name "Legend"
          , faction: Nothing
          , chapter: I
          , description: text
              """The Nocturnal relies on extreme mobility and fear to strike
              down its foes. It can be used to represent winged demons,
              master assassins, gargoyles, or other vicious and mobile
              foes."""
          , hp: Nothing
          , maxVigor: Nothing
          , defense: Nothing
          , move: Nothing
          , tactics: seq []
          , trophies: []
          , traits:
              [ FoeTrait $ Trait
                  { name: Name "Master of the Night"
                  , description: seq
                      [ text
                          """Can move diagonally. Additionally, the Nocturnal
                          has aura 2. It has permanent """
                      , italic $ ref (Name "Evasion") $ text "evasion"
                      , text " if there are no other characters in the aura."
                      ]
                  }
              , RoundAction $ Trait
                  { name: Name "Crippling Paranoia"
                  , description: seq
                      [ text
                          """At the start of the round, the Nocturnal chooses a
                          foe. At the end of the round, that foe deals """
                      , dice 1 D6
                      , text
                          """ damage to all allies in adjacent spaces. If there
                          are no adjacent allies, that foe takes """
                      , dice 1 D6
                      , text " damage and is "
                      , italic $ ref (Name "Stun") $ text "stunned"
                      , text "."
                      ]
                  }
              ]
          , abilities: []
          , phases: Phases
              { description: text
                  """Phase change triggers at the start of each round. The
                  Nocturnal starts in phase I and goes up to phase II, then III,
                  then back to I. """
              , details:
                  [ Phase
                      { description: seq []
                      , traits: []
                      , abilities:
                          [ ChainAbility
                              [ Ability
                                  { name: Name "The Pain"
                                  , cost: One
                                  , tags:
                                      [ Attack
                                      , RangeTag (Range (NumVar 1) (NumVar 2))
                                      , KeywordTag (Name "Chain")
                                      ]
                                  , steps:
                                      [ Step Eff Nothing $ text "Teleport 1."
                                      , AttackStep
                                          (text "3 damage")
                                          (seq [])
                                      , Step Eff Nothing $
                                          seq
                                            [ italic $ text "Miss"
                                            , text ": +"
                                            , dice 1 D6
                                            ]
                                      , Step Eff Nothing $ text "Teleport 1."
                                      ]
                                  }
                              , Ability
                                  { name: Name "The Agony"
                                  , cost: One
                                  , tags:
                                      [ Attack
                                      , RangeTag (Range (NumVar 2) (NumVar 5))
                                      , AreaTag (Cross (NumVar 1))
                                      , KeywordTag (Name "Chain")
                                      ]
                                  , steps:
                                      [ AttackStep
                                          (text "2 piercing damage")
                                          (text "+3 piercing damage")
                                      , Step AreaEff Nothing $
                                          text "2 piercing damage."
                                      ]
                                  }
                              , Ability
                                  { name: Name "The Horror"
                                  , cost: Two
                                  , tags:
                                      [ Attack
                                      , RangeTag Melee
                                      , KeywordTag (Name "Chain")
                                      ]
                                  , steps:
                                      [ AttackStep
                                          (text "2 damage")
                                          (seq [ text "+", dice 2 D6 ])
                                      , Step Eff Nothing $ text
                                          """Deals 2 damage again to afflicted
                                          foes, then 2 damage again if the
                                          target is bloodied."""
                                      ]
                                  }
                              ]
                          , FoeAbility $ Ability
                              { name: Name "Serrated Blade"
                              , cost: One
                              , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                              , steps:
                                  [ Step Eff Nothing $ seq
                                      [ text
                                          """A foe in range takes 2 damage,
                                          increased by + """
                                      , dice 1 D6
                                      , text " if that foe is in crisis."
                                      ]
                                  ]
                              }
                          , FoeAbility $ Ability
                              { name: Name "Bloody Slash"
                              , cost: One
                              , tags:
                                  [ RangeTag Close
                                  , AreaTag (Line (NumVar 3))
                                  , LimitTag 1 "round"
                                  ]
                              , steps:
                                  [ Step AreaEff Nothing $ text
                                      """: Foes in the area take 2 damage, once,
                                      for each foe in the area. The Nocturnal
                                      may then teleport 3."""
                                  ]
                              }
                          , FoeAbility $ Ability
                              { name: Name "Crimson Rain"
                              , cost: One
                              , tags:
                                  [ KeywordTag (Name "Zone")
                                  , RangeTag (Range (NumVar 1) (NumVar 4))
                                  , LimitTag 2 "round"
                                  ]
                              , steps:
                                  [ Step (KeywordStep (Name "Zone")) Nothing $
                                      text
                                        """Choose a free space in range.
                                        Characters that enter that space
                                        voluntarily or start their turn there
                                        are struck by a projectile, taking 3
                                        damage twice, and ending this effect.
                                        This area lasts until triggered, and any
                                        number of zones can be created."""
                                  ]
                              }
                          , FoeAbility $ Ability
                              { name: Name "Roundelay"
                              , cost: One
                              , tags: [ LimitTag 1 "round" ]
                              , steps:
                                  [ Step Eff Nothing $ text
                                      """The Nocturnal teleports and gains vigor
                                      equal to 1+ the round number. """
                                  ]
                              }
                          ]
                      }
                  , Phase
                      { description: text "As phase I, but gains:"
                      , traits: []
                      , abilities:
                          [ FoeAbility $ Ability
                              { name: Name "Amygdala"
                              , cost: One
                              , tags:
                                  [ RangeTag (Range (NumVar 1) (NumVar 2))
                                  , LimitTag 1 "round"
                                  ]
                              , steps:
                                  [ Step Eff Nothing $ seq
                                      [ text
                                          """All foes in range are inflicted
                                          with supernatural fear. They must save
                                          or be pushed """
                                      , italic $ seq [ dice 1 D3, text "+1" ]
                                      , text " spaces and "
                                      , italic
                                          $ ref (Name "Blind")
                                          $ text "blinded"
                                      , text
                                          """, or 1 space and no blind on a
                                          successful save."""
                                      ]
                                  ]
                              }
                          , FoeAbility $ Ability
                              { name: Name "Slash Vein"
                              , cost: One
                              , tags:
                                  [ KeywordTag (Name "Mark")
                                  , LimitTag 1 "round"
                                  ]
                              , steps:
                                  [ Step Eff Nothing $ seq
                                      [ text
                                          """The Nocturnal mark a foe in range.
                                          While marked, after that foe
                                          vonuntarily moves, they take """
                                      , dice 1 D6
                                      , text
                                          """+2 piercing damage. This effect can
                                          only trigger once a turn, but any
                                          number of times a round. This mark is
                                          cleared if a foes spends an entire
                                          turn without voluntarily moving."""
                                      ]
                                  ]
                              }
                          , FoeAbility $ Ability
                              { name: Name "Assassinate"
                              , cost: One
                              , tags:
                                  [ RangeTag (Range (NumVar 1) (NumVar 3))
                                  , LimitTag 1 "round"
                                  ]
                              , steps:
                                  [ Step Eff Nothing $ seq
                                      [ text
                                          """The Nocturnal chooses a foe in
                                          range that has not acted yet this
                                          round. At the end of that foe's
                                          turn: """
                                      , list Unordered
                                          [ seq
                                              [ text
                                                  """As long as they're in
                                                  range, teleport to an space
                                                  adjacent to them, deal """
                                              , dice 1 D6
                                              , text
                                                  """ damage, three times to
                                                  them, and """
                                              , italic
                                                  $ ref (Name "Stun")
                                                  $ text "stun"
                                              , text " them."
                                              ]
                                          , text
                                              """Increase each instance of
                                              damage by +2 if that character is
                                              bloodied, or +4 if they are in
                                              crisis."""
                                          , text
                                              """If they are not in range, the
                                              Nocturnal may teleport 3
                                              instead."""
                                          ]
                                      ]
                                  ]
                              }
                          ]
                      }
                  , Phase
                      { description: text "As phase I, but gains:"
                      , traits:
                          [ RoundAction $ Trait
                              { name: Name "Bloody Nightmare"
                              , description: text
                                  """For the rest of combat, all foes take
                                  piercing damage at the end of their turns if
                                  they are not adjacent to an ally equal to the
                                  round number."""
                              }
                          ]
                      , abilities:
                          [ FoeAbility $ Ability
                              { name: Name "Kidnap"
                              , cost: One
                              , tags: [ LimitTag 2 "round" ]
                              , steps:
                                  [ Step Eff Nothing $ seq
                                      [ text
                                          "The Nocturnal dashes 6 spaces with "
                                      , italic
                                          $ ref (Name "Phasing")
                                          $ text "phasing"
                                      , text
                                          """. One foe adjacent to any point
                                          during its dash is removed from the
                                          battlefield, then placed adjacent when
                                          it finishes its movement. That foe
                                          then becomes """
                                      , italic $ ref (Name "Slow") $ text "slow"
                                      , text
                                          """. Foes can save to avoid being
                                          moved, but still become """
                                      , italic $ ref (Name "Slow") $ text "slow"
                                      , text " on a successful save."
                                      ]
                                  ]
                              }
                          ]
                      }
                  ]
              }
          , specials: Nothing
          }
      ]
  }
