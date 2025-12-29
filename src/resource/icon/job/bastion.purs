module ToA.Resource.Icon.Job.Bastion
  ( bastion
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
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
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

bastion :: Icon
bastion =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Bastion"
          , colour: Name "Red"
          , soul: Name "Knight"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """The Bastions are the shield lords of Arden Eld, wandering
                  knights and larger then life figures that tread the ancient
                  imperial roads with their heads held high and armor gleaming.
                  From town to town they act as errant knights and mercenaries,
                  protecting the weak and vulnerable, and driving back the
                  Blights with hammer-like blows from their weapons and
                  great-shields. The imperious and mighty presence of a Bastion
                  in town is a stabilizing force and can become an event for a
                  whole village. All Bastions follow an ancient and
                  long-forgotten hero’s code, an old oath to stand against chaos
                  in all its forms. The names of the Bastions are recorded in
                  the White Peak Citadel on the Eastern frontier, and they are
                  interred there in their armor when they pass from this
                  life."""
              ]
          , trait: Name "Endless Battlement"
          , keyword: Name "Overdrive"
          , abilities:
              (I /\ Name "Heracule")
                : (I /\ Name "Catapult")
                : (II /\ Name "Implacable Shield")
                : (IV /\ Name "Entrench")
                : empty
          , limitBreak: Name "Perfect Parry"
          , talents:
              Name "Perseus"
                : Name "Supernova"
                : Name "Presence"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Endless Battlement"
          , description:
              [ Text "Once a round, you may dash 3 at the start or end of "
              , Italic [ Text "any" ]
              , Text " allied turn. You are "
              , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
              , Text " and immune to all damage while moving this way."
              , Newline
              , Bold [ Text "Overdrive" ]
              , Text ": Twice a round."
              ]
          , subItem: Nothing
          }
      ]

  , talents:
      [ Talent
          { name: Name "Perseus"
          , colour: Name "Red"
          , description:
              [ Text
                  """You are immune to damage from allied area effects. Allied
                  area effects that include you as a target deal +1 area
                  damage."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Supernova"
          , colour: Name "Red"
          , description:
              [ Text
                  """Count the current round number as 1 higher for the rest of
                  combat after any ally is defeated."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Presence"
          , colour: Name "Red"
          , description:
              [ Text "Your abilities with teh aura tag gain "
              , Bold [ Text "Overdrive" ]
              , Text ": increase aura size by +1."
              ]
          , subItem: Nothing
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Perfect Parry"
          , colour: Name "Red"
          , description:
              [ Text
                  """Even the strongest of blows glances off a bastion in their
                  full glory."""
              ]
          , cost: Interrupt (NumVar 1) /\ 3
          , tags: [ TargetTag Self, TargetTag Ally ]
          , steps:
              [ Step TriggerStep Nothing
                  [ Text
                      """You or an adjacent ally takes damage from a foe's
                      ability."""
                  ]
              , Step Eff (Just D6)
                  [ Text "Roll "
                  , Italic [ Dice 1 D6 ]
                  , Text "."
                  , List Unordered
                      [ [ Text "Reduce the damage by half." ]
                      , [ Text
                            """If you roll equal to or under the round number,
                            the damage additionally cannot reduce its target
                            below 1 hp. The triggering foe then gains """
                        , Italic [ Dice 1 D3 ]
                        , Text " "
                        , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                        , Text " and is pushed "
                        , Italic [ Dice 1 D3 ]
                        , Text " spaces."
                        ]
                      , [ Text "If you roll "
                        , Italic [ Text "exactly" ]
                        , Text
                            """ the round number, deal half the amount of damage
                            as the triggering ability to your foe."""
                        ]
                      ]
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text
                      """If you roll exactly the round number, deal the full
                      damage."""
                  ]
              ]
          }
      , Ability
          { name: Name "Heracule"
          , colour: Name "Red"
          , description:
              [ Text
                  """Hurl your shield or weapon as a discus with irrepressible
                  force."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step OnHit (Just D6)
                  [ Text
                      """Your attack target and one other (4+) two other, (6+)
                      all foes in range are pushed 1."""
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Increase max range and push by +2 and gains damage "
                  , Power
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Catapult"
          , colour: Name "Red"
          , description:
              [ Text "Use your body as a springboard to set up ally maneuvers."
              ]
          , cost: Interrupt (NumVar 1)
          , tags: [ KeywordTag (Name "Push"), TargetTag Ally ]
          , steps:
              [ Step TriggerStep Nothing
                  [ Text "An ally ends their movement in an adjacent space." ]
              , Step Eff (Just D6)
                  [ Text
                      """Push that ally 2 or (5+) 3 spaces. If they would end
                      this push adjacent to a foe, that foe is """
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Gains interrupt 2." ]
              ]
          }
      , Ability
          { name: Name "Implacable Shield"
          , colour: Name "Red"
          , description:
              [ Text
                  """You stand tall and proud, sheltering your allies from
                  fierce blows."""
              ]
          , cost: One
          , tags: [ End, KeywordTag (Name "Aura"), TargetTag Self ]
          , steps:
              [ SubStep Eff Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text
                      """, aura 1, and the following interrupt until the
                      start of your next turn:"""
                  ]
                  $ AbilityItem
                      { name: Name "Shield Block"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  """An ally in the aura is targeted by a foe's
                                  ability that deals damage."""
                              ]
                          , Step Eff (Just D6)
                              [ Text
                                  """You take the damage and effects your ally
                                  would have took in your ally's place. You take
                                  only those effects and don't otherwise
                                  re-target or affect other parts of the
                                  ability. Then, you regain this interrupt on a
                                  (5+)."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Effect chance becomes 3+." ]
              ]
          }
      , Ability
          { name: Name "Entrench"
          , colour: Name "Red"
          , description:
              [ Text
                  """You become an immovable object, stern and powerful, like a
                  towering citadel."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Stance")
              , KeywordTag (Name "Aura")
              , TargetTag Self
              ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Text "While in this stance:"
                  , List Unordered
                      [ [ Text "During your turn, you are "
                        , Italic [ Ref (Name "Immobile") [ Text "immobile" ] ]
                        , Text "."
                        ]
                      , [ Text "You are immune to involuntary movement." ]
                      , [ Text "You can be used as a "
                        , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
                        , Text " object by adjacent allies."
                        ]
                      , [ Text
                            """Gain aura 1. Any foe that voluntarily enters the
                            aura from the outside takes """
                        , Dice 1 D6
                        , Text
                            """ damage and is pushed 1, interrupting by not
                            ending movement. A foe can't trigger this effect
                            more than once a turn."""
                        ]
                      ]
                  ]
              , Step Eff Nothing
                  [ Text "If you are in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text
                      """, also gain +1 armor in this stance and increase aura
                      size by +1."""
                  ]
              ]
          }
      ]
  }
