module ToA.Resource.Icon.Job.HawkKnight
  ( hawkKnight
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
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

hawkKnight :: Icon
hawkKnight =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Hawk Knight"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--eagle-emblem]"
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description: text
              """Ferocious knights from the infamous Talon Company. The company
              has long since disbanded, but the knights persist as dangerous
              wandering mercenaries. Their philosophy is ‘soaring above all’,
              training relentlessly to become the pinnacle of armed combat, and
              fighting any and all they can, regardless of allegiance. As a
              result, they are are spectacular and vicious duelists, tempered
              only by the fact that they duel to the blood rather than duel to
              the death. Hawk Knights are much maligned by the generally
              pacifistic villages of the green, but they know that their era
              will come. Until then, they bide their time sharpening their
              blades and doing odd jobs for soft-bellied fools, awaiting the
              time of carrion."""
          , trait: Name "One Hit Kill"
          , keyword: Name "Excel"
          , abilities:
              (I /\ Name "Razor Feather")
                : (I /\ Name "Hawk's Disdain")
                : (II /\ Name "Wicked Sheath")
                : (IV /\ Name "Perfect Strike")
                : empty
          , limitBreak: Name "Bloody Talons"
          , talents:
              Id "ferocity|talent|hawk-knight"
                : Id "sinew|talent|hawk-knight"
                : Id "dissect|talent|hawk-knight"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "One Hit Kill"
          , description: seq
              [ text
                  """If you don't attack during your turn, you can deliver a
                  killing blow. Your next attack gains attack """
              , power
              , text ", an additional +1 damage on "
              , italic $ ref (Name "Excel") $ text "excel"
              , text ", and an additional +2 damage on "
              , italic $ ref (Name "Critical Hit") $ text "critical hit"
              , text
                  """. You may keep this effect even if you miss or are
                  defeated."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "ferocity|talent|hawk-knight"
          , name: Name "Ferocity"
          , colour: Name "Red"
          , description: text
              """If you're bloodied, lower your threshold to critical hit by 1.
              If you're in crisis, lower it by 2."""
          }
      , Talent
          { id: Id "sinew|talent|hawk-knight"
          , name: Name "Sinew"
          , colour: Name "Red"
          , description: text
              """If you don't attack during your turn, you may increase all
              lines and crosses you create by +2 on your next turn."""
          }
      , Talent
          { id: Id "dissect|talent|hawk-knight"
          , name: Name "Dissect"
          , colour: Name "Red"
          , description: text
              """You may add damage to critical hits equal to half the round
              number, rounded up."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Bloody Talons"
          , colour: Name "Red"
          , description: text
              """The more the blood flows, the stench of carrion fills the air,
              invigorating you for the final strike."""
          , cost: One /\ 4
          , tags:
              [ Attack
              , RangeTag Close
              , AreaTag (Line (NumVar 4))
              , RangeTag Melee
              ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Gains attack "
                  , power
                  , text " for each bloodied ally anywhere, and "
                  , power
                  , text " if you are also bloodied."
                  ]
              , Step Eff Nothing $ seq
                  [ text "Grazes if you don't "
                  , italic $ ref (Name "Excel") $ text "excel"
                  , text " or greater."
                  ]
              , AttackStep (text "2 damage") (seq [ text "+", dice 3 D6 ])
              , Step AreaEff Nothing $ seq
                  [ text "2 damage. "
                  , italic $ text "Excel"
                  , text ": 2 damage again. "
                  , italic $ text "Critical hit"
                  , text ": 2 damage again."
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing $ seq
                  [ text "Your target gains "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text ", "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text ", and is pushed 6."
                  ]
              , Step Eff Nothing $ text
                  """If you miss this attack, refund 2 resolve. You can limit
                  break again this combat."""
              ]
          }
      , Ability
          { name: Name "Razor Feather"
          , colour: Name "Red"
          , description: text
              """Your sword strokes are so fast you can slash the air multiple
              times in a blink, sending out cutting shockwaves."""
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 1) (NumVar 3))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ AttackStep (text "4 damage") (seq [ text "+", dice 1 D6 ])
              , Step AreaEff Nothing $ text "2 damage."
              , Step Eff (Just D6) $ text
                  """You may target one, (4+) two, (6+) or three additional
                  cross 1 in range, extending the area effect. The areas cannot
                  overlap."""
              , Step (KeywordStep (Name "Excel")) Nothing $ text
                  """All targets in the area are slashed with an aftershock,
                  taking 2 damage again."""
              , Step (KeywordStep (Name "Critical Hit")) Nothing $ text
                  "Repeat the excel effect."
              ]
          }
      , Ability
          { name: Name "Hawk's Disdain"
          , colour: Name "Red"
          , description: text
              """With a clap, you deflect a blow with your bare hand or the flat
              edge of your blade."""
          , cost: One
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ text "Gain "
                      , italic $ ref (Name "Shield") $ text "shield"
                      , text
                          """, and gain the following interrupt until the start
                          of your next turn."""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Turn Blades/Cut Bullets"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              """A foe's ability would deal damage to an
                              adjacent ally."""
                          , Step Eff Nothing $ text
                              """Your ally halves incoming damage. You also take
                              half the incoming damage. This damage is
                              calculated before reductions."""
                          ]
                      }
              , Step Eff Nothing $ seq
                  [ text
                      """If you scored a critical hit or excelled this turn,
                      this ability becomes """
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Wicked Sheath"
          , colour: Name "Red"
          , description: text
              """You sheath your blade, in preparation for a blindingly fast
              strike."""
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ bold $ text "End your turn"
                  , text ". Your next attack gains:"
                  , list Unordered
                      [ italic $ seq [ text "Attack ", power ]
                      , seq
                          [ italic $ text "On hit"
                          , text
                              """: Foe is pushed 1 and push yourself away from
                              your foe 1."""
                          ]
                      , seq [ italic $ text "Excel", text ": +2 damage." ]
                      , seq
                          [ italic $ text "Critical hit"
                          , text ": Increase pushes by +2 and foe is "
                          , italic $ ref (Name "Stun") $ text "stunned"
                          , text "."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Perfect Strike"
          , colour: Name "Red"
          , description: text
              """Nothing less than perfect will do for those that soar above.
              Tear your foes with your talons and shriek victory."""
          , cost: Interrupt (NumVar 1)
          , tags: []
          , steps:
              [ Step TriggerStep Nothing $ seq
                  [ text "You "
                  , italic $ ref (Name "Excel") $ text "excel"
                  , text " or score a critical hit."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """You may re-roll the same attack roll, including all
                      modifiers, then check the below. This counts as an effect
                      and not an attack, and only applies the below effects - no
                      damage or effects of the original attack. Hit, excel, and
                      critical hit effects are cumulative.
                      """
                  , list Unordered
                      [ seq
                          [ italic $ text "Miss"
                          , text ": You are "
                          , italic $ ref (Name "Daze") $ text "dazed"
                          , text " and end your turn."
                          ]
                      , seq
                          [ italic $ text "Hit"
                          , text
                              """: deal 2 damage to your target again and gain 2
                              vigor."""
                          ]
                      , seq
                          [ italic $ text "Excel"
                          , text ": Increase damage and vigor by +"
                          , dice 1 D3
                          , text "."
                          ]
                      , seq
                          [ italic $ text "Critical hit"
                          , text ": Increase damage and vigor by a further +"
                          , dice 1 D6
                          , text " instead."
                          ]
                      ]
                  ]
              , Step Eff Nothing $ text
                  "Double vigor and damage if you're in crisis."
              ]
          }
      ]
  }
