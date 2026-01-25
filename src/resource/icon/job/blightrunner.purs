module ToA.Resource.Icon.Job.Blightrunner
  ( blightrunner
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
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

blightrunner :: Icon
blightrunner =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Blightrunner"
          , colour: Name "Yellow"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Few souls are brave or foolhardy enough to brave the blight
                  lands alone. The Blightrunners make a career out of it.
                  Couriers for churner camps, caravans, and city bigwigs, they
                  are ardent trekkers and survivalists, who thrive on the thrill
                  of outrunning foes too monstrous to describe. The paths of the
                  runners are recorded and kept in a great hide skin journal,
                  updated at their meeting every five years, and updated to
                  match current accounts - part of the only reason the
                  blightlands are traversable by ordinary kin at all."""
              , Newline
              , Newline
              , Text
                  """Especially brave runners will make it their duty to forge
                  new and long pathways through toxic and inhospitable lands
                  teeming with monsters - daring each other to match the
                  impossibility of their travels."""
              ]
          , trait: Name "Adrenaline"
          , keyword: Name "Overdrive"
          , abilities:
              (I /\ Name "Baton Pass")
                : (I /\ Name "Toxic Spike")
                : (II /\ Name "Zipline")
                : (IV /\ Name "Viper Sting")
                : empty
          , limitBreak: Name "Burning Sands"
          , talents:
              Name "Twitch"
                : Name "Pulse"
                : Name "Turbo"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Adrenaline"
          , description:
              [ Italic [ Ref (Name "Evasion") [ Text "Evasion" ] ]
              , Text " stacks up to six times on you."
              , List Unordered
                  [ [ Text
                        """Once a round, after you move 3 or more spaces in a
                        straight line without stopping, gain """
                    , Italic [ Text "evasion" ]
                    , Text ", or two stacks if you moved 6 or more space."
                    ]
                  , [ Text
                        """Your attacks deal +damage equal to half your stacks
                        of """
                    , Italic [ Text "evasion" ]
                    , Text
                        """, rounded up, or all your stacks against foes in
                        crisis."""
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "twitch|talent|blightrunner"
          , name: Name "Twitch"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """When you move outside your tun, increase that movement by
                  +2."""
              ]
          }
      , Talent
          { id: Id "pulse|talent|blightrunner"
          , name: Name "Pulse"
          , colour: Name "Yellow"
          , description:
              [ Text
                  "At round 3, increase all movement you make or grant by +1."
              ]
          }
      , Talent
          { id: Id "turbo|talent|blightrunner"
          , name: Name "Turbo"
          , colour: Name "Yellow"
          , description:
              [ Text "Increase the effect of "
              , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
              , Text " for you and adjacent allies to +3 spaces. You gain "
              , Italic [ Text "haste" ]
              , Text " when you are first bloodied in a combat."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Burning Sands"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You infuse your movements with rapid bursts of aether,
                  moving so fast that spurts of flame seem to spring from your
                  feet."""
              ]
          , cost: Quick /\ 2
          , tags: [ TargetTag Self, KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Text
                      """While in this stance, increase all movement you make or
                      grant by half the round number, rounded up. When """
                  , Italic [ Text "you" ]
                  , Text " move in this stance:"
                  , List Unordered
                      [ [ Text "you can "
                        , Italic [ Ref (Name "Phasing") [ Text "phase" ] ]
                        , Text " through foes"
                        ]
                      , [ Text "you "
                        , Italic [ Text "must" ]
                        , Text " move in a straight line"
                        ]
                      , [ Text "you "
                        , Italic [ Text "must" ]
                        , Text " spend all movement available to you"
                        ]
                      ]
                  ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 3)) Nothing
                  [ Text
                      "Ignore any or all of the above effects of your choice."
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "You are "
                  , Ref (Name "Immune") [ Text "immune" ]
                  , Text " to all damage and "
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text " while moving."
                  ]
              ]
          }
      , Ability
          { name: Name "Baton Pass"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Your momentum pushes your allies forward, as you skillfully
                  direct their strikes."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 3." ]
              , AttackStep [ Text "1 damage" ] [ Text "+", Dice 1 D3 ]
              , Step Eff (Just D6)
                  [ Text
                      """One, (4+) two, or (6+) three allies adjacent to your
                      target may also dash 3, then may deal 2 damage to a
                      different adjacent foe."""
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Increase all dashed by +3." ]
              ]
          }
      , Ability
          { name: Name "Toxic Spike"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You shoot a dart imbued with the hallucinogenic venom of
                  the blight lands, critical for escaping huge monsters."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text "Mark a foe in range with a toxic dart. While marked:"
                  , List Unordered
                      [ [ Text "your foe has attack "
                        , Weakness
                        , Text " against all foes not adjacent to them"
                        ]
                      , [ Text
                            """once a round, when your foe misses as attack,
                            they stumble and you may push them """
                        , Dice 1 D3
                        , Text "+1 in any direction"
                        ]
                      ]
                  , Text
                      """A foe may save at the end of their turn to end this
                      mark."""
                  ]
              , Step (KeywordStep (Name "Mark")) Nothing
                  [ Text "Gains a further attack "
                  , Weakness
                  , Text " and push +2."
                  ]
              ]
          }
      , Ability
          { name: Name "Zipline"
          , colour: Name "Yellow"
          , description: [ Text "You go through when you can go over." ]
          , cost: One
          , tags: [ KeywordTag (Name "Zone"), AreaTag (Line (NumVar 4)), End ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and create a line 4 zipline in range, which could
                      overlap characters. You or any ally adjacent to either
                      unoccupied end space of the zipline, may use a quick
                      ability to enter that space, then """
                  , Italic [ Ref (Name "Fly") [ Text "fly" ] ]
                  , Text
                      """ to the other end othe zipline or as far as possible,
                      then gain """
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text "."
                  ]
              , Step Eff Nothing
                  [ Text
                      """Instead of replacing this zone when it is used again,
                      you may choose to extend the existing zone by +4 spaces,
                      added from any end space. It could change directions, and
                      this creates a new end space."""
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Does not end turn." ]
              ]
          }
      , Ability
          { name: Name "Viper Sting"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You turn your enemies' strikes to your own favor, spinning
                  thier own momentum into a deadly force."""
              ]
          , cost: One
          , tags: [ End ]
          , steps:
              [ InsetStep Eff Nothing
                  [ Text "Gain "
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text " and the following interrupt:"
                  ]
                  $ AbilityInset
                      { name: Name "Viper Sting"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                      , steps:
                          [ Step TriggerStep Nothing
                              [ Text "A foe misses an attack." ]
                          , Step Eff Nothing
                              [ Text
                                  """Dash 3. If that puts you adjacent to your
                                  foe, they take 2 damage. If their attack roll
                                  was 5 or less, they take """
                              , Dice 2 D3
                              , Text
                                  """ instead. Double this damage if they are in
                                  crisis."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text "Range +3 and dash +3." ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 4)) Nothing
                  [ Text "Regain the interrupt." ]
              ]
          }
      ]
  }
