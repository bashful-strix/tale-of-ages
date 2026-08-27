module ToA.Resource.Icon.Job.Cleaver
  ( cleaver
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
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
import ToA.Data.Icon.Markup (dice, italic, power, ref, seq, text)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

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
          , sign: Sign "icon-[game-icons--axe-swing]"
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description: text
              """Arden Eld is home to wild and dangerous frontiers, some of
              which border on inhospitable climes, undersea monster dens, or
              even Blightlands. The rough and tumble warriors that make their
              homes there in the wilds are built of a different sort, eschewing
              armor and even traditional weaponry. Instead, they build their own
              weapons and armament from the most durable materials around -
              monster parts. Using anything from Wyrm jawbones the size of a
              man, to blast beetle shell casings, to sawshark teeth, they
              construct anything from massive longblades to trick spears,
              serrated daggers, bone great swords, or even buzzsaws. The
              Cleavers, as they are known, are proud of their craftsmanship.
              They wield their monstrous and oversized weaponry with a reckless
              abandon, unbelievable strength, and a ferocious bloodlust, a
              terrifying sight to witness in battle."""
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
              Id "massive|talent|cleaver"
                : Id "shred|talent|cleaver"
                : Id "rage|talent|cleaver"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Berserkergang"
          , description: seq
              [ text
                  """At the start of your turn, if you are bloodied, you may
                  gain 2 vigor and clear one negative status. Increase this by
                  +"""
              , dice 1 D6
              , text " and additionally become "
              , italic $ ref (Name "Unstoppable") $ text "unstoppable"
              , text " until the start of your next turn if you're in "
              , italic $ ref (Name "Crisis") $ text "crisis"
              , text "."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "massive|talent|cleaver"
          , name: Name "Massive"
          , colour: Name "Red"
          , description: text
              "Your attacks with a range of melee gain range 1-2."
          }
      , Talent
          { id: Id "shred|talent|cleaver"
          , name: Name "Shred"
          , colour: Name "Red"
          , description: seq
              [ text
                  """If you're in crisis, all damage from your abilities with
                  the attack tag gains """
              , italic $ ref (Name "Pierce") $ text "pierce"
              , text "."
              ]
          }
      , Talent
          { id: Id "rage|talent|cleaver"
          , name: Name "Rage"
          , colour: Name "Red"
          , description: seq
              [ text "Your attacks deal damage "
              , power
              , text " if you have a stack of "
              , italic $ ref (Name "Reckless") $ text "reckless"
              , text
                  """. They additionally gain +2 base damage if you have 3 or
                  more """
              , italic $ text "reckless"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Last Stand"
          , colour: Name "Red"
          , description: text "Nothing can take you down."
          , cost: One /\ 2
          , tags: [ TargetTag Self, KeywordTag (Name "Aura") ]
          , steps:
              [ Step Eff Nothing $ text
                  """Until the start of your next turn, gain aura 1. Yourself
                  and allies in the aura take 1/2 damage while the aura is
                  active. However, at the start of your next turn, end this aura
                  and reduce yourself to 1 hp."""
              , Step Eff Nothing $ text
                  """Increase aura size by +1 if you're bloodied, or a further
                  +1 if you're in crisis."""
              ]
          }
      , Ability
          { name: Name "Thirsting Edge"
          , colour: Name "Red"
          , description: text
              """Your swing is so fierce that your weapon strikes multiple times
              in one hit."""
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 1 D6 ])
              , Step (KeywordStep (Name "Reckless")) (Just D6) $ seq
                  [ text "Deal 1 or (4+) 4 damage again "
                  , italic $ text "on hit"
                  , text "."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """You may trigger the reckless effect again if you're
                      bloodied, or twice if you're in crisis. Gain """
                  , italic $ ref (Name "Reckless") $ text "reckless"
                  , text " each time."
                  ]
              ]
          }
      , Ability
          { name: Name "Pound"
          , colour: Name "Red"
          , description: text
              """Sometimes problems can be solved by just hitting them really,
              really hard."""
          , cost: One
          , tags: [ TargetTag Foe, RangeTag Melee ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text "You smash an adjacent foe, "
                  , italic $ ref (Name "Daze") $ text "dazing"
                  , text
                      """ them and lowering terrain by 1 or (5+) two levels
                      under them."""
                  ]
              , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text "Your foe also takes ", dice 2 D3, text " damage." ]
              ]
          }
      , Ability
          { name: Name "Seismic Smasher"
          , colour: Name "Red"
          , description: text
              """You pound the earth, creating a traveling shockwave that knocks
              foes off their feet and tears up the earth."""
          , cost: Two
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 3)) ]
          , steps:
              [ Step AreaEff Nothing $ seq [ dice 1 D6, text " damage." ]
              , Step Eff (Just D6) $ text
                  """Every 3rd space in the line, create a height 1 boulder
                  object (odd) or lower terrain by 1 (even). This effect could
                  be created under characters."""
              , Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text
                      """Line +3, +2 damage. You may repeat this effect up to
                      three times, gaining """
                  , italic $ ref (Name "Reckless") $ text "reckless"
                  , text " each time."
                  ]
              ]
          }
      , Ability
          { name: Name "Wild Swing"
          , colour: Name "Red"
          , description: text "Your strike is instinctual and without thought."
          , cost: One
          , tags: [ RangeTag Melee ]
          , steps:
              [ Step (KeywordStep (Name "Reckless")) Nothing $ seq
                  [ text "Gains effect ", power, text "." ]
              , Step (VariableKeywordStep (Name "Sacrifice") (NumVar 4)) Nothing
                  $ seq [ text "Gains effect ", power, text "." ]
              , Step Eff (Just D6) $ seq
                  [ text "Deal 1 damage or (6+) "
                  , dice 2 D6
                  , text " to an adjacent foe, (6+) "
                  , italic $ ref (Name "Stun") $ text "stun"
                  , text " them, (6+) and push them 3."
                  ]
              ]
          }
      ]
  }
