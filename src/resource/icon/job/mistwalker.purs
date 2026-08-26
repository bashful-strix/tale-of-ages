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
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
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
          , sign: Sign "icon-[game-icons--fog]"
          , soul: Name "Water"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Spies and informants of the highest caliber, trained at
                  secretive guild academies. Mistwalkers use the suffused water
                  Aether in their own bodies to evaporate and re-appear where
                  they will, and use the water in other’s bodies to jerk them
                  around like puppet. They can meld into the low lying fog
                  around the rooftops, or by the riverbanks at morning, always
                  listening and watching."""
              , newline
              , newline
              , text
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
              Id "foundations|talent|mistwalker"
                : Id "vanish|talent|mistwalker"
                : Id "thirst|talent|mistwalker"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Lurker in the Fog"
          , description: seq
              [ text "You ignore "
              , italic $ ref (Name "Cover") $ text "cover"
              , text " from "
              , italic $ ref (Name "Obscured") $ text "obscured"
              , text " spaces. You can swap places with any unoccupied "
              , italic $ text "obscured"
              , text " or "
              , italic $ ref (Name "Adverse Terrain") $ text "adverse"
              , text " terrain space in 1-3 as a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text " ability during your turn."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "foundations|talent|mistwalker"
          , name: Name "Foundations"
          , colour: Name "Blue"
          , description: seq
              [ text
                  """When you start a push or pull against characters standing
                  in """
              , italic $ ref (Name "Adverse Terrain") $ text "adverse"
              , text " terrain, move them +1 more space."
              ]
          }
      , Talent
          { id: Id "vanish|talent|mistwalker"
          , name: Name "Vanish"
          , colour: Name "Blue"
          , description: seq
              [ text "While inside an "
              , italic $ ref (Name "Obscured") $ text "obscured"
              , text " space, attacks not from adjacent spaces take "
              , weakness
              , text " against you."
              ]
          }
      , Talent
          { id: Id "thirst|talent|mistwalker"
          , name: Name "Thirst"
          , colour: Name "Blue"
          , description: text
              "Your attacks deal +1 damage on hit to characters with vigor."
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Vapor Form"
          , colour: Name "Blue"
          , description: text
              """You meld into a wraith of mist, quick, terrifying, and no less
              deadly."""
          , cost: Quick /\ 4
          , tags: [ TargetTag Self ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "For the rest of combat:"
                  , list Unordered
                      [ seq
                          [ text "you gain "
                          , italic $ ref (Name "Phasing") $ text "phasing"
                          , text " and "
                          , italic $ ref (Name "Fly") $ text "flying"
                          , text " when you move"
                          ]
                      , text "you can share space with other characters"
                      , seq
                          [ text "you have "
                          , italic $ ref (Name "Cover") $ text "cover"
                          , text " from all directions"
                          ]
                      , seq
                          [ text "you are both a character and an "
                          , italic $ ref (Name "Obscured") $ text "obscured"
                          , text
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
          , description: text
              """You whip a tendril of mist that steals the air from your
              target's lungs, leaving them stumbling."""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 1) (NumVar 2))
              , AreaTag (Line (NumVar 3))
              ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Any character in the area with vigor loses 2 vigor. If
                      that character is inside an """
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text " space or "
                  , italic $ ref (Name "Adverse Terrain") $ text "adverse"
                  , text " terrain, double this vigor loss."
                  ]
              , AttackStep
                  (text "3 damage")
                  (seq [ text "+", dice 1 D3, text " and pull 1" ])
              , Step AreaEff Nothing $ text "3 damage."
              ]
          }
      , Ability
          { name: Name "Evaporate"
          , colour: Name "Blue"
          , description: text
              """You vaporize a large area of the battlefield, then lash the
              resultant water aether towards you before it reforms."""
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 5))
              , AreaTag (Blast (NumVar 3))
              , TargetTag Foe
              , TargetTag Ally
              , TargetTag Summon
              ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Characters in the area take 3 piercing damage. Then
                      pull all characters and summons in the area """
                  , italic $ dice 1 D3
                  , text "+1 with "
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text
                      """. Characters may pass a save to avoid being pulled. One
                      (3+) two or (5+) all characters pulled this way leave
                      an """
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text " space in the first space they vacate."
                  ]
              ]
          }
      , Ability
          { name: Name "Writhing Wall"
          , colour: Name "Blue"
          , description: text
              """Writhing mists wrap into a barrier that repels even the most
              ferocious warrior, sending them reeling."""
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 2))
              , AreaTag (Line (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ text
                      """You create a line 4 zone of writhing mists. Each space
                      is an """
                  , italic $ ref (Name "Obscured") $ text "obscured"
                  , text " space."
                  ]
              , Step Eff (Just D3) $ seq
                  [ text
                      """In addition, characters that voluntarily enter the
                      space for the first time in a turn or start their turn
                      there are pushed """
                  , italic $ dice 1 D3
                  , text
                      """+1 spaces away from the wall (to a side of your choice
                      if they are in the wall already), interrupting but not
                      ending any movement. Characters with """
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text
                      """ ignore this effect, and characters may choose to pass
                      a save to ignore this effect."""
                  ]
              ]
          }
      , Ability
          { name: Name "Withering Tendrils"
          , colour: Name "Blue"
          , description: text
              """You pull tendrils of mist around you, ready to lash out and
              steal the moisture from your foe's body."""
          , cost: One
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  ( text
                      """Gain one use of the following interrupt until the start
                      of your next turn."""
                  )
                  $ AbilityInset
                      { name: Name "Withering Tendrils"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ AreaTag (Burst (NumVar 2) true) ]
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "A character enters or exits a space in the area."
                          , Step Eff (Just D3) $ seq
                              [ text "Push all characters in the area "
                              , italic $ dice 1 D3
                              , text
                                  """, interrupting but not stopping any
                                  movement. Affected characters with vigor are
                                  pushed +2 more spaces, then lose vigor equal
                                  to the spaces they were pushed."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Impact")) Nothing $ seq
                  [ text "Foes gain "
                  , italic $ ref (Name "Slow") $ text "slow"
                  , text "."
                  ]
              ]
          }
      ]
  }
