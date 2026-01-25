module ToA.Resource.Icon.Job.Fool
  ( fool
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Inset(..)
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
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

fool :: Icon
fool =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Fool"
          , colour: Name "Yellow"
          , soul: Name "Thief"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Fools are dedicated defenders of the common people of Arden
                  Eld, part folk hero, and part hired killer. They have no
                  official organization, and cover their faces with masks to
                  hide their identity, wearing bells and motley to cover their
                  collections of deadly weapons and explosives. Some people fear 
                  the Fools, calling them self-interested thugs or anarchic
                  cultists of the Laughing Titan, the god of death. They may not
                  be entirely wrong, but none can deny their flair for the
                  theatrical."""
              , Newline
              , Newline
              , Text
                  """They are feared rightly by all would-be tyrants,
                  under-barons, and aspiring imperial lords. Wherever kin labor
                  under oppression, someone will take up the mask and knives and
                  sent cold jolts of fear into the hearts of the rich and
                  comfortable."""
              ]
          , trait: Name "Stacked Die"
          , keyword: Name "Finishing Blow"
          , abilities:
              (I /\ Name "Death XIII")
                : (I /\ Name "Knife Juggler")
                : (II /\ Name "Deathwheel")
                : (IV /\ Name "Gallows Humor")
                : empty
          , limitBreak: Name "Curtain Call"
          , talents:
              Name "Carnage"
                : Name "Barbs"
                : Name "Kismet"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Stacked Die"
          , description:
              [ Text "You start combat with a stacked die, a "
              , Italic [ Text "d6" ]
              , Text
                  """. Randomly roll it at the start of combat and keep the
                  number."""
              , List Unordered
                  [ [ Text
                        """You can substitute the die roll for any effect roll
                        you would otherwise make. You must choose before
                        activating the ability. Then discard the die."""
                    ]
                  , [ Text
                        """Once a round, when you damage a bloodied foe, you can
                        re-roll the die if you have it, keeping the new result,
                        or gain a new die if you don't have one."""
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "carnage|talent|fool"
          , name: Name "Carnage"
          , colour: Name "Yellow"
          , description:
              [ Text "Once a round, after you score a "
              , Italic [ Ref (Name "Finishing Blow") [ Text "finishing blow" ] ]
              , Text ", you may dash 3. Also gain "
              , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
              , Text " if your foe was in crisis."
              ]
          }
      , Talent
          { id: Id "barbs|talent|fool"
          , name: Name "Barbs"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a round, when you reduce a character to 0 hp, you may
                  deal 2 damage to all foes adjacent to that character. Increase
                  this to """
              , Dice 2 D3
              , Text " against any these foes that are bloodied."
              ]
          }
      , Talent
          { id: Id "kismet|talent|fool"
          , name: Name "Kismet"
          , colour: Name "Yellow"
          , description:
              [ Text "Your abilities may gain effect "
              , Power
              , Text " if they target at least one foe in crisis."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Curtain Call"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Bring out the fireworks. Fire up the elden magic. Time for
                  a showstopper."""
              ]
          , cost: Two /\ 4
          , tags: [ AreaTag (Line (OtherVar "X")) ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text "Roll the effect die, then draw a line "
                  , Italic [ Text "area effect" ]
                  , Text
                      """ of that many spaces +2, stopping the line when it hits
                      an obstruction such as a character or object. Soar into
                      the air, removing yourself from the battlefield, then
                      place yourself adjacent to the """
                  , Italic [ Text "first" ]
                  , Text
                      """ foe in that line, delivery a massive blow. This
                      ability has different effects depending on their position
                      on the line. Foes can save for half damage."""
                  , List Unordered
                      [ [ Bold [ Text "0-3 spaces" ]
                        , Text ": "
                        , Dice 2 D6
                        , Text "+2 damage."
                        ]
                      , [ Bold [ Text "4-6 spaces" ]
                        , Text ": "
                        , Dice 2 D6
                        , Text "+2 damage, then "
                        , Dice 2 D6
                        , Text " damage again."
                        ]
                      , [ Bold [ Text "6+ spaces" ]
                        , Text
                            """: Also destroy all vigor on your foe before
                            dealing damage, and the damage becomes """
                        , Italic [ Ref (Name "Piercing") [ Text "piercing" ] ]
                        , Text "."
                        ]
                      ]
                  , Text
                      """If there are no valid targets after rolling, the
                      resolve and action cost of this ability if refunded."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text
                      """Reduce action cost to 1. If your target is in crisis,
                      reduce action cost to """
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Death XIII"
          , colour: Name "Yellow"
          , description:
              [ Text
                  "A shard of Divine Death, summoned with a snap of the finger."
              ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 6)) ]
          , steps:
              [ Step AreaEff (Just D6)
                  [ Text
                      """Roll the effect die. If your target is at the exact
                      range of the effect die, this ability deals """
                  , Dice 3 D3
                  , Text " damage on hit instead."
                  ]
              , AttackStep [ Text "2 damage"] [ Text "+", Dice 1 D3 ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text
                      """Burst 1 (target) area effect explosion, 2 damage and
                      push 1. If your target is in crisis, increase damage and
                      burst by +1."""
                  ]
              ]
          }
      , Ability
          { name: Name "Knife Juggler"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """It is not enough to rudely and plainly strike your foe
                  down. One must make it entertaining."""
              ]
          , cost: One
          , tags: [ AreaTag (Line (OtherVar "X")) ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Draw a line X spaces long, stopping at an obstruction.
                      The first character in the line takes 2 damage, increase
                      by +2 for every 3 spaces the knife traveled before
                      impacting its target, including the target's space."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text "You may dash 1, then throw a knife again." ]
              ]
          }
      , Ability
          { name: Name "Deathwheel"
          , colour: Name "Yellow"
          , description:
              [ Text "A blur of cape, a flash of color, the gleaming of blades."
              ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Dash X+2. You must dash in a straight line as far as
                      possible. You gain """
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text
                      """ for this dash. The first foe you pass through takes 2
                      damage. The second takes """
                  , Dice 1 D3
                  , Text "+1. The third or more take "
                  , Dice 2 D3
                  , Text "+2."
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text " if you passed through a bloodied foe. Also gain "
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text " if your passed through a foe in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Gallows Humor"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """The power of Divine Death flows through you, empowering
                  your strikes."""
              ]
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Aura")  ]
          , steps:
              [ InsetStep (KeywordStep (Name "Stance")) Nothing
                  [ Text
                      """In this stance, you gain aura 2 and the following
                      interrupt."""
                  ]
                  $ AbilityInset
                      { name: Name "Snuff Candle"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  """A foe in crisis in the aura takes damage
                                  from an ally's ability."""
                              ]
                          , Step Eff (Just D6)
                              [ Text
                                  """Snap you fingers and roll the effect die.
                                  If your foe is at """
                              , Italic [ Dice 1 D6 ]
                              , Text
                                  """ or less HP, they are instantly defeated,
                                  ignoring all effects, unless they are immune
                                  to damage. Otherwise, they take 2 """
                              , Italic
                                  [ Ref (Name "Piercing") [ Text "piercing" ] ]
                              , Text " damage."
                              ]
                          , Step Eff Nothing
                              [ Text
                                  """If this interrupt defeats your foe, regain
                                  the interrupt."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
