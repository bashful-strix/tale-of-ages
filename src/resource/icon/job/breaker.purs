module ToA.Resource.Icon.Job.Breaker
  ( breaker
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
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , dice
  , list
  , italic
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

breaker :: Icon
breaker =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Breaker"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--shoulder-armor]"
          , soul: Name "Knight"
          , class: Name "Stalwart"
          , description: text
              """The first in the fight, breakers are a mercenary siege order of
              mythical strength and reputation. To even join the order, one must
              perform the Iron Vigil, a ten day training where a recruit is
              bound into heavy armor and ordered to wear it during all
              activities - even while sleeping. Wearing this armor, they are
              pushed to the point of exhaustion, taught to fight, sprint, run,
              climb, and even swim with it in order to transform the body into a
              living weapon of war. Once further training is accomplished,
              breakers don the heavy breaker gauntlet and can blow away all
              opposition with ease. Even the sturdy gates of castle walls are
              nothing to them."""
          , trait: Name "Shatter on the Ramparts"
          , keyword: Name "Impact"
          , abilities:
              (I /\ Name "Brazen Blow")
                : (I /\ Name "Land Waster")
                : (II /\ Name "Valiant")
                : (IV /\ Name "Battering Ram")
                : empty
          , limitBreak: Name "Gatebreaker"
          , talents:
              Id "implacable|talent|breaker"
                : Id "seeker|talent|breaker"
                : Id "topple|talent|breaker"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Shatter on the Ramparts"
          , description: text
              """Once a round, when you push or pull a foe into an obstruction,
              you may deal damage to them equal to the round number +1."""
          }
      ]

  , talents:
      [ Talent
          { id: Id "implacable|talent|breaker"
          , name: Name "Implacable"
          , colour: Name "Red"
          , description: seq
              [ text "Each time you dash 1 space, you are "
              , italic $ ref (Name "Immune") $ text "immune"
              , text " to all damage and "
              , italic $ ref (Name "Unstoppable") $ text "unstoppable"
              , text
                  """ during that movement. This also applies to any dash you
                  grant to an ally."""
              ]
          }
      , Talent
          { id: Id "seeker|talent|breaker"
          , name: Name "Seeker"
          , colour: Name "Red"
          , description: text
              """If you start your turn with no foes adjacent, you may dash 3,
              as long as each space of the dash takes you closer to a foe."""
          }
      , Talent
          { id: Id "topple|talent|breaker"
          , name: Name "Topple"
          , colour: Name "Red"
          , description: text
              """Once a round, when you cause a character or object to impact
              with another character, you can push the second character 2 spaces
              and deal 2 damage to them."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Gatebreaker"
          , colour: Name "Red"
          , description: text
              """You sprint into a mighty charge, blowing away all opposing
              forces."""
          , cost: Two /\ 3
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 5)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Move along the line with "
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text
                      """ until you would enter the space of a character, then
                      stop moving."""
                  , list Unordered
                      [ text
                          """You may enter the spaces of objects during this
                          movement without stopping, and destroy and remove them
                          if you do."""
                      , seq
                          [ text
                              """If you would enter the space of a character,
                              that character must save. They take """
                          , dice 2 D6
                          , text
                              """ damage on a failed save, half damage on a
                              successful save, and are pushed the number of
                              spaces you moved before entering their space."""
                          ]
                      ]
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing $ seq
                  [ text
                      """Character takes damage equal to twice the spaces you
                      moved and is """
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Brazen Blow"
          , colour: Name "Red"
          , description: text "Leave your enemies reeling."
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "1 damage") (seq [ text "+", dice 1 D6 ])
              , Step OnHit (Just D6) $ text
                  "Push your target one, (4+) two, or (6+) four spaces."
              , Step (KeywordStep (Name "Impact")) Nothing $ text
                  """Deal damage to your foe equal to the number of spaces they
                  were pushed before impact (max +6)."""
              ]
          }
      , Ability
          { name: Name "Land Waster"
          , colour: Name "Red"
          , description: text
              """Crash your weapon into the earth, sending up devastating
              shockwaves."""
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Blast (NumVar 3)) ]
          , steps:
              [ Step AreaEff (Just D6) $ seq
                  [ dice 1 D6
                  , text "+2 damage, then push 1 or (4+) 2 spaces."
                  ]
              , Step Eff Nothing $ seq
                  [ italic $ ref (Name "Afflicted") $ text "Afflicted"
                  , text
                      """ characters take +2 damage and are pushed +2 more
                      spaces."""
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing $ seq
                  [ text "Foes are "
                  , italic $ ref (Name "Daze") $ text "dazed"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Valiant"
          , colour: Name "Red"
          , description: text "Stride forth, battering aside foes."
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6) $ text
                  "Dash 1, then dash 1, (4+), then dash 1 (6+) then dash 1."
              , Step Eff Nothing $ text
                  "Before each dash, push all adjacent characters 1."
              , Step (KeywordStep (Name "Impact")) Nothing $ text
                  "Refund the action cost of this ability."
              ]
          }
      , Ability
          { name: Name "Battering Ram"
          , colour: Name "Red"
          , description: text
              """You let your momentum carry you onwards from foe to foe in an
              unstoppable charge."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text
                      """Once a round, after you push a character, you may dash
                      the same number of spaces as you pushed them as long as
                      each space of the dash ends closer to them than you
                      started. You are """
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text ", immune to all damage, and gain "
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text
                      """ while dashing this way. When you phase through a
                      character, you can push them 1. When you phase through an
                      object, you can destroy that object, removing it."""
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing $ text
                  "May trigger twice a round."
              ]
          }
      ]
  }
