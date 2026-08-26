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
          , sign: Sign "icon-[game-icons--scythe]"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description: seq
              [ text
                  """Servants of Tsumi, the Moon Titan, the Harvesters are the
                  death priests of Arden Eld. They travel from land to land,
                  sanctifying burial sites, performing funeral rites, and
                  helping lingering spirits move on. The land is full of the
                  malice and unfulfilled wishes of the long suffering dead, and
                  so the services of the Harvesters are in high demand."""
              , newline
              , newline
              , text
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
              Id "cycle|talent|harvester"
                : Id "necromancer|talent|harvester"
                : Id "sanguinity|talent|harvester"
                : empty
          }
      ]

  , traits:
      [ InsetTrait
          { name: Name "Blooming Death"
          , description: text
              """At the end of your turn, summon a thrall in free space in range
              1-3. Summon two if you are bloodied, or three if you are in
              crisis."""
          , inset: SummonInset
              { name: Name "Thrall"
              , colour: Name "Green"
              , max: 6
              , abilities:
                  [ Step SummonAction Nothing $ seq
                      [ text
                          """All thralls dash 3 spaces, then explode, dealing 2
                          damage to an adjacent foe or granting 2 vigor to an
                          adjacent ally. Increase by +"""
                      , dice 1 D3
                      , text
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
          , description: text
              """Once a round, when you reduce a character to 0 hp, you can
              immediately make a free move, or grant it to an ally in range
              1-3."""
          }
      , InsetTalent
          { id: Id "necromancer|talent|harvester"
          , name: Name "Necromancer"
          , colour: Name "Green"
          , description: text
              """If you don't attack during your turn, summon a thrall in range
              1-3."""
          , inset: SummonInset
              { name: Name "Thrall"
              , colour: Name "Green"
              , max: 6
              , abilities:
                  [ Step SummonAction Nothing $ seq
                      [ text
                          """All thralls dash 3 spaces, then explode, dealing 2
                          damage to an adjacent foe or granting 2 vigor to an
                          adjacent ally. Increase by +"""
                      , dice 1 D3
                      , text
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
          , description: seq
              [ text
                  """When you grant vigor to yourself or an ally in crisis,
                  grant them 2 """
              , italic $ ref (Name "Strength") $ text "strength"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Death Sentence"
          , colour: Name "Green"
          , description: text
              """A flash of the scythe, and the line between life and death is
              blurred."""
          , cost: Quick /\ 4
          , tags: [ RangeTag Melee, End ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  ( text
                      """You slash an adjacent foe with your weapon, knocking
                      their soul out of their body. Summon their soul in range
                      1-2. Dismiss the soul at the end of your next turn."""
                  )
                  $ SummonInset
                      { name: Name "Severed Soul"
                      , colour: Name "Green"
                      , max: 1
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text
                                  """While they have their soul knocked out,
                                  foes can act normally. However, the soul can
                                  be targeted as if it was the body,
                                  transferring all damage, marks, or statuses it
                                  would take to the body, no matter the distance
                                  or line of sight. Other effects (such as pushes
                                  or pulls) apply to the soul."""
                              , list Unordered
                                  [ seq
                                      [ text "Damage transferred gains "
                                      , italic
                                          $ ref (Name "Pierce")
                                          $ text "pierce"
                                      , text "."
                                      ]
                                  , seq
                                      [ text
                                          "The soul always counts as being in "
                                      , italic
                                          $ ref (Name "Crisis")
                                          $ text "crisis"
                                      , text "."
                                      ]
                                  , text
                                      """Abilities that are able to target both
                                      the body and soul of the foe (such as
                                      AoEs) can hit both."""
                                  ]
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Reap"
          , colour: Name "Green"
          , description: text
              "Swing the great scythe, and pull forth the fruit of death."
          , cost: One
          , tags:
              [ Attack
              , RangeTag Close
              , AreaTag (Arc (NumVar 3))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D3 ])
              , Step AreaEff Nothing $ text "2 damage."
              , InsetStep OnHit Nothing
                  ( text
                      """Summon a thrall adjacent to your foe at the end of your
                      turn."""
                  )
                  $ SummonInset
                      { name: Name "Thrall"
                      , colour: Name "Green"
                      , max: 6
                      , abilities:
                          [ Step SummonAction Nothing $ seq
                              [ text
                                  """All thralls dash 3 spaces, then explode,
                                dealing 2 damage to an adjacent foe or granting
                                2 vigor to an adjacent ally. Increase by +"""
                              , dice 1 D3
                              , text
                                  """ against characters in crisis. Then dismiss
                                the thrall."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ text
                  "Summon two, or three if your foe is in crisis."
              ]
          }
      , Ability
          { name: Name "Sanguine Thicket"
          , colour: Name "Green"
          , description: text
              """You sow rapidly growing seeds of the blood oak, the carnivorous
              holy plant of the harvesters."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 2) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text "Create a line 3 wall in free space in range."
                  , list Unordered
                      [ seq
                          [ text "This area is "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous"
                          , text " terrain."
                          ]
                      , text
                          """Bloodied characters take +2 damage from this
                          terrain, or +3 if they're in crisis."""
                      , seq
                          [ text "Once a round, when you score a "
                          , italic
                              $ ref (Name "Finishing Blow")
                              $ text "finishing blow"
                          , text " against "
                          , italic $ text "any"
                          , text
                              """ character, the plants feed on life force and
                              you can cause the area to grow by 2 spaces, added
                              to the total area in any way you choose. This
                              could grow under characters."""
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Hulk"
          , colour: Name "Green"
          , description: text
              "Drag forth a rotten warrior of twisting vines, flesh and earth."
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 3))
              , KeywordTag (Name "Summon")
              , End
              ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ bold $ text "End your turn"
                      , text
                          """ and summon a hulk in free space in range, a size 2
                          summon. Push all foes adjacent to the hulk 1 spaces.
                          The hulk has 15 maximum vigor. It starts with 6 vigor,
                          then gains 3 additional vigor per foe pushed this
                          way."""
                      ]
                  )
                  $ SummonInset
                      { name: Name "Hulk"
                      , colour: Name "Green"
                      , max: 1
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text
                                  """Adjacent allies may use the hulk for cover,
                                  and may also spend its vigor as their own.
                                  After the hulk ends a turn at 0 vigor, it
                                  collapses, """
                              , italic $ text "dismissing"
                              , text " it."
                              ]
                          , Step SummonAction (Just D3) $ seq
                              [ text
                                  """The hulk dashes 3, may push an adjacent
                                  character 1, then gains """
                              , italic $ dice 1 D3
                              , text " vigor."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Waking Dead"
          , colour: Name "Green"
          , description: text
              """You infuse necromantic vigor into an ally, scouring their body
              but infusing them with un-life."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text "Mark and reduce an ally to 1 hp, but:"
                  , list Unordered
                      [ text "grant them maximum vigor"
                      , seq
                          [ text "they are "
                          , italic
                              $ ref (Name "Unstoppable")
                              $ text "unstoppable"
                          , text " and gain "
                          , power
                          , text " on attack rolls and saves while marked."
                          ]
                      ]
                  , text "While marked, that ally is "
                  , italic $ ref (Name "Defeated") $ text "defeated"
                  , text
                      """ at the end of their turn. They can remove this mark by
                      defeating a foe."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ seq
                  [ text
                      """Your ally may immediately make a free move when marked.
                      If they are in crisis, they also gain """
                  , italic $ ref (Name "Strength") $ text "strength"
                  , text "."
                  ]
              ]
          }
      ]
  }
