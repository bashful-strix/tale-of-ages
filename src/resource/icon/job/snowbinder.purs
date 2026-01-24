module ToA.Resource.Icon.Job.Snowbinder
  ( snowbinder
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

snowbinder :: Icon
snowbinder =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Snowbinder"
          , colour: Name "Blue"
          , soul: Name "Water"
          , class: Name "Wright"
          , description:
              [ Text
                  """Guides, leaders, and folk mages of the far northern lands,
                  where the land is blanketed with a thick layer of snow most of
                  the year. These distant lands have retained many of their old
                  ways, and were never truly conquered by the Arken. Even in
                  times of deep summer, they are covered in a thick layer of
                  frost that confounds the weaponry, soldiery, and war machines
                  of would-be conquerors."""
              , Newline
              , Newline
              , Text
                  """To their inhabitants, these lands are a demanding but
                  comforting home. The Snowbinders are an honored caste that
                  keep the roads clear, the storms from biting too much, and
                  create warm refuges for settlements. To travelers and
                  visitors, the hospitality of the northern lands is legendary.
                  To invaders, it offers only a bone-biting chill."""
              ]
          , trait: Name "Icy Gust"
          , keyword: Name "Conserve"
          , abilities:
              (I /\ Name "Rime")
                : (I /\ Name "Freeze Solid")
                : (II /\ Name "Sleet Slide")
                : (IV /\ Name "Snow Siege")
                : empty
          , limitBreak: Name "Great Blizzion"
          , talents:
              Name "Crystalline"
                : Name "Spin"
                : Name "Slide"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Icy Gust"
          , description:
              [ Text
                  """If you don't attack during your turn, you may push or pull
                  a character, summon, or object in range 1-3 spaces equal to
                  the round number + 1. Unlike other pushes or pulls, you can
                  choose the distance pulled."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Crystalline"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Your first attack of any combat deals +base damage equal to
                  the round number."""
              ]
          }
      , Talent
          { name: Name "Spin"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Once a combat, when you push a character, summon or object,
                  you can increase the distance of that push by the round number
                  +1."""
              ]
          }
      , Talent
          { name: Name "Slide"
          , colour: Name "Blue"
          , description:
              [ Text
                  """If you don't attack during your turn, at the end of that
                  turn, you may push yourself 3. You can choose the direction of
                  this push."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Great Blizzion"
          , colour: Name "Blue"
          , description:
              [ Text
                  """To your foes, the ice storm you call is a relentless,
                  hungry gale. To you, it is a warm refuge that shields you and
                  your charges from harm."""
              ]
          , cost: One /\ 2
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing
                  [ Bold [ Text "End your turn." ]
                  , Text " Until the start of your next turn, "
                  , Italic [ Text "all" ]
                  , Text
                      """ characters become unable to attack due to the strength
                      of snow and wind. """
                  , Italic [ Text "All" ]
                  , Text " spaces for that duration become "
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text " and "
                  , Italic
                      [ Ref
                          (Name "Difficult Terrain")
                          [ Text "difficult terrain" ]
                      ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Rime"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You strike and the attack rebounds, forming into an icy
                  weapon that hovers in the air."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 5)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , InsetStep Eff Nothing
                  [ Text
                      """Summon a rime weapon in the closest free end of the
                      line. The weapon becomes active at the end of your
                      turn."""
                  ]
                  $ SummonInset
                      { name: Name "Rime Weapon"
                      , colour: Name "Blue"
                      , max: 6
                      , abilities:
                          [ Step SummonAction Nothing
                              [ Text
                                  """All active rime weapons repeate the exact
                                  area of the line that created them, dealing
                                  piercing damage in that area equal to the
                                  round number and pushing characters in the
                                  area 1. If the weapon moves, the area they
                                  affected moves with them, mirroring the
                                  movement."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text
                      """You may use this ability without the attack tag. If you
                      do, it just creates the rime weapon."""
                  ]
              ]
          }
      , Ability
          { name: Name "Freeze Solid"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You freeze the water in the air, creating a fragile icicle
                  - usually a trick for traversing up glacier chasms."""
              ]
          , cost: One
          , tags: [ KeywordTag (Name "Object"), End ]
          , steps:
              [ Step (KeywordStep (Name "Object")) Nothing
                  [ Text
                      """You create a height 1 icicle object in free space in
                      range. If any character would be pushed or pulled into the
                      object, it shatters, creating a burst 2 effect centered on
                      it. All characters inside take 2 piercing damage, then are
                      pushed 1. Then remove it and replace it with """
                  , Italic
                      [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
                  , Text " terrain."
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text "Create a height 2 object instead." ]
              ]
          }
      , Ability
          { name: Name "Sleet Slide"
          , colour: Name "Blue"
          , description:
              [ Text
                  """An elementary magic trick originally for entertainment,
                  turned to combat purpose."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 3))
              , AreaTag (Line (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """You create a zone of slippery ice in free space in
                      range."""
                  , List Unordered
                      [ [ Text
                            """Characters that start their turn in the area or
                            voluntarily enter its space for the first time in a
                            turn may choose to save. On a failed save, or if
                            they decline to save, they are pushed to the closest
                            end of the line, or as far as possible (you can
                            choose if a space is equidistant). Foes then
                            become """
                        , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                        , Text "."
                        ]
                      , [ Text
                            """You can push any summon you create in the area to
                            either end of the line."""
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text "Increase line by +2." ]
              ]
          }
      , Ability
          { name: Name "Snow Siege"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You create a steadily growing ball of rock, ice, and sleet.
                  As it moves, it gathers in size and bulk until it is powerful
                  enough to blow open a castle wall."""
              ]
          , cost: Two
          , tags: [ KeywordTag (Name "Summon") ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  [ Text
                      """Summon a snowball in a free adjacent space, and set out
                      a power die, starting at 1.
                      """
                  ]
                  $ SummonInset
                      { name: Name "Snowball"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """The snowball is a height 1 object as well
                                  as a summon. Characters on top of the snowball
                                  when it moves are pushed with it, remaining
                                  on top if possible."""
                              ]
                          , Step SummonEff Nothing
                              [ Text
                                  """Once a turn, but any number of times a
                                  round, when the snowball is pushed, tick the
                                  power die up by 1."""
                              ]
                          , Step SummonEff Nothing
                              [ Text
                                  """If the snowball would be pushed into the
                                  space of a character, that character gains """
                              , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                              , Text
                                  """, then is pushed 1 and takes 2 piercing
                                  dmmage per tick on the power die. Then tick
                                  the die down by """
                              , Dice 1 D3
                              , Text
                                  """. If the die would be reduced to 0, dismiss
                                  the snowball."""
                              ]
                          , Step SummonAction Nothing
                              [ Text "Push the snowball 1." ]
                          ]
                      }
              ]
          }
      ]
  }
