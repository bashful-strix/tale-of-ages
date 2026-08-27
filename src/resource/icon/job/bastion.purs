module ToA.Resource.Icon.Job.Bastion
  ( bastion
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
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
  , newline
  , power
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
          , sign: Sign "icon-[game-icons--rosa-shield]"
          , soul: Name "Knight"
          , class: Name "Stalwart"
          , description: text
              """The Bastions are the shield lords of Arden Eld, wandering
              knights and larger then life figures that tread the ancient
              imperial roads with their heads held high and armor gleaming. From
              town to town they act as errant knights and mercenaries,
              protecting the weak and vulnerable, and driving back the Blights
              with hammer-like blows from their weapons and great-shields. The
              imperious and mighty presence of a Bastion in town is a
              stabilizing force and can become an event for a whole village. All
              Bastions follow an ancient and long-forgotten hero’s code, an old
              oath to stand against chaos in all its forms. The names of the
              Bastions are recorded in the White Peak Citadel on the Eastern
              frontier, and they are interred there in their armor when they pass
              from this life."""
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
              Id "perseus|talent|bastion"
                : Id "supernova|talent|bastion"
                : Id "presence|talent|bastion"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Endless Battlement"
          , description: seq
              [ text "Once a round, you may dash 3 at the start or end of "
              , italic $ text "any"
              , text " allied turn. You are "
              , italic $ ref (Name "Unstoppable") $ text "unstoppable"
              , text " and immune to all damage while moving this way."
              , newline
              , bold $ text "Overdrive"
              , text ": Twice a round."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "perseus|talent|bastion"
          , name: Name "Perseus"
          , colour: Name "Red"
          , description: text
              """You are immune to damage from allied area effects. Allied area
              effects that include you as a target deal +1 area damage."""
          }
      , Talent
          { id: Id "supernova|talent|bastion"
          , name: Name "Supernova"
          , colour: Name "Red"
          , description: text
              """Count the current round number as 1 higher for the rest of
              combat after any ally is defeated."""
          }
      , Talent
          { id: Id "presence|talent|bastion"
          , name: Name "Presence"
          , colour: Name "Red"
          , description: seq
              [ text "Your abilities with the aura tag gain "
              , bold $ text "Overdrive"
              , text ": increase aura size by +1."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Perfect Parry"
          , colour: Name "Red"
          , description: text
              """Even the strongest of blows glances off a bastion in their
              full glory."""
          , cost: Interrupt (NumVar 1) /\ 3
          , tags: [ TargetTag Self, TargetTag Ally ]
          , steps:
              [ Step TriggerStep Nothing $ text
                  "You or an adjacent ally takes damage from a foe's ability."
              , Step Eff (Just D6) $ seq
                  [ text "Roll "
                  , italic $ dice 1 D6
                  , text "."
                  , list Unordered
                      [ text "Reduce the damage by half."
                      , seq
                          [ text
                              """If you roll equal to or under the round number,
                              the damage additionally cannot reduce its target
                              below 1 hp. The triggering foe then gains """
                          , italic $ dice 1 D3
                          , text " "
                          , italic $ ref (Name "Daze") $ text "dazed"
                          , text " and is pushed "
                          , italic $ dice 1 D3
                          , text " spaces."
                          ]
                      , seq
                          [ text "If you roll "
                          , italic $ text "exactly"
                          , text
                              """ the round number, deal half the amount of
                              damage as the triggering ability to your foe."""
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing $ text
                  "If you roll exactly the round number, deal the full damage."
              ]
          }
      , Ability
          { name: Name "Heracule"
          , colour: Name "Red"
          , description: text
              "Hurl your shield or weapon as a discus with irrepressible force."
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step OnHit (Just D6) $ text
                  """Your attack target and one other (4+) two other, (6+) all
                  foes in range are pushed 1."""
              , Step (KeywordStep (Name "Overdrive")) Nothing $ seq
                  [ text "Increase max range and push by +2 and gains damage "
                  , power
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Catapult"
          , colour: Name "Red"
          , description: text
              "Use your body as a springboard to set up ally maneuvers."
          , cost: Interrupt (NumVar 1)
          , tags: [ KeywordTag (Name "Push"), TargetTag Ally ]
          , steps:
              [ Step TriggerStep Nothing $ text
                  "An ally ends their movement in an adjacent space."
              , Step Eff (Just D6) $ seq
                  [ text
                      """Push that ally 2 or (5+) 3 spaces. If they would end
                      this push adjacent to a foe, that foe is """
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing $ text
                  "Gains interrupt 2."
              ]
          }
      , Ability
          { name: Name "Implacable Shield"
          , colour: Name "Red"
          , description: text
              """You stand tall and proud, sheltering your allies from fierce
              blows."""
          , cost: One
          , tags: [ End, KeywordTag (Name "Aura"), TargetTag Self ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ text "Gain "
                      , italic $ ref (Name "Shield") $ text "shield"
                      , text
                          """, aura 1, and the following interrupt until the
                          start of your next turn:"""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Shield Block"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              """An ally in the aura is targeted by a foe's
                              ability that deals damage."""
                          , Step Eff (Just D6) $ text
                              """You take the damage and effects your ally
                              would have took in your ally's place. You take
                              only those effects and don't otherwise
                              re-target or affect other parts of the
                              ability. Then, you regain this interrupt on a
                              (5+)."""
                          ]
                      }
              , Step (KeywordStep (Name "Overdrive")) Nothing $ text
                  "Effect chance becomes 3+."
              ]
          }
      , Ability
          { name: Name "Entrench"
          , colour: Name "Red"
          , description: text
              """You become an immovable object, stern and powerful, like a
              towering citadel."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Stance")
              , KeywordTag (Name "Aura")
              , TargetTag Self
              ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text "While in this stance:"
                  , list Unordered
                      [ seq
                          [ text "During your turn, you are "
                          , italic $ ref (Name "Immobile") $ text "immobile"
                          , text "."
                          ]
                      , text "You are immune to involuntary movement."
                      , seq
                          [ text "You can be used as a "
                          , italic $ ref (Name "Cover") $ text "cover"
                          , text " object by adjacent allies."
                          ]
                      , seq
                          [ text
                              """Gain aura 1. Any foe that voluntarily enters
                              the aura from the outside takes """
                          , dice 1 D6
                          , text
                              """ damage and is pushed 1, interrupting but not
                              ending movement. A foe can't trigger this effect
                              more than once a turn."""
                          ]
                      ]
                  ]
              , Step Eff Nothing $ seq
                  [ text "If you are in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text
                      """, also gain +1 armor in this stance and increase aura
                      size by +1."""
                  ]
              ]
          }
      ]
  }
