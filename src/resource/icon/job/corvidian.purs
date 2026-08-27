module ToA.Resource.Icon.Job.Corvidian
  ( corvidian
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
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

corvidian :: Icon
corvidian =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Corvidian"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--raven]"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description: seq
              [ text
                  """Also known as Raven Knights, the Corvidian orders are an
                  ill-reputed Churner organization that are known primarily for
                  being traveling peddlers and battlefield scavengers. Once the
                  fighting is over, be it between monsters or kin, they descend
                  on the battlefield with their black, tattered cloaks, and
                  leaving strapped with pouches full of loot."""
              , newline
              , newline
              , text
                  """Despite their dismal reputation, many of them operate as
                  vital lifelines to local communities impacted by war, blights,
                  or monster activity, acting as fences and suppliers when
                  nobody else will dare brave a conflict area."""
              ]
          , trait: Name "Way of the Crow"
          , keyword: Name "Finishing Blow"
          , abilities:
              (I /\ Name "Demoralize")
                : (I /\ Name "Kidney Shot")
                : (II /\ Name "Intimidate")
                : (IV /\ Name "Execute")
                : empty
          , limitBreak: Name "Bloodbath"
          , talents:
              Id "cruelty|talent|corvidian"
                : Id "mortality|talent|corvidian"
                : Id "camraderie|talent|corvidian"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Way of the Crow"
          , description: seq
              [ text
                  """Before you attack a foe, you may consume a negative status
                  token on your foe to deal +2 damage on hit. You may consume 3
                  negative statuses to also grant the attack """
              , italic $ ref (Name "Pierce") $ text "piercing"
              , text
                  """. If an attack powered up this way defeats your foe, clear
                  a negative status on yourself, then gain """
              , italic $ ref (Name "Shield") $ text "shield"
              , text "."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "cruelty|talent|corvidian"
          , name: Name "Cruelty"
          , colour: Name "Red"
          , description: seq
              [ text "Your attacks gain attack "
              , power
              , text " and damage "
              , power
              , text " against characters in crisis."
              ]
          }
      , Talent
          { id: Id "mortality|talent|corvidian"
          , name: Name "Mortality"
          , colour: Name "Red"
          , description: text
              """Foes in crisis treat you and all allies adjacent to you as
              having +1 armor."""
          }
      , Talent
          { id: Id "camraderie|talent|corvidian"
          , name: Name "Camraderie"
          , colour: Name "Red"
          , description: seq
              [ text "When you "
              , italic $ ref (Name "Rescue") $ text "rescue"
              , text " an ally, you and that ally gain "
              , italic $ ref (Name "Shield") $ text "shield"
              , text " and "
              , dice 1 D3
              , text "+1 "
              , italic $ ref (Name "Vigor") $ text "vigor"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Bloodbath"
          , colour: Name "Red"
          , description: text
              """Your skill at looting corpses has given you more than quick
              fingers - it has given you an intimate knowledge of both killing
              implements and where best to poke them."""
          , cost: One /\ 3
          , tags: [ KeywordTag (Name "Aura"), KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text "While in this stance, gain aura 1."
                  , list Unordered
                      [ text
                          """All foes in the aura count as bloodied, and
                          bloodied foes count as being in crisis."""
                      , seq
                          [ text
                              """The first time in a round a foe is defeated in
                              the aura, yourself and allies in the aura gain """
                          , dice 1 D3
                          , text " vigor and clear a negative status."
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Demoralize"
          , colour: Name "Red"
          , description: text
              """You strike down their strongest and best, driving them to their
              inevitable end."""
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step (KeywordStep (Name "Finishing Blow")) (Just D3) $ seq
                  [ text
                      """Release a burst 1 (self) area effect, pushing all foes
                      inside 1. If your foe is in crisis, push +"""
                  , dice 1 D3
                  , text "."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """If your attack defeats your foe, all foes in the area
                      become """
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Kidney Shot"
          , colour: Name "Red"
          , description: text "Fighting fair never got anyone anywhere."
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "An adjacent foe must save. They are "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text
                      """ and pushed 1. On a failed save, they then increase a
                      negative status of your choice by +1."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ seq
                  [ text
                      """Foe fails the save. If they are in crisis, they
                      increase """
                  , italic $ text "all"
                  , text " their negative statuses by +1."
                  ]
              ]
          }
      , Ability
          { name: Name "Intimidate"
          , colour: Name "Red"
          , description: text
              """You lock eyes with a foe, letting them know the fate that will
              befall them if they come in your reach."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 3) (NumVar 5))
              , End
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and mark a foe in range. While marked, that foe gains
                      attack """
                  , weakness
                  , text
                      """ against you and adjacent allies. If you start your
                      turn adjacent to your marked foe, that foe must save. They
                      take """
                  , dice 1 D6
                  , text
                      """+4 damage, or half as much on a successful save. Then
                      end the mark. The mark otherwise remains active."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ seq
                  [ text "Foe is also "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text " on a failed save."
                  ]
              ]
          }
      , Ability
          { name: Name "Execute"
          , colour: Name "Red"
          , description: text "Finish them."
          , cost: One
          , tags: [ End ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ bold $ text "End your turn"
                      , text " and gain "
                      , italic $ ref (Name "Sturdy") $ text "sturdy"
                      , text
                          """. Gain the following interrupt until the end of
                          your next turn."""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Cut Down"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "You hit an attack, and the attack resolves."
                          , Step Eff (Just D6) $ seq
                              [ text
                                  """Roll the effect die. If your foe's HP is
                                  under the effect die, they are instantly
                                  defeated, ignoring all other effects. Then
                                  gain """
                              , italic $ ref (Name "Shield") $ text "shield"
                              , text
                                  """, and vigor equal to the effect die if you
                                  defeated your foe this way. Otherwise this has
                                  no effect."""
                              ]
                          , Step (KeywordStep (Name "Afflicted")) Nothing $ seq
                              [ text "If your foe is afflicted, gain effect "
                              , power
                              , text ", or "
                              , power
                              , power
                              , text
                                  """ if they have 3 or more negative status
                                  tokens of any kind."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
