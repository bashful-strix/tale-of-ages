module ToA.Resource.Icon.Job.Fool
  ( fool
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
import ToA.Data.Icon.Pc.Talent (Talent(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))

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
          , sign: Sign "icon-[game-icons--jester-hat]"
          , soul: Name "Thief"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """Fools are dedicated defenders of the common people of Arden
                  Eld, part folk hero, and part hired killer. They have no
                  official organization, and cover their faces with masks to
                  hide their identity, wearing bells and motley to cover their
                  collections of deadly weapons and explosives. Some people fear
                  the Fools, calling them self-interested thugs or anarchic
                  cultists of the Laughing Titan, the god of death. They may not
                  be entirely wrong, but none can deny their flair for the
                  theatrical."""
              , newline
              , newline
              , text
                  """They are feared rightly by all would-be tyrants,
                  under-barons, and aspiring imperial lords. Wherever kin labor
                  under oppression, someone will take up the mask and knives and
                  send cold jolts of fear into the hearts of the rich and
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
              Id "carnage|talent|fool"
                : Id "barbs|talent|fool"
                : Id "kismet|talent|fool"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Stacked Die"
          , description: seq
              [ text "You start combat with a stacked die, a "
              , italic $ text "d6"
              , text
                  """. Randomly roll it at the start of combat and keep the
                  number."""
              , list Unordered
                  [ text
                      """You can substitute the die roll for any effect roll you
                      would otherwise make. You must choose before activating
                      the ability. Then discard the die."""
                  , text
                      """Once a round, when you damage a bloodied foe, you can
                      re-roll the die if you have it, keeping the new result, or
                      gain a new die if you don't have one."""
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "carnage|talent|fool"
          , name: Name "Carnage"
          , colour: Name "Yellow"
          , description: seq
              [ text "Once a round, after you score a "
              , italic $ ref (Name "Finishing Blow") $ text "finishing blow"
              , text ", you may dash 3. Also gain "
              , italic $ ref (Name "Haste") $ text "haste"
              , text " if your foe was in crisis."
              ]
          }
      , Talent
          { id: Id "barbs|talent|fool"
          , name: Name "Barbs"
          , colour: Name "Yellow"
          , description: seq
              [ text
                  """Once a round, when you reduce a character to 0 hp, you may
                  deal 2 damage to all foes adjacent to that character. Increase
                  this to """
              , dice 2 D3
              , text " against any of these foes that are bloodied."
              ]
          }
      , Talent
          { id: Id "kismet|talent|fool"
          , name: Name "Kismet"
          , colour: Name "Yellow"
          , description: seq
              [ text "Your abilities may gain effect "
              , power
              , text " if they target at least one foe in crisis."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Curtain Call"
          , colour: Name "Yellow"
          , description: text
              """Bring out the fireworks. Fire up the elden magic. Time for a
              showstopper."""
          , cost: Two /\ 4
          , tags: [ AreaTag (Line (OtherVar "X")) ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text "Roll the effect die, then draw a line "
                  , italic $ text "area effect"
                  , text
                      """ of that many spaces +2, stopping the line when it hits
                      an obstruction such as a character or object. Soar into
                      the air, removing yourself from the battlefield, then
                      place yourself adjacent to the """
                  , italic $ text "first"
                  , text
                      """ foe in that line, delivering a massive blow. This
                      ability has different effects depending on their position
                      on the line. Foes can save for half damage."""
                  , list Unordered
                      [ seq
                          [ bold $ text "0-3 spaces"
                          , text ": "
                          , dice 2 D6
                          , text "+2 damage."
                          ]
                      , seq
                          [ bold $ text "4-6 spaces"
                          , text ": "
                          , dice 2 D6
                          , text "+2 damage, then "
                          , dice 2 D6
                          , text " damage again."
                          ]
                      , seq
                          [ bold $ text "6+ spaces"
                          , text
                              """: Also destroy all vigor on your foe before
                              dealing damage, and the damage becomes """
                          , italic $ ref (Name "Piercing") $ text "piercing"
                          , text "."
                          ]
                      ]
                  , text
                      """If there are no valid targets after rolling, the
                      resolve and action cost of this ability is refunded."""
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ seq
                  [ text
                      """Reduce action cost to 1. If your target is in crisis,
                      reduce action cost to """
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Death XIII"
          , colour: Name "Yellow"
          , description: text
              "A shard of Divine Death, summoned with a snap of the finger."
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 6)) ]
          , steps:
              [ Step AreaEff (Just D6) $ seq
                  [ text
                      """Roll the effect die. If your target is at the exact
                      range of the effect die, this ability deals """
                  , dice 3 D3
                  , text " damage on hit instead."
                  ]
              , AttackStep (text "2 damage") (seq [ text "+", dice 1 D3 ])
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ text
                  """Burst 1 (target) area effect explosion, 2 damage and push
                  1. If your target is in crisis, increase damage and burst by
                  +1."""
              ]
          }
      , Ability
          { name: Name "Knife Juggler"
          , colour: Name "Yellow"
          , description: text
              """It is not enough to rudely and plainly strike your foe down.
              One must make it entertaining."""
          , cost: One
          , tags: [ AreaTag (Line (OtherVar "X")) ]
          , steps:
              [ Step Eff (Just D6) $ text
                  """Draw a line X spaces long, stopping at an obstruction. The
                  first character in the line takes 2 damage, increase by +2 for
                  every 3 spaces the knife traveled before impacting its target,
                  including the target's space."""
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ text
                  "You may dash 1, then throw a knife again."
              ]
          }
      , Ability
          { name: Name "Deathwheel"
          , colour: Name "Yellow"
          , description: text
              "A blur of cape, a flash of color, the gleaming of blades."
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Dash X+2. You must dash in a straight line as far as
                      possible. You gain """
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text
                      """ for this dash. The first foe you pass through takes 2
                      damage. The second takes """
                  , dice 1 D3
                  , text "+1. The third or more take "
                  , dice 2 D3
                  , text "+2."
                  ]
              , Step (KeywordStep (Name "Finishing Blow")) Nothing $ seq
                  [ text "Gain "
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text " if you passed through a bloodied foe. Also gain "
                  , italic $ ref (Name "Evasion") $ text "evasion"
                  , text " if your passed through a foe in "
                  , italic $ ref (Name "Crisis") $ text "crisis"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Gallows Humor"
          , colour: Name "Yellow"
          , description: text
              """The power of Divine Death flows through you, empowering your
              strikes."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Aura") ]
          , steps:
              [ InsetStep (KeywordStep (Name "Stance")) Nothing
                  ( text
                      """In this stance, you gain aura 2 and the following
                      interrupt."""
                  )
                  $ AbilityInset
                      { name: Name "Snuff Candle"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              """A foe in crisis in the aura takes damage from
                              an ally's ability."""
                          , Step Eff (Just D6) $ seq
                              [ text
                                  """Snap your fingers and roll the effect die.
                                  If your foe is at """
                              , italic $ dice 1 D6
                              , text
                                  """ or less HP, they are instantly defeated,
                                  ignoring all effects, unless they are immune
                                  to damage. Otherwise, they take 2 """
                              , italic $ ref (Name "Piercing") $ text "piercing"
                              , text " damage."
                              ]
                          , Step Eff Nothing $ text
                              """If this interrupt defeats your foe, regain the
                              interrupt."""
                          ]
                      }
              ]
          }
      ]
  }
