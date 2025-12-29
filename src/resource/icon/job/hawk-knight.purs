module ToA.Resource.Icon.Job.HawkKnight
  ( hawkKnight
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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

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
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Ferocious knights from the infamous Talon Company. The
                  company has long since disbanded, but the knights persist as
                  dangerous wandering mercenaries. Their philosophy is ‘soaring
                  above all’, training relentlessly to become the pinnacle of
                  armed combat, and fighting any and all they can, regardless of
                  allegiance. As a result, they are are spectacular and vicious
                  duelists, tempered only by the fact that they duel to the
                  blood rather than duel to the death. Hawk Knights are much
                  maligned by the generally pacifistic villages of the green,
                  but they know that their era will come. Until then, they bide
                  their time sharpening their blades and doing odd jobs for
                  soft-bellied fools, awaiting the time of carrion."""
              ]
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
              Name "Ferocity"
                : Name "Sinew"
                : Name "Dissect"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "One Hit Kill"
          , description:
              [ Text
                  """If you don't attack during your turn, you can deliver a
                  killing blow. Your next attack gains attack """
              , Power
              , Text ", an additional +1 damage on "
              , Italic [ Ref (Name "Excel") [ Text "excel" ] ]
              , Text ", and an additional +2 damage on "
              , Italic [ Ref (Name "Critical Hit") [ Text "critical hit" ] ]
              , Text
                  """. You may keep this effect even if you miss or are
                  defeated."""
              ]
          , subItem: Nothing
          }
      ]

  , talents:
      [ Talent
          { name: Name "Ferocity"
          , colour: Name "Red"
          , description:
              [ Text
                  """If you're bloodied, lower your threshold to critical hit by
                  1. If you're in crisis, lower it by 2."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Sinew"
          , colour: Name "Red"
          , description:
              [ Text
                  """If you don't attack during your turn, you may increase all
                  lines and crosses you create by +2 on your next turn."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Dissect"
          , colour: Name "Red"
          , description:
              [ Text
                  """You may add damage to critical hits equal to half the round
                  number, rounded up."""
              ]
          , subItem: Nothing
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Bloody Talons"
          , colour: Name "Red"
          , description:
              [ Text
                  """The more the blood flows, the stench of carrion fills the
                  air, invigorating you for the final strike."""
              ]
          , cost: One /\ 4
          , tags:
              [ Attack
              , RangeTag Close
              , AreaTag (Line (NumVar 4))
              , RangeTag Melee
              ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Gains attack "
                  , Power
                  , Text " for each bloodied ally anywhere, and "
                  , Power
                  , Text " if you are also bloodied."
                  ]
              , Step Eff Nothing
                  [ Text "Grazes if you don't "
                  , Italic [ Ref (Name "Excel") [ Text "excel" ] ]
                  , Text " or greater."
                  ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 3 D6 ]
              , Step AreaEff Nothing
                  [ Text "2 damage. "
                  , Italic [ Text "Excel" ]
                  , Text ": 2 damage again. "
                  , Italic [ Text "Critical hit" ]
                  , Text ": 2 damage again."
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing
                  [ Text "Your target gains "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text ", "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text ", and is pushed 6."
                  ]
              , Step Eff Nothing
                  [ Text
                      """If you miss this attack, refund 2 resolve. You can
                        limit break again this combat."""
                  ]
              ]
          }
      , Ability
          { name: Name "Razor Feather"
          , colour: Name "Red"
          , description:
              [ Text
                  """Your sword strokes are so fast you can slash the air
                  multiple times in a blink, sending our cutting shockwaves."""
              ]
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 1) (NumVar 3))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ AttackStep [ Text "4 damage" ] [ Text "+", Dice 1 D6 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step Eff (Just D6)
                  [ Text
                      """You may target one, (4+) two, (6+) or three
                        additional cross 1 in range, extending the area effect.
                        The areas cannont overlap."""
                  ]
              , Step (KeywordStep (Name "Excel")) Nothing
                  [ Text
                      """All targets in the area are slashed with an aftershock,
                      taking 2 damage again."""
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing
                  [ Text "Repeat the excel effect." ]
              ]
          }
      , Ability
          { name: Name "Hawk's Disdain"
          , colour: Name "Red"
          , description:
              [ Text
                  """With a clap, you deflect a blow with your bare hand or the
                  flat edge of your blade."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ SubStep Eff Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text
                      """, and gain the following interrupt until the start of
                      your next turn."""
                  ]
                  $ AbilityItem
                      { name: Name "Turn Blades/Cut Bullets"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  """A foe's ability would deal damage to an
                                  adjacent ally."""
                              ]
                          , Step Eff Nothing
                              [ Text
                                  """Your ally halves incoming damage. Tou also
                                  take half the incoming damage. This damage is
                                  colculated before reductions."""
                              ]
                          ]
                      }
              , Step Eff Nothing
                  [ Text
                      """If you scored a critical hit or excelled this turn,
                      this ability becomes """
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Wicked Sheath"
          , colour: Name "Red"
          , description:
              [ Text
                  """You sheath your blade, in preparation for a blindingly fast
                  strike."""
              ]
          , cost: One
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text ". Your next attack gains:"
                  , List Unordered
                      [ [ Italic [ Text "Attack ", Power ] ]
                      , [ Italic [ Text "On hit" ]
                        , Text
                            """: Foe is pushed 1 and push yourself away from
                            your foe 1."""
                        ]
                      , [ Italic [ Text "Excel" ]
                        , Text ": +2 damage."
                        ]
                      , [ Italic [ Text "Critical hit" ]
                        , Text ": Increase pushed by +2 and foe is "
                        , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                        , Text "."
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Perfect Strike"
          , colour: Name "Red"
          , description:
              [ Text
                  """Nothing less than perfect will do for those that soar
                  above. Tear your foes with your talons and shriek victory."""
              ]
          , cost: Interrupt (NumVar 1)
          , tags: []
          , steps:
              [ Step TriggerStep Nothing
                  [ Text "You "
                  , Italic [ Ref (Name "Excel") [ Text "excel" ] ]
                  , Text " or score a critical hit."
                  ]
              , Step Eff Nothing
                  [ Text
                      """You may re-roll the same attack roll, including all
                      modifiers, then check the below. This counts as an effect
                      and not an attack, and only applies the below effects - no
                      damage or effects of the original attack. Hit, excel, and
                      critical hit effects are cumulative.
                      """
                  , List Unordered
                      [ [ Italic [ Text "Miss" ]
                        , Text ": You are "
                        , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                        , Text " and end your turn."
                        ]
                      , [ Italic [ Text "Hit" ]
                        , Text
                            """: deal 2 damage to your target again and gain 2
                            vigor."""
                        ]
                      , [ Italic [ Text "Excel" ]
                        , Text ": Increase damage and vigor by +"
                        , Dice 1 D3
                        , Text "."
                        ]
                      , [ Italic [ Text "Critical hit" ]
                        , Text ": Increase damage and vigor by a further +"
                        , Dice 1 D6
                        , Text " instead."
                        ]
                      ]
                  ]
              , Step Eff Nothing
                  [ Text "Double vigor and damage if you're in crisis." ]
              ]
          }
      ]
  }
