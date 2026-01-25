module ToA.Resource.Icon.Job.ShrineGuardian
  ( shrineGuardian
  ) where

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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

shrineGuardian :: Icon
shrineGuardian =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Shrine Guardian"
          , colour: Name "Green"
          , soul: Name "Monk"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Traveling priests, monks, judges, and doctors, the Shrine
                  Guardians roam the world from village to village, performing
                  necessary rituals, marriages, ceremonies, and yearly
                  festivals. They are a welcome sight in most villages,
                  especially those too poor to afford to maintain a temple, and
                  most perform the important function of traveling judge and
                  medium, acting as an impartial party translating for the will
                  of the local spirits. They travel with many blessed relics of
                  the deities of the land and portable shrines on their back,
                  carrying their gods with them."""
              ]
          , trait: Name "Shrine of Blessing"
          , keyword: Name "Zone"
          , abilities:
              (I /\ Name "Sanctify")
                : (I /\ Name "Abjure")
                : (II /\ Name "Horse and Ox Seal")
                : (IV /\ Name "Heaven's Ward")
                : empty
          , limitBreak: Name "Great Spirit Festival"
          , talents:
              Id "hearth|talent|shrine-guardian"
                : Id "festivity|talent|shrine-guardian"
                : Id "talisman|talent|shrine-guardian"
                : empty
          }
      ]

  , traits:
      [ InsetTrait
          { name: Name "Shrine of Blessing"
          , description:
              [ Text
                  """At the start of combat, you can place your portable shrine
                  down in any space in range 1-3."""
              ]
          , inset: KeywordInset
              { name: Name "Shrine"
              , colour: Name "Green"
              , keyword: Name "Object"
              , steps:
                  [ Step Eff Nothing [ Text "Height 1." ]
                  , Step Eff Nothing
                      [ Text "As a quick ability, you can push the shrine "
                      , Dice 1 D3
                      , Text "+1 spaces if it is adjacent."
                      ]
                  , Step Eff Nothing
                      [ Text
                          """The shrine has aura 1. Attacks against foes in the
                          aura gain attack """
                      , Power
                      , Text ". At round 3+, foes gain attack "
                      , Weakness
                      , Text
                          """ against allies in the aura. At round 5+, double
                          both these effects."""
                      ]
                  ]
              }
          }
      ]

  , talents:
      [ Talent
          { id: Id "hearth|talent|shrine-guardian"
          , name: Name "Hearth"
          , colour: Name "Green"
          , description:
              [ Text
                  """As a quick ability, you may teleport an ally up to 3
                  spaces, as long as they end this teleport inside one of your
                  zones or auras."""
              ]
          }
      , Talent
          { id: Id "festivity|talent|shrine-guardian"
          , name: Name "Festivity"
          , colour: Name "Green"
          , description:
              [ Text
                  """Your auras may also effect allies that are adjacent to any
                  space affected by the aura."""
              ]
          }
      , Talent
          { id: Id "talisman|talent|shrine-guardian"
          , name: Name "Talisman"
          , colour: Name "Green"
          , description:
              [ Text
                  """Once a round, when you mark a character inside one of your
                  zones or auras, you can increase a negative or positive status
                  on them by +1."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Great Spirit Festival"
          , colour: Name "Green"
          , description:
              [ Text
                  """You clap and initiate a powerful ritual, briefly merging
                  the world of spirits and gods with the material world in a
                  riotous dance."""
              ]
          , cost: One /\ 3
          , tags: [ End ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing
                  [ Text
                      """You place a zone with a blast area down with a size
                      equal to the round number +2. This zone may overlap
                      characters and other zones. While inside, any ally that
                      misses an attack may re-roll it, taking the second result
                      as final. Any foe that hits an attack while inside the
                      zone must re-roll it, taking the second result as final. A
                      character can only be affected by this zone once a round.
                      The zone disperses at the end of you next turn,
                      granting """
                  , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                  , Text " to yourself and all allies inside."
                  ]
              ]
          }
      , Ability
          { name: Name "Sanctify"
          , colour: Name "Green"
          , description:
              [ Text
                  """You throw out a handful of glittering salt, scorching the
                  spiritually inpure."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 4))
              , KeywordTag (Name "Zone")
              ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step OnHit (Just D3)
                  [ Text "Place "
                  , Italic [ Dice 1 D3 ]
                  , Text
                      """ holy ground zones in free space in range. You can have
                      any number of these zones. Allies save with """
                  , Power
                  , Text " inside holy ground, and foes save with "
                  , Weakness
                  , Text ". At round 3+, they become "
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text " and "
                  , Italic
                      [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
                  , Text " terrain for foes."
                  ]
              ]
          }
      , Ability
          { name: Name "Abjure"
          , colour: Name "Green"
          , description:
              [ Text
                  """You make the sign of an astral seal, blasting away all
                  malice."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 4)) ]
          , steps:
              [ Step Eff (Just D3)
                  [ Text "Deal 1 piercing damage to a foe in range, "
                  , Italic [ Ref (Name "Brand") [ Text "brand" ] ]
                  , Text " them, and push them "
                  , Italic [ Dice 1 D3 ]
                  , Text "."
                  ]
              , Step Eff (Just D6)
                  [ Text
                      """If that foe then inside one of your zones or auras,
                      they explode for a burst 1 (self) area effect, dealing 2
                      or (5+) """
                  , Dice 1 D3
                  , Text
                      """+1 damage to your target foe and all foes in the area,
                      and pushing all other foes 1 or (5+) 2 spaces away from
                      your target foe."""
                  ]
              ]
          }
      , Ability
          { name: Name "Horse and Ox Seal"
          , colour: Name "Green"
          , description:
              [ Text
                  """With a word and a quickly drawn talisman, you stomp your
                  foot and forbid your foe from stepping on holy earth."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """Mark a foe in range. While marked, your chosen foe
                      treats all spaces inside your auras or zones as """
                  , Italic
                      [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
                  , Text
                      """ terrain. While inside those zones, you and allies gain
                      attack """
                  , Power
                  , Text
                      """ against your target. A foe can save at the end of
                      their turn to end this mark, but only if they are not in
                      one of your zones or auras."""
                  ]
              ]
          }
      , Ability
          { name: Name "Heaven's Ward"
          , colour: Name "Green"
          , description:
              [ Text
                  """You place a holy seal over your ally, enveloping them in
                  divine protection."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 4))
              , KeywordTag (Name "Mark")
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """Mark an ally in range. While marked, any foe that
                      attempts to use an ability that includes that ally as a
                      target must first save. On a successful save, the foe
                      is """
                  , Italic [ Ref (Name "Brand") [ Text "branded" ] ]
                  , Text
                      """ and the mark fades. On a failed save, the chosen ally
                      takes 1/2 damage from the ability, and gains """
                  , Power
                  , Text
                      " on any saves against its effects. Then the mark fades."
                  ]
              , Step (KeywordStep (Name "Overdrive")) Nothing
                  [ Text
                      "You may mark a second ally without replacing this mark."
                  ]
              ]
          }
      ]
  }
