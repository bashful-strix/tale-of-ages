module ToA.Resource.Icon.Job.Sealer
  ( sealer
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
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

sealer :: Icon
sealer =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Sealer"
          , colour: Name "Green"
          , sign: Sign "icon-[game-icons--punch-blast]"
          , soul: Name "Monk"
          , class: Name "Mendicant"
          , description: seq
              [ text
                  """The Sealers are a famous chronicler order of legendary
                  monster hunters and exorcists of unbelievable prowess and
                  unshakeable faith. Whenever an especially bad blight or an
                  arch demon appears, the Sealers are usually there to drive it
                  back with blessed brands, martial arts, and flaming blows from
                  their hands or weapons."""
              , newline
              , newline
              , text
                  """It is the Sealers who were originally responsible for the
                  great Chambers of the Chroniclers, where old evils, or great
                  and ancient powers and artifacts too monumental to permanently
                  destroy were incarcerated using ancient sealing magic. These
                  days, many of the Chambers lie open and the order works
                  fervently at recovering their contents. Modern Sealers do not
                  bemoan their lack of capable vessels, and often seal evil
                  spirits into specially prepared jars, portable iron vessels,
                  or even weapons, which Sealers may then put to use in the
                  service of destroying further opponents."""
              ]
          , trait: Name "Mantra of Sealing"
          , keyword: Name "Excel"
          , abilities:
              (I /\ Name "God Hand")
                : (I /\ Name "Matsuri")
                : (II /\ Name "Evil Crushing Fist")
                : (IV /\ Name "Condemn")
                : empty
          , limitBreak: Name "Passage to the Afterlife"
          , talents:
              Id "surge|talent|sealer"
                : Id "flash|talent|sealer"
                : Id "ascension|talent|sealer"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Mantra of Sealing"
          , description: text
              """You increase you total attack roll by half the round number,
              rounded up. If you roll a total of 10 or over on an attack roll,
              the target of your attack explodes with divine energy with a burst
              1 (target) area effect. All foes in the area take 2 damage, and
              allies in the area gain 2 vigor."""
          }
      ]
  , talents:
      [ Talent
          { id: Id "surge|talent|sealer"
          , name: Name "Surge"
          , colour: Name "Green"
          , description: text
              """At round 3+, increase all your burst effects by +1, and +1
              again at round 5+."""
          }
      , Talent
          { id: Id "flash|talent|sealer"
          , name: Name "Flash"
          , colour: Name "Green"
          , description: seq
              [ text
                  """After you hit an attack, you may teleport 1. If you
                  excelled or better, you may teleport """
              , dice 1 D3
              , text "+1 spaces instead."
              ]
          }
      , Talent
          { id: Id "ascension|talent|sealer"
          , name: Name "Ascension"
          , colour: Name "Green"
          , description: text
              """When you check for range to teleport an ally, you can increase
              that range by +1 and you may teleport them +1 spaces further."""
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Passage to the Afterlife"
          , colour: Name "Green"
          , description: text
              """You unleash the supreme Sealer war art, inflicting ten thousand
              blows and shattering the connections of your foe's vital energy to
              their body, hurrying on the transmigration of immortal souls."""
          , cost: Two /\ 4
          , tags: [ Attack ]
          , steps:
              [ Step Eff Nothing $ text
                  "You cannot unleash this ability before round 4."
              , Step Eff Nothing $ text "Teleport 4."
              , AttackStep (text "4 damage") $ seq [ text "+", dice 2 D6 ]
              , Step (KeywordStep (Name "Excel")) Nothing $ seq
                  [ text
                      """All allies in range 1-2 of your foe may teleport into
                      free adjacent space to your foe. Then your foe takes """
                  , dice 2 D6
                  , text " damage from each ally that teleported this way."
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing $ text
                  "Excel effect has no maximum range."
              ]
          }
      , Ability
          { name: Name "God Hand"
          , colour: Name "Green"
          , description: text
              """Divine energy infuses you, allowing hammer-like blows that
              would fell a demon with even your bare hands."""
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ text "Teleport 1."
              , AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , Step (KeywordStep (Name "Excel")) Nothing $ text
                  """The target of your attack explodes with divine energy with
                  a burst 1 (target) area effect. All foes in the area take 2
                  damage, and allies in the area gain 2 vigor."""
              , Step (KeywordStep (Name "Critical Hit")) Nothing $ text
                  "Increase burst area by half the round number, rounded up."
              ]
          }
      , Ability
          { name: Name "Matsuri"
          , colour: Name "Green"
          , description: text
              """You and allies teleport in a display that sends sprays of
              bright fire, lighting up the sky."""
          , cost: Two
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Choose a blast 3 area in range. You and all adjacent
                      allies may teleport into free space in the area, in any
                      order, then all foes in the area take 2 """
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage and must save or be "
                  , italic $ ref (Name "Brand") $ text "branded"
                  , text " and pushed 1 away from the center."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """If you excelled this turn, reduce the action cost of
                      this ability to 1 action. If you critical hit, it
                      becomes """
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Evil Crushing Fist"
          , colour: Name "Green"
          , description: text
              "Your blows are redoubled by those of your righteous allies."
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), End ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) (Just D6) $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and enter this stance. While in this stance, you can
                      teleport 2 before any attack, and your attacks gain """
                  , power
                  , text "."
                  , list Unordered
                      [ text
                          """When you excel or critical hit with an attack, an
                          ally in range 1-2 of your target may teleport 1. Then
                          if they are adjacent to your target, they deal 2
                          damage (4+) then you may repeat this effect on a new
                          ally (6+) and again."""
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Condemn"
          , colour: Name "Green"
          , description: text
              """Brand your foe with a hellish seal, condemning them and
              crushing them under the weight of their own evil."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 5))
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """Mark a foe in range, then set out a power die at 1.
                      When you or an ally attacks your foe, they gain """
                  , power
                  , text
                      """ on the attack roll, then tick the die up by 2. At 3 or
                      more ticks, increase this attack to
                      """
                  , power
                  , power
                  , text " and "
                  , power
                  , power
                  , power
                  , text
                      """ at 5 or more ticks. At 6 ticks, when your foe is hit
                      by an attack, they explode, with the following
                      effects: """
                  , list Unordered
                      [ seq
                          [ bold $ text "Hit"
                          , text
                              """: Burst 1 (target). 2 damage and push 1 to
                              foes, 2 vigor to allies."""
                          ]
                      , seq [ bold $ text "Excel", text ": Burst +1." ]
                      , seq
                          [ bold $ text "Critical Hit"
                          , text ": +2 damage, vigor, and push."
                          ]
                      ]
                  , text "Then the mark ends."
                  ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
