module ToA.Resource.Icon.Foe.Factions
  ( factions
  ) where

import ToA.Data.Icon.Foe (Faction(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

factions :: Array Faction
factions =
  [ basic
  , relict
  , beast
  ]

basic :: Faction
basic = Faction
  { name: Name "Basic"
  , description: []
  , template: { description: [], traits: [] }
  , mechanic: { name: Name "", description: [] }
  , keywords: []
  }

relict :: Faction
relict = Faction
  { name: Name "Relict"
  , description:
      [ Text
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
      , Newline
      , Newline
      , Text
          """These networks and their central nodes, the Metachiron,
          have run for untold centuries, using their stored souls as
          power as they enact survival protocols hewn in cuneiform by
          long dead priests."""
      , Newline
      , Newline
      , Text
          """Now the great tomb-cities prepared for the populace now lie
          beneath the earth, both dead and alive. Great monuments of dead
          emperors peer over pitch black chasms lined with the husks of
          the deceased. Relict armor sits eerily still in alcoves, or
          crumpled into a corner, until a node senses intruders, the
          Relict within rippling out through conduits to manifest in
          crackling undeath."""
      , Newline
      , Newline
      , Text
          """There are some Relict, remnants of the Black Sun cult,
          that have retained more sense of themselves and work at dark
          purpose to resurrect the old empire and bring back the
          Arkenlords. These masters of the dead are barely sane from
          their long stint with undeath and think only of returning the
          surface world to its former glory."""
      ]
  , template:
      { description:
          [ Text
              """To make any foe a Relict, you can add the following
              traits. All Relict have these traits."""
          , Newline
          , Newline
          , Text "Most relict are mindless husks and are "
          , Bold [ Text "monsters" ]
          , Text ". Their more intelligent masters are "
          , Bold [ Text "kin" ]
          , Text " and usually have more complex motivations."
          , List Unordered
              [ [ Bold [ Text "Motivations: " ]
                , Text
                    """Relict are usually dormant, but become active
                    when their tomb-cities are intruded upon by unlucky
                    treasure-seekers. They can also be stirred into
                    wakefulness by the priests of the Black Sun, whose
                    only goal is the reawakening of the old empire, the
                    resurrection of the Arkenlords, and the reconquest
                    and total subjugation of the world of the
                    living."""
                ]
              , [ Text
                    """Intelligent Relict are usually delirious or
                    obsessive."""
                ]
              ]
          ]
      , traits: [ Name "Legion of the Dead" ]
      }
  , mechanic:
      { name: Name "Legion of the Dead"
      , description:
          [ Text
              """Relict are a legion of mindless husks, cursed with an
              undying existence. This gives all relict except Legends
              the following traits:"""
          , List Unordered
              [ [ Text "Add a "
                , Bold [ Text "Husk" ]
                , Text
                    """ mob to any non-legend fight. This does not take
                    up points in the encounter."""
                ]
              , [ Text
                    """After being defeated, any relict sheds any of its
                    mortal remains and becomes a weak shade of pure
                    energy. When a relict is defeated, summon a """
                , Bold [ Text "husk" ]
                , Text " in its space, adding to the members of the mob."
                ]
              ]
          ]
      }
  , keywords: [ Name "Sacrifice", Name "Horde" ]
  }

beast :: Faction
beast = Faction
  { name: Name "Beast"
  , description:
      [ Text
          """The ruins are full of wildlife that has adapted to their
          unique environment over time - or have been changed or warped
          by it. Wherever there are dungeons or a Blight, there are Ruin
          Beasts. They are the most common monsters found afield in the
          blight-stricken areas of Arden Eld, and the most likely to
          wander adrift."""
      , Newline
      , Newline
      , Text
          """Beasts fit into a dungeon ecosystem much the same as they do
          in more mundane ecosystems outside of their unnatural
          environments. There are many biologists and naturalists across
          Arden Eld undertaking the hard work of categorizing the
          dizzying number of species that are found every week by
          intrepid adventurers. Many beast organs and excretions are
          extremely useful in medicine, research, industry, and even
          cosmetics, and teams of hunters are often sent out to bag a
          particularly beast once its kind are sighted."""
      , Newline
      , Newline
      , Text
          """Some naturalists are more in favor of conservation, and
          argue that despite their strange origins, the beasts of the
          great dungeons, though dangerous and unusual, should be treated
          as just another part of the natural world. They’re more
          interested in studying the beasts and preventing them from
          harming local communities than actively poaching them."""
      , Newline
      , Newline
      , Text
          """Not all ruin beasts are hostile, and some are in fact quite
          docile unless provoked. However, nearly all of them are capable
          of tremendous bursts of strength and power when enraged, a
          byproduct of their harsh environment - and necessary for
          survival."""
      ]
  , template:
      { description:
          [ Text
              """To make any foe a Beast, you can add the following
              traits. All Beasts have these traits."""
          , Newline
          , Newline
          , Bold [ Text "Monsters: " ]
          , Text
              """Beasts do not negotiate. They might flee if losing a
              fight badly or act out of self preservation."""
          , List Unordered
              [ [ Bold [ Text "Motivations: " ]
                , Text
                    """Beasts have simple motivations, which are
                    typically for territory or food. Ruin beasts in
                    particular are often affected by the blighted
                    energies of unconfined ruins, which can mutate them
                    or drive them sick or mad. Sometimes it is possible
                    to cure these beasts of their afflictions."""
                ]
              ]
          ]
      , traits: [ Name "Enrage" ]
      }
  , mechanic:
      { name: Name "Enrage"
      , description:
          [ Text "While in crisis, take 1/2 damage from all sources." ]
      }
  , keywords: [ Name "Ferocity", Name "Aura" ]
  }
