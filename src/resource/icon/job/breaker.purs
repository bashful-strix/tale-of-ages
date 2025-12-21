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
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
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
          , soul: Name "Knight"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """The first in the fight, breakers are a mercenary siege
                  order of mythical strength and reputation. To even join the
                  order, one must perform the Iron Vigil, a ten day training
                  where a recruit is bound into heavy armor and ordered to wear
                  it during all activities - even while sleeping. Wearing this
                  armor, they are pushed to the point of exhaustion, taught to
                  fight, sprint, run, climb, and even swim with it in order to
                  transform the body into a living weapon of war. Once further
                  training is accomplished, breakers don the heavy breaker
                  gauntlet and can blow away all opposition with ease. Even the
                  sturdy gates of castle walls are nothing to them."""
              ]
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
              Name "Implacable"
                : Name "Seeker"
                : Name "Topple"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Shatter on the Ramparts"
          , description:
              [ Text
                  """Once a round, when you push or pull a foe into an
                  obstruction, you may deal damage to them equal to the round
                  number +1."""
              ]
          , subItem: Nothing
          }
      ]

  , talents:
      [ Talent
          { name: Name "Implacable"
          , colour: Name "Red"
          , description:
              [ Text "Each time you dash 1 space, you are "
              , Italic [ Ref (Name "Immune") [ Text "immune" ] ]
              , Text " to all damage and "
              , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
              , Text
                  """ during that movement. This also applies to any dash you
                  grant to an ally."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Seeker"
          , colour: Name "Red"
          , description:
              [ Text
                  """If you start your turn with no foes adjacent, you may dash
                  3, as long as each space of the dash takes you closer to a
                  foe."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Topple"
          , colour: Name "Red"
          , description:
              [ Text
                  """Once a round, when your cause a character or object to
                  impact with another character, you can push the second
                  character 2 spaces and deal 2 damage to them."""
              ]
          , subItem: Nothing
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Gatebreaker"
          , colour: Name "Red"
          , description:
              [ Text
                  """You sprint into a mighty charge, blowing away all opposing
                  forces."""
              ]
          , cost: Two /\ 3
          , tags: [ Close, AreaTag (Line 5) ]
          , steps:
              [ Step Nothing $ Eff
                  [ Text "Move along the line with "
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text
                      """ until you would enter the space of a character, then
                      stop moving."""
                  , List Unordered
                      [ [ Text
                            """You may enter the spaces of objects during this
                            movement without stopping, and destroy and remove
                            them if you do."""
                        ]
                      , [ Text
                            """If you would enter the space of a character, that
                            character must save. They take """
                        , Dice 2 D6
                        , Text
                            """ damage on a failed save, half damage on a
                            successful save, and are pushed the number of spaces
                            you moved before entering their space."""
                        ]
                      ]
                  ]
              , Step Nothing $ KeywordStep (Name "Impact")
                  [ Text
                      """Character takes damage equal to twice the spaces you
                      moved and is """
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Brazen Blow"
          , colour: Name "Red"
          , description: [ Text "Leave your enemies reeling." ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Nothing $ AttackStep
                  [ Text "1 damage" ]
                  [ Text "+", Dice 1 D6 ]
              , Step (Just D6) $ OnHit
                  [ Text "Push your target one, (4+) two, or (6+) four spaces."
                  ]
              , Step Nothing $ KeywordStep (Name "Impact")
                  [ Text
                      """Deal damage to your foe equal to the number of spaces
                      they were pushed before impact (max +6)."""
                  ]
              ]
          }
      , Ability
          { name: Name "Land Waster"
          , colour: Name "Red"
          , description:
              [ Text
                  """Crash your weapon into the earth, sending up devastating
                  shockwaves."""
              ]
          , cost: Two
          , tags: [ Close, AreaTag (Blast 3) ]
          , steps:
              [ Step (Just D6) $ AreaEff
                  [ Dice 1 D6
                  , Text "+2 damage, then push 1 or (4+) 2 spaces."
                  ]
              , Step Nothing $ Eff
                  [ Italic [ Ref (Name "Afflicted") [ Text "Afflicted" ] ]
                  , Text
                      """ characters take +2 damage and are pushed +2 more
                      spaces."""
                  ]
              , Step Nothing $ KeywordStep (Name "Impact")
                  [ Text "Foes are "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Valiant"
          , colour: Name "Red"
          , description: [ Text "Stride forth, battering aside foes." ]
          , cost: One
          , tags: []
          , steps:
              [ Step (Just D6) $ Eff
                  [ Text
                      "Dash 1, then dash 1, (4+), then dash 1 (6+) then dash 1."
                  ]
              , Step Nothing $ Eff
                  [ Text "Before each dash, push all adjacent characters 1." ]
              , Step Nothing $ KeywordStep (Name "Impact")
                  [ Text "Refund the action cost of this ability." ]
              ]
          }
      , Ability
          { name: Name "Battering Ram"
          , colour: Name "Red"
          , description:
              [ Text
                  """You let your momentum carry you onwards from foe to foe in
                  an unstoppable charge."""
              ]
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Stance")
                  [ Text
                      """Once a round, after you push a character, you may dash
                      the same number of spaces as you pushed them as long as
                      each space of the dash ends closer to them than you
                      started. You are """
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text ", immune to all damage, and gain "
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text
                      """ while dashing this way. When you phase through a
                      character, you can push them 1. When you phase through an
                      object, you can destroy that object, removing it."""
                  ]
              , Step Nothing $ KeywordStep (Name "Impact")
                  [ Text "May trigger twice a round." ]
              ]
          }
      ]
  }
