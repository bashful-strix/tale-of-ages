module ToA.Resource.Icon.Job.Freelancer
  ( freelancer
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
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

freelancer :: Icon
freelancer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Freelancer"
          , colour: Name "Yellow"
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Freelancers are free-roaming exorcists and hired guns,
                  roaming the land and fighting blights, demons and bandits in
                  the name of justice. They tend to act as wild cards: highly
                  independent, highly effective, and sticking to their codes of
                  honor."""
              , Newline
              , Newline
              , Text
                  """Freelancers have their history in an ancient disgraced
                  knightly order from one of the Seven Families of the Thrynn.
                  They each wield a bright metal six gun, a bow, or a long rifle
                  with extreme skill, the bullets, shot, or arrows of which they
                  infuse with raw Aether drawn from their very souls. Each
                  weapon is a relic passed down from master to student over the
                  years, and can only be won in a duel with another Freelancer.
                  It supernaturally inherits a fragment of the soul aether of
                  each of its wielders, an unbroken line going back to the First
                  Founders"""
              ]
          , trait: Name "Gun Soul Sutra"
          , keyword: Name "Excel"
          , abilities:
              (I /\ Name "Fan the Hammer")
                : (I /\ Name "Astral Chain")
                : (II /\ Name "Coolhand")
                : (IV /\ Name "Trigrammaton")
                : empty
          , limitBreak: Name "Paradiso"
          , talents:
              Name "Steady"
                : Name "Flourish"
                : Name "Kickoff"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Gun Soul Sutra"
          , description:
              [ Text
                  """If you attack a target at the very end space of a line or
                  the maximum range of an ability, your attack gains attack """
              , Power
              , Text " and deals +2 damage on hit."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "steady|talent|freelancer"
          , name: Name "Steady"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """If you don't attack during your turn, you may grant all
                  abilities +3 max range during your next turn."""
              ]
          }
      , Talent
          { id: Id "flourish|talent|freelancer"
          , name: Name "Flourish"
          , colour: Name "Yellow"
          , description:
              [ Text "If you critical hit, you may gain "
              , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
              , Text " and "
              , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
              , Text "."
              ]
          }
      , Talent
          { id: Id "kickoff|talent|freelancer"
          , name: Name "Kickoff"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """Once a round, you allow an ally that starts their turn in
                  one of your auras to immediately make an extra free move."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Paradiso"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You summon the spirit of your weapon, drawing out the
                  residual soul aether of every single one of its previous
                  users. Ghostly doubles of dozens of your predecessors match
                  your movements, and create an aura of untold power."""
              ]
          , cost: One /\ 3
          , tags: [ End, KeywordTag (Name "Aura") ]
          , steps:
              [ Step (KeywordStep (Name "Aura")) Nothing
                  [ Bold [ Text "End your turn" ]
                  , Text
                      """ and gain aura 2 until the end of your next turn. While
                      standing in Paradiso, abilities used by you or allies
                      against foes outside of Paradiso gain infinite max range,
                      attack """
                  , Power
                  , Text ", and ignore cover."
                  ]
              ]
          }
      , Ability
          { name: Name "Fan the Hammer"
          , colour: Name "Yellow"
          , description:
              [ Text "Your shots ring out with supernatural accuracy." ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 3) (NumVar 3)) ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 1." ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step (KeywordStep (Name "Excel")) (Just D6)
                  [ Text
                      """Deal 2 damage to your target again (4+) and again (6+)
                      and again."""
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing
                  [ Text "Repeat and re-roll the excel effect." ]
              ]
          }
      , Ability
          { name: Name "Astral Chain"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You whip out the astral chain gauntlet, creating a charged
                  connection to your foe."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 3) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) (Just D6)
                  [ Text "Mark your target. At the end of your target's turn:"
                  , List Unordered
                      [ [ Text
                            """If they're in range 3 or your, they take 2 damage
                            once (4+) twice, (6+) 3 times. If they're at """
                        , Italic [ Text "exactly" ]
                        , Text " 3 spaces away, they take triple damage."
                        ]
                      , [ Text
                            """If your target is further away, you may instead
                            pull yourself 3 spaces towards your target, then
                            gain """
                        , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
                        , Text "."
                        ]
                      , [ Text "Then your target may save to end this mark." ]
                      ]
                  ]
              , Step Eff Nothing
                  [ Text "If you "
                  , Italic [ Ref (Name "Excel") [ Text "excelled" ] ]
                  , Text
                      """ or scored a critical hit this turn, this ability
                      becomes """
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Coolhand"
          , colour: Name "Yellow"
          , description: [ Text "Steady your nerves." ]
          , cost: One
          , tags: []
          , steps:
              [ Step Eff (Just D6)
                  [ Text "Your next attack gains attack "
                  , Power
                  , Text
                      ", (4+) ignores all cover, (6+) and this action becomes "
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text " this turn, refunding its action cost."
                  ]
              , Step Eff Nothing
                  [ Text "After using this ability, it gains effect "
                  , Power
                  , Text " for the rest of combat, stacking up to 3 times."
                  ]
              ]
          }
      , Ability
          { name: Name "Trigrammaton"
          , colour: Name "Yellow"
          , description:
              [ Text
                  """You line up the perfect sequence of shots, in devotion to
                  the sacred geometry."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 3) (NumVar 3)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step OnHit Nothing
                  [ Text "A different foe at exactly range 3 takes 3 damage." ]
              , Step (KeywordStep (Name "Excel")) Nothing
                  [ Text
                      """May choose another foe at exactly range 6 to take 6
                      damage."""
                  ]
              , Step (KeywordStep (Name "Critical Hit")) Nothing
                  [ Text
                      """May choose another foe at exactly range 9 to take 9
                      damage."""
                  ]
              ]
          }
      ]
  }
