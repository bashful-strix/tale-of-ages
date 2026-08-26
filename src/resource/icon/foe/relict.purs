module ToA.Resource.Icon.Foe.Relict
  ( relict
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Chapter (Chapter(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Foe
  ( Faction(..)
  , Foe(..)
  , FoeAbility(..)
  , FoeInsert(..)
  , FoeTrait(..)
  )
import ToA.Data.Icon.Keyword (Keyword(..), Category(..))
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

relict :: Icon
relict =
  { classes: []
  , colours: []
  , souls: []
  , jobs: []
  , traits: []
  , talents: []
  , abilities: []
  , foeClasses: []

  , factions:
      [ Faction
          { name: Name "Relict"
          , description: seq
              [ text
                  """The Relict are the most common danger that adventurers face
                  in the ruins of Arden Eld. They are the spectral remnants of
                  the Arken Empire, souls bound in a semi-automated etheric
                  network that runs through the ruins, entrapped there by an
                  ancient cabal of sorcerers as a last ditch effort to save a
                  dying people. The process was technically successful, but most
                  relict have been left mindless husks - tormented souls
                  harnessed and stored en mass in a lightning aether powered
                  sarcophagus-like nodes buried deep in the darkness of the
                  earth, sunk there by the Doom in the days of eld."""
              , newline
              , newline
              , text
                  """These networks and their central nodes, the Metachiron,
                  have run for untold centuries, using their stored souls as
                  power as they enact survival protocols hewn in cuneiform by
                  long dead priests."""
              , newline
              , newline
              , text
                  """Now the great tomb-cities prepared for the populace now lie
                  beneath the earth, both dead and alive. Great monuments of
                  dead emperors peer over pitch black chasms lined with the
                  husks of the deceased. Relict armor sits eerily still in
                  alcoves, or crumpled into a corner, until a node senses
                  intruders, the Relict within rippling out through conduits to
                  manifest in crackling undeath."""
              , newline
              , newline
              , text
                  """There are some Relict, remnants of the Black Sun cult,
                  that have retained more sense of themselves and work at dark
                  purpose to resurrect the old empire and bring back the
                  Arkenlords. These masters of the dead are barely sane from
                  their long stint with undeath and think only of returning the
                  surface world to its former glory."""
              ]
          , template:
              { description: seq
                  [ text
                      """To make any foe a Relict, you can add the following
                      traits. All Relict have these traits."""
                  , newline
                  , newline
                  , text "Most relict are mindless husks and are "
                  , bold $ text "monsters"
                  , text ". Their more intelligent masters are "
                  , bold $ text "kin"
                  , text " and usually have more complex motivations."
                  , list Unordered
                      [ seq
                          [ bold $ text "Motivations: "
                          , text
                              """Relict are usually dormant, but become active
                              when their tomb-cities are intruded upon by
                              unlucky treasure-seekers. They can also be stirred
                              into wakefulness by the priests of the Black Sun,
                              whose only goal is the reawakening of the old
                              empire, the resurrection of the Arkenlords, and
                              the reconquest and total subjugation of the world
                              of the living."""
                          ]
                      , text
                          """Intelligent Relict are usually delirious or
                          obsessive."""
                      ]
                  ]
              , traits: [ Name "Legion of the Dead" ]
              }
          , mechanic:
              { name: Name "Legion of the Dead"
              , description: seq
                  [ text
                      """Relict are a legion of mindless husks, cursed with an
                      undying existence. This gives all relict except Legends
                      the following traits:"""
                  , list Unordered
                      [ seq
                          [ text "Add a "
                          , bold $ text "Husk"
                          , text
                              """ mob to any non-legend fight. This does not
                              take up points in the encounter."""
                          ]
                      , seq
                          [ text
                              """After being defeated, any relict sheds any of
                              its mortal remains and becomes a weak shade of pure
                              energy. When a relict is defeated, summon a """
                          , bold $ text "husk"
                          , text
                              " in its space, adding to the members of the mob."
                          ]
                      ]
                  ]
              }
          , keywords: [ Name "Sacrifice", Name "Horde" ]
          }
      ]

  , keywords:
      [ Keyword
          { name: Name "Horde"
          , category: General
          , description: text
              """This ability becomes more powerful when 2 or more allies are
              adjacent to the target."""
          }
      ]

  , foes:
      [ Mob
          { name: Name "Husk"
          , colour: Name "Purple"
          , class: Name "Mob"
          , faction: Just $ Name "Relict"
          , description: text
              """The shuffling mass of relict servitors, in thrall to the
              network."""
          , notes: text
              """This mob is always present in Relict fights. When new
              husks are summoned, they add to the current mob, or create a
              new one that can act on the following round if there isn’t
              one. """
          , traits:
              [ FoeTrait
                  { name: Name "Endless Dead"
                  , description: text
                      """Add to this mob by 1 at the start of every round,
                      placing a new member anywhere on the battlefield not
                      adjacent to a foe."""
                  }
              , FoeTrait
                  { name: Name "Fading"
                  , description: text
                      """This mob is defeated if all of its allies is defeated,
                      and disintegrates."""
                  }
              ]
          , abilities:
              [ FoeAbility
                  { name: Name "Frenzied Scrabbling"
                  , cost: Two
                  , tags: []
                  , description: seq
                      [ italic $ text "Effect"
                      , text
                          """: All husks may dash 2. Then any foes adjacent to
                          one or more husks take 2 damage."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Soul Sacrifice"
                  , cost: Two
                  , tags: []
                  , description: seq
                      [ text
                          """Choose a bloodied character adjacent to one or more
                          husks, then destroy any number of husks adjacent to
                          that character. If that character is an ally, they
                          gain 2 vigor per husk destroyed. If that character was
                          a foe, they must save or """
                      , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                      , text
                          """ 2 per husk destroyed, or sacrifice 1 per husk on a
                          successful save."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }

      , Foe
          { name: Name "Necrosavant"
          , colour: Name "Green"
          , class: Name "Leader"
          , faction: Just $ Name "Relict"
          , chapter: Just I
          , description: text
              """The Priests of the Black Sun were the central cult of the Arken
              Imperium and foremost in political power and influence. It was
              they, under the leadership of their sorcerer-priests, that
              orchestrated the Ur-spell that necrotized what remained of the
              empire. The process of preserving the entire population of the
              empire required a great deal of work, and therefore the priests
              classes were split into many castes that labored at numerous
              terrible projects. In the end of days, in their desperation, they
              delved into deeper and darker magics and sacrificed their very
              souls for the purpose of the Great Work."""
          , notes: seq []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Unholy"
                  , cost: One
                  , tags:
                      [ Attack
                      , RangeTag (Range (NumVar 2) (NumVar 5))
                      , AreaTag (Cross (NumVar 2))
                      ]
                  , description: seq
                      [ text "1 piercing damage. "
                      , italic $ text "Hit"
                      , text ": +1 piercing damage. "
                      , italic $ text "Area effect"
                      , text ": 1 piercing damage. "
                      , italic $ text "On hit"
                      , text ": All foes in the area must sacrifice "
                      , italic $ dice 1 D3
                      , text " after this ability resolves. "
                      , italic $ ref (Name "Horde") $ text "Horde"
                      , text ": Double sacrifice ammount."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Rahaal"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
                  , description: seq
                      [ text
                          "Chose a character in range. That character chooses:"
                      , list Unordered
                          [ seq
                              [ text "foe: sacrifice 4 or gain 2 "
                              , italic $ ref (Name "Brand") $ text "branded"
                              , text "."
                              ]
                          , text "ally: dash 2 or clear a negative status."
                          ]
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Terrorize"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 3))
                      , LimitTag 1 "combat"
                      ]
                  , description: seq
                      [ italic $ text "Effect"
                      , text
                          """: A foe in range is marked. While marked, they deal
                          half damage. They may ignore this effect while
                          adjacent to an ally. At the end of the turn, they may
                          save to end this mark. End a turn adjacent to an ally,
                          ending this mark."""
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Call the Dead"
                  , cost: One
                  , tags:
                      [ RangeTag Close
                      , AreaTag (Line (NumVar 4))
                      , KeywordTag (Name "Zone")
                      , End
                      , LimitTag 1 "combat"
                      ]
                  , description: seq
                      [ italic $ text "Area Effect"
                      , text
                          """: Creates a one space grasping hands zone under
                          every foe or ally in the area. Any number of these
                          zones can be active. The zones are """
                      , italic
                          $ ref (Name "Difficult Terrain")
                          $ text "difficult terrain"
                      , text " for foes. While inside, foes deal damage "
                      , weakness
                      , text " and abilities used against them trigger all "
                      , italic $ ref (Name "Horde") $ text "horde"
                      , text " effects."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              ]
          }

      , Foe
          { name: Name "Wraith"
          , colour: Name "Blue"
          , class: Name "Artillery"
          , faction: Just $ Name "Relict"
          , chapter: Just I
          , description: text
              """Former slave wrights of the old empire, turned into living
              weapons to fight back against the Doom. Tethered to the network,
              these relict can float on the air with eerie grace, flickering in
              and out of existence."""
          , notes: seq []
          , traits: []
          , abilities:
              [ FoeAbility
                  { name: Name "Gauntlet Bolt"
                  , cost: One
                  , tags:
                      [ Attack
                      , RangeTag (Range (NumVar 1) (NumVar 5))
                      , KeywordTag (Name "Chain")
                      ]
                  , description: seq
                      [ text "1 damage. "
                      , italic $ text "Hit"
                      , text ": +"
                      , dice 1 D6
                      , text ". "
                      , italic $ ref (Name "Horde") $ text "Horde"
                      , text ": Create "
                      , italic
                          $ ref (Name "Dangerous Terrain")
                          $ text "dangerous terrain"
                      , text
                          """ under the target and every adjacent all of the
                          target."""
                      ]
                  , chain: Just $ FoeAbility
                      { name: Name "Chain Lightning"
                      , cost: Two
                      , tags:
                          [ Attack
                          , RangeTag (Range (NumVar 2) (NumVar 6))
                          , AreaTag (Cross (NumVar 3))
                          , KeywordTag (Name "Chain")
                          ]
                      , description: seq
                          [ text "2 damage. "
                          , italic $ text "Hit"
                          , text ": +"
                          , dice 2 D6
                          , text ". "
                          , italic $ text "Area effect"
                          , text ": 2 damage. "
                          , italic $ text "Effect"
                          , text
                              """: Deals 3 damage again to all foes if catching
                              3 or more foes or """
                          , italic $ text "soul sparks"
                          , text " in the area."
                          ]
                      , chain: Nothing
                      , insert: Nothing
                      }
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Rift Tear"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                  , description: seq
                      [ text
                          """Teleport 3. Alternatively, teleport a character in
                          range 1. """
                      , italic $ ref (Name "Horde") $ text "Horde"
                      , text ": Teleport +2."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Soul Spark"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 1) (NumVar 6))
                      , KeywordTag (Name "Summon")
                      ]
                  , description: seq
                      [ text "Create a "
                      , italic $ text "Soul Spark"
                      , text " summon in free space in range."
                      ]
                  , chain: Nothing
                  , insert: Just $ SummonInsert
                      { name: Name "Soul Spark"
                      , colour: Name "Blue"
                      , max: 3
                      , effects:
                          [ seq
                              [ text
                                  """All damage against foes adjacent to soul
                                  sparks gain damage """
                              , power
                              , text " and becomes "
                              , italic $ ref (Name "Pierce") $ text "piercing"
                              , text "."
                              ]
                          ]
                      }
                  }
              ]
          }
      ]
  }
