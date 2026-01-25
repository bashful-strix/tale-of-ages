module ToA.Resource.Icon.Job.Colossus
  ( colossus
  ) where

import Prelude

import Data.Array.NonEmpty (cons')
import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
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

colossus :: Icon
colossus =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Colossus"
          , colour: Name "Red"
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Ferocious followers of Arenheir, the Wolf Titan, the
                  Colossi are a martial order of grapplers and pankrationists
                  that reaches across all of Arden Eld. They largely forgo the
                  use of all weaponry in return for training their bodies to
                  perfection, forging their very hands and feat into killing
                  implements, and using grappling techniques that can liquify
                  rock. Colossi travel throughout the land seeking powerful
                  foes, and taking trophies to return to their great lodges to
                  offer in tribute to Arenheir in fierce hope of resurrecting
                  their god. At their lodges they feast and drink to their
                  deeds, companions, and boasts. They seek glory and challenge
                  through battle, and will often go for only the absolute
                  strongest warriors and monsters, heedless of their own
                  safety."""
              ]
          , trait: Name "Blood of the Wolf Soul"
          , keyword: Name "Sacrifice"
          , abilities:
              (I /\ Name "Megalo Buster")
                : (I /\ Name "Megaton Suplex")
                : (II /\ Name "Grendel")
                : (IV /\ Name "War God's Step")
                : empty
          , limitBreak: Name "Gigantas Crusher"
          , talents:
              Name "Grit"
                : Name "Adrenaline"
                : Name "Surge"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Blood of the Wolf Soul"
          , description:
              [ Text
                  """The first time in a combat your would be reduced to 0 hp,
                  stay at 1 hp instead and become """
              , Ref (Name "Immune") [ Text "immune" ]
              , Text
                  """ to all damage until the end of the current turn, then lose
                  this effect. At the start of your turn when you lack this
                  effect, roll the effect die. On a 4+, regain this effect."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "grit|talent|colossus"
          , name: Name "Grit"
          , colour: Name "Red"
          , description:
              [ Text "The first time in a round you "
              , Ref (Name "Sacrifice") [ Text "sacrifice" ]
              , Text ", gain 2 vigor. Increase this to 4 if you're in crisis."
              ]
          }
      , Talent
          { id: Id "adrenaline|talent|colossus"
          , name: Name "Adrenaline"
          , colour: Name "Red"
          , description:
              [ Text "At 1 hp, all your attacks deal +3 base and area damage." ]
          }
      , Talent
          { id: Id "surge|talent|colossus"
          , name: Name "Surge"
          , colour: Name "Red"
          , description:
              [ Text
                  """If you start your turn in crisis, you may clear up to two
                  negative status tokens. If you are at 1 hp, you may clear all
                  statuses instead."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Gigantas Crusher"
          , colour: Name "Red"
          , description: [ Text "Wrestle the gods themselves." ]
          , cost: Two /\ 4
          , tags: [ RangeTag Melee, TargetTag Foe ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """You grab an adjacent foe. That character must save.
                      Even if that character saves successfully, you grab them,
                      and you both soar into the air. Remove both of you from
                      the battlefield. At the start of that character's next
                      turn, you come spinning back to earth, slamming your foe
                      into the battlefield in unoccupied space in range 3 of
                      your original location. You """
                  , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                  , Text
                      """ 25% of you max hp. Your foe sacrifices 50% of their
                      max hp, or 25% on a successfult save. Then:"""
                  , List Unordered
                      [ [ Text "place yourself adjacent to your foe" ]
                      , [ Text "lower the terrain under your foe by 1" ]
                      , [ Text "Push all adjacent characters to both of you 1" ]
                      ]
                  , Newline
                  , Text
                      """This ability can be used against Legends, but it costs
                      +2 resolve and they may always save, sacrificing 4 hp and
                      refunding this ability's resolve cost on a successful
                      save, and only sacrificing 25% of their max hp on a failed
                      save."""
                  ]
              ]
          }
      , Ability
          { name: Name "Megalo Buster"
          , colour: Name "Red"
          , description:
              [ Text
                  """You deliver a mighty blow with wild abandon, so strong that
                  you yourself are left reeling."""
              ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "4 damage" ] [ Text "+", Dice 1 D6 ]
              , Step OnHit (Just D6)
                  [ Text "Both you and your foe are "
                  , Italic [ Ref (Name "Stun") [ Text "stunned" ] ]
                  , Text " and pushed 2 or (5+) 4 spaces away from each other."
                  ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 3)) Nothing
                  [ Text "Avoid the stun and push." ]
              ]
          }
      , Ability
          { name: Name "Megaton Suplex"
          , colour: Name "Red"
          , description:
              [ Text
                  """Wrapping your arms around your foe, you fling the two of
                  you backwards with tremendous force."""
              ]
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step (VariableKeywordStep (Name "Sacrifice") (NumVar 3)) Nothing
                  [ Text "An adjacent foe takes 3 damage and is "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text
                      """. They must save, or be picked up and removed from the
                      battlefield. """
                  , Ref (Name "Fly") [ Text "Fly" ]
                  , Text " 3, then place your foe in a free adjacent space."
                  ]
              ]
          }
      , Ability
          { name: Name "Grendel"
          , colour: Name "Red"
          , description:
              [ Text "With bulging muscles, you hold your foe in a vice grip." ]
          , cost: One
          , tags: [ KeywordTag (Name "Stance") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Text
                      """When you enter this stance, or at the end of your turn,
                      you may grab an adjacent foe. A grabbed foe has attack """
                  , Weakness
                  , Text " except against you, and your and they are "
                  , Italic [ Ref (Name "Immobile") [ Text "immobile" ] ]
                  , Text
                      """. A foe ends the grab after using an ability that
                      damages you, or by passing a save at the end of their
                      turn. You can only grab one foe at once and it also ends
                      if either of you are involuntarily moved. You end a grab
                      voluntarily any time during your turn."""
                  ]
              , Step
                  (VariableKeywordStep (Name "Sacrifice") (RollVar 3 D3))
                  Nothing
                  [ Text
                      """Maintain the grab if it would end. Prevent any forced
                      movement that would end the grab."""
                  ]
              ]
          }
      , Ability
          { name: Name "War God's Step"
          , colour: Name "Red"
          , description:
              [ Text
                  """You crack the earth with your step, sending out rippling
                  shockwaves."""
              ]
          , cost: One
          , tags: [ AreaTag (Burst (OtherVar "X") true) ]
          , steps:
              [ Step AreaEff (Just D6)
                  [ Text
                      """Smash every character in burst 1 (self) or (4+) burst
                      2 (self)."""
                  ]
              , Step AreaEff Nothing
                  [ Text "Create "
                  , Italic
                      [ Ref
                          (Name "Difficult Terrain")
                          [ Text "difficult terrain" ]
                      ]
                  , Text
                      """ under every character in range, then those characters
                      are """
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text "."
                  ]
              , Step
                  ( AltStep $
                      (VariableKeywordStep (Name "Sacrifice") (RollVar 3 D3))
                        `cons'` [ KeywordStep (Name "Reckless") ]
                  )
                  Nothing
                  [ Text
                      """Maintain the grab if it would end. Prevent any forced
                      movement that would end the grab."""
                  ]
              ]
          }
      ]
  }
