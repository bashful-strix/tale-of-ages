module ToA.Resource.Icon.Job.Alchemist
  ( alchemist
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
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
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

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
          , sign: Sign "icon-[game-icons--round-potion]"
          , soul: Name "Earth"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Members of the Invisible Chain, the secretive order of
                  warrior-sages seeking to untangle the mysteries of the
                  physical world, and in turn, life itself. Aether creates form.
                  Form creates Aether. Nothingness and solidity are
                  intertwined."""
              , newline
              , newline
              , text
                  """As Alchemists are generally forbidden from most medical
                  practice in the city guilds, they often act as traveling
                  surgeons, pharmacologists, and doctors to ply their living.
                  Their meetings take place in secret refuges, where they share
                  advanced medical knowledge, secrets of the physical form, and
                  attempt to commandeer the resources of the order towards some
                  project or another of staggering ambition."""
              , newline
              , newline
              , text
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
              Id "elixir|talent|alchemist"
                : Id "effuse|talent|alchemist"
                : Id "purity|talent|alchemist"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Master of Fundaments"
          , description: seq
              [ text
                  """As a quick ability, you may transmute a terrain space in
                  range 1-3. This removes any current effects of the terrain
                  space except elevation. You may then leave the space blank or
                  roll """
              , italic $ dice 1 D3
              , text "."
              , list Ordered
                  [ seq
                      [ bold $ text "Liquid"
                      , text ": The space becomes "
                      , italic
                          $ ref (Name "Dangerous Terrain") $ text "dangerous"
                      , text " or "
                      , italic
                          $ ref (Name "Difficult Terrain") $ text "difficult"
                      , text " terrain (choose)."
                      ]
                  , seq
                      [ bold $ text "Solid"
                      , text ": The space becomes a height 1 object."
                      ]
                  , seq
                      [ bold $ text "Vapor"
                      , text ": The space becomes an "
                      , italic $ ref (Name "Obscured") $ text "obscured"
                      , text " space."
                      ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "elixir|talent|alchemist"
          , name: Name "Elixir"
          , colour: Name "Blue"
          , description: text
              """At round 4+, choose a weave effect from your active abilities.
              It is weaved automatically into every ability you use of action
              cost 1 or greater, except its original ability."""
          }
      , Talent
          { id: Id "effuse|talent|alchemist"
          , name: Name "Effuse"
          , colour: Name "Blue"
          , description: seq
              [ text
                  """Once a combat, as a quick ability, you may target a close
                  blast 2 area. You may change any """
              , italic $ ref (Name "Difficult Terrain") $ text "difficult"
              , text " terrain, "
              , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
              , text " terrain, or "
              , italic $ ref (Name "Obscured") $ text "obscured"
              , text
                  """ spaces in the area to any other one of these three types,
                  or you may remove them entirely."""
              ]
          }
      , Talent
          { id: Id "purity|talent|alchemist"
          , name: Name "Purity"
          , colour: Name "Blue"
          , description: text
              """Once a combat, from the start of your turn until the start of
              your following turn, your free moves you gain or grant go +2
              spaces and grant immunity to adverse terrain."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Homunculus"
          , colour: Name "Blue"
          , description: text
              """Life can be spun up, as the makers once did, out of its base
              elements. The process lacks the finesse, but time will wear away
              all its impurities."""
          , cost: One /\ 3
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 5))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ InsetStep Eff Nothing
                  ( text
                      """You summon a homunculus in free space in range, an
                      artificial being that can shift its form."""
                  )
                  $ SummonInset
                      { name: Name "Homunculus"
                      , colour: Name "Blue"
                      , max: 1
                      , abilities:
                          [ Step Eff Nothing $ text "Size 1."
                          , Step SummonEff Nothing $ seq
                              [ text
                                  """When summoned, choose one of the following
                                  effects:"""
                              , list Unordered
                                  [ seq
                                      [ bold $ text "Liquid"
                                      , text ": The homunculus is "
                                      , italic
                                          $ ref (Name "Difficult Terrain")
                                          $ text "difficult"
                                      , text " and "
                                      , italic
                                          $ ref (Name "Dangerous Terrain")
                                          $ text "dangerous"
                                      , text " terrain and has "
                                      , italic
                                          $ ref (Name "Phase")
                                          $ text "phasing"
                                      , text
                                          """. The first time in a round it passes
                                          through a foe's spaces, it inflicts """
                                      , italic $ ref (Name "Slow") $ text "slow"
                                      , text "."
                                      ]
                                  , seq
                                      [ bold $ text "Solid"
                                      , text
                                          """The homunculus is a height 1
                                          object. It cannot be removed, but
                                          otherwise follows all the rules for
                                          objects. Any characters sharing its
                                          space when it takes this form is moved
                                          up on top of it. When it moves, any
                                          character on top of it is pushed the
                                          same number of spaces, staying on top
                                          of it if possible."""
                                      ]
                                  , seq
                                      [ bold $ text "Vapor"
                                      , text "The homunculus gains "
                                      , italic
                                          $ ref (Name "Fly") $ text "flying"
                                      , text " and is an "
                                      , italic
                                          $ ref (Name "Obscured")
                                          $ text "obscured"
                                      , text " space."
                                      ]
                                  ]
                              ]
                          , Step SummonAction Nothing $ text
                              """The homunculus moves 4, then you may switch
                              the homunculus' effect."""
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Bio"
          , colour: Name "Blue"
          , description: text
              """You command the elements to dissolve - earth and flesh alike
              bursts into a toxic vapor."""
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D3 ])
              , Step OnHit Nothing $ seq
                  [ text "Create "
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text " terrain under your attack target."
                  ]
              , Step Eff Nothing $ seq
                  [ italic $ text "All"
                  , text
                      """ attack and area damage becomes piercing against
                      targets already in """
                  , italic $ text "dangerous"
                  , text " terrain."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing $ seq
                  [ text "Create "
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text
                      """ terrain under a character in range 2-5 after this
                      ability resolves."""
                  ]
              ]
          }
      , Ability
          { name: Name "Realignment"
          , colour: Name "Blue"
          , description: text
              """Using your exhaustive knowledge of anatomies, you quickly
              rearrange energy channels in your target to heal them -
              forcefully."""
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , TargetTag Self
              , TargetTag Ally
              , TargetTag Foe
              ]
          , steps:
              [ Step Eff Nothing $ text
                  """You hit a precise pressure point, purging toxins from your
                  target's body. Remove all negative status tokens on the
                  character, then choose: your target takes 1 piercing damage or
                  gains 1 vigor per status removed."""
              , Step (KeywordStep (Name "Weave")) Nothing $ seq
                  [ text "Create a close blast 2 "
                  , italic $ text "area effect"
                  , text
                      """ from your target after this ability resolves,
                      regardless of range. Create """
                  , italic
                      $ ref (Name "Dangerous Terrain")
                      $ text "dangerous terrain"
                  , text
                      """ in every free space in the area. If your target is a
                      foe, they are then """
                  , italic $ ref (Name "Slow") $ text "slowed"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Transmute"
          , colour: Name "Blue"
          , description: text
              "To the master the fundaments, the world is as smoke."
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)) ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      "Choose an unoccupied terrain space in range, then roll "
                  , italic $ dice 1 D6
                  , text
                      """. The space removes any object or terrain type it has
                      other than elevation, then gains one of the following:"""
                  , list Ordered
                      [ italic
                          $ ref (Name "Difficult Terrain")
                          $ text "Difficult terrain"
                      , italic
                          $ ref (Name "Dangerous Terrain")
                          $ text "Dangerous terrain"
                      , seq
                          [ text "The space becomes "
                          , italic $ ref (Name "Obscured") $ text "obscured"
                          ]
                      , text "Place a height 1 object in the area"
                      , text "Raise or lower terrain by 1"
                      , text "Pick two effects"
                      ]
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing $ text
                  "Repeat the above effect after this ability resolves."
              ]
          }
      , Ability
          { name: Name "Power Pill"
          , colour: Name "Blue"
          , description: text
              """You create a masterwork medicine that floods the target with
              primal aether. This is too much for the unperfected form to
              handle... for now."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , TargetTag Self
              , TargetTag Ally
              ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Your target gains 2 "
                  , italic $ ref (Name "Keen") $ text "keen"
                  , text ", and becomes "
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text " until the end of their next turn."
                  ]
              , Step Eff (Just D3) $ seq
                  [ text "At the end of that turn, they lose "
                  , italic $ text "unstoppable"
                  , text ", become "
                  , italic $ ref (Name "Stun") $ text "stunned"
                  , text
                      """ and release a burst 1 (self) area effect for push 2.
                      Then create """
                  , italic $ dice 1 D3
                  , text " spaces of "
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text
                      """ terrain in free spaces in the area. Characters caught
                      in the explosion already in """
                  , italic $ text "dangerous"
                  , text " terrain take "
                  , dice 2 D3
                  , text " piercing damage."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing $ text
                  """After this ability resolves, self or an ally in range 1-2
                  may make an extra free move."""
              ]
          }
      ]
  }
