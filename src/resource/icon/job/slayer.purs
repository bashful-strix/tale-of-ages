module ToA.Resource.Icon.Job.Slayer
  ( slayer
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
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Markup (bold, dice, italic, ref, seq, text, weakness)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))

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
          , sign: Sign "icon-[game-icons--fragmented-sword]"
          , soul: Name "Warrior"
          , class: Name "Stalwart"
          , description: text
              """Warriors of impossible strength and insane bravado, Slayers are
              warriors that specialize in fighting the largest and most
              dangerous monsters to crawl out of the pits that riddle the land.
              They relish in fighting against impossible odds, training
              themselves in forbidden techniques, arcane arts, and oversized
              weaponry that normal Kin would quake at wielding. They organize
              themselves into loose orders and train and hunt together, sharing
              tales and trophies of the colossal horrors they have slain. Some
              say in order to fight their quarries, the Slayers must ingest
              monster blood to gain their strength, giving them dark and
              forbidden power that makes other Kin fear and respect them in
              equal measure."""
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
              Id "bulk|talent|slayer"
                : Id "hale|talent|slayer"
                : Id "deflect|talent|slayer"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Hot Blooded"
          , description: seq
              [ text "If you don't attack during your turn, gain 3 vigor, or "
              , dice 3 D3
              , text " if you're in "
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text ". While at maximum vigor, you are "
              , italic $ ref (Name "Unstoppable") $ text "unstoppable"
              , text ", and effects cannot prevent you from attacking."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "bulk|talent|slayer"
          , name: Name "Bulk"
          , colour: Name "Red"
          , description: text
              "While at maximum vigor, you are immune to involuntary movement."
          }
      , Talent
          { id: Id "hale|talent|slayer"
          , name: Name "Hale"
          , colour: Name "Red"
          , description: seq
              [ text "The first time in combat you enter "
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text ", after the triggering damage in applied, you gain "
              , dice 1 D6
              , text "+2 "
              , italic $ text "vigor"
              , text "."
              ]
          }
      , Talent
          { id: Id "deflect|talent|slayer"
          , name: Name "Deflect"
          , colour: Name "Red"
          , description: seq
              [ text
                  """When you or an adjacent ally is damaged by an ability, you
                  may spend the """
              , italic $ ref (Name "Sturdy") $ text "sturdy"
              , text ", "
              , italic $ ref (Name "Unstoppable") $ text "unstoppable"
              , text ", or "
              , italic $ ref (Name "Shield") $ text "shield"
              , text " effect on yourself to grant them "
              , dice 1 D3
              , text
                  """ armor against the damage. If you do, you can't gain or
                  benefit from any of these effects until the start of your next
                  turn."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "God Waster"
          , colour: Name "Red"
          , description: text
              """Sever Divinity and cut through the threads of possibility. Pour
              all your rage into one blow and topple the Gods."""
          , cost: Two /\ 4
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 6)) ]
          , steps:
              [ AttackStep (text "[Vigor] damage") $ seq [ text "+", dice 2 D6 ]
              , Step AreaEff Nothing $ text "[Vigor] damage."
              , Step (KeywordStep (Name "Heavy")) Nothing $ seq
                  [ text "Gain "
                  , dice 4 D3
                  , text " vigor before the attack and pushes 4 on hit."
                  ]
              , Step Eff Nothing $ text
                  """Then burn out and lose all your vigor. You cannot gain
                  vigor for the rest of combat."""
              , Step Eff Nothing $ text
                  """If you miss this attack, ignore the last effect and refund
                  2 resolve. You can limit break again this combat."""
              ]
          }
      , Ability
          { name: Name "Demon Splitter"
          , colour: Name "Red"
          , description: text
              """Swing your weapon with enough force to cut even the most
              tenebrous of foes."""
          , cost: Two
          , tags: [ Attack, RangeTag Close, AreaTag (Line (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing $ text "Dash 1."
              , AttackStep (text "2 damage") $ seq [ text "+", dice 2 D6 ]
              , Step AreaEff Nothing $ text "2 damage."
              , Step (KeywordStep (Name "Heavy")) Nothing $ seq
                  [ weakness
                  , text " on attack, Line +3, +3 base damage and area damage."
                  ]
              ]
          }
      , Ability
          { name: Name "Barge"
          , colour: Name "Red"
          , description: text
              "Even when winding up a massive attack, you are a menacing force."
          , cost: One
          , tags: [ TargetTag Self ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ text "Gain "
                      , italic $ ref (Name "Sturdy") $ text "sturdy"
                      , text
                          """ and the following interrupt until the start of
                          your next turn."""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Shoulder Check"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "A foe in range 1-2 damages you or an ally."
                          , Step Eff Nothing $ seq
                              [ text "The foe must save. They are "
                              , italic $ ref (Name "Daze") $ text "dazed"
                              , text
                                  """ and pushed 1 after the triggering ability
                                  resolves. On a failed save the triggering
                                  damage is also reduced by 1/2."""
                              ]
                          , Step (KeywordStep (Name "Heavy")) Nothing $ seq
                              [ text "You may dash up to 3 spaces with "
                              , italic
                                  $ ref (Name "Unstoppable")
                                  $ text "unstoppable"
                              , text
                                  """ before triggering this ability. On a
                                  failed save, your foe also doubles """
                              , italic $ ref (Name "Daze") $ text "daze"
                              , text " and push."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Bravado"
          , colour: Name "Red"
          , description: text
              """You throw your arms wide and let your enemies know how little
              you care."""
          , cost: One
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Gain "
                  , italic $ ref (Name "Shield") $ text "shield"
                  , text "."
                  ]
              , Step Eff Nothing $ seq
                  [ text "At the start of your next turn, you gain "
                  , dice 4 D3
                  , text
                      """ vigor. The first time each turn an enemy damages you
                      with an ability before then, you must save or lose this
                      effect and immediately gain 2 vigor instead."""
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ seq
                  [ text "You are "
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text " until this effect expires."
                  ]
              ]
          }
      , Ability
          { name: Name "Jotunn Crusher"
          , colour: Name "Red"
          , description: text
              """Your blows are strong enough to topple even titanic foes.
              Normal opponents stand no chance."""
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Blast (NumVar 2)), End ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ bold $ text "End your turn"
                      , text ", target a close blast 2 area, gain, "
                      , italic $ ref (Name "Sturdy") $ text "sturdy"
                      , text
                          """, and gain the following interrupt until the start
                          of your next turn. If you move, the targeted area
                          moves with you, mirroring your movement."""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Crusher Release"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "A foe starts or ends their turn in the area."
                          , Step AreaEff Nothing $ seq
                              [ text
                                  """At the end of the triggering turn, you
                                  release your blow. Move the area six spaces in
                                  a straight line away from you. Foes caught in
                                  the area must save. They take """
                              , dice 1 D6
                              , text
                                  """+4 damage, or half as much on a successful
                                  save, and are pushed 1. The targeted foe takes
                                  triple damage and is """
                              , italic $ ref (Name "Stun") $ text "stunned"
                              , text " if they are caught in the area."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Interrupt deals +4 more damage."
              ]
          }
      ]
  }
