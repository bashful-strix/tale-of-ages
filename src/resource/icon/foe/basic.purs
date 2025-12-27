module ToA.Resource.Icon.Foe.Basic
  ( basic
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(Self)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Foe
  ( Faction(..)
  , Foe(..)
  , FoeAbility(..)
  , FoeInsert(..)
  , FoeTrait(..)
  )
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

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
          , description: []
          , template: { description: [], traits: [] }
          , mechanic: { name: Name "", description: [] }
          , keywords: []
          }
      ]

  , foes:
      [ Foe
          { name: Name "Sledge"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text "Hard hitting foe that inflicts stun with a heavy blow." ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Yank"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 3) (NumVar 4)) ]
                  , description:
                      [ Text "A character in range is pulled "
                      , Dice 1 D3
                      , Text ". If pulled adjacent, they take 3 "
                      , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                      , Text " damage."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Block"
                  , cost: One
                  , tags: [ End ]
                  , description:
                      [ Text "Gain "
                      , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                      , Text
                          """ and the following interrupt until the start of its
                          next turn."""
                      ]
                  , chain: Nothing
                  , insert: Just $ AbilityInsert
                      { name: Name "Shield Block"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step Nothing $ TriggerStep
                              [ Text
                                  """This character or an adjacent ally is
                                  attacked."""
                              ]
                          , Step Nothing $ Eff
                              [ Text "The attack deals 1/2 damage." ]
                          ]
                      }
                  }
              , FoeAbility
                  { name: Name "Shoulder Check"
                  , cost: One
                  , tags: [ KeywordTag (Name "Chain") ]
                  , description:
                      [ Text "Dash 1, then gain 2 vigor. Increase both by "
                      , Dice 1 D3
                      , Text " if bloodied."
                      ]
                  , chain: Just $ FoeAbility
                      { name: Name "Crushing Overhead"
                      , cost: Two
                      , tags: [ Attack, KeywordTag (Name "Chain") ]
                      , description:
                          [ Text "6 damage and the foe is "
                          , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                          , Text ". "
                          , Italic [ Text "Hit" ]
                          , Text ": +"
                          , Dice 2 D6
                          , Text " and foe must save or additionally be "
                          , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                          , Text "."
                          ]
                      , chain: Nothing
                      , insert: Nothing
                      }
                  , insert: Nothing
                  }
              ]
          }
      , Foe
          { name: Name "Soldier"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """Basic melee fighter, controls the flow of combat with deft
                  strikes and slashes."""
              ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Deft Strike"
                  , cost: One
                  , tags: [ Attack ]
                  , description:
                      [ Text "2 damage. Hit: +"
                      , Dice 1 D6
                      , Text ". "
                      , Italic [ Text "Afflicted" ]
                      , Text " foes take +2 base damage."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Bash"
                  , cost: One
                  , tags: [ KeywordTag (Name "Repeatable") ]
                  , description:
                      [ Text "An adjacent foe takes 2 damage and is pushed 1." ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Block"
                  , cost: One
                  , tags: [ End ]
                  , description:
                      [ Text "Gain "
                      , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                      , Text
                          """ and the following interrupt until the start of its
                          next turn."""
                      ]
                  , chain: Nothing
                  , insert: Just $ AbilityInsert
                      { name: Name "Shield Block"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step Nothing $ TriggerStep
                              [ Text
                                  """This character or an adjacent ally is
                                  attacked."""
                              ]
                          , Step Nothing $ Eff
                              [ Text "The attack deals 1/2 damage." ]
                          ]
                      }
                  }
              ]
          }
      , Foe
          { name: Name "Warrior"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """Straightforward, hard hitting foe that attacks with
                  sweeping, heavy attacks."""
              ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Giant Slice"
                  , cost: One
                  , tags:
                      [ Attack
                      , RangeTag Close
                      , AreaTag (Line (NumVar 3))
                      , KeywordTag (Name "Chain")
                      ]
                  , description:
                      [ Text "2 damage. Hit: +"
                      , Dice 1 D3
                      , Text ". "
                      , Italic [ Text "Area effect" ]
                      , Text ": 2 damage. "
                      , Italic [ Text "Effect" ]
                      , Text
                          """: Gains +2 base damage and area damage if catching
                          two or more foes in the area."""
                      ]
                  , chain: Just $ FoeAbility
                      { name: Name "Whirlwind"
                      , cost: Two
                      , tags: [ RangeTag Melee, KeywordTag (Name "Chain") ]
                      , description:
                          [ Text "The Warrior "
                          , Italic [ Text "dashes" ]
                          , Text " 1 space, "
                          , Italic [ Dice 1 D3 ]
                          , Text
                              """+1 times. After it moves, each time, it deals 3
                              damage to adjacent characters and pushes them 1."""
                          ]
                      , chain: Nothing
                      , insert: Nothing
                      }
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Bulk Up"
                  , cost: One
                  , tags: [ TargetTag Self, End ]
                  , description:
                      [ Text
                          """Remove a negative token from self, then gain 2
                          vigor. Repeat this effect if in crisis."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Battle Cry"
                  , cost: One
                  , tags:
                      [ AreaTag (Burst (NumVar 1) true), LimitTag 1 "combat" ]
                  , description:
                      [ Text
                          """Grant self and each ally in the area 3 vigor. Those
                          characters can also clear a negative condition if this
                          character is bloodied."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }

      , Foe
          { name: Name "Dervish"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text "A fighter that attacks in sweeping bursts." ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Razor Wind"
                  , cost: One
                  , tags: []
                  , description:
                      [ Text "Repeat the following effect "
                      , Italic [ Dice 1 D3 ]
                      , Text
                          """ times: Dash 2, then burst 1 (self): 2 damage.
                          Increase damage by +1 against bloodied foes, or +2
                          against foes in crisis."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Western Wind"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)) ]
                  , description:
                      [ Text "The Dervish or an ally in range may fly "
                      , Italic [ Dice 1 D3 ]
                      , Text "+1 and gain "
                      , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Fan of Knives"
                  , cost: Two
                  , tags: [ RangeTag Close, AreaTag (Blast (NumVar 3)) ]
                  , description:
                      [ Italic [ Text "Area effect" ]
                      , Text ": "
                      , Dice 1 D6
                      , Text
                          """+4, save for half. Deals +4 damage against foes
                          with no allies adjacent."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Blinding Wind"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 3))
                      , LimitTag 2 "combat"
                      ]
                  , description:
                      [ Text
                          """A foe in range must save. On a successful save,
                          they become """
                      , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                      , Text
                          """. On a failed save, they also become marked and
                          unable to draw line of sight to any space that is not
                          adjacent. They can ignore this mark if they are
                          adjacent to any ally, and repeat a save to end it at
                          the end of their turn."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , Foe
          { name: Name "Gunner"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text "A mobile ranged attacker that hits multiple times." ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Riddle"
                  , cost: One
                  , tags: [ Attack, RangeTag (Range (NumVar 3) (NumVar 5)) ]
                  , description:
                      [ Text "2 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": 3 damage again, then 3 damage again."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Strafe"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 2) (NumVar 3)) ]
                  , description:
                      [ Text
                          """The Gunner dashes 2, then deals 2 damage to a foe
                          in range. If a foe is at exactly range 3, they
                          take """
                      , Dice 1 D3
                      , Text "+1 damage instead."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Overwatch"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 3) (NumVar 5)), End ]
                  , description:
                      [ Text
                          """Target a blast 3 area in range, which could be
                          placed over characters. Then gain the following
                          interrupt until the start of this character's next
                          turn."""
                      ]
                  , chain: Nothing
                  , insert: Just $ AbilityInsert
                      { name: Name "Overwatch"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step Nothing $ TriggerStep
                              [ Text "A foe voluntarily moves in the ares." ]
                          , Step Nothing $ Eff
                              [ Text
                                  """All foes in the area must save. Foes take 2
                                  damage. On a failed save, they take 2 damage
                                  again, three more times."""
                              ]
                          ]
                      }
                  }
              , FoeAbility
                  { name: Name "Flash Bomb"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 2) (NumVar 3))
                      , AreaTag (Cross (NumVar 2))
                      , LimitTag 1 "combat"
                      ]
                  , description:
                      [ Italic [ Text "Area effect" ]
                      , Text ": All foes take "
                      , Dice 1 D6
                      , Text "+4 damage (save for half) and are "
                      , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                      , Text ". The center space then becomes an "
                      , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                      , Text " space. "
                      , Italic [ Text "Effect" ]
                      , Text
                          """: If the Gunner catches itself or allies in the
                          area, they gain """
                      , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , Foe
          { name: Name "Skulk"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text "A sneaky foe that hits hard against weakened foes." ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Shank"
                  , cost: One
                  , tags: [ Attack, RangeTag Melee ]
                  , description:
                      [ Text "2 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": +"
                      , Dice 1 D6
                      , Text ". "
                      , Italic [ Text "Effect" ]
                      , Text ": Deals damage "
                      , Power
                      , Text " to bloodied foes, and a further damage "
                      , Power
                      , Text " against afflicted foes."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Throwing Blade"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 2) (NumVar 3)) ]
                  , description:
                      [ Text
                          """A foe in range takes 2 damage, ignoring cover,
                          increased by +"""
                      , Dice 1 D6
                      , Text " if target is in crisis."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Prowl"
                  , cost: One
                  , tags: []
                  , description:
                      [ Text "Dash 3, then gain "
                      , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Dirty Trick"
                  , cost: One
                  , tags: [ End, LimitTag 2 "combat" ]
                  , description:
                      [ Text "An adjacent foe is "
                      , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                      , Text " and must save or first lose "
                      , Dice 1 D3
                      , Text
                          """ positive status tokens. The Skulk may then
                          teleport 3."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }

      , Foe
          { name: Name "Priest"
          , colour: Name "Green"
          , class: Name "Leader"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """Divinely infused foes with the power to shield allies from
                  harm."""
              ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Griholy"
                  , cost: One
                  , tags:
                      [ Attack
                      , AreaTag (Cross (NumVar 1))
                      , RangeTag (Range (NumVar 2) (NumVar 4))
                      ]
                  , description:
                      [ Text "2 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": +"
                      , Dice 1 D3
                      , Text ". "
                      , Italic [ Text "Area effect" ]
                      , Text
                          """: Allies in the area gain 2 vigor. Foes take 2
                          damage. Increase all damage or vigor by +"""
                      , Dice 1 D3
                      , Text " for bloodied characters."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Purge"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , description:
                      [ Text "A foe in range chooses: either take "
                      , Dice 1 D3
                      , Text
                          """+1 piercing damage or lose a positive status. If
                          they have no positive status, they automatically take
                          the damage."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Diaga"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , description:
                      [ Text
                          """An ally in range may immediately save to end all
                          stacks of a status. They gain """
                      , Power
                      , Text " on the save if they are bloodied."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Aegi"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 2))
                      , KeywordTag (Name "Mark")
                      , LimitTag 2 "combat"
                      ]
                  , description:
                      [ Text "Allied character in range gains "
                      , Italic [ Dice 1 D6, Text "+4" ]
                      , Text
                          """ vigor and becomes marked. When marked, they take
                          take 1/2 damage. The first time in a turn the marked
                          character is damaged by an ability, they must save or
                          lose all vigor and the mark after the tirggering
                          ability resolves."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , Foe
          { name: Name "Sergeant"
          , colour: Name "Green"
          , class: Name "Leader"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  "Martial leaders that are excellent at moving allies around."
              ]
          , notes: []
          , traits:
              [ FoeTrait
                  { name: Name "Aura of Command"
                  , description:
                      [ Text "Aura 1. Allies in the area have attack "
                      , Power
                      , Text "."
                      ]
                  }
              ]
          , abilities:
              [ FoeAbility
                  { name: Name "Leader's Strike"
                  , cost: One
                  , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 3)) ]
                  , description:
                      [ Text "3 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": +"
                      , Dice 1 D3
                      , Text ". "
                      , Italic [ Text "Effect" ]
                      , Text ": Up to three allies in range can dash 2 with "
                      , Italic
                          [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Marching Orders"
                  , cost: Two
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                  , description:
                      [ Text "The Sergeant and all allies in range dash "
                      , Dice 2 D3
                      , Text " and gain 1 "
                      , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                      , Text
                          """. If the Sergeant is bloodied, they are immune to
                          all damage and """
                      , Italic
                          [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                      , Text " during this movement."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Takedown"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , description:
                      [ Text
                          """A foe in range must save. They take 1 damage once
                          for every ally of the Sergeant adjacent to them, up to
                          three times. On a failed save, they take 3 damage for
                          each ally instead."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }

      , Foe
          { name: Name "Justicar"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """A rare wright using the power of light aether to punish
                  foes trying to flee."""
              ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Judgement Bolt"
                  , cost: One
                  , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 8)) ]
                  , description:
                      [ Text "2 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": +"
                      , Dice 1 D6
                      , Text ". "
                      , Italic [ Text "Effect" ]
                      , Text ": gains attak "
                      , Power
                      , Text " and damage "
                      , Power
                      , Text
                          """ against foes 4 or more spaces away. Deals +2 base
                          damage against foes 7 or more spaces away."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Mighty Summoning"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 4) (NumVar 6)) ]
                  , description:
                      [ Text "An ally in range is pulled "
                      , Italic [ Dice 1 D6 ]
                      , Text " spaces and gains "
                      , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
                      , Text ". Alternatively, pull self "
                      , Italic [ Dice 1 D6 ]
                      , Text
                          " spaces towards an ally or object in range and gain "
                      , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Punishment of Cowards"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 3) (NumVar 6)) ]
                  , description:
                      [ Text
                          """The Justicar prepares for action and gains the
                          following interrupt until the start of their next
                          turn."""
                      ]
                  , chain: Nothing
                  , insert: Just $ AbilityInsert
                      { name: Name "Punish Cowards"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step Nothing $ TriggerStep
                              [ Text
                                  "A foe ends movement 4 or more spaces away."
                              ]
                          , Step Nothing $ Eff
                              [ Text
                                  """The foe is pulled 1, then must save or be
                                  pulled an additional +"""
                              , Dice 1 D3
                              , Text " and become "
                              , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                              , Text "."
                              ]
                          ]
                      }
                  }
              , FoeAbility
                  { name: Name "Riven"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 2) (NumVar 6))
                      , End
                      , KeywordTag (Name "Mark")
                      ]
                  , description:
                      [ Text
                          """Choose a foe in range. At the end of that
                          character's turn, as long as they're in range, they
                          must save or take piercing damage equal to double the
                          distance between this character and the marked foe, or
                          just 2 piercing damage on a successful save. Then end
                          the mark."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , Foe
          { name: Name "Pyromancer"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """A wright of pure fire aether, summoning it to eradicate
                  their foes."""
              ]
          , notes: []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Flame Burst"
                  , cost: One
                  , tags:
                      [ Attack
                      , RangeTag (Range (NumVar 3) (NumVar 6))
                      , AreaTag (Blast (NumVar 2))
                      , KeywordTag (Name "Chain")
                      ]
                  , description:
                      [ Text "3 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": 3 damage again. "
                      , Italic [ Text "Area effect" ]
                      , Text ": 3 damage. "
                      , Italic [ Text "On hit" ]
                      , Text
                          ": Create dangerous terrain under the attack target."
                      ]
                  , chain: Just $ FoeAbility
                      { name: Name "Gripyre"
                      , cost: Two
                      , tags:
                          [ Attack
                          , RangeTag (Range (NumVar 3) (NumVar 8))
                          , AreaTag (Blast (NumVar 3))
                          , KeywordTag (Name "Chain")
                          ]
                      , description:
                          [ Text "3 damage. "
                          , Italic [ Text "Hit" ]
                          , Text ": +"
                          , Dice 2 D6
                          , Text ". "
                          , Italic [ Text "Area effect" ]
                          , Text ": 3 damage. "
                          , Italic [ Text "Effect" ]
                          , Text
                              """: Deals +2 base or area damage to characters
                              standing in adverse terrain."""
                          ]
                      , chain: Nothing
                      , insert: Nothing
                      }
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Emberflash"
                  , cost: One
                  , tags:
                      [ AreaTag (Cross (RollVar 1 D3))
                      , RangeTag (Range (NumVar 1) (NumVar 6))
                      ]
                  , description:
                      [ Italic [ Text "Area effect" ]
                      , Text ": 2 piercing damage and create a "
                      , Italic
                          [ Ref
                              (Name "Dangerous Terrain")
                              [ Text "dangerous terrain" ]
                          ]
                      , Text " space in the center."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Flash Fire"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 6)) ]
                  , description:
                      [ Text
                          """A character in range takes 2 damage, then must save
                          or become """
                      , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                      , Text ". "
                      , Italic [ Ref (Name "Afflicted") [ Text "Afflicted" ] ]
                      , Text
                          """ foes also explode for a burst 1 (target)
                          explosion for 3 piercing damage."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , Foe
          { name: Name "Scourer"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """A foe using water and fire aether together to create
                  pressurized bursts of steam and boiling vapor."""
              ]
          , notes: []
          , traits:
              [ FoeTrait
                  { name: Name "Vaporsight"
                  , description: [ Text "Ignores cover from obscured spaces." ]
                  }
              ]
          , abilities:
              [ FoeAbility
                  { name: Name "Scour"
                  , cost: One
                  , tags:
                      [ Attack
                      , RangeTag Close
                      , AreaTag (Line (NumVar 6))
                      , KeywordTag (Name "Mark")
                      ]
                  , description:
                      [ Text "3 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": +"
                      , Dice 1 D3
                      , Text ". "
                      , Italic [ Text "Area effect" ]
                      , Text ": 3 damage. "
                      , Italic [ Text "Effect" ]
                      , Text
                          """: Mark the attack target. Attacks against the
                          marked target for the rest of sombat combat gain
                          attack """
                      , Power
                      , Text
                          """ and deal +2 damage on hit. This effect stacks.
                          Lose all stacks if a new target is marked."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Steam Vent"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 6))
                      , AreaTag (Burst (NumVar 1) false)
                      ]
                  , description:
                      [ Text "2 piercing damage, and create an "
                      , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                      , Text " space in the center space."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Vaporize"
                  , cost: One
                  , tags: []
                  , description:
                      [ Text "Teleport self and all adjacent allies "
                      , Dice 2 D3
                      , Text "+1."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Boiling Bolus"
                  , cost: One
                  , tags:
                      [ KeywordTag (Name "Zone")
                      , RangeTag (Range (NumVar 2) (NumVar 6))
                      , AreaTag (Cross (NumVar 1))
                      , LimitTag 1 "combat"
                      ]
                  , description:
                      [ Text "The zone is "
                      , Italic
                          [ Ref
                              (Name "Dangerous Terrain")
                              [ Text "dangerous" ]
                          ]
                      , Text " and "
                      , Italic
                          [ Ref
                              (Name "Difficult Terrain")
                              [ Text "difficult" ]
                          ]
                      , Text
                          """ terrain. Increase to cross 2 at round 3+, even if
                          already placed, and cross 4 at round 5+. This could
                          cause the zone to grow under characters."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }

      , Elite
          { name: Name "Archon"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """Archons are armored, tough warriors that can be used to
                  represent particularly hardy fighters, military leaders, or
                  warlords. Alternately, they can be used to represent
                  particularly ruthless or tough monsters."""
              ]
          , notes: []
          , hp: 80
          , defense: 3
          , move: 4
          , traits:
              [ FoeTrait
                  { name: Name "Enrage"
                  , description:
                      [ Text "In crisis, takes 1/2 damage from all sources." ]
                  }
              ]
          , abilities:
              [ FoeAbility
                  { name: Name "Blackheart"
                  , cost: One
                  , tags: [ Attack, KeywordTag (Name "Chain") ]
                  , description:
                      [ Text "2 damage. "
                      , Italic [ Text "Hit" ]
                      , Text ": +"
                      , Dice 1 D6
                      , Text ". "
                      , Italic [ Text "Effect" ]
                      , Text ": Gains attack "
                      , Power
                      , Text
                          """ and deals +3 damage on hit against afflicted
                          characters."""
                      ]
                  , chain: Just $ FoeAbility
                      { name: Name "Dark Edge"
                      , cost: Two
                      , tags:
                          [ Attack
                          , RangeTag Close
                          , AreaTag (Blast (NumVar 2))
                          , KeywordTag (Name "Chain")
                          ]
                      , description:
                          [ Text "3 damage and shove 1. "
                          , Italic [ Text "Hit" ]
                          , Text ": +"
                          , Dice 2 D6
                          , Text " and shove +"
                          , Italic [ Dice 1 D3 ]
                          , Text ". "
                          , Italic [ Text "Area effect" ]
                          , Text
                              """: 3 damage. If foes are shoved into a an
                              obstruction, they must save or be """
                          , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                          , Text "."
                          ]
                      , chain: Nothing
                      , insert: Nothing
                      }
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Hamstring"
                  , cost: One
                  , tags: [ KeywordTag (Name "Mark") ]
                  , description:
                      [ Italic [ Text "Effect" ]
                      , Text ": An adjacent foe is "
                      , Italic [ Ref (Name "Mark") [ Text "marked" ] ]
                      , Text
                          """. If that foe voluntarily moves while marked, they
                          take """
                      , Dice 2 D3
                      , Text " "
                      , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                      , Text
                          """ damage. Reomve this mark if they end their turn
                          without moving voluntarily."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Great Slam"
                  , cost: One
                  , tags: []
                  , description:
                      [ Italic [ Text "Effect [X]" ]
                      , Text
                          """: Dash 2 spaces, then one adjacent foe is either
                          (1-3) shoved 1 space (4+) or """"
                      , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                      , Text ". While moving, become "
                      , Italic
                          [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                      , Text " and "
                      , Italic [ Ref (Name "Immune") [ Text "immune" ] ]
                      , Text " to all damage."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Great Shieldwall"
                  , cost: One
                  , tags: [ KeywordTag (Name "only usable when bloodied"), End ]
                  , description:
                      [ Text "Until start of the Archon's next turn, becomes "
                      , Italic [ Ref (Name "Immobile") [ Text "immobile" ] ]
                      , Text
                          """, but the Archon grants cover to allies, and
                          attacks against all adjacent allies deal damage """
                      , Weakness
                      , Text " and have attack "
                      , Weakness
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }
      , Elite
          { name: Name "Rogue"
          , colour: Name "Yellow"
          , class: Name "Skirmisher"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """Rogues are quick witted and quick on their feet. They can
                  be used to represent skilled thieves, scouts, or assassins, or
                  particularly agile or bloodthirsty monsters."""
              ]
          , notes: []
          , hp: 64
          , defense: 6
          , move: 5
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Disappearing Act"
                  , cost: Interrupt (NumVar 1)
                  , tags: []
                  , description:
                      [ Italic [ Text "Trigger" ]
                      , Text ": When blooded. "
                      , Italic [ Text "Effect" ]
                      , Text
                          """: Remove self from the battlefield. At the end of
                          the next player turn, return them to the battlefield
                          anywhere in range 1-3 of a character, with """
                      , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
                      , Text "."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Dire Gouge"
                  , cost: One
                  , tags: [ Attack, RangeTag (Melee) ]
                  , description:
                      [ Text "2 damage. "
                      , Italic [ Text "Hit [X]" ]
                      , Text ": Deal 3 damage (4+) then 3 damage again."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Blinding Dust"
                  , cost: One
                  , tags: []
                  , description:
                      [ Text
                          """An adjacent foe takes 2 damage, then must save or
                          become """
                      , Italic [ Ref (Name "Blind") [ Text "blinded" ] ]
                      , Text ". The Rogue may then dash 4 spaces."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Dirty Fighting"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 2))
                      , KeywordTag (Name "Chain")
                      ]
                  , description:
                      [ Text
                          """Swap two characters in range (including self), then
                          gain """
                      , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                      , Text "."
                      ]
                  , chain: Just $ FoeAbility
                      { name: Name "Foul Play"
                      , cost: One
                      , tags:
                          [ RangeTag (Range (NumVar 1) (NumVar 3))
                          , KeywordTag (Name "Chain")
                          ]
                      , description:
                          [ Italic [ Text "Effect" ]
                          , Text
                              """: Teleport adjacent to a foe in range, then
                              deal 3 damage to that foe. Can repeat the effect,
                              but must choose a different foe in range each time
                              unless a foe has already been chosen by the
                              ability, or this effect has triggered three
                              times."""
                          ]
                      , chain: Nothing
                      , insert: Nothing
                      }
                  , insert: Nothing
                  }
              ]
          }

      , Legend
          { name: Name "Nocturnal"
          , colour: Name "Purple"
          , class: Name "Legend"
          , faction: Nothing
          , chapter: Nothing
          , description:
              [ Text
                  """The Nocturnal relies on extreme mobility and fear to strike
                  down its foes. It can be used to represent winged demons,
                  master assassins, gargoyles, or other vicious and mobile
                  foes."""
              ]
          , notes: []
          , tactics: []
          , traits:
              [ FoeTrait
                  { name: Name "Master of the Night"
                  , description:
                      [ Text
                          """Can move diagonally. Additionally, the Nocturnal
                          has aura 2. It has permanent """
                      , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                      , Text " if there are no other characters in the aura."
                      ]
                  }
              ]
          , roundActions:
              [ FoeTrait
                  { name: Name "Crippling Paranoia"
                  , description:
                      [ Text
                          """At the start of the round, the Nocturnal chooses a
                          foe. At the end of the round, that foe deals """
                      , Dice 1 D6
                      , Text
                          """ damage to all allies in adjacent spaces. If there
                          are no adjacent allies, that foe takes """
                      , Dice 1 D6
                      , Text " damage and is "
                      , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                      , Text "."
                      ]
                  }
              ]
          , phases:
              { description:
                  [ Text
                      """Phase change triggers at the start of each round. The
                      Nocturnal starts in phase I and goes up to phase II, then
                      III, then back to I. """
                  ]
              , details:
                  [ { description: []
                    , traits: []
                    , roundActions: []
                    , abilities:
                        [ FoeAbility
                            { name: Name "The Pain"
                            , cost: One
                            , tags:
                                [ Attack
                                , RangeTag (Range (NumVar 1) (NumVar 2))
                                , KeywordTag (Name "Chain")
                                ]
                            , description:
                                [ Italic [ Text "Effect" ]
                                , Text ": Teleport 1. "
                                , Italic [ Text "Attack" ]
                                , Text ": 3 damage. "
                                , Italic [ Text "Miss" ]
                                , Text ": +"
                                , Dice 1 D6
                                , Text ". "
                                , Italic [ Text "Effect" ]
                                , Text ": Teleport 1."
                                ]
                            , chain: Just $ FoeAbility
                                { name: Name "The Agony"
                                , cost: One
                                , tags:
                                    [ Attack
                                    , RangeTag (Range (NumVar 2) (NumVar 5))
                                    , AreaTag (Cross (NumVar 1))
                                    , KeywordTag (Name "Chain")
                                    ]
                                , description:
                                    [ Text "2 piercing damage. "
                                    , Italic [ Text "Hit" ]
                                    , Text ": +3 piercing damage. "
                                    , Italic [ Text "Area effect" ]
                                    , Text ": 2 piercing damage."
                                    ]
                                , chain: Just $ FoeAbility
                                    { name: Name "The Horror"
                                    , cost: Two
                                    , tags:
                                        [ Attack
                                        , RangeTag Melee
                                        , KeywordTag (Name "Chain")
                                        ]
                                    , description:
                                        [ Text "2 damage. "
                                        , Italic [ Text "Hit" ]
                                        , Text ": +"
                                        , Dice 2 D6
                                        , Text ". "
                                        , Italic [ Text "Effect" ]
                                        , Text
                                            """: Deals 2 damage again to
                                            afflicted foes, then 2 damage again
                                            if the target is bloodied."""
                                        ]
                                    , chain: Nothing
                                    , insert: Nothing
                                    }
                                , insert: Nothing
                                }
                            , insert: Nothing
                            }
                        , FoeAbility
                            { name: Name "Serrated Blade"
                            , cost: One
                            , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                            , description:
                                [ Text
                                    """A foe in range takes 2 damage, increased
                                    by + """
                                , Dice 1 D6
                                , Text " if that foe is in crisis."
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        , FoeAbility
                            { name: Name "Bloody Slash"
                            , cost: One
                            , tags:
                                [ RangeTag Close
                                , AreaTag (Line (NumVar 3))
                                , LimitTag 1 "round"
                                ]
                            , description:
                                [ Italic [ Text "Area effect" ]
                                , Text
                                    """: Foes in the area take 2 damage, once,
                                    for each foe in the area. The Nocturnal may
                                    then teleport 3."""
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        , FoeAbility
                            { name: Name "Crimson Rain"
                            , cost: One
                            , tags:
                                [ KeywordTag (Name "Zone")
                                , RangeTag (Range (NumVar 1) (NumVar 4))
                                , LimitTag 2 "round"
                                ]
                            , description:
                                [ Italic [ Text "Zone" ]
                                , Text
                                    """: Choose a free space in range.
                                    Characters that enter that space voluntarily
                                    or start their turn there are struck by a
                                    projectile, taking 3 damage twice, and
                                    ending this effect. This area lasts until
                                    triggered, and any number of zones can be
                                    created."""
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        , FoeAbility
                            { name: Name "Roundelay"
                            , cost: One
                            , tags: [ LimitTag 1 "round" ]
                            , description:
                                [ Text
                                    """The Nocturnal teleports and gains vigor
                                    equal to 1+ the round number. """
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        ]
                    }
                  , { description: [ Text "As phase I, but gains:" ]
                    , traits: []
                    , roundActions: []
                    , abilities:
                        [ FoeAbility
                            { name: Name "Amygdala"
                            , cost: One
                            , tags:
                                [ RangeTag (Range (NumVar 1) (NumVar 2))
                                , LimitTag 1 "round"
                                ]
                            , description:
                                [ Text
                                    """All foes in range are inflicted with
                                    supernatural fear. They must save or be
                                    pushed """
                                , Italic [ Dice 1 D3, Text "+1" ]
                                , Text " spaces and "
                                , Italic
                                    [ Ref (Name "Blind") [ Text "blinded" ] ]
                                , Text
                                    """, or 1 space and no blind on a successful
                                    save."""
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        , FoeAbility
                            { name: Name "Slash Vein"
                            , cost: One
                            , tags:
                                [ KeywordTag (Name "Mark"), LimitTag 1 "round" ]
                            , description:
                                [ Text
                                    """The Nocturnal mark a foe in range. While
                                    marked, after that foe vonuntarily moves,
                                    they take """
                                , Dice 1 D6
                                , Text
                                    """+2 piercing damage. This effect can only
                                    trigger once a turn, but any number of times
                                    a round. This mark is cleared if a foes
                                    spends an entire turn without voluntarily
                                    moving."""
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        , FoeAbility
                            { name: Name "Assassinate"
                            , cost: One
                            , tags:
                                [ RangeTag (Range (NumVar 1) (NumVar 3))
                                , LimitTag 1 "round"
                                ]
                            , description:
                                [ Text
                                    """The Nocturnal chooses a foe in range that
                                    has not acted yet this round. At the end of
                                    that foe's turn: """
                                , List Unordered
                                    [ [ Text
                                          """As long as they're in range,
                                          teleport to an space adjacent to them,
                                          deal """
                                      , Dice 1 D6
                                      , Text
                                          " damage, three times to them, and "
                                      , Italic
                                          [ Ref (Name "Stun") [ Text "stun" ] ]
                                      , Text " them."
                                      ]
                                    , [ Text
                                          """Increase each instance of damage by
                                          +2 if that character is bloodied, or
                                          +4 if they are in crisis."""
                                      ]
                                    , [ Text
                                          """If they are not in range, the
                                          Nocturnal may teleport 3 instead."""
                                      ]
                                    ]
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        ]
                    }
                  , { description: [ Text "As phase I, but gains:" ]
                    , traits: []
                    , roundActions:
                        [ FoeTrait
                            { name: Name "Bloody Nightmare"
                            , description:
                                [ Text
                                    """For the rest of combat, all foes take
                                    piercing damage at the end of their turns if
                                    they are not adjacent to an ally equal to
                                    the round number."""
                                ]
                            }
                        ]
                    , abilities:
                        [ FoeAbility
                            { name: Name "Kidnap"
                            , cost: One
                            , tags: [ LimitTag 2 "round" ]
                            , description:
                                [ Text "The Nocturnal dashes 6 spaces with "
                                , Italic
                                    [ Ref (Name "Phasing") [ Text "phasing" ] ]
                                , Text
                                    """. One foe adjacent to any point during
                                    its dash is removed from the battlefield,
                                    then placed adjacent when it finishes its
                                    movement. That foe then becomes """
                                , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                                , Text
                                    """. Foes can save to avoid being moved, but
                                    still become """
                                , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                                , Text " on a successful save."
                                ]
                            , chain: Nothing
                            , insert: Nothing
                            }
                        ]
                    }
                  ]
              }
          }
      ]
  }
