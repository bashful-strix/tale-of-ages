module ToA.Resource.Icon.Foe.Beast
  ( beast
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
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
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))

beast :: Icon
beast =
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
          { name: Name "Beast"
          , description: seq
              [ text
                  """The ruins are full of wildlife that has adapted to their
                  unique environment over time - or have been changed or warped
                  by it. Wherever there are dungeons or a Blight, there are Ruin
                  Beasts. They are the most common monsters found afield in the
                  blight-stricken areas of Arden Eld, and the most likely to
                  wander adrift."""
              , newline
              , newline
              , text
                  """Beasts fit into a dungeon ecosystem much the same as they
                  do in more mundane ecosystems outside of their unnatural
                  environments. There are many biologists and naturalists across
                  Arden Eld undertaking the hard work of categorizing the
                  dizzying number of species that are found every week by
                  intrepid adventurers. Many beast organs and excretions are
                  extremely useful in medicine, research, industry, and even
                  cosmetics, and teams of hunters are often sent out to bag a
                  particularly beast once its kind are sighted."""
              , newline
              , newline
              , text
                  """Some naturalists are more in favor of conservation, and
                  argue that despite their strange origins, the beasts of the
                  great dungeons, though dangerous and unusual, should be
                  treated as just another part of the natural world. They’re
                  more interested in studying the beasts and preventing them
                  from harming local communities than actively poaching them."""
              , newline
              , newline
              , text
                  """Not all ruin beasts are hostile, and some are in fact quite
                  docile unless provoked. However, nearly all of them are
                  capable of tremendous bursts of strength and power when
                  enraged, a byproduct of their harsh environment - and
                  necessary for survival."""
              ]
          , template:
              { description: seq
                  [ text
                      """To make any foe a Beast, you can add the following
                      traits. All Beasts have these traits."""
                  , newline
                  , newline
                  , bold $ text "Monsters: "
                  , text
                      """Beasts do not negotiate. They might flee if losing a
                      fight badly or act out of self preservation."""
                  , list Unordered
                      [ seq
                          [ bold $ text "Motivations: "
                          , text
                              """Beasts have simple motivations, which are
                              typically for territory or food. Ruin beasts in
                              particular are often affected by the blighted
                              energies of unconfined ruins, which can mutate
                              them or drive them sick or mad. Sometimes it is
                              possible to cure these beasts of their
                              afflictions."""
                          ]
                      ]
                  ]
              , traits: [ Name "Enrage" ]
              }
          , mechanic:
              { name: Name "Enrage"
              , description: text
                  "While in crisis, take 1/2 damage from all sources."
              }
          , keywords: [ Name "Ferocity", Name "Aura" ]
          }
      ]

  , keywords:
      [ Keyword
          { name: Name "Enrage"
          , category: General
          , description: text
              "When in crisis, take 1/2 damage from all sources."
          }
      , Keyword
          { name: Name "Ferocity"
          , category: General
          , description: text
              "Triggers additional effects while this character is bloodied."
          }
      ]

  , foes:
      [ Foe
          { name: Name "Halitoad"
          , colour: Name "Red"
          , class: Name "Heavy"
          , faction: Just $ Name "Beast"
          , chapter: Just I
          , description: text
              """The enormous and foul-smelling Halitoad uses its long tongue to
              strangle and digest its prey"""
          , notes: seq []
          , traits:
              [ FoeTrait
                  { name: Name "Stench"
                  , description: seq
                      [ text "Adjacent foes deal damage ", weakness ]
                  }
              ]
          , abilities:
              [ FoeAbility
                  { name: Name "Buffeting Burp"
                  , cost: Two
                  , tags: [ Attack, RangeTag Close, AreaTag (Blast (NumVar 2)) ]
                  , description: seq
                      [ text "3 damage. "
                      , italic $ text "Hit"
                      , text " +"
                      , dice 1 D6
                      , text ". "
                      , italic $ text "Area effect"
                      , text ": 3 damage and push 1. "
                      , italic $ text "Ferocity"
                      , text ": Base damage and area damage +1, close blast 4."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Gob Spit"
                  , cost: One
                  , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                  , description: seq
                      [ text
                          """A character in range has a difficult terrain space
                          created under them, then must save or become """
                      , italic $ ref (Name "Daze") $ text "dazed"
                      , text
                          """. If it's an ally, they additionally gain 2 vigor,
                          + """
                      , dice 1 D6
                      , text " if they are in crisis."
                      ]
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Tongue Flick"
                  , cost: One
                  , tags:
                      [ RangeTag (Range (NumVar 2) (NumVar 3))
                      , KeywordTag (Name "Repeatable")
                      ]
                  , description: text
                      "The Halitoad pulls a character in range 1."
                  , chain: Nothing
                  , insert: Nothing
                  }
              , FoeAbility
                  { name: Name "Bulky Block"
                  , cost: One
                  , tags: [ End ]
                  , description: seq
                      [ text "Gain "
                      , italic $ ref (Name "Shield") $ text "shield"
                      , text
                          """ and the following interrupt until the start of its
                          next turn. """
                      , italic $ text "Ferocity"
                      , text ": Interrupt 2."
                      ]
                  , chain: Nothing
                  , insert: Just $ AbilityInsert
                      { name: Name "Block"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "This character or an adjacent ally is attacked."
                          , Step Eff Nothing $ text
                              "The attack deals 1/2 damage."
                          ]
                      }
                  }
              ]
          }
      ]
  }
