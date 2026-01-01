module ToA.Resource.Icon.Job.Tactician
  ( tactician
  ) where

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

tactician :: Icon
tactician =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Tactician"
          , colour: Name "Red"
          , soul: Name "Knight"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Veterans, advisors, and upstart geniuses, tacticians wield
                  their understanding of battle like a well balanced blade.
                  The hammering of metal on metal and cries of men and horses
                  beat like a drum for them, an instrument that they have
                  learned to play deftly and with keen precision. The few that
                  become known by this moniker generally go on to become
                  generals of incredible repute, and are well sought after by
                  the city guilds."""
              , Newline
              , Newline
              , Text
                  """They are a relatively new sight in Arden Eld, which has
                  seen little need for warfare until the current era."""
              ]
          , trait: Name "Press the Fight"
          , keyword: Name "Crisis"
          , abilities:
              (I /\ Name "Pincer Attack")
                : (I /\ Name "Bait and Switch")
                : (II /\ Name "Hold the Center")
                : (IV /\ Name "Mighty Standard")
                : empty
          , limitBreak: Name "Mighty Command"
          , talents:
              Name "Mastermind"
                : Name "Spur"
                : Name "Fieldwork"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Press the Fight"
          , description:
              [ Text
                  """Once a round, after you push, pull or swap any character,
                  you may allow an ally in range 1-3 to dash spaces equal to the
                  round number + 1. If your ally was in """
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text ", they may also gain "
              , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
              , Text " equal to the distance dashed."
              ]
          }
      ]
  , talents:
      [ Talent
          { name: Name "Mastermind"
          , colour: Name "Red"
          , description:
              [ Text
                  """Increase all pushes and pulls against bloodied characters
                  by 1, or +2 if they are in """
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text "."
              ]
          }
      , Talent
          { name: Name "Spur"
          , colour: Name "Red"
          , description:
              [ Text
                  """Once a round, when an ally starts their turn in range 1-3,
                  you may push or pull them 2 spaces, or 4 if they're in """
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text "."
              ]
          }
      , Talent
          { name: Name "Fieldwork"
          , colour: Name "Red"
          , description:
              [ Text
                  """Once a round, when you swap places with a character, either
                  deal 2 damage to them or grant them 2 vigor. Double these
                  effects if they're in """
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text "."
              ]
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Mighty Command"
          , colour: Name "Red"
          , description:
              [ Text
                  """You issue an earth shattering command, breaking enemy
                  morale and driving your allies on."""
              ]
          , cost: One /\ 2
          , tags: [ TargetTag Ally, TargetTag Foe ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Every other character on the battlefield, regardless of
                      range and line of sight is pushed or pulled 1 space in any
                      direction of your choice. You may move them in any order,
                      and may choose different directions for each character."""
                  ]
              , Step Eff Nothing
                  [ Text "Bloodied characters or pushed +2 spaces." ]
              , Step Eff Nothing
                  [ Text "Foes in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text " are additionally "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Pincer Attack"
          , colour: Name "Red"
          , description:
              [ Text
                  """Your weapon finds every weakness, driving your foe straight
                  into your waiting ally."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "1 damage" ] [ Text "+", Dice 1 D3 ]
              , Step OnHit Nothing
                  [ Text
                      """Push 1. If your foe would be pushed into an ally's
                      space, that ally deals 2 """
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage to that foe and gains "
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text
                      ". Double these effects if your ally or you target is in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Bait and Switch"
          , colour: Name "Red"
          , description:
              [ Text
                  """You lay a trap for your foe, striking when they overextend
                  themselves."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)), TargetTag Ally ]
          , steps:
              [ Step Eff Nothing [ Text "Swap places with an ally in range." ]
              , Step Eff Nothing
                  [ Text
                      """If your ally was adjacent to at least one foe, you may
                      then deal 2 damage to one of those foes after swapping
                      and """
                  , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
                  , Text " them."
                  ]
              ]
          }
      , Ability
          { name: Name "Hold the Center"
          , colour: Name "Red"
          , description:
              [ Text
                  """You brace with a shield or armor, strengthening your
                  formation against incoming blows."""
              ]
          , cost: Interrupt (NumVar 1)
          , tags: [ TargetTag Ally, RangeTag Adjacent ]
          , steps:
              [ Step TriggerStep Nothing
                  [ Text "An adjacent ally is damaged." ]
              , Step Eff (Just D6)
                  [ Text
                      """Reduce that damage by the number of adjacent allies to
                      you, then push all adjacent foes 1, (4+) two, or (6+) four
                      spaces."""
                  ]
              , Step Eff Nothing
                  [ Text "If that ally was in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text " double damage reduction and push."
                  ]
              ]
          }
      , Ability
          { name: Name "Mighty Standard"
          , colour: Name "Red"
          , description:
              [ Text
                  """You place your banner, striking fear into the hearts of
                  your foes."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              , End
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text " and designate a blast 3 "
                  , Italic [ Ref (Name "Zone") [ Text "zone" ] ]
                  , Text
                      """ with at least one space in range, which could overlap
                      characters. Allies that end their turn inside the zone
                      gain """
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text ". If they are in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text
                      ", they also gain +1 armor while inside the zone."
                  ]
              , Step Eff (Just D3)
                  [ Text
                      "While inside the zone, you can pick up the banner as a "
                  , Bold [ Text "quick" ]
                  , Text
                      """ ability and swing it, pushing all other characters
                      inside """
                  , Italic [ Dice 1 D3 ]
                  , Text ", but removing the zone. Foes pushed are "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text "."
                  ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
