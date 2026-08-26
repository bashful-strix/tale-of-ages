module ToA.Resource.Icon.Job.Zephyr
  ( zephyr
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
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , newline
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

zephyr :: Icon
zephyr =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Zephyr"
          , colour: Name "Green"
          , sign: Sign "icon-[game-icons--whirlwind]"
          , soul: Name "Bard"
          , class: Name "Mendicant"
          , description: seq
              [ text
                  """All the islands rely on the currents and breezes and listen
                  to them like a respected grandmother. Traveling over the
                  water, with its treacherous tidal shifts and frequent monster
                  infestations, is fickle and dangerous, and requires patience.
                  When more alacrity is required, the islands call on their
                  resident Zephyr."""
              , newline
              , newline
              , text
                  """The Zephyrs are tight knit priesthood of messengers to
                  which the wind is an old and familiar song. In quiet times,
                  they tend to the flocks of messenger birds and maintain the
                  (sometimes very mundane) aerial flow of letters, mail, and
                  small goods between islands and the mainland. In more pressing
                  times, they take to the skies, whether for emergency or
                  battle, soaring with incredible speed and skill, no matter the
                  weather. It is rumored that the oldest Zephyrs can whisper into
                  the wind itself and have it heard miles away, but if they can,
                  it is a secret art they do not divulge to land-bound
                  outsiders."""
              ]
          , trait: Name "Fair Winds"
          , keyword: Name "Dominant"
          , abilities:
              (I /\ Name "Gust")
                : (I /\ Name "Cyclone")
                : (II /\ Name "Tempest Shot")
                : (IV /\ Name "Pandaemonium")
                : empty
          , limitBreak: Name "Grandmother Gale"
          , talents:
              Id "stormborn|talent|zephyr"
                : Id "alacrity|talent|zephyr"
                : Id "squall|talent|zephyr"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Fair Winds"
          , description: seq
              [ text
                  """You automatically enter the Fair Winds stance at the start
                  of combat, and enter it again automatically if you end your
                  turn at elevation 1 or higher."""
              , list Unordered
                  [ text "This stance stacks with other stances."
                  , seq
                      [ text "While in this stance, your "
                      , italic $ ref (Name "Free Move") $ text "free move"
                      , text " becomes flying and moves +2 spaces."
                      ]
                  , seq
                      [ text "As a "
                      , italic $ ref (Name "Quick") $ text "quick"
                      , text
                          """ ability, you can forgo your free move to allow an
                          ally in range 1-5 to fly that many spaces instead."""
                      ]
                  , text
                      """You exit the stance if you end your turn at elevation 0
                      or lower."""
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "stormborn|talent|zephyr"
          , name: Name "Stormborn"
          , colour: Name "Green"
          , description: seq
              [ text
                  """The first time in combat you become bloodied or enter
                  crisis, you can create an """
              , italic $ ref (Name "Obscured") $ text "obscured"
              , text " space under yourself or up to two spaces of "
              , ref (Name "Difficult Terrain") $ text "difficult terrain"
              , text " in free adjacent spaces."
              ]
          }
      , Talent
          { id: Id "alacrity|talent|zephyr"
          , name: Name "Alacrity"
          , colour: Name "Green"
          , description: text
              """Increase your free move and any free move you grant by half the
              round number, rounded up."""
          }
      , Talent
          { id: Id "squall|talent|zephyr"
          , name: Name "Squall"
          , colour: Name "Green"
          , description: seq
              [ text
                  """Once a round, as a quick ability, you may place a 1 space
                  squall """
              , italic $ ref (Name "Zone") $ text "zone"
              , text
                  """ in range 1-3. You can place any number of these zones.
                  When an ally enters the zone, they can fly """
              , italic $ dice 1 D3
              , text
                  """, consuming the zone. When a foe enters the zone for any
                  reason, push them 1 in any direction, consuming the zone."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Grandmother Gale"
          , colour: Name "Green"
          , description: text
              """You call in the mother of all storms. Her momentary visitation
              is enough to toss around even the sturdiest warrior like
              driftwood."""
          , cost: Two /\ 3
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """You summon a massive swirling sheet of wind that
                      blankets the battlefield. Choose a blast 3 area in range,
                      which could include characters. Other than that blast
                      area, all other spaces on the battlefield become """
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text
                      ". Attacks from characters in these spaces have attack "
                  , weakness
                  , weakness
                  , text
                      """ and all characters in these spaces count as being
                      elevation +1 and """
                  , italic $ ref (Name "Fly") $ text "fly"
                  , text
                      """ when they move. This effect ends at the end of your
                      next turn."""
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """You can invert this effect if you want, changing it to
                      all spaces """
                  , italic $ text "inside"
                  , text " the blast area instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Gust"
          , colour: Name "Green"
          , description: text
              "With no weapon at all, you batter your foes like loose leaves."
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 4))
              , AreaTag (Line (NumVar 3))
              ]
          , steps:
              [ AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , Step AreaEff Nothing $ text "2 damage."
              , InsetStep OnHit Nothing
                  ( text
                      """Creates an updraft in free space adjacent to your
                      target. You may place any number of these zones."""
                  )
                  $ KeywordInset
                      { name: Name "Updraft"
                      , colour: Name "Green"
                      , keyword: Name "Zone"
                      , steps:
                          [ Step Eff Nothing $ seq
                              [ text "This is an "
                              , italic $ ref (Name "Obscured") $ text "obscured"
                              , text
                                  """ space. Yourself or allies inside count as
                                  +1 space of elevation higher than their base
                                  space."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Dominant")) Nothing $ text
                  "Create a second updraft."
              ]
          }
      , Ability
          { name: Name "Cyclone"
          , colour: Name "Green"
          , description: text "You ask the wind to cause a little mischief."
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , End
              , RangeTag (Range (NumVar 3) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and create a 1 space zone of swirling wind in a free
                      space in range."""
                  , list Unordered
                      [ seq
                          [ text "This is an "
                          , italic $ ref (Name "Obscured") $ text "obscured"
                          , text
                              """ space. Characters inside count as +1 space of
                              elevation higher than their base space."""
                          ]
                      , seq
                          [ text
                              """Once a round, yourself or an ally that exits
                              the space on their turn can fly 3 spaces as a """
                          , italic $ ref (Name "Quick") $ text "quick"
                          , text
                              """ ability. The cyclone then deactivates until
                              the start of your next turn, losing all its
                              effects."""
                          ]
                      , text
                          """At the start of each of your turns, any existing
                          space grows, counting as +1 space higher (max +3)."""
                      ]
                  ]
              , Step (KeywordStep (Name "Dominant")) (Just D3) $ seq
                  [ text
                      "Blow away all adjacent foes to the space, pushing them "
                  , italic $ dice 1 D3
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Tempest Shot"
          , colour: Name "Green"
          , description: text
              """You imbue swirling wind into arrows, bullets, or stones,
              creating miniature tornadoes when they strike."""
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 3) (NumVar 5))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Zone")) (Just D3)
                  ( seq
                      [ text "You create "
                      , italic $ seq [ dice 1 D3, text "+1" ]
                      , text
                          """ spaces in range. Any foe that voluntarily enters a
                          space or starts their turn there is struck by a
                          projectile, taking 2 """
                      , italic $ ref (Name "Pierce") $ text "piercing"
                      , text " damage and becoming "
                      , italic $ ref (Name "Brand") $ text "branded"
                      , text
                          """. Then create an updraft in their space. Allies can
                          activate a space by entering it and take no other
                          damage or effects."""
                      ]
                  )
                  $ KeywordInset
                      { name: Name "Updraft"
                      , colour: Name "Green"
                      , keyword: Name "Zone"
                      , steps:
                          [ Step Eff Nothing $ seq
                              [ text "This is an "
                              , italic $ ref (Name "Obscured") $ text "obscured"
                              , text
                                  """ space. Yourself or allies inside count as
                                  +1 space of elevation higher than their base
                                  space."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Dominant")) (Just D3) $ seq
                  [ text "After creating a space, may push an adjacent foe "
                  , italic $ dice 1 D3
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Pandaemonium"
          , colour: Name "Green"
          , description: text
              """You call upon the ancient and ferocious winds that swirled at
              the start of time, when the land was roiling and unformed."""
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ InsetStep (KeywordStep (Name "Stance")) Nothing
                  ( text
                      """Gain the following interrupt each round while in this
                      stance."""
                  )
                  $ AbilityInset
                      { name: Name "Chaos Wind"
                      , colour: Name "Green"
                      , cost: Interrupt (NumVar 2)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              """A character enters or exits a space in range
                              1-2."""
                          , Step Eff Nothing $ seq
                              [ text
                                  """Swap them with any other character in
                                  range, interrupting but not stopping their
                                  movement. Foes can save to avoid this effect,
                                  but are """
                              , italic $ ref (Name "Brand") $ text "branded"
                              , text " on a successful save."
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Dominant")) (Just D3) $ seq
                  [ text
                      """If you swap a character onto lower ground then they
                      started, then may fly """
                  , italic $ dice 1 D3
                  , text
                      """ (allies) or you may push or pull them the same amount
                      (enemy)."""
                  ]
              ]
          }
      ]
  }
