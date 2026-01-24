module ToA.Resource.Icon.Job.Mistwalker
  ( mistwalker
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
  , Target(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

mistwalker :: Icon
mistwalker =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Mistwalker"
          , colour: Name "Blue"
          , soul: Name "Water"
          , class: Name "Wright"
          , description:
              [ Text
                  """Spies and informants of the highest caliber, trained at
                  secretive guild academies. Mistwalkers use the suffused water
                  Aether in their own bodies to evaporate and re-appear where
                  they will, and use the water in other’s bodies to jerk them
                  around like puppet. They can meld into the low lying fog
                  around the rooftops, or by the riverbanks at morning, always
                  listening and watching."""
              , Newline
              , Newline
              , Text
                  """At their best, members of this order act as a secretive
                  vigilante force, striking from the fog in service of the
                  dispossessed or desperate. At their worst, they act as secret
                  police for guild barons, their name whispered in hushed tones
                  and writ in furtive glances."""
              ]
          , trait: Name "Lurker in the Fog"
          , keyword: Name "Phasing"
          , abilities:
              (I /\ Name "Steal Breath")
                : (I /\ Name "Evaporate")
                : (II /\ Name "Writhing Wall")
                : (IV /\ Name "Withering Tendrils")
                : empty
          , limitBreak: Name "Vapor Form"
          , talents:
              Name "Foundations"
                : Name "Vanish"
                : Name "Thirst"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Lurker in the Fog"
          , description:
              [ Text "You ignore "
              , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
              , Text " from "
              , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
              , Text " spaces. You can swap places with any unoccupied "
              , Italic [ Text "obscured" ]
              , Text " or "
              , Italic [ Ref (Name "Adverse Terrain") [ Text "adverse" ] ]
              , Text " terrain space in 1-3 as a "
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text " ability during your turn."
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Foundations"
          , colour: Name "Blue"
          , description:
              [ Text
                  """When you start a push or pull against characters standing
                  in """
              , Italic [ Ref (Name "Adverse Terrain") [ Text "adverse" ] ]
              , Text " terrain, move them +1 more space."
              ]
          }
      , Talent
          { name: Name "Vanish"
          , colour: Name "Blue"
          , description:
              [ Text "While inside an "
              , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
              , Text " space, attacks not from adjacent spaces take "
              , Weakness
              , Text " against you."
              ]
          }
      , Talent
          { name: Name "Thirst"
          , colour: Name "Blue"
          , description:
              [ Text
                  "Your attacks deal +1 damage on hit to characters with vigor."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Vapor Form"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You meld into a wraith of mist, quick, terrifying, and no
                  less deadly."""
              ]
          , cost: Quick /\ 4
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing
                  [ Text "For the rest of combat:"
                  , List Unordered
                      [ [ Text "you gain "
                        , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                        , Text " and "
                        , Italic [ Ref (Name "Fly") [ Text "flying" ] ]
                        , Text " when you move"
                        ]
                      , [ Text "you can share space with other characters" ]
                      , [ Text "you have "
                        , Italic [ Ref (Name "Cover") [ Text "cover" ] ]
                        , Text " from all directions"
                        ]
                      , [ Text "you are both a character and an "
                        , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                        , Text
                            """ space. Effects cannot remove you, but can move
                            you around if they move or affect terrain."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Steal Breath"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You whip a tendril of mist that steals the air from your
                  target's lungs, leaving them stumbling."""
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 1) (NumVar 2))
              , AreaTag (Line (NumVar 3))
              ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Any character in the area with vigor loses 2 vigor. If
                      that character is inside an """
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text " space of "
                  , Italic [ Ref (Name "Adverse Terrain") [ Text "adverse" ] ]
                  , Text ", double this vigor loss."
                  ]
              , AttackStep
                  [ Text "3 damage" ]
                  [ Text "+", Dice 1 D3, Text " and pull 1"]
              , Step AreaEff Nothing [ Text "3 damage." ]
              ]
          }
      , Ability
          { name: Name "Evaporate"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You vaporize a large area of the battlefield, then lash the
                  resultant water aether towards you before it reforms."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 5))
              , AreaTag (Blast (NumVar 3))
              , TargetTag Foe
              , TargetTag Ally
              , TargetTag Summon
              ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Characters in the area take 3 piercing damage. Then
                      pull all characters and summons in the area """
                  , Italic [ Dice 1 D3 ]
                  , Text "+1 with "
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text
                      """. Character may pass a save to avoid being pulled. One
                      (3+) two or (5+) all characters pulled this way leave
                      an """
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text " space in the ifrst space they vacate."
                  ]
              ]
          }
      , Ability
          { name: Name "Writhing Wall"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Writhing mists wrap into a barrier that repels even the
                  most ferocious warrior, sending them reeling."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , AreaTag (Line (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """You create a line 4 zone of writhing mists. Each space
                      is an """
                  , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                  , Text " space."
                  ]
              , Step Eff (Just D3)
                  [ Text
                      """In addition, characters that voluntarily enter the
                      space for the first time in a turn or start their turn
                      there are pushed """
                  , Italic [ Dice 1 D3 ]
                  , Text
                      """+1 spaces away from the wall (to a side of your choice
                      if they are in the wall already), interrupting but not
                      ending any movement. Characters with """
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text
                      """ ignore this effect, and characters may choose to pass
                      a save to ignore this effect."""
                  ]
              ]
          }
      , Ability
          { name: Name "Withering Tendrils"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You pull tendrils of mist around you, ready to lash out and
                  steal the moisture from your foe's body."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  [ Text
                      """Gain one use of the following interrupt until the start
                      of your next turn."""
                  ]
                  $ AbilityInset
                      { name: Name "Withering Tendrils"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ AreaTag (Burst (NumVar 2) true) ]
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text
                                  """A character enters or exits a space in the
                                  area."""
                              ]
                          , Step Eff (Just D3)
                              [ Text "Push all characters in the area "
                              , Italic [ Dice 1 D3 ]
                              , Text
                                  """, interrupting but not stopping any
                                  movement. Affected characters with vigor are
                                  pushed +2 more spaces, then lose vigor equal
                                  to the spaces they were pushed."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Impact")) Nothing
                  [ Text "Foes gain "
                  , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                  , Text "."
                  ]
              ]
          }
      ]
  }
