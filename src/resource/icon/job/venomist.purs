module ToA.Resource.Icon.Job.Venomist
  ( venomist
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
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

venomist :: Icon
venomist =
  { classes: []
  , colours: []
  , souls: []
  , foes: []
  , foeClasses: []
  , factions: []

  , keywords:
      [ Keyword
          { name: Name "Shadow Venom"
          , category: Status Negative
          , description: text
              """A unique status. When taking a turn, a character afflicted by
              Shadow Venom cannot draw line of sight except to adjacent spaces
              until the end of that turn. They can ignore this effect while they
              are adjacent to an ally."""
          }
      ]

  , jobs:
      [ Job
          { name: Name "Venomist"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--poison]"
          , soul: Name "Shadow"
          , class: Name "Vagabond"
          , description: text
              """Night-walkers, shadow-steppers, and masters of secret venom
              arts, the Venomists are spies, scouts, and assassins of
              unparalleled skill. Joining their order is presumed to be
              extremely difficult, but they tend to open their ranks to anyone
              that has been lost or abandoned. Their number forms a secret and
              deadly society of Vermin Clans spread across Arden Eld, each
              practicing and refining the Night Venom Techniques. They are known
              for hunting and drawing out poisons from the deadliest creatures
              in Arden Eld, with which they coat their weapons and even ingest
              to build up immunity and practice toxic enlightenment. As poison
              can fell anything, whether lord or beast, it is a great
              leveler."""
          , trait: Name "Shadow Venom"
          , keyword: Name "Afflicted"
          , abilities:
              (I /\ Name "Venom Lash")
                : (I /\ Name "Fume Slice")
                : (II /\ Name "Centipede Dash")
                : (IV /\ Name "Choking Cloud")
                : empty
          , limitBreak: Name "Abyssal Ecstasy"
          , talents:
              Id "taste|talent|venomist"
                : Id "slither|talent|venomist"
                : Id "pressure|talent|venomist"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Shadow Venom"
          , description: seq
              [ text
                  """Once a round, when you damage a target, you can inflict
                  them with """
              , ref (Name "Shadow Venom") $ text "Shadow Venom (-)"
              , text
                  """, a unique status. When taking a turn, a character
                  afflicted by Shadow Venom cannot draw line of sight except to
                  adjacent spaces until the end of that turn. They can ignore
                  this effect while they are adjacent to an ally."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "taste|talent|venomist"
          , name: Name "Taste"
          , colour: Name "Yellow"
          , description: seq
              [ text "Improve the effect of "
              , italic $ ref (Name "Blind") $ text "blind"
              , text " to "
              , weakness
              , weakness
              , text
                  """ on attacks against you and adjacent allies. When you
                  critical hit, you may inflict """
              , italic $ ref (Name "Blind") $ text "blind"
              , text "."
              ]
          }
      , Talent
          { id: Id "slither|talent|venomist"
          , name: Name "Slither"
          , colour: Name "Yellow"
          , description: seq
              [ text "You can "
              , italic $ ref (Name "Phasing") $ text "phase"
              , text
                  """ through afflicted foes when you move. Once a round, when
                  you do this, you can deal 2 damage to that foe, or """
              , dice 2 D3
              , text " if they are in crisis."
              ]
          }
      , Talent
          { id: Id "pressure|talent|venomist"
          , name: Name "Pressure"
          , colour: Name "Yellow"
          , description: seq
              [ text "Your attacks gain "
              , italic $ ref (Name "Critical Hit") $ text "critical hit"
              , text
                  """: increase all negative statuses on your foe by +1, or +2
                  if your foe is in """
              , italic $ text "crisis"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Abyssal Ecstasy"
          , colour: Name "Yellow"
          , description: text
              """You catalyze a toxic mist in your blood so potent that it coats
              the entire battlefield in a deadly, hallucinogenic haze."""
          , cost: One /\ 3
          , tags: []
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Yourself and all allies gain "
                  , italic $ ref (Name "Stealth") $ text "stealth"
                  , text ", and all foes gain "
                  , italic $ ref (Name "Blind") $ text "blind"
                  , text " and "
                  , italic $ ref (Name "Shadow Venom") $ text "shadow venom"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Venom Lash"
          , colour: Name "Yellow"
          , description: text
              """You lash out with a chain, whip, or grapple filled with tiny
              channels and barbs for containing poisons."""
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ AttackStep (text "2 damage") $ seq [ text "+", dice 1 D6 ]
              , Step Eff Nothing $ text
                  "Pull yourself 1 or 2 spaces towards your target."
              , Step (KeywordStep (Name "Afflicted")) Nothing $ text
                  """Then you may choose to have your foe save or be pulled 1,
                  or up to 3 spaces on a failed save, choosing the pull
                  distance. If your foe has 3 negative status tokens or more,
                  they fail the save."""
              ]
          }
      , Ability
          { name: Name "Fume Slice"
          , colour: Name "Yellow"
          , description: text
              "Spattered venom from your weapon creates a toxic shield."
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 3)) ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """Slash a line 3 zone, which could be created over
                      characters. Each space of the zone is an """
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text " space and is "
                  , italic
                      $ ref (Name "Difficult Terrain")
                      $ text "difficult terrain"
                  , text ". When created, characters in the area effect take 2 "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage and must save or be "
                  , italic $ ref (Name "Blind") $ text "blinded"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing $ text
                  """If initially targeting at least one afflicted foe, extend
                  the line by +2. If that foe had 3 or more negative statuses,
                  extend the area by +6."""
              ]
          }
      , Ability
          { name: Name "Centipede Dash"
          , colour: Name "Yellow"
          , description: text
              """As you weave around your foes, tiny nicks with needles or
              blades blossom into stinging death."""
          , cost: One
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 4)), End ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text
                      """Target a line 4 area, then dash to the end, or as far
                      as possible, with """
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text ". Then "
                  , bold $ text "end your turn."
                  , list Unordered
                      [ seq
                          [ text
                              """The first foe you pass through during this
                              movement is """
                          , italic $ ref (Name "Blind") $ text "blinded"
                          , text "."
                          ]
                      , text
                          """All bloodied foes then have all their statuses
                          increased by +1. Foes in crisis have their statuses
                          increased by +2."""
                      ]
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing $ seq
                  [ text
                      """Afflicted foes take 2 damage. Foes with 3 or more
                      negative status tokens takes 2 """
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Choking Cloud"
          , colour: Name "Yellow"
          , description: text
              """You throw a gleaming stone of condensed pure poison. On impact,
              it blossoms into a beautiful, shimmering, and very deadly
              cloud."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 3))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D6)
                  (text "Summon one or (5+) two choking clouds in range.")
                  $ SummonInset
                      { name: Name "Choking Cloud"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text "The cloud is an "
                              , italic $ ref (Name "Obscured") $ text "obscured"
                              , text
                                  """ space. In addition, characters other than
                                  you standing in or adjacent to a cloud do not
                                  clear statuses at the end of their turn."""
                              ]
                          , Step SummonEff Nothing $ seq
                              [ text "Afflicted foes treat the area as "
                              , italic
                                  $ ref (Name "Difficult Terrain")
                                  $ text "difficult"
                              , text " and "
                              , italic
                                  $ ref (Name "Dangerous Terrain")
                                  $ text "dangerous terrain"
                              , text "."
                              ]
                          , Step SummonAction Nothing $ text
                              """The cloud flies 2 spaces. It can enter or end
                              this movement in character's spaces."""
                          ]
                      }
              ]
          }
      ]
  }
