module ToA.Resource.Icon.Job.Dragoon
  ( dragoon
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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

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
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Aces of the guild battalions, Dragoons are masters of heavy
                  gunnery and explosives, dabbling in fiery concoctions,
                  powders, and fuses far past the point of safety or even self
                  preservation. While most of the city guilds are still working
                  their way around the musket and the sabre, Dragoons have
                  already hammered their way through soot, shrapnel, and
                  innumerable accidents into a more impressive fare: long barrel
                  rifling, multi-barrel mini-guns, explosive bullets filled with
                  liquid wyrm fire, the works. So creative and hazardous is
                  their craft that their invention has yet to pass on to the
                  wider world in reproducible form, perhaps for the better."""
              ]
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
              Name "Reach"
                : Name "Breather"
                : Name "Volatile"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Sparking Munition"
          , description:
              [ Text
                  """Once a round, when you damage a character with an ability
                  and that target is 4 or more spaces away, you may cause your
                  target to explode for a burst 1 (target) area effect for 2
                  damage. If your target was 7 or more spaces away, increase
                  burst to 2, damage to """
              , Dice 2 D3
              , Text ", and push 1."
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Reach"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Increase the range of all your abilities with a listed
                  range by +1, and the maximum line of all line effects by
                  +1."""
              ]
          }
      , Talent
          { name: Name "Breather"
          , colour: Name "Yellow"
          , description:
              [ Text "You can expend "
              , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
              , Text " or "
              , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
              , Text
                  """ on yourself as an quick ability to immediately clear a
                  negative status and dash 1 space."""
              ]
          }
      , Talent
          { name: Name "Volatile"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """While you have 3 or more negative status tokens, increase
                  the size of all blast or burst effects you crease by +1."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Mageza Cannon"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Aether-focused direct energy weapon. Takes a long time to
                  charge, and a short time to show your enemies why getting in
                  a fight with your was a bad idea."""
              ]
          , cost: Two /\ 4
          , tags: [ AreaTag (Line (NumVar 9)) ]
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """Draw a line 9 area. If the line ends, or meets an
                      obstruction, stop drawing the line, then place a blast 3
                      area effect with at least one space placed on the last
                      space of the line. Characters in the area must save."""
                  ]
              , Step Eff Nothing
                  [ Text
                      """Gains different effects based on the distance of the
                      line."""
                  , List Unordered
                      [ [ Bold [ Text "0-3" ]
                        , Text ": "
                        , Dice 2 D3
                        , Text " damage"
                        ]
                      , [ Bold [ Text "4-6" ]
                        , Text ": "
                        , Dice 2 D3
                        , Text " damage, twice, and blast +1"
                        ]
                      , [ Bold [ Text "6-9" ]
                        , Text ": "
                        , Dice 3 D3
                        , Text " damage, three times"
                        ]
                      , [ Bold [ Text "9+" ]
                        , Text ": "
                        , Dice 4 D3
                        , Text " damage, four times, and blast +1"
                        ]
                      ]
                  , Text "Foes take half damage on a successful save."
                  ]
              ]
          }
      , Ability
          { name: Name "Frag Shot"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Why shoot one bullet when you can shoot as many as you can
                  cram into the hopper?"""
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 4))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 1." ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text
                      """Max range +3, and +1 area damage. You may repeat this
                      effect, gaining """
                  , Italic [ Ref (Name "Reckless") [ Text "reckless" ] ]
                  , Text " each time."
                  ]
              ]
          }
      , Ability
          { name: Name "Blast Jump"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You soar into the air with explosive pizzaz, leaving your
                  enemies scorched."""
              ]
          , cost: One
          , tags: [ AreaTag (Burst (NumVar 1) true) ]
          , steps:
              [ Step AreaEff (Just D6)
                  [ Text
                      """Explode for a burst 1 (self) area effect. Characters
                      and summons caught inside other than yourself are pushed 1
                      space, and characters tale 2 damage. Then you may fly """
                  , Italic [ Dice 1 D6 ]
                  , Text " spaces."
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text
                      """Increase flight and damage by +2, and gain """
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Friend Maker"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Modified from fireworks. Some have kept the color and
                  elaborate noisemakers and patterns."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ InsetStep Eff (Just D6)
                  [ Text
                      "Summon one or (5+) two rockets in free space in range."
                  ]
                  $ SummonInset
                      { name: Name "Rocket"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """The rocket cna be targeted like a
                                  character. If it would take any damage, it
                                  ignites, traveling in a line 4 path in a
                                  direction of your choice until it meets and
                                  obstruction or the last space of the line."""
                              , List Unordered
                                  [ [ Text
                                        """When it hits an obstruction or runs
                                        out of line, it explodes in a burst 1
                                        area effect centered on its space,
                                        dismissing it."""
                                    ]
                                  , [ Text
                                        """Characters caught inside must save or
                                        take damage equal to the spaces it
                                        traveled before impact, or half as much
                                        on a successful save."""
                                    ]
                                  ]
                              ]
                          , Step (KeywordStep (Name "Reckless")) Nothing
                              [ Text
                                  """Immediately ignite the rocket. Yourself and
                                  adjacent characters to the rocket when it
                                  ignites gain """
                              , Italic
                                  [ Ref (Name "Stealth") [ Text "stealth" ] ]
                              , Text " from the back blast."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Maniac"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You're not one for half measures, tuning your weaponry up
                  to a ridiculous degree. Will that (literally) blow up in your
                  face? Who cares!"""
              ]
          , cost: Quick
          , tags: [ KeywordTag (Name "Stance"), End ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text ": While in this stance:"
                  , List Unordered
                      [ [ Text
                            """You immediately convert any other negative status
                            into """
                        , Italic [ Ref (Name "Reckless") [ Text "reckless" ] ]
                        , Text
                            """, including any statuses you are currently from,
                            even if you couldn't gain more reckless."""
                        ]
                      , [ Text "Reckless stacks up to 6." ]
                      , [ Text
                            """Your attacks deal +damage on hit equal to half
                            your reckless stacks, rounded up."""
                        ]
                      , [ Text
                            """Once a round, when you gain reckless, you may
                            also gain """
                        , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                        , Text " or "
                        , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                        , Text "."
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text "Immediately go to reckless 6." ]
              ]
          }
      ]
  }
