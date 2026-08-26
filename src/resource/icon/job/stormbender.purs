module ToA.Resource.Icon.Job.Stormbender
  ( stormbender
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
import ToA.Data.Icon.Markup (bold, dice, italic, newline, ref, seq, text)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

stormbender :: Icon
stormbender =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Stormbender"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--lightning-storm]"
          , soul: Name "Water"
          , class: Name "Wright"
          , description: seq
              [ text
                  """The seas of Arden Eld are its most treacherous terrain.
                  Boiling over with monsters, and wracked with unnatural and
                  freakish weather, most folk prefer to give them wide berth.
                  However, there are still those brave and hardy souls that live
                  on the islands around Arden Eld, and the merchants, sailors,
                  and travelers that rely on the sea for fast passage and the
                  movement of cargo, the lifeblood of the continent's great
                  cities."""
              , newline
              , newline
              , text
                  """The Stormbenders are the great masters of the sea, the
                  supreme navigators that make sailing even possible around
                  Arden Eld. Water-attuned wrights, they are most at home on a
                  deck, or clambering the rigging. Each of them are sailors of
                  the highest caliber, coming from all over - old trade guilds,
                  islander clans, and nautical churner enclaves."""
              , newline
              , newline
              , text
                  """Bending the essence of the sea to their beck and call, the
                  Stormbenders can clear the skies with a swipe of their hands,
                  feel the currents ahead for aquatic monsters, turn weather
                  away from the hull of the ship, and blow wind into its sails.
                  It doesn't matter that many of them dabble in a little light
                  piracy on the side - they are the undisputed masters of their
                  element, and they wouldn't have it any other way."""
              ]
          , trait: Name "Dash on the Rocks"
          , keyword: Name "Impact"
          , abilities:
              (I /\ Name "Aqua")
                : (I /\ Name "Heave-Ho")
                : (II /\ Name "Deepwrath")
                : (IV /\ Name "Waterspout")
                : empty
          , limitBreak: Name "Tsunami"
          , talents:
              Id "trip|talent|stormbender"
                : Id "swell|talent|stormbender"
                : Id "whirlpool|talent|stormbender"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Dash on the Rocks"
          , description: seq
              [ text "Once a round, when you cause a character to "
              , bold $ ref (Name "Impact") $ text "impact"
              , text
                  """, you can cause them to release a burst 1 (target)
                  explosion of icy water centered on them, dealing """
              , dice 1 D3
              , text
                  """ piercing damage to all characters within except the
                  original character."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "trip|talent|stormbender"
          , name: Name "Trip"
          , colour: Name "Blue"
          , description: seq
              [ text "Once a combat, you can activate any "
              , italic $ ref (Name "Impact") $ text "impact"
              , text " effect if a character enters an "
              , italic $ ref (Name "Adverse Terrain") $ text "adverse"
              , text " terrain space during a push or pull."
              ]
          }
      , Talent
          { id: Id "swell|talent|stormbender"
          , name: Name "Swell"
          , colour: Name "Blue"
          , description: text
              """Once a combat, you may increase the size of a burst you create
              by +2."""
          }
      , Talent
          { id: Id "whirlpool|talent|stormbender"
          , name: Name "Whirlpool"
          , colour: Name "Blue"
          , description: text
              """When a summon would push or pull a character, increase that
              push or pull by +1. When you would push or pull a summon, increase
              that push or pull by +1."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Tsunami"
          , colour: Name "Blue"
          , description: seq
              [ text "On account of the magic that is in my body,"
              , newline
              , text "Turn aside, detested of Sea and Storm."
              , newline
              , text "Thou wretch, go with thy face diverted!"
              , newline
              , text "Be scattered like dust, and feed the wind!"
              ]
          , cost: Two /\ 3
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  ( text
                      """Create a huge swell of elemental water in free space in
                      range."""
                  )
                  $ SummonInset
                      { name: Name "Tsunami"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step Eff Nothing $ text "Size 2."
                          , Step SummonEff Nothing $ seq
                              [ text "Counts as "
                              , italic
                                  $ ref (Name "Difficult Terrain")
                                  $ text "difficult"
                              , text
                                  """ terrain and can enter character's spaces
                                  and end sharing a space with them."""
                              ]
                          , Step SummonAction Nothing $ text
                              """Move your tsunami 4 spaces towards an edge of
                              the map. It must move the maximum spaces possible,
                              and ignores terrain and obstruction. If this would
                              move the tsunami off the map, dismiss it."""
                          , Step SummonEff Nothing $ seq
                              [ text
                                  """The first time in a round the tsunami would
                                  enter the space of any character with its
                                  summon action they are pushed spaces equal to
                                  the round number +2, choosing the order if
                                  characters are pushed simultaneously. If
                                  they """
                              , bold $ ref (Name "Impact") $ text "impact"
                              , text " during this movement, they take "
                              , dice 1 D6
                              , text "+2 damage, but no more than once a round."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Aqua"
          , colour: Name "Blue"
          , description: text
              """A tendril of icy water batters your foes, sweeping landlubbers
              off their legs."""
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 6)) ]
          , steps:
              [ AttackStep (text "3 damage") $ seq [ text "+", dice 1 D3 ]
              , Step AreaEff Nothing $ text "3 damage."
              , Step OnHit (Just D6) $ text
                  "Push or (4+) pull all characters inside the area 1."
              , Step (KeywordStep (Name "Impact")) Nothing $ seq
                  [ text "Create "
                  , italic $ ref (Name "Difficult Terrain") $ text "difficult"
                  , text " terrain under a character."
                  ]
              ]
          }
      , Ability
          { name: Name "Heave-Ho"
          , colour: Name "Blue"
          , description: text
              """You call a swell of the sea out of thin air, blasting your foes
              with a wave."""
          , cost: Two
          , tags:
              [ AreaTag (Blast (NumVar 4))
              , RangeTag (Range (NumVar 3) (NumVar 5))
              ]
          , steps:
              [ Step AreaEff (Just D3) $ seq
                  [ text "Push all characters "
                  , italic $ dice 1 D3
                  , text "+1 in the same direction. You may push in any order."
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing $ seq
                  [ text "Character takes "
                  , dice 1 D6
                  , text "+4 damage (save for half) and becomes "
                  , italic $ ref (Name "Slow") $ text "slow"
                  , text " on a failed save. "
                  , italic $ ref (Name "Afflicted") $ text "Afflicted"
                  , text " characters have "
                  , italic $ ref (Name "Difficult Terrain") $ text "difficult"
                  , text " terrain created under them."
                  ]
              ]
          }
      , Ability
          { name: Name "Deepwrath"
          , colour: Name "Blue"
          , description: text
              """You mark your foe with the symbol of the Deep Water Titan. No
              matter where they step, the deeps come up to claim them."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 6))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) (Just D3) $ seq
                  [ text
                      """Mark a character in range. While marked, at the end of
                      their turn, push or pull them """
                  , italic $ dice 1 D3
                  , text " spaces, then create "
                  , italic $ ref (Name "Difficult Terrain") $ text "difficult"
                  , text
                      """ terrain under them. Then they may save, ending this
                      mark on success."""
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing $ seq
                  [ text
                      """Drag target under, removing them from the battlefield,
                      then placing them in any other space in range 3 before
                      creating """
                  , italic $ text "difficult"
                  , text " terrain under them."
                  ]
              ]
          }
      , Ability
          { name: Name "Waterspout"
          , colour: Name "Blue"
          , description: text
              """You grab the reigns of the storm and pull it to earth, causing
              a rippling tornado of water."""
          , cost: Two
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  (text "Summon a waterspout in a free space in range.")
                  $ SummonInset
                      { name: Name "Waterspout"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step Eff Nothing $ text "Size 1."
                          , Step SummonEff Nothing $ seq
                              [ text "The summon is also an "
                              , italic $ ref (Name "Obscured") $ text "obscured"
                              , text " space."
                              ]
                          , Step SummonEff Nothing $ seq
                              [ text
                                  """The first time in a round any character or
                                  summon enters the waterspout's spaces for any
                                  reason, they are sucked in and removed from
                                  the battlefield until the end of the current
                                  turn. At the end of that turn, spit them out.
                                  Foes are pushed 3, and allies may """
                              , italic $ ref (Name "Fly") $ text "fly"
                              , text " 3."
                              ]
                          , Step (KeywordStep (Name "Impact")) Nothing $ seq
                              [ text "Foes take "
                              , dice 1 D6
                              , text "+2 damage and gain "
                              , italic $ ref (Name "Slow") $ text "slow"
                              , text "."
                              ]
                          , Step SummonAction Nothing $ text
                              """Attempt to suck in a character in range 1-2,
                              with the same effect as above. Foes can pass a
                              save to avoid this effect, but can be pushed or
                              pulled 1 on a successful save."""
                          ]
                      }
              , Step (KeywordStep (Name "Conserve")) Nothing $ text
                  "Reduce action cost to 1."
              ]
          }
      ]
  }
