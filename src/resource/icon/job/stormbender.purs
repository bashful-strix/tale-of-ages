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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
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
          , soul: Name "Water"
          , class: Name "Wright"
          , description:
              [ Text
                  """The seas of Arden Eld are its most treacherous terrain.
                  Boiling over with monsters, and wracked with unnatural and
                  freakish weather, most folk prefer to give them wide berth.
                  However, there are still those brave and hardy souls that live
                  on the islands around Arden Eld, and the merchants, sailors,
                  and travelers that rely on the sea for fast passage and the
                  movement of cargo, the lifeblood of the continent’s great
                  cities."""
              , Newline
              , Newline
              , Text
                  """The Stormbenders are the great masters of the sea, the
                  supreme navigators that make sailing even possible around
                  Arden Eld. Water-attuned wrights, they are most at home on a
                  deck, or clambering the rigging. Each of them are sailors of
                  the highest caliber, coming from all over - old trade guilds,
                  islander clans, and nautical churner enclaves."""
              , Newline
              , Newline
              , Text
                  """Bending the essence of the sea to their beck and call, the
                  Stormbenders can clear the skies with a swipe of their hands,
                  feel the currents ahead for aquatic monsters, turn weather
                  away from the hull of the ship, and blow wind into its sails.
                  It doesn’t matter that many of them dabble in a little light
                  piracy on the side - they are the undisputed masters of their
                  element, and they wouldn’t have it any other way."""
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
              Name "Trip"
                : Name "Swell"
                : Name "Whirlpool"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Dash on the Rocks"
          , description:
              [ Text "Once a round, when you cause a character to "
              , Bold [ Ref (Name "Impact") [ Text "impact" ] ]
              , Text
                  """, you can cause them to release a burst 1 (target)
                  explosion of icy water centered on them, dealing """
              , Dice 1 D3
              , Text
                  """ piercing damage to all characters within except the
                  original character."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Trip"
          , colour: Name "Blue"
          , description:
              [ Text "Once a combat, you can activate any "
              , Italic [ Ref (Name "Impact") [ Text "impact" ] ]
              , Text " effect a character enters an "
              , Italic [ Ref (Name "Adverse Terrain") [ Text "adverse" ] ]
              , Text " terrain space during a push or pull."
              ]
          }
      , Talent
          { name: Name "Swell"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Once a combat, you may increase the size of a burst you
                  create by +2."""
              ]
          }
      , Talent
          { name: Name "Whirlpool"
          , colour: Name "Blue"
          , description:
              [ Text
                  """When a summon would push or pull a character, increase that
                  push or pull by +1. When you would push or pull a summon,
                  increase that push or pull by +1."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Tsunami"
          , colour: Name "Blue"
          , description:
              [ Text "On account of the magic that is in my body,"
              , Newline
              , Text "Turn aside, detested of Sea and Storm."
              , Newline
              , Text "Thou wretch, go with thy face diverted!"
              , Newline
              , Text "Be scattered like dust, and feed the wind!"
              ]
          , cost: Two /\ 3
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 2))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  [ Text
                      """Create a huge swell of elemental water in free space in
                      range."""
                  ]
                  $ SummonInset
                      { name: Name "Tsunami"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step Eff Nothing [ Text "Size 2." ]
                          , Step SummonEff Nothing
                              [ Text "Counts as "
                              , Italic
                                  [ Ref
                                      (Name "Difficult Terrain")
                                      [ Text "difficult" ]
                                  ]
                              , Text
                                  """ terrain and can enter character's spaces
                                  and end sharing a space with them."""
                              ]
                          , Step SummonAction Nothing
                              [ Text
                                  """Move your tsunami 4 spaces towards an edge
                                  of the map. It must move the maximum spaces
                                  possible, and ignores terrain and obstruction.
                                  If this would move the tsunami off the map,
                                  dismiss it."""
                              ]
                          , Step SummonEff Nothing
                              [ Text
                                  """The first time in a round the tsunami would
                                  enter the space of any character with its
                                  summon action they are pushed spaces equal to
                                  the round number +2, choosing the order if
                                  characters are pushed simultaneously. If
                                  they """
                              , Bold [ Ref (Name "Impact") [ Text "impact" ] ]
                              , Text " during this movement, they take "
                              , Dice 1 D6
                              , Text "+2 damage, but no more than once a round."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Aqua"
          , colour: Name "Blue"
          , description:
              [ Text
                  """A tendril of icy water batters your foes, sweeping
                  landlubbers off their legs."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 6)) ]
          , steps:
              [ AttackStep [ Text "3 damage" ] [ Text "+", Dice 1 D3 ]
              , Step AreaEff Nothing [ Text "3 damage." ]
              , Step OnHit (Just D6)
                  [ Text "Push or (4+) pull all characters inside the area 1." ]
              , Step (KeywordStep (Name "Impact")) Nothing
                  [ Text "Create "
                  , Italic
                      [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
                  , Text " terrain under a character."
                  ]
              ]
          }
      , Ability
          { name: Name "Heave-Ho"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You call a swell of the sea out of thin air, blasting your
                  foes with a wave."""
              ]
          , cost: Two
          , tags:
              [ AreaTag (Blast (NumVar 4))
              , RangeTag (Range (NumVar 3) (NumVar 5))
              ]
          , steps:
              [ Step AreaEff (Just D3)
                  [ Text "Push all characters "
                  , Italic [ Dice 1 D3 ]
                  , Text "+1 in the same direction. You may push in any order."
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing
                  [ Text "Character takes "
                  , Dice 1 D6
                  , Text "+4 damage (save for half) and becomes "
                  , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                  , Text " on a failed save. "
                  , Italic [ Ref (Name "Afflicted") [ Text "Afflicted" ] ]
                  , Text " characters have "
                  , Italic
                      [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
                  , Text " terrain created under them."
                  ]
              ]
          }
      , Ability
          { name: Name "Deepwrath"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You mark your foe with teh symbol of the Deep Water Titan.
                  No matter where they step, the deeps come up to claim them."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 6))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) (Just D3)
                  [ Text
                      """Mark a character in range. While marked, at the end of
                      their turn, push or pull them """
                  , Italic [ Dice 1 D3 ]
                  , Text " spaces, then create "
                  , Italic
                      [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
                  , Text
                      """ terrain under them. Then they may save, ending this
                      mark on success."""
                  ]
              , Step (KeywordStep (Name "Impact")) Nothing
                  [ Text
                      """Drag target under, removing them from the battlefield,
                      then placing them in any other space in range 3 before
                      creating """
                  , Italic [ Text "difficult" ]
                  , Text " terrain under them."
                  ]
              ]
          }
      , Ability
          { name: Name "Waterspout"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You grab the reigns of the storm and pull it to earth,
                  causing a rippling tornado of water."""
              ]
          , cost: Two
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  [ Text "Summon a waterspout in a free space in range." ]
                  $ SummonInset
                      { name: Name "Waterspout"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step Eff Nothing [ Text "Size 1." ]
                          , Step SummonEff Nothing
                              [ Text "The summon is also an "
                              , Italic
                                  [ Ref (Name "Obscured") [ Text "obscured" ] ]
                              , Text " space."
                              ]
                          , Step SummonEff Nothing
                              [ Text
                                  """The first time in a round any character or
                                  summon enters the waterspout's spaces for any
                                  reason, they are sucked in and removed from
                                  the battlefield until the end of the current
                                  turn. At the end of that turn, spit them out.
                                  Foes are pushed 3, and allies may """
                              , Italic [ Ref (Name "Fly") [ Text "fly" ] ]
                              , Text " 3."
                              ]
                          , Step (KeywordStep (Name "Impact")) Nothing
                              [ Text "Foes take "
                              , Dice 1 D6
                              , Text "+2 damage and gain "
                              , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                              , Text "."
                              ]
                          , Step SummonAction Nothing
                              [ Text
                                  """Attempt to suck in a character in range
                                  1-2, with the same effect as above. Foes can
                                  pass a save to avoid this effect, but can be
                                  pushed or pulled 1 on a successful save."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Conserve")) Nothing
                  [ Text "Reduce action cost to 1." ]
              ]
          }
      ]
  }
