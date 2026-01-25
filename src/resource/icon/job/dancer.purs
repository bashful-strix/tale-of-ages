module ToA.Resource.Icon.Job.Dancer
  ( dancer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

dancer :: Icon
dancer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Dancer"
          , colour: Name "Yellow"
          , soul: Name "Thief"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Ritual sword dancers of the villages, a quasi-priesthood
                  that has survived from ancient times. Whenever there is a
                  major shrine found somewhere in the Green, there was assuredly
                  a Dancer tasked to protect it and perform the proper
                  ceremonies to satisfy the local spirits."""
              , Newline
              , Newline
              , Text
                  """Nowadays, true Dancers are few and far between. Dancing was 
                  a way to commune with the gods and transmit the wishes,
                  dreams, and hopes of the common people. With their departure
                  and death, it is now a way to commune with their essences or
                  spirits, a far more trying and risky venture. Though they
                  still serve the common people, Dancers can now only be found
                  where the crimson lilies bloom and boundaries between life and
                  death are blurred."""
              ]
          , trait: Name "Masterful Step"
          , keyword: Name "Weave"
          , abilities:
              (I /\ Name "Six Veils")
                : (I /\ Name "Danse Macabre")
                : (II /\ Name "Tumble")
                : (IV /\ Name "Crimson Blossoms")
                : empty
          , limitBreak: Name "Dance of the Scarlet Lily"
          , talents:
              Id "flow|talent|dancer"
                : Id "perfection|talent|dancer"
                : Id "untouchable|talent|dancer"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Masterful Step"
          , description:
              [ Text "If you don't attack during your turn, gain "
              , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
              , Text " and during your next turn, all abilities gain effect "
              , Power
              , Text "."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "flow|talent|dancer"
          , name: Name "Flow"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a combat, you may allow a copy of a weave effect to
                  weave further one more time."""
              ]
          }
      , Talent
          { id: Id "perfection|talent|dancer"
          , name: Name "Perfection"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a combat, when an ability grants you a move, dash,
                  teleport, or flight, you may increase all those amounts for
                  the entire ability by +3, and they ignore all movement
                  penalties."""
              ]
          }
      , Talent
          { id: Id "untouchable|talent|dancer"
          , name: Name "Untouchable"
          , colour: Name "Yellow"
          , description:
              [ Text "Add +1 to your "
              , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
              , Text " rolls. If you're in crisis, add +2."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Dance of the Scarlet Lily"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You pick the perfect, serene moment to unleash woe upon
                  your enemy."""
              ]
          , cost: Quick /\ 2
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)), End ]
          , steps:
              [ Step Eff (Just D6)
                  [ Bold [ Text "End your turn." ]
                  , Text
                      """ Target ally can immediately use any non-limit break
                      ability that costs 1 action or less, (4+) also gaining """
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text " and "
                  , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                  , Text " (6+) and clearing all negative statuses first."
                  ]
              , Step Eff Nothing
                  [ Text "Gains effect "
                  , Power
                  , Text " if your ally is in crisis."
                  ]
              ]
          }
      , Ability
          { name: Name "Six Veils"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Each veil is a gate to the underworld. Each revelation more
                  terrifying than the last."""
              ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 1." ]
              , AttackStep [ Text "1 damage" ] [ Text "+", Dice 1 D3 ]
              , Step (KeywordStep (Name "Weave")) (Just D6)
                  [ Text
                      """After this ability resolves, deal 2 damage to an
                      adjacent foe, then dash 1 (4+) then deal 2 damage and dash
                      1, (6+) then deal 2 damage and dash 1, and gain """
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Danse Macabre"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Danger or refuge - where your dance carries you is up to
                  the will of the dead."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Roll and move spaces equal to the effect die. You must
                      move in a straight line as far as possible, but you may
                      interrupt this movement with abilities. If you move as
                      many spaces as you rolled or further, refund the action
                      cost of this ability and becomes """
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text "."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text "After this ability resolves, gain "
                  , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
                  , Text ", then swap places with an adjacent character."
                  ]
              ]
          }
      , Ability
          { name: Name "Tumble"
          , colour: Name "Yellow"
          , description: [ Text "Others seem clumsy in your presence." ]
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) (Just D6)
                  [ Text "While in this stance, you have "
                  , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
                  , Text
                      """ for characters. The first time in a round you would
                      enter a character's space, you may swap places with that
                      character, then push them 1 or (4+) 2 or (6+) 4 places."""
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text
                      """Dash 3 after using this ability, then swap places with
                      an adjacent character."""
                  ]
              ]
          }
      , Ability
          { name: Name "Crimson Blossoms"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Each petal of the scarlet lily is razor sharp, and can draw
                  blood - a thousand tiny paper cuts that accumulate after
                  crossing a field of them can be death to the unprepared."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Fly spaces equal to the effect die. After landing,
                      target every foe in range and line of sight equal to half
                      the amount you flew. Those foes take 2 damage once, or
                      three times if they are at range 3 or greater."""
                  ]
              , Step (KeywordStep (Name "Gambit")) (Just D6)
                  [ Text "(1-3) Reduce flight to 1 (4+) Increase flight by +3."
                  ]
              , Step (KeywordStep (Name "Weave")) Nothing
                  [ Text
                      """Your first fly or dash you take with your next ability
                      goes +3 more spaces."""
                  ]
              ]
          }
      ]
  }
