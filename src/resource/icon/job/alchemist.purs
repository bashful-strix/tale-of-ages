module ToA.Resource.Icon.Job.Alchemist
  ( alchemist
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
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

alchemist :: Icon
alchemist =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Alchemist"
          , colour: Name "Blue"
          , soul: Name "Earth"
          , class: Name "Wright"
          , description:
              [ Text
                  """Members of the Invisible Chain, the secretive order of
                  warrior-sages seeking to untangle the mysteries of the
                  physical world, and in turn, life itself. Aether creates form.
                  Form creates Aether. Nothingness and solidity are
                  intertwined."""
              , Newline
              , Newline
              , Text
                  """As Alchemists are generally forbidden from most medical
                  practice in the city guilds, they often act as traveling
                  surgeons, pharmacologists, and doctors to ply their living.
                  Their meetings take place in secret refuges, where they share
                  advanced medical knowledge, secrets of the physical form, and
                  attempt to commander the resources of the order towards some
                  project or another of staggering ambition."""
              , Newline
              , Newline
              , Text
                  """All things can be broken into their elements, and in turn,
                  purified and reformed. The body is no different."""
              ]
          , trait: Name "Master of Fundaments"
          , keyword: Name "Weave"
          , abilities:
              (I /\ Name "Bio")
                : (I /\ Name "Realignment")
                : (II /\ Name "Transmute")
                : (IV /\ Name "Power Pill")
                : empty
          , limitBreak: Name "Homunculus"
          , talents:
              Name "Elixir"
                : Name "Effuse"
                : Name "Purity"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Master of Fundaments"
          , description:
              [ Text
                  """As a quick ability, you may transmute a terrain space in
                  range 1-3. This removes any current effects of the terrain
                  space except elevation. You may then leave the space blank or
                  roll """
              , Italic [ Dice 1 D3 ]
              , Text "."
              , List Ordered
                  [ [ Bold [ Text "Liquid" ]
                    , Text ": The space becomes "
                    , Italic
                        [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                    , Text " or "
                    , Italic
                        [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
                    , Text " terrain (choose)."
                    ]
                  , [ Bold [ Text "Solid" ]
                    , Text ": The space becomes a height 1 object."
                    ]
                  , [ Bold [ Text "Vapor" ]
                    , Text ": The space becomes an "
                    , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                    , Text " space."
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Elixir"
          , colour: Name "Blue"
          , description:
              [ Text
                  """At round 4+, choose a weave effect from your active
                  abilities. It is weaved automatically into every ability you
                  use of action cost 1 or greater, except its original
                  ability."""
              ]
          }
      , Talent
          { name: Name "Effuse"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Once a combat, as a quick ability, you may target a close
                  blast 2 area. You may change any """
              , Italic [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
              , Text " terrain, "
              , Italic [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
              , Text " terrain, or "
              , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
              , Text
                  """ spaces in the area to any other one of these three types,
                  or you may remove them entirely."""
              ]
          }
      , Talent
          { name: Name "Purity"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Once a combat, from the start of your turn until the start
                  of your following turn, your free moves you gain or grant go
                  +2 spaces and grant immunity to adverse terrain."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Homunculus"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Life can be spun up, as the makers once did, out of its
                  base elements. The process lacks the finesse, but time will
                  wear away all its impurities."""
              ]
          , cost: One /\ 3
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 5))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ InsetStep Eff Nothing
                  [ Text
                      """You summon a homunculus in free space in range, an
                      artificial being that can shift its form."""
                  ]
                  $ SummonInset
                      { name: Name "Homunculus"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step Eff Nothing [ Text "Size 1." ]
                          , Step SummonEff Nothing
                              [ Text
                                  """When summoned, choose one of the following
                                  effects:"""
                              , List Unordered
                                  [ [ Bold [ Text "Liquid" ]
                                    , Text ": The homunculus is "
                                    , Italic
                                        [ Ref
                                            (Name "Difficult Terrain")
                                            [ Text "difficult" ]
                                        ]
                                    , Text " and "
                                    , Italic
                                        [ Ref
                                            (Name "Dangerous Terrain")
                                            [ Text "dangerous" ]
                                        ]
                                    , Text " terrain and has "
                                    , Italic
                                        [ Ref
                                            (Name "Phase")
                                            [ Text "phasing" ]
                                        ]
                                    , Text
                                        """. The first time in a round it passes
                                        through a foe's spaces, it inflicts """
                                    , Italic
                                        [ Ref (Name "Slow") [ Text "slow" ] ]
                                    , Text "."
                                    ]
                                  , [ Bold [ Text "Solid" ]
                                    , Text
                                        """The homunculus is a height 1 object.
                                        It cannot be removed, but otherwise
                                        follows all the rules for objects. Any
                                        characters sharing its space when it
                                        takes this form is moved up on top of
                                        it. When it moves, any character on top
                                        of it is pushed the same number of
                                        spaces, staying on top of it if
                                        possible."""
                                    ]
                                  , [ Bold [ Text "Vapor" ]
                                    , Text "The homunculus gains "
                                    , Italic
                                        [ Ref (Name "Fly") [ Text "flying" ] ]
                                    , Text " and is an "
                                    , Italic
                                        [ Ref
                                            (Name "Obscured")
                                            [ Text "obscured" ]
                                        ]
                                    , Text " space."
                                    ]
                                  ]
                              ]
                          , Step SummonAction Nothing
                              [ Text
                                  """The homunculus moves 4, then you may switch
                                  the homunculus' effect."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Bio"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You command the elements to dissovle - earth and flesh
                  alike bursts into a toxic vapor."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step OnHit Nothing
                  [ Text "Create "
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text " terrain under your attack target."
                  ]
              , Step Eff Nothing
                  [ Italic [ Text "All" ]
                  , Text
                      """ attack and area damage becomes piercing against
                      targets already in """
                  , Italic [ Text "dangerous" ]
                  , Text " terrain."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text "Create "
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text
                      """ terrain under a character in range 2-5 after this
                      ability resolves."""
                  ]
              ]
          }
      , Ability
          { name: Name "Realignment"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Using your exhaustive knowledge of anatomies, you quickly
                  rearrange energy channels in your target to heal them -
                  forcefully."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , TargetTag Self
              , TargetTag Ally
              , TargetTag Foe
              ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """You hit a precise pressure point, purging toxins from
                      your target's body. Remove all negative status tokens on
                      the character, then choose: your target takes 1 piercing
                      damage or gains 1 vigor per status removed."""
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text "Create a close blast 2 "
                  , Italic [ Text "area effect" ]
                  , Text
                      """ from your target after this ability resolves,
                      regardless of range. Create """
                  , Italic
                      [ Ref
                          (Name "Dangerous Terrain")
                          [ Text "dangerous terrain" ]
                      ]
                  , Text
                      """ in every free space in the area. If your target is a
                      foe, they are then """
                  , Italic [ Ref (Name "Slow") [ Text "slowed" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Transmute"
          , colour: Name "Blue"
          , description:
              [ Text "To the master the fundaments, the world is as smoke." ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)) ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      "Choose an unoccupied terrain space in range, then roll "
                  , Italic [ Dice 1 D6 ]
                  , Text
                      """. The space removes any object or terrain type it has
                      other than elevation, then gains one of the following:"""
                  , List Ordered
                      [ [ Italic
                            [ Ref
                                (Name "Difficult Terrain")
                                [ Text "Difficult terrain" ]
                            ]
                        ]
                      , [ Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "Dangerous terrain" ]
                            ]
                        ]
                      , [ Text "The space becomes "
                        , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                        ]
                      , [ Text "Place a height 1 object in the area" ]
                      , [ Text "Raise or lower terrain by 1" ]
                      , [ Text "Pick two effects" ]
                      ]
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text "Repeat the above effect after this ability resolves."
                  ]
              ]
          }
      , Ability
          { name: Name "Power Pill"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You create a masterwork medicine that floods the target
                  with primal aether. This is too much for the unperfected form
                  to handle... for now."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , TargetTag Self
              , TargetTag Ally
              ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Your target gains 2 "
                  , Italic [ Ref (Name "Keen") [ Text "keen" ] ]
                  , Text ", and becomes "
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text " until the end of their next turn."
                  ]
              , Step Eff (Just D3)
                  [ Text "At the end of that turn, they lose "
                  , Italic [ Text "unstoppable" ]
                  , Text ", become "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text
                      """ and release a burst 1 (self) area effect for push 2.
                      Then create """
                  , Italic [ Dice 1 D3 ]
                  , Text " spaces of "
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text
                      """ in terrain in free spaces in the area. Characters
                      caught in the explosion alrady in """
                  , Italic [ Text "dangerous" ]
                  , Text " terrain take "
                  , Dice 2 D3
                  , Text " piercing damage."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text
                        """After this ability resolves, self or an ally in range
                        1-2 may make an extra free move."""
                  ]
              ]
          }
      ]
  }
