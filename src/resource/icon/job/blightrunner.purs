module ToA.Resource.Icon.Job.Blightrunner
  ( blightrunner
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
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
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

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
          , sign: Sign "icon-[game-icons--sprint]"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """Few souls are brave or foolhardy enough to brave the blight
                  lands alone. The Blightrunners make a career out of it.
                  Couriers for churner camps, caravans, and city bigwigs, they
                  are ardent trekkers and survivalists, who thrive on the thrill
                  of outrunning foes too monstrous to describe. The paths of the
                  runners are recorded and kept in a great hide skin journal,
                  updated at their meeting every five years, and updated to
                  match current accounts - part of the only reason the
                  blightlands are traversable by ordinary kin at all."""
              , newline
              , newline
              , text
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
              Id "twitch|talent|blightrunner"
                : Id "pulse|talent|blightrunner"
                : Id "turbo|talent|blightrunner"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Adrenaline"
          , description: seq
              [ italic $ ref (Name "Evasion") $ text "Evasion"
              , text " stacks up to six times on you."
              , list Unordered
                  [ seq
                      [ text
                          """Once a round, after you move 3 or more spaces in a
                          straight line without stopping, gain """
                      , italic $ text "evasion"
                      , text ", or two stacks if you moved 6 or more spaces."
                      ]
                  , seq
                      [ text
                          """Your attacks deal +damage equal to half your stacks
                          of """
                      , italic $ text "evasion"
                      , text
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
          , description: text
              "When you move outside your turn, increase that movement by +2."
          }
      , Talent
          { id: Id "pulse|talent|blightrunner"
          , name: Name "Pulse"
          , colour: Name "Yellow"
          , description: text
              "At round 3, increase all movement you make or grant by +1."
          }
      , Talent
          { id: Id "turbo|talent|blightrunner"
          , name: Name "Turbo"
          , colour: Name "Yellow"
          , description: seq
              [ text "Increase the effect of "
              , italic $ ref (Name "Haste") $ text "haste"
              , text " for you and adjacent allies to +3 spaces. You gain "
              , italic $ text "haste"
              , text " when you are first bloodied in a combat."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Burning Sands"
          , colour: Name "Yellow"
          , description: text
              """You infuse your movements with rapid bursts of aether, moving
              so fast that spurts of flame seem to spring from your feet."""
          , cost: Quick /\ 2
          , tags: [ TargetTag Self, KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text
                      """While in this stance, increase all movement you make or
                      grant by half the round number, rounded up. When """
                  , italic $ text "you"
                  , text " move in this stance:"
                  , list Unordered
                      [ seq
                          [ text "you can "
                          , italic $ ref (Name "Phasing") $ text "phase"
                          , text " through foes"
                          ]
                      , seq
                          [ text "you "
                          , italic $ text "must"
                          , text " move in a straight line"
                          ]
                      , seq
                          [ text "you "
                          , italic $ text "must"
                          , text " spend all movement available to you"
                          ]
                      ]
                  ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 3)) Nothing
                  $ text
                      "Ignore any or all of the above effects of your choice."
              , Step (KeywordStep (Name "Overdrive")) Nothing $ seq
                  [ text "You are "
                  , ref (Name "Immune") $ text "immune"
                  , text " to all damage and "
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text " while moving."
                  ]
              ]
          }
      , Ability
          { name: Name "Baton Pass"
          , colour: Name "Yellow"
          , description: text
              """Your momentum pushes your allies forward, as you skillfully
              direct their strikes."""
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ text "Dash 3."
              , AttackStep (text "1 damage") (seq [ text "+", dice 1 D3 ])
              , Step Eff (Just D6) $ text
                  """One, (4+) two, or (6+) three allies adjacent to your target
                  may also dash 3, then may deal 2 damage to a different
                  adjacent foe."""
              , Step (KeywordStep (Name "Overdrive")) Nothing $ text
                  "Increase all dashes by +3."
              ]
          }
      , Ability
          { name: Name "Toxic Spike"
          , colour: Name "Yellow"
          , description: text
              """You shoot a dart imbued with the hallucinogenic venom of the
              blight lands, critical for escaping huge monsters."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text "Mark a foe in range with a toxic dart. While marked:"
                  , list Unordered
                      [ seq
                          [ text "your foe has attack "
                          , weakness
                          , text " against all foes not adjacent to them"
                          ]
                      , seq
                          [ text
                              """once a round, when your foe misses an attack,
                              they stumble and you may push them """
                          , dice 1 D3
                          , text "+1 in any direction"
                          ]
                      ]
                  , text
                      """A foe may save at the end of their turn to end this
                      mark."""
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing $ seq
                  [ text "Gains a further attack "
                  , weakness
                  , text " and push +2."
                  ]
              ]
          }
      , Ability
          { name: Name "Zipline"
          , colour: Name "Yellow"
          , description: text "Why go through when you can go over?"
          , cost: One
          , tags: [ KeywordTag (Name "Zone"), AreaTag (Line (NumVar 4)), End ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and create a line 4 zipline in range, which could
                      overlap characters. You or any ally adjacent to either
                      unoccupied end space of the zipline, may use a quick
                      ability to enter that space, then """
                  , italic $ ref (Name "Fly") $ text "fly"
                  , text
                      """ to the other end of the zipline or as far as possible,
                      then gain """
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text "."
                  ]
              , Step Eff Nothing $ text
                  """Instead of replacing this zone when it is used again, you
                  may choose to extend the existing zone by +4 spaces, added
                  from any end space. It could change directions, and this
                  creates a new end space."""
              , Step (KeywordStep (Name "Overdrive")) Nothing $ text
                  "Does not end turn."
              ]
          }
      , Ability
          { name: Name "Viper Sting"
          , colour: Name "Yellow"
          , description: text
              """You turn your enemies' strikes to your own favor, spinning
              their own momentum into a deadly force."""
          , cost: One
          , tags: [ End ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ text "Gain "
                      , italic $ ref (Name "Evasion") $ text "evasion"
                      , text " and the following interrupt:"
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Viper Sting"
                      , colour: Name "Yellow"
                      , cost: Interrupt (NumVar 1)
                      , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "A foe misses an attack."
                          , Step Eff Nothing $ seq
                              [ text
                                  """Dash 3. If that puts you adjacent to your
                                  foe, they take 2 damage. If their attack roll
                                  was 5 or less, they take """
                              , dice 2 D3
                              , text
                                  """ damage instead. Double this damage if they
                                  are in crisis."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Overdrive")) Nothing $ text
                  "Range +3 and dash +3."
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 4)) Nothing
                  $ text "Regain the interrupt."
              ]
          }
      ]
  }
