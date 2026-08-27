module ToA.Resource.Icon.Job.Dragoon
  ( dragoon
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
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

dragoon :: Icon
dragoon =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Dragoon"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--mine-explosion]"
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description: text
              """Aces of the guild battalions, Dragoons are masters of heavy
              gunnery and explosives, dabbling in fiery concoctions, powders,
              and fuses far past the point of safety or even self preservation.
              While most of the city guilds are still working their way around
              the musket and the sabre, Dragoons have already hammered their way
              through soot, shrapnel, and innumerable accidents into a more
              impressive fare: long barrel rifling, multi-barrel mini-guns,
              explosive bullets filled with liquid wyrm fire, the works. So
              creative and hazardous is their craft that their invention has yet
              to pass on to the wider world in reproducible form, perhaps for
              the better."""
          , trait: Name "Sparking Munition"
          , keyword: Name "Reckless"
          , abilities:
              (I /\ Name "Frag Shot")
                : (I /\ Name "Blast Jump")
                : (II /\ Name "Friend Maker")
                : (IV /\ Name "Maniac")
                : empty
          , limitBreak: Name "Mageza Cannon"
          , talents:
              Id "reach|talent|dragoon"
                : Id "breather|talent|dragoon"
                : Id "volatile|talent|dragoon"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Sparking Munition"
          , description: seq
              [ text
                  """Once a round, when you damage a character with an ability
                  and that target is 4 or more spaces away, you may cause your
                  target to explode for a burst 1 (target) area effect for 2
                  damage. If your target was 7 or more spaces away, increase
                  burst to 2, damage to """
              , dice 2 D3
              , text ", and push 1."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "reach|talent|dragoon"
          , name: Name "Reach"
          , colour: Name "Yellow"
          , description: text
              """Increase the range of all your abilities with a listed range by
              +1, and the maximum line of all line effects by +1."""
          }
      , Talent
          { id: Id "breather|talent|dragoon"
          , name: Name "Breather"
          , colour: Name "Yellow"
          , description: seq
              [ text "You can expend "
              , italic $ ref (Name "Haste") $ text "haste"
              , text " or "
              , italic $ ref (Name "Evasion") $ text "evasion"
              , text
                  """ on yourself as an quick ability to immediately clear a
                  negative status and dash 1 space."""
              ]
          }
      , Talent
          { id: Id "volatile|talent|dragoon"
          , name: Name "Volatile"
          , colour: Name "Yellow"
          , description: text
              """While you have 3 or more negative status tokens, increase the
              size of all blast or burst effects you create by +1."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Mageza Cannon"
          , colour: Name "Yellow"
          , description: text
              """Aether-focused direct energy weapon. Takes a long time to
              charge, and a short time to show your enemies why getting in a
              fight with you was a bad idea."""
          , cost: Two /\ 4
          , tags: [ AreaTag (Line (NumVar 9)) ]
          , steps:
              [ Step AreaEff Nothing $ text
                  """Draw a line 9 area. If the line ends, or meets an
                  obstruction, stop drawing the line, then place a blast 3 area
                  effect with at least one space placed on the last space of the
                  line. Characters in the area must save."""
              , Step Eff Nothing $ seq
                  [ text
                      """Gains different effects based on the distance of the
                      line."""
                  , list Unordered
                      [ seq
                          [ bold $ text "0-3"
                          , text ": "
                          , dice 2 D3
                          , text " damage"
                          ]
                      , seq
                          [ bold $ text "4-6"
                          , text ": "
                          , dice 2 D3
                          , text " damage, twice, and blast +1"
                          ]
                      , seq
                          [ bold $ text "6-9"
                          , text ": "
                          , dice 3 D3
                          , text " damage, three times"
                          ]
                      , seq
                          [ bold $ text "9+"
                          , text ": "
                          , dice 4 D3
                          , text " damage, four times, and blast +1"
                          ]
                      ]
                  , text "Foes take half damage on a successful save."
                  ]
              ]
          }
      , Ability
          { name: Name "Frag Shot"
          , colour: Name "Yellow"
          , description: text
              """Why shoot one bullet when you can shoot as many as you can cram
              into the hopper?"""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 4))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ Step Eff Nothing $ text "Dash 1."
              , AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step AreaEff Nothing $ text "2 damage."
              , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text
                      """Max range +3, and +1 area damage. You may repeat this
                      effect, gaining """
                  , italic $ ref (Name "Reckless") $ text "reckless"
                  , text " each time."
                  ]
              ]
          }
      , Ability
          { name: Name "Blast Jump"
          , colour: Name "Yellow"
          , description: text
              """You soar into the air with explosive pizzaz, leaving your
              enemies scorched."""
          , cost: One
          , tags: [ AreaTag (Burst (NumVar 1) true) ]
          , steps:
              [ Step AreaEff (Just D6) $ seq
                  [ text
                      """Explode for a burst 1 (self) area effect. Characters
                      and summons caught inside other than yourself are pushed 1
                      space, and characters take 2 damage. Then you may fly """
                  , italic $ dice 1 D6
                  , text " spaces."
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text
                      """Increase flight and damage by +2, and gain """
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Friend Maker"
          , colour: Name "Yellow"
          , description: text
              """Modified from fireworks. Some have kept the color and elaborate
              noisemakers and patterns."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ InsetStep Eff (Just D6)
                  ( text
                      "Summon one or (5+) two rockets in free space in range."
                  )
                  $ SummonInset
                      { name: Name "Rocket"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text
                                  """The rocket can be targeted like a
                                  character. If it would take any damage, it
                                  ignites, traveling in a line 4 path in a
                                  direction of your choice until it meets an
                                  obstruction or the last space of the line."""
                              , list Unordered
                                  [ text
                                      """When it hits an obstruction or runs out
                                      of line, it explodes in a burst 1 area
                                      effect centered on its space, dismissing
                                      it."""
                                  , text
                                      """Characters caught inside must save or
                                      take damage equal to the spaces it
                                      traveled before impact, or half as much on
                                      a successful save."""
                                  ]
                              ]
                          , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                              [ text
                                  """Immediately ignite the rocket. Yourself and
                                  adjacent characters to the rocket when it
                                  ignites gain """
                              , italic $ ref (Name "Stealth") $ text "stealth"
                              , text " from the back blast."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Maniac"
          , colour: Name "Yellow"
          , description: text
              """You're not one for half measures, tuning your weaponry up to a
              ridiculous degree. Will that (literally) blow up in your face? Who
              cares!"""
          , cost: Quick
          , tags: [ KeywordTag (Name "Stance"), End ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text ": While in this stance:"
                  , list Unordered
                      [ seq
                          [ text
                              """You immediately convert any other negative
                              status into """
                          , italic $ ref (Name "Reckless") $ text "reckless"
                          , text
                              """, including any statuses you are currently
                              suffering from, even if you couldn't gain more
                              reckless."""
                          ]
                      , text "Reckless stacks up to 6."
                      , text
                          """Your attacks deal +damage on hit equal to half your
                          reckless stacks, rounded up."""
                      , seq
                          [ text
                              """Once a round, when you gain reckless, you may
                              also gain """
                          , italic $ ref (Name "Evasion") $ text "evasion"
                          , text " or "
                          , italic $ ref (Name "Haste") $ text "haste"
                          , text "."
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing $ text
                  "Immediately go to reckless 6."
              ]
          }
      ]
  }
