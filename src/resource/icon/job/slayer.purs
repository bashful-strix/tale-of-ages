module ToA.Resource.Icon.Job.Slayer
  ( slayer
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
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

slayer :: Icon
slayer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Slayer"
          , colour: Name "Red"
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Warriors of impossible strength and insane bravado, Slayers
                  are warriors that specialize in fighting the largest and most
                  dangerous monsters to crawl out of the pits that riddle the
                  land. They relish in fighting against impossible odds,
                  training themselves in forbidden techniques, arcane arts, and
                  oversized weaponry that normal Kin would quake at wielding.
                  They organize themselves into loose orders and train and hunt
                  together, sharing tales and trophies of the colossal horrors
                  they have slain. Some say in order to fight their quarries,
                  the Slayers must ingest monster blood to gain their strength,
                  giving them dark and forbidden power that makes other Kin fear
                  and respect them in equal measure."""
              ]
          , trait: Name "Hot Blooded"
          , keyword: Name "Heavy"
          , abilities:
              (I /\ Name "Demon Splitter")
                : (I /\ Name "Barge")
                : (II /\ Name "Bravado")
                : (IV /\ Name "Jotunn Crusher")
                : empty
          , limitBreak: Name "God Waster"
          , talents:
              Name "Bulk"
                : Name "Hale"
                : Name "Deflect"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Hot Blooded"
          , description:
              [ Text "If you don't attack during your turn, gain 3 vigor, or "
              , Dice 3 D3
              , Text " if you're in "
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text ". While at maximum vigor, you are "
              , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
              , Text ", and effects cannot prevent you from attacking."
              ]
          , subItem: Nothing
          }
      ]

  , talents:
      [ Talent
          { name: Name "Bulk"
          , colour: Name "Red"
          , description:
              [ Text
                  """While at maximum vigor, you are immune to involuntary
                  movement."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Hale"
          , colour: Name "Red"
          , description:
              [ Text "The first time in combat you enter "
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text ", after the triggering damage in applied, you gain "
              , Dice 1 D6
              , Text "+2 "
              , Italic [ Text "vigor" ]
              , Text "."
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Deflect"
          , colour: Name "Red"
          , description:
              [ Text
                  """When you or an adjacent ally is damaged by an ability, you
                  may spend the """
              , Italic [ Ref (Name "Sturdy") [ Text "sturdy" ] ]
              , Text ", "
              , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
              , Text ", or "
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text " effect on yourself to grant them "
              , Dice 1 D3
              , Text
                  """ armor against the damage. If you do, you can't gain or
                  benefit from any of these effects until the start of your next
                  turn."""
              ]
          , subItem: Nothing
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "God Waster"
          , colour: Name "Red"
          , description:
              [ Text
                  """Sever Divinity and cut through the threads of possibility.
                  Pour all your rage into one blow and topple the Gods."""
              ]
          , cost: Two /\ 4
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep [ Text "[Vigor] damage" ] [ Text "+", Dice 2 D6 ]
              , Step AreaEff Nothing [ Text "[Vigor] damage." ]
              , Step (KeywordStep (Name "Heavy")) Nothing
                  [ Text "Gain "
                  , Dice 4 D3
                  , Text " vigor before the attack and pushes 4 on hit."
                  ]
              , Step Eff Nothing
                  [ Text
                      """Then burn out and lose all your vigor. You cannot gain
                      vigor for the rest of combat."""
                  ]
              , Step Eff Nothing
                  [ Text
                      """If you miss htis attack, ignore the last effect and
                      refund 2 resolve. You can limit break again this
                      combat."""
                  ]
              ]
          }
      , Ability
          { name: Name "Demon Splitter"
          , colour: Name "Red"
          , description:
              [ Text
                  """Swing your weapon with enough force to cut even the most
                  tenebrous of foes."""
              ]
          , cost: Two
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 1." ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 2 D6 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step (KeywordStep (Name "Heavy")) Nothing
                  [ Weakness
                  , Text " on attack, Line +3, +3 base damage and area damage."
                  ]
              ]
          }
      , Ability
          { name: Name "Barge"
          , colour: Name "Red"
          , description:
              [ Text
                  """Even when winding up a massive attack, you are a menacing
                  force."""
              ]
          , cost: One
          , tags: [ TargetTag Self ]
          , steps:
              [ SubStep Eff Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Sturdy") [ Text "sturdy" ] ]
                  , Text
                      """ and the following interrupt until the start of your
                      next turn."""
                  ]
                  $ AbilityItem
                      { name: Name "Shoulder Check"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "A foe in range 1-2 damage you or an ally."
                              ]
                          , Step Eff Nothing
                              [ Text "The foe must save. They are "
                              , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                              , Text
                                  """ and pushed 1 after the triggering ability
                                  resolves. On a failed save the triggering
                                  damage is also reduced by 1/2."""
                              ]
                          , Step (KeywordStep (Name "Heavy")) Nothing
                              [ Text "You may dash up to 3 spaces with "
                              , Italic
                                  [ Ref
                                      (Name "Unstoppable")
                                      [ Text "unstoppable" ]
                                  ]
                              , Text
                                  """ before triggering this ability. On a
                                  failed dave, your foe also doubles """
                              , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
                              , Text " and push."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Bravado"
          , colour: Name "Red"
          , description:
              [ Text
                  """You throw your arms wide and let your enemies know how
                  little you care."""
              ]
          , cost: One
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text "."
                  ]
              , Step Eff Nothing
                  [ Text "At the start of your next turn, you gain "
                  , Dice 4 D3
                  , Text
                      """ vigor. The first time each turn an enemy damages you
                      with an ability before then, you must save or lose this
                      effect and immediately gain 2 vigor instead."""
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing
                  [ Text "You are "
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text " until this effect expires."
                  ]
              ]
          }
      , Ability
          { name: Name "Jotunn Crusher"
          , colour: Name "Red"
          , description:
              [ Text
                  """Your blows are strong enough to topple even titanic foes.
                  Normal opponents stand no chance."""
              ]
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Blast (NumVar 2)), End ]
          , steps:
              [ SubStep Eff Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text ", target a close blast 2 area, gain, "
                  , Italic [ Ref (Name "Sturdy") [ Text "sturdy" ] ]
                  , Text
                      """, and gain the following interrupt until the start of
                      your next turn. If you move, the targeted area moves with
                      you, mirroring your movement."""
                  ]
                  $ AbilityItem
                      { name: Name "Crusher Release"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  "A foe starts or ends their turn in the area."
                              ]
                          , Step AreaEff Nothing
                              [ Text
                                  """At the end of the triggering turn, you
                                  release your blow. Move the area six spaces in
                                  a straight line away from you. Foes caught in
                                  the area must save. They take """
                              , Dice 1 D6
                              , Text
                                  """+4 damage, or half as much on a successful
                                  save, and are pushed 1. The targeted foe takes
                                  triple damage and is """
                              , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                              , Text " if they are caught in the area."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Heavy")) Nothing
                  [ Text "Interrup deals +4 more damage." ]
              ]
          }
      ]
  }
