module ToA.Resource.Icon.Job.Cleaver
  ( cleaver
  ) where

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
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

cleaver :: Icon
cleaver =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Cleaver"
          , colour: Name "Red"
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Arden Eld is home to wild and dangerous frontiers, some of
                  which border on inhospitable climes, undersea monster dens, or
                  even Blightlands. The rough and tumble warriors that make
                  their homes there in the wilds are built of a different sort,
                  eschewing armor and even traditional weaponry. Instead, they
                  build their own weapons and armament from the most durable
                  materials around - monster parts. Using anything from Wyrm
                  jawbones the size of a man, to blast beetle shell casings, to
                  sawshark teeth, they construct anything from massive longblade
                  to trick spears, serrated daggers, bone great swords, or even
                  buzzsaws. The Cleavers, as they are known, are proud of their
                  craftsmanship. They wield their monstrous and oversized
                  weaponry with a reckless abandon, unbelievable strength, and a
                  ferocious bloodlust, a terrifying sight to witness in
                  battle."""
              ]
          , trait: Name "Berserkergang"
          , keyword: Name "Reckless"
          , abilities:
              (I /\ Name "Thirsting Edge")
                : (I /\ Name "Pound")
                : (II /\ Name "Seismic Smasher")
                : (IV /\ Name "Wild Swing")
                : empty
          , limitBreak: Name "Last Stand"
          , talents:
              Name "Massive"
                : Name "Shred"
                : Name "Rage"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Berserkergang"
          , description:
              [ Text
                  """At the start of your turn, if you are bloodied, you may
                  gain 2 vigor and clear one negative status. Increase this by
                  + """
              , Dice 1 D6
              , Text " and additionally become "
              , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
              , Text " until the start of your next turn if you're in "
              , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
              , Text "."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "massive|talent|cleaver"
          , name: Name "Massive"
          , colour: Name "Red"
          , description:
              [ Text "Your attacks with a range of melee gain range 1-2." ]
          }
      , Talent
          { id: Id "shred|talent|cleaver"
          , name: Name "Shred"
          , colour: Name "Red"
          , description:
              [ Text
                  """If you're in crisis, all damage from your abilitiies with
                  the attack tag gains """
              , Italic [ Ref (Name "Pierce") [ Text "pierce" ] ]
              , Text "."
              ]
          }
      , Talent
          { id: Id "rage|talent|cleaver"
          , name: Name "Rage"
          , colour: Name "Red"
          , description:
              [ Text "Your attacks deal damage "
              , Power
              , Text " if you have a stack of "
              , Italic [ Ref (Name "Reckless") [ Text "reckless" ] ]
              , Text
                  """. They additionally gain +2 base damage if you have 3 or
                  more """
              , Italic [ Text "reckless" ]
              , Text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Last Stand"
          , colour: Name "Red"
          , description: [ Text "Nothing can take you down." ]
          , cost: One /\ 2
          , tags: [ TargetTag Self, KeywordTag (Name "Aura") ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Until the start of your next turn, gain aura 1.
                      Yourself and allies in the aura take 1/2 damage while the
                      aura is active. However, at the start of your next turn,
                      end this aura and reduce yourself to 1 hp."""
                  ]
              , Step Eff Nothing
                  [ Text
                      """Increase aura size by +1 if you're bloodied, or a
                      further +1 if you're in crisis."""
                  ]
              ]
          }
      , Ability
          { name: Name "Thirsting Edge"
          , colour: Name "Red"
          , description:
              [ Text
                  """Your swing is so fierce that your weapon strikes multiple
                  times in one hit."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D6 ]
              , Step (KeywordStep (Name "Reckless")) (Just D6)
                  [ Text "Deal 1 or (4+) 4 damage again "
                  , Italic [ Text "on hit" ]
                  , Text "."
                  ]
              , Step Eff Nothing
                  [ Text
                      """You may trigger the reckless effect again if you're
                      bloodied, or twice if you're in crisis. Gain """
                  , Italic [ Ref (Name "Reckless") [ Text "reckless" ] ]
                  , Text " each time."
                  ]
              ]
          }
      , Ability
          { name: Name "Pound"
          , colour: Name "Red"
          , description:
              [ Text
                  """Sometimes problems can be solved by just hitting them
                  really, really hard."""
              ]
          , cost: One
          , tags: [ TargetTag Foe, RangeTag Melee ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text "You smash an adjacent foe, "
                  , Italic [ Ref (Name "Daze") [ Text "dazing" ] ]
                  , Text
                      """ them and lowering terrain by 1 or (5+) two levels
                      under them."""
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text "Your foe also takes "
                  , Dice 2 D3
                  , Text " damage."
                  ]
              ]
          }
      , Ability
          { name: Name "Seismic Smasher"
          , colour: Name "Red"
          , description:
              [ Text
                  """You pound the earth, creating a traveling shockwave that
                  knocks foes off their feet and tears up the earth."""
              ]
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 3)) ]
          , steps:
              [ Step AreaEff Nothing [ Dice 1 D6, Text " damage." ]
              , Step Eff (Just D6)
                  [ Text
                      """Every 3rd space in the line, create a height 1 boulder
                      object (odd) or lower terrain by 1 (even). This effect
                      could be created under characters."""
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text
                      """Line +3, +2 damage. You may repeat this effect up to
                      three times, gaining """
                  , Italic [ Ref (Name "Reckless") [ Text "reckless" ] ]
                  , Text " each time."
                  ]
              ]
          }
      , Ability
          { name: Name "Wild Swing"
          , colour: Name "Red"
          , description:
              [ Text "Your strike is instinctual and without thought." ]
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step (KeywordStep (Name "Reckless")) Nothing
                  [ Text "Gains effect ", Power, Text "." ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 4)) Nothing
                  [ Text "Gains effect ", Power, Text "." ]
              , Step Eff (Just D6)
                  [ Text "Deal 1 damage or (6+) "
                  , Dice 2 D6
                  , Text " to an adjacent foe, (6+) "
                  , Italic [ Ref (Name "Stun") [ Text "stun" ] ]
                  , Text " them, (6+) and push them 3."
                  ]
              ]
          }
      ]
  }
