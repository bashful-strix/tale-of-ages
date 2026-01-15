module ToA.Resource.Icon.Job.Herbalist
  ( herbalist
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

herbalist :: Icon
herbalist =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Herbalist"
          , colour: Name "Green"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """The hedge witches of the villages are invaluable to their
                  functioning, even if their reputation often that of crotchety
                  or eccentric hermits. Often living in the borders of
                  settlements, away from the hustle and bustle, they spend their
                  days cultivating and pruning forest and field to raise the
                  herbs and flowers needed for vital medicines and remedies,
                  healing not only mundane illness but also supernatural curses,
                  afflictions of the soul, and maladies of ill luck or
                  fortune."""
              , Newline
              , Newline
              , Text
                  """To an untrained eye, a Herbalist’s garden looks like any
                  other wild patch. To those tutored in the ways of the Almanac,
                  it is a bounty of blessings, carefully selected in a way that
                  is unique to each practitioner. Herbalists, regardless of age
                  or ability, often go on on long pilgrimages in search of rare
                  flowers or herbs from legend or rumor, and so nearly all keep
                  a good pair of boots handy."""
              ]
          , trait: Name "Green Almanac"
          , keyword: Name "Summon"
          , abilities:
              (I /\ Name "Cultivate")
                : (I /\ Name "Vine Wall")
                : (II /\ Name "Rot")
                : (IV /\ Name "Poison Thorn")
                : empty
          , limitBreak: Name "Essence Sap"
          , talents:
              Name "Signature"
                : Name "Fertilize"
                : Name "Nutrition"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Green Almanac"
          , description:
              [ Text "Once a round, when you "
              , Italic [ Text "summon" ]
              , Text
                  """, you can grant a benefit to an ally in range 1-3 of that
                  summon. The benefit depends on the first letter of the
                  summon's name."""
              , List Unordered
                  [ [ Text "a-h: That ally can dash 2." ]
                  , [ Text "i-p: That ally can clear a negative status." ]
                  , [ Text "q-z: That ally gains "
                    , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                    , Text "."
                    ]
                  ]
              , Text "Double effects if your ally is in crisis."
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Signature"
          , colour: Name "Green"
          , description:
              [ Text
                  """Choose a summon ability. It gains +2 max range and you may
                  rename the ability and the summon it creates in any way you
                  choose."""
              ]
          }
      , Talent
          { name: Name "Fertilize"
          , colour: Name "Green"
          , description:
              [ Text
                  """Once a round, when you create an adverse terrain space, you
                  can create an additional identical space in adjacency."""
              ]
          }
      , Talent
          { name: Name "Nutrition"
          , colour: Name "Green"
          , description:
              [ Text "Increase the effect of "
              , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
              , Text
                  """ on you and adjacent allies to +3 damage. The first time
                  you become bloodied in a combat, gain """
              , Italic [ Text "strength" ]
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Essence Sap"
          , colour: Name "Green"
          , description:
              [ Text
                  """You tap and burgeon the life aether of the bounty around
                  you, returning it to your allies threefold."""
              ]
          , cost: One /\ 3
          , tags: [ AreaTag (Burst (NumVar 2) true) ]
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """Target every character and summon in the area, then
                      sample the first letter of each summon's name, or each
                      character's job name (foe or ally). For each unique
                      letter, heal yourself and all allies in the area by 2
                      vigor. This could put characters over their vigor maximum.
                      At the end of affected character's turns, reduce their
                      vigor to their max if it's over."""
                  ]
              ]
          }
      , Ability
          { name: Name "Cultivate"
          , colour: Name "Green"
          , description:
              [ Text
                  """You sow a line of rapidly growing plants or mushrooms that
                  release a sticky healing sap."""
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag Close
              , AreaTag (Cross (NumVar 1))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , InsetStep OnHit Nothing
                  [ Text
                      """Summon a bouncing spore adjacent to your foe, then
                      summon a bouncing spore in every """
                  , Italic [ Ref (Name "Adverse Terrain") [ Text "adverse" ] ]
                  , Text " terrain space in the area."
                  ]
                  $ SummonInset
                      { name: Name "Bouncing Spore"
                      , colour: Name "Green"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """Yourself or an ally entering or exiting a
                                  spore's space can pop it, """
                              , Italic [ Text "dismissing" ]
                              , Text
                                  """ the spore, gaining 1 vigor and ignoring
                                  any terrain movement penalities or damage in
                                  this space. If this is the third spore or more
                                  they have popped this turn, increase vigor by
                                  +"""
                              , Dice 1 D3
                              , Text "."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Vine Wall"
          , colour: Name "Green"
          , description:
              [ Text
                  """You coax the plants in the ground to grow rapidly, and they
                  spring forth like well trained animals."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Object")
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D3)
                  [ Text "Create "
                  , Italic [ Dice 1 D3 ]
                  , Text "+1 "
                  , Italic [ Text "vines" ]
                  , Text
                      """ in range, which can be created under characters. A
                      vine deal 2 piercing damage to any character in its area
                      when it is created, but a character can only take this
                      damage once a turn."""
                  ]
                  $ SummonInset
                      { name: Name "Vine"
                      , colour: Name "Green"
                      , max: 6
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text "A vine counts as "
                              , Italic
                                  [ Ref
                                      (Name "Difficult Terrain")
                                      [ Text "difficult terrain" ]
                                  ]
                              , Text
                                  """. Bloodied characters must spend an
                                  additional +1 space of movement (3 total) to
                                  exit its space, or +2 spaces (4 total) if they
                                  are in crisis. A character can destroy a vine
                                  by using the interact action in an adjacent
                                  space, but leaves difficult terrain in its
                                  space."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Rot"
          , colour: Name "Green"
          , description:
              [ Text "Leaves shrivel. Hair curls. Wounds fail to heal." ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """Mark a foe in range. While marked, that character takes
                      2 """
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage at the end of their turn and creates "
                  , Italic
                      [ Ref
                          (Name "Difficult Terrain")
                          [ Text "difficult terrain" ]
                      ]
                  , Text " under themselves. Increase damage to "
                  , Dice 2 D6
                  , Text " piercing, and increase difficult terrain to "
                  , Italic [ Text "3" ]
                  , Text
                      """ adjacent spaces of your choice if any part of it is
                      absorbed by vigor. That character may then save to end the
                      mark."""
                  ]
              ]
          }
      , Ability
          { name: Name "Poison Thorn"
          , colour: Name "Green"
          , description:
              [ Text
                  """Your foe feels a sharp sting in their feet, and finds
                  themself tethered to a bulbous poison vine."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ InsetStep (KeywordStep (Name "Mark")) (Just D6)
                  [ Text
                      """Summon one or (5+) two poison bulbs in range 1-3 of
                      your marked foe. A foe can only remove this mark when
                      there are no poison bulbs left. If you transfer this mark
                      or use it again, bulbs remain."""
                  ]
                  $ SummonInset
                      { name: Name "Poison Bulb"
                      , colour: Name "Green"
                      , max: 6
                      , abilities:
                          [ Step SummonEff Nothing [ Text "Immobile" ]
                          , Step SummonEff Nothing
                              [ Text "Each bulb deals 2 "
                              , Italic
                                  [ Ref (Name "Pierce") [ Text "piercing" ] ]
                              , Text
                                  """ damage to the marked foe at the end of
                                  their turn. An ally of the marked character,
                                  or that character may """
                              , Italic [ Text "dismiss" ]
                              , Text
                                  """ a bulb by moving into its space. The bulb
                                  leaves """
                              , Italic
                                  [ Ref
                                      (Name "Difficult Terrain")
                                      [ Text "difficult" ]
                                  ]
                              , Text " terrain when dismissed."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text
                      """Summon +1 more bulb, or two more if your foe is in
                      crisis."""
                  ]
              ]
          }
      ]
  }
