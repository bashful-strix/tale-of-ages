module ToA.Resource.Icon.Job.Harvester
  ( harvester
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
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

harvester :: Icon
harvester =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Harvester"
          , colour: Name "Green"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Servants of Tsumi, the Moon Titan, the Harvesters are the
                  death priests of Arden Eld. They travel from land to land,
                  sanctifying burial sites, performing funeral rites, and
                  helping lingering spirits move on. The land is full of the
                  malice and unfulfilled wishes of the long suffering dead, and
                  so the services of the Harvesters are in high demand."""
              , Newline
              , Newline
              , Text
                  """Tsumi is the protector of cycles, and so the Harvesters
                  also perform fertility blessings, oversee harvest festivals,
                  and see to the cultivation and protection of the land and
                  nature. They plant flowers over battlefields, and tend groves
                  of beautiful fruit trees planted over graveyards. This dual
                  nature makes Harvesters fierce warriors, able to make the
                  battle bloom or rot with a single swipe of their
                  greatscythes."""
              ]
          , trait: Name "Blooming Death"
          , keyword: Name "Finishing Blow"
          , abilities:
              (I /\ Name "Reap")
                : (I /\ Name "Sanguine Thicket")
                : (II /\ Name "Hulk")
                : (IV /\ Name "Waking Dead")
                : empty
          , limitBreak: Name "Death Sentence"
          , talents:
              Name "Cycle"
                : Name "Necromancer"
                : Name "Sanguinity"
                : empty
          }
      ]

  , traits:
      [ InsetTrait
          { name: Name "Blooming Death"
          , description:
              [ Text
                  """At the end of your turn, summon a thrall in free space in
                  range 1-3. Summon two if you are bloodied, or three if you are
                  in crisis."""
              ]
          , inset: SummonInset
              { name: Name "Thrall"
              , colour: Name "Green"
              , max: 6
              , abilities:
                  [ Step SummonAction Nothing
                      [ Text
                          """All thralls dash 3 spaces, then explode, dealing 2
                          damage to an adjacent foe or granting 2 vigor to an
                          adjacent ally. Increase by +"""
                      , Dice 1 D3
                      , Text
                          """ against characters in crisis. Then dismiss the
                          thrall."""
                      ]
                  ]
              }
          }
      ]

  , talents:
      [ Talent
          { id: Id "cycle|talent|harvester"
          , name: Name "Cycle"
          , colour: Name "Green"
          , description:
              [ Text
                  """Once a round, when you reduce a character to 0 hp, you can
                  immediately smake a free move, or grant it to an ally in range
                  1-3."""
              ]
          }
      , InsetTalent
          { id: Id "necromancer|talent|harvester"
          , name: Name "Necromancer"
          , colour: Name "Green"
          , description:
              [ Text
                  """If you don't attack during your turn, summon a thrall in
                  range 1-3."""
              ]
          , inset: SummonInset
              { name: Name "Thrall"
              , colour: Name "Green"
              , max: 6
              , abilities:
                  [ Step SummonAction Nothing
                      [ Text
                          """All thralls dash 3 spaces, then explode, dealing 2
                          damage to an adjacent foe or granting 2 vigor to an
                          adjacent ally. Increase by +"""
                      , Dice 1 D3
                      , Text
                          """ against characters in crisis. Then dismiss the
                          thrall."""
                      ]
                  ]
              }
          }
      , Talent
          { id: Id "sanguinity|talent|harvester"
          , name: Name "Sanguinity"
          , colour: Name "Green"
          , description:
              [ Text
                  """When you grant vigor to yourself or an ally in crisis,
                  grant them 2 """
              , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
              , Text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Death Sentence"
          , colour: Name "Green"
          , description:
              [ Text
                  """A flash of the scythe, and the line between life and death
                  is blurred."""
              ]
          , cost: Quick /\ 4
          , tags: [ RangeTag Melee, End ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  [ Text
                      """You slash an adjacent foe with your weapon, knocking
                      their soul out of their body. Summon their soul in range
                      1-2. Dismiss the soul at the end of your next turn."""
                  ]
                  $ SummonInset
                      { name: Name "Severed Soul"
                      , colour: Name "Green"
                      , max: 1
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """While they have their soul knocked our,
                                  foes can act normally. However, the soul can
                                  be targeted as if it was the body,
                                  transferring all damage, mark, or statuses it
                                  would take to the body, no matter the distance
                                  or line of sight. Other effect (such as pushes
                                  or pulls) apply to the soul."""
                              , List Unordered
                                  [ [ Text "Damage transferred gains "
                                    , Italic
                                        [ Ref (Name "Pierce") [ Text "pierce" ]
                                        ]
                                    , Text "."
                                    ]
                                  , [ Text "The soul always counts as being in "
                                    , Italic
                                        [ Ref (Name "Crisis") [ Text "crisis" ]
                                        ]
                                    , Text "."
                                    ]
                                  , [ Text
                                        """Abilities that are able to target
                                        both the body and soul of the foe (such
                                        as AoEs) can hit both."""
                                    ]
                                  ]
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Reap"
          , colour: Name "Green"
          , description:
              [ Text
                  "Swing the great scythe, and pull forth the fruit of death."
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag Close
              , AreaTag (Arc (NumVar 3))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , InsetStep OnHit Nothing
                  [ Text
                      """Summon a thrall adjacent to your foe at the end of your
                      turn."""
                  ]
                  $ SummonInset
                    { name: Name "Thrall"
                    , colour: Name "Green"
                    , max: 6
                    , abilities:
                        [ Step SummonAction Nothing
                            [ Text
                                """All thralls dash 3 spaces, then explode,
                                dealing 2 damage to an adjacent foe or granting
                                2 vigor to an adjacent ally. Increase by +"""
                            , Dice 1 D3
                            , Text
                                """ against characters in crisis. Then dismiss
                                the thrall."""
                            ]
                        ]
                    }
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text "Summon two, or three if your foe is in crisis." ]
              ]
          }
      , Ability
          { name: Name "Sanguine Thicket"
          , colour: Name "Green"
          , description:
              [ Text
                  """You sow rapidly growing seeds of the blood oak, the
                  carnivorous holy plant of the harvesters."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text "Create a line 3 wall in free space in range."
                  , List Unordered
                      [ [ Text "This area is "
                        , Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "dangerous" ]
                            ]
                        , Text " terrain."
                        ]
                      , [ Text
                            """Bloodied characters take +2 damage from this
                            terrain, or +3 if they're in crisis."""
                        ]
                      , [ Text "Once a round, when you score a "
                        , Italic
                            [ Ref
                                (Name "Finishing Blow")
                                [ Text "finishing blow" ]
                            ]
                        , Text " against "
                        , Italic [ Text "any" ]
                        , Text
                            """ character, the plants feed on life force and you
                            can cause the area to grow by 2 spaces, added to the
                            total area in any way you choose. The could grow
                            under characters."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Hulk"
          , colour: Name "Green"
          , description:
              [ Text
                  """Drag forth a rotten warrior of twisting vines, flesh and
                  earth."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 3))
              , KeywordTag (Name "Summon")
              , End
              ]
          , steps:
              [ InsetStep Eff Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and summon a hulk in free space in range, a size 2
                      summon. Push all foes adjacent to the hulk 1 spaces. The
                      hulk has 15 maximum vigor. It starts with 6 vigor, then
                      gains 3 additional vigor per foe pushed this way."""
                  ]
                  $ SummonInset
                      { name: Name "Hulk"
                      , colour: Name "Green"
                      , max: 1
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """Adjacent allies may use the hulk for cover,
                                  and may also spend its vigor as their own.
                                  After the hulk ends a turn at 0 vigor, it
                                  collapses, """
                              , Italic [ Text "dismissing" ]
                              , Text " it."
                              ]
                          , Step SummonAction (Just D3)
                              [ Text
                                  """The hulk dashes 3, may push an adjacent
                                  character 1, then gains """
                              , Italic [ Dice 1 D3 ]
                              , Text " vigor."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Waking Dead"
          , colour: Name "Green"
          , description:
              [ Text
                  """You infuse necromantic vigor into an ally, scouring their
                  body but infusing them with un-life."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text "Mark and reduce an ally to 1 hp, but:"
                  , List Unordered
                      [ [ Text "grant them maximum vigor" ]
                      , [ Text "they are "
                        , Italic
                            [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                        , Text " and gain "
                        , Power
                        , Text " on attack rolls and saves while marked."
                        ]
                      ]
                  , Text "While marked, that ally is "
                  , Italic [ Ref (Name "Defeated") [ Text "defeated" ] ]
                  , Text
                      """ at the end of their turn. They can remove this mark by
                      defeating a foe."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text
                      """Your ally may immediately make a free move when marked.
                      If they are in crisis, they also gain """
                  , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                  , Text "."
                  ]
              ]
          }
      ]
  }
