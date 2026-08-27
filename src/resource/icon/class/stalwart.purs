module ToA.Resource.Icon.Class.Stalwart
  ( stalwart
  ) where

import Prelude

import Color (fromInt)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
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
import ToA.Data.Icon.Pc.Class (Class(..))
import ToA.Data.Icon.Pc.Soul (Soul(..))

stalwart :: Icon
stalwart =
  { classes:
      [ Class
          { name: Name "Stalwart"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--swords-emblem]"
          , tagline: text "Weapon master and unparalleled soldier"
          , strengths: text
              """Tough, good at punishing foes, protecting allies, and
              controlling the battlefield"""
          , weaknesses: text "Lower mobility and weak to ranged attackers"
          , complexity: text "Low"
          , description: text
              """Stalwarts are consummate warriors and masters of martial
              prowess. Tough, vigorous, and equally skilled at punishing foes as
              they are protecting allies, they act as an anchor for their teams,
              protecting areas of the battlefield, preventing foes from
              approaching or harming allies, and pushing foes around with their
              immense strength."""
          , hp: 40
          , defense: 3
          , move: 4
          , trait: Name "Rampart"
          , basic: Name "Furor"
          , keywords:
              [ Name "Daze"
              , Name "Immobile"
              , Name "Push"
              , Name "Shield"
              , Name "Stance"
              , Name "Sturdy"
              , Name "Stun"
              , Name "Unstoppable"
              ]
          , apprentice:
              [ Name "Interpose"
              , Name "Impel"
              , Name "Hook"
              , Name "Mighty Hew"
              , Name "Second Wind"
              , Name "Shatter"
              ]
          }
      ]
  , colours: [ Colour { name: Name "Red", value: fromInt 0xe7000b } ] -- red-600
  , souls:
      [ Soul
          { name: Name "Knight"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--winged-sword]"
          , class: Name "Stalwart"
          , description: seq
              [ text
                  """The soul of one affected by strife and embedded with
                  steel."""
              , newline
              , text
                  """An unbending, iron will, and the power to lead from the
                  front."""
              ]
          }
      , Soul
          { name: Name "Warrior"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--axe-sword]"
          , class: Name "Stalwart"
          , description: seq
              [ text "The soul of one who seeks power at all ends."
              , newline
              , text
                  """The will to cut down all before you with impossible
                  strength, and the hand to carry it out."""
              ]
          }
      , Soul
          { name: Name "Berserker"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--fire-silhouette]"
          , class: Name "Stalwart"
          , description: seq
              [ text "The soul of one fueled by a heart of rage."
              , newline
              , text
                  """The terrifying power to fight on even when the body is
                  broken and the blood is boiled away."""
              ]
          }
      , Soul
          { name: Name "Mercenary"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--coins]"
          , class: Name "Stalwart"
          , description: seq
              [ text "The soul of one tempered by suffering and avarice."
              , newline
              , text
                  """The strength to fight on your own terms, to grasp your own
                  fate through the thorns that pierce you."""
              ]
          }
      ]
  , jobs: []
  , traits:
      [ Trait
          { name: Name "Rampart"
          , description: seq
              [ text
                  """You are an imposing sight on the battlefield. Whether
                  through gear, training, or simple toughness, you gain the
                  following benefits:"""
              , newline
              , list Unordered
                  [ text "You have 1 armor"
                  , seq
                      [ text
                          """Once a round, before you or an adjacent ally is
                          targeted by a foe's ability, you may grant that
                          character +"""
                      , dice 1 D3
                      , text " "
                      , italic $ ref (Name "Armor") $ text "armor"
                      , text " against the entire ability"
                      ]
                  , text
                      """Foes must spend +1 movement to exit a space adjacent to
                      you"""
                  ]
              ]
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Furor"
          , colour: Name "Red"
          , description: text "Strike with your heart."
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step OnHit Nothing $ seq
                  [ text "Gain 2 vigor. If you or your target is in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text ", deals damage"
                  , power
                  , text " and double vigor gain."
                  ]
              ]
          }
      , Ability
          { name: Name "Interpose"
          , colour: Name "Red"
          , description: text
              "You are able to step quickly and rapidly in the midst of combat."
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)), TargetTag Ally ]
          , steps:
              [ Step TriggerStep Nothing $ text
                  "An ally ends their turn in range."
              , Step Eff Nothing $ seq
                  [ text
                      """Dash 2. If you end this move adjacent to that ally,
                      they gain """
                  , italic $ ref (Name "Shield") $ text "shield"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Impel"
          , colour: Name "Red"
          , description: text "Hurl headlong into battle."
          , cost: One
          , tags: [ RangeTag Melee, TargetTag Foe ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text "Dash 1, then an adjacent foe is "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text " and pushed 1 (4+) two or (6+) four spaces."
                  ]
              ]
          }
      , Ability
          { name: Name "Hook"
          , colour: Name "Red"
          , description: text
              "You grab an ally and pull them from the teeth of the enemy."
          , cost: Quick
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 3)), TargetTag Ally ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Pull target 1. They are "
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text " and "
                  , italic $ ref (Name "Immune") $ text "immune"
                  , text " to all damage while moving this way."
                  ]
              ]
          }
      , Ability
          { name: Name "Mighty Hew"
          , colour: Name "Red"
          , description: text "Finish them."
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "3 damage") (seq [ text "+", dice 2 D6 ])
              , Step OnHit (Just D6) $ seq
                  [ text "Deal a follow up blow against "
                  , italic $ ref (Name "Afflicted") $ text "afflicted"
                  , text " foes, dealing 2 damage again (5+) and "
                  , italic $ ref (Name "Stun") $ text "stunning"
                  , text " them."
                  ]
              ]
          }
      , Ability
          { name: Name "Second Wind"
          , colour: Name "Red"
          , description: text "You brace and ready yourself for the fray."
          , cost: One
          , tags: [ End, TargetTag Self ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Gain 2 vigor and end a negative status token. If
                      you're in """
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text " increase vigor by +"
                  , dice 1 D6
                  , text "."
                  ]
              , Step Eff Nothing $ seq
                  [ text "Gain "
                  , italic $ ref (Name "Sturdy") $ text "sturdy"
                  , text " or grant it to an adjacent ally. Then "
                  , bold $ text "end your turn"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Shatter"
          , colour: Name "Red"
          , description: text
              "Slam your weapon into the ground, sending up shockwaves."
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Blast (NumVar 3)) ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ dice 1 D6, text "+2 damage, push 1." ]
              , Step Eff Nothing $ text
                  """If you catch three or more characters in the area, increase
                  area damage by +2."""
              , Step Eff Nothing $ seq
                  [ text "One character in the area is "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text "."
                  ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
