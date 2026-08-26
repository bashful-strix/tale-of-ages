module ToA.Resource.Icon.Job.Tactician
  ( tactician
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
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup
  ( bold
  , dice
  , italic
  , newline
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
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
          , sign: Sign "icon-[game-icons--all-for-one]"
          , soul: Name "Knight"
          , class: Name "Stalwart"
          , description: seq
              [ text
                  """Veterans, advisors, and upstart geniuses, tacticians wield
                  their understanding of battle like a well balanced blade.
                  The hammering of metal on metal and cries of men and horses
                  beat like a drum for them, an instrument that they have
                  learned to play deftly and with keen precision. The few that
                  become known by this moniker generally go on to become
                  generals of incredible repute, and are well sought after by
                  the city guilds."""
              , newline
              , newline
              , text
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
              Id "mastermind|talent|tactician"
                : Id "spur|talent|tactician"
                : Id "fieldwork|talent|tactician"
                : empty
          }
      ]
  , traits:
      [ Trait
          { name: Name "Press the Fight"
          , description: seq
              [ text
                  """Once a round, after you push, pull or swap any character,
                  you may allow an ally in range 1-3 to dash spaces equal to the
                  round number + 1. If your ally was in """
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text ", they may also gain "
              , italic $ ref (Name "Vigor") $ text "vigor"
              , text " equal to the distance dashed."
              ]
          }
      ]
  , talents:
      [ Talent
          { id: Id "mastermind|talent|tactician"
          , name: Name "Mastermind"
          , colour: Name "Red"
          , description: seq
              [ text
                  """Increase all pushes and pulls against bloodied characters
                  by 1, or +2 if they are in """
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text "."
              ]
          }
      , Talent
          { id: Id "spur|talent|tactician"
          , name: Name "Spur"
          , colour: Name "Red"
          , description: seq
              [ text
                  """Once a round, when an ally starts their turn in range 1-3,
                  you may push or pull them 2 spaces, or 4 if they're in """
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text "."
              ]
          }
      , Talent
          { id: Id "fieldwork|talent|tactician"
          , name: Name "Fieldwork"
          , colour: Name "Red"
          , description: seq
              [ text
                  """Once a round, when you swap places with a character, either
                  deal 2 damage to them or grant them 2 vigor. Double these
                  effects if they're in """
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text "."
              ]
          }
      ]
  , abilities:
      [ LimitBreak
          { name: Name "Mighty Command"
          , colour: Name "Red"
          , description: text
              """You issue an earth shattering command, breaking enemy morale
              and driving your allies on."""
          , cost: One /\ 2
          , tags: [ TargetTag Ally, TargetTag Foe ]
          , steps:
              [ Step Eff Nothing $ text
                  """Every other character on the battlefield, regardless of
                  range and line of sight is pushed or pulled 1 space in any
                  direction of your choice. You may move them in any order, and
                  may choose different directions for each character."""
              , Step Eff Nothing $ text
                  "Bloodied characters or pushed +2 spaces."
              , Step Eff Nothing $ seq
                  [ text "Foes in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text " are additionally "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Pincer Attack"
          , colour: Name "Red"
          , description: text
              """Your weapon finds every weakness, driving your foe straight
              into your waiting ally."""
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "1 damage") $ seq [ text "+", dice 1 D3 ]
              , Step OnHit Nothing $ seq
                  [ text
                      """Push 1. If your foe would be pushed into an ally's
                      space, that ally deals 2 """
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage to that foe and gains "
                  , italic $ ref (Name "Shield") $ text "shield"
                  , text
                      ". Double these effects if your ally or you target is in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Bait and Switch"
          , colour: Name "Red"
          , description: text
              """You lay a trap for your foe, striking when they overextend
              themselves."""
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)), TargetTag Ally ]
          , steps:
              [ Step Eff Nothing $ text "Swap places with an ally in range."
              , Step Eff Nothing $ seq
                  [ text
                      """If your ally was adjacent to at least one foe, you may
                      then deal 2 damage to one of those foes after swapping
                      and """
                  , italic $ ref (Name "Daze") $ text "daze"
                  , text " them."
                  ]
              ]
          }
      , Ability
          { name: Name "Hold the Center"
          , colour: Name "Red"
          , description: text
              """You brace with a shield or armor, strengthening your formation
              against incoming blows."""
          , cost: Interrupt (NumVar 1)
          , tags: [ TargetTag Ally, RangeTag Adjacent ]
          , steps:
              [ Step TriggerStep Nothing $ text "An adjacent ally is damaged."
              , Step Eff (Just D6) $ text
                  """Reduce that damage by the number of adjacent allies to you,
                  then push all adjacent foes 1, (4+) two, or (6+) four
                  spaces."""
              , Step Eff Nothing $ seq
                  [ text "If that ally was in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text " double damage reduction and push."
                  ]
              ]
          }
      , Ability
          { name: Name "Mighty Standard"
          , colour: Name "Red"
          , description: text
              """You place your banner, striking fear into the hearts of your
              foes."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              , End
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text " and designate a blast 3 "
                  , italic $ ref (Name "Zone") $ text "zone"
                  , text
                      """ with at least one space in range, which could overlap
                      characters. Allies that end their turn inside the zone
                      gain """
                  , italic $ ref (Name "Shield") $ text "shield"
                  , text ". If they are in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text
                      ", they also gain +1 armor while inside the zone."
                  ]
              , Step Eff (Just D3) $ seq
                  [ text
                      "While inside the zone, you can pick up the banner as a "
                  , bold $ text "quick"
                  , text
                      """ ability and swing it, pushing all other characters
                      inside """
                  , italic $ dice 1 D3
                  , text ", but removing the zone. Foes pushed are "
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
