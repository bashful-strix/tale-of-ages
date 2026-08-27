module ToA.Resource.Icon.Job.BleakKnight
  ( bleakKnight
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , dice
  , list
  , italic
  , newline
  , power
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))

bleakKnight :: Icon
bleakKnight =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Bleak Knight"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--bleeding-heart]"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description: seq
              [ text
                  """Also known as dark knights - a black-clad mercenary order
                  with a dread reputation, taught and tempered to embrace any
                  kind of suffering and pain. They fly a banner with no sigil,
                  and many will flee the battlefield when they see it coming."""
              , newline
              , newline
              , text
                  """The Bleak Knights are known to be one of the stalwart
                  orders practicing limited aether manipulation, usually to
                  channel their suffering into strength. They follow an iron
                  doctrine of total, incorruptible warfare and while they take
                  captives and follow the rules of law (to the extreme letter),
                  they show no weakness or mercy to their foes, regardless of
                  circumstance. They have the infamous tradition of only
                  accepting recruits from those that have gone through
                  tremendous suffering - including the victims of their own
                  campaigns."""
              ]
          , trait: Name "Armored Agony"
          -- TODO: refactor keyword?
          , keyword: Name "No keywords."
          , abilities:
              (I /\ Name "Demise")
                : (I /\ Name "Masochism")
                : (II /\ Name "Revenge")
                : (IV /\ Name "Quietus")
                : empty
          , limitBreak: Name "Chain of Misery"
          , talents:
              Id "tenacity|talent|bleak-knight"
                : Id "torment|talent|bleak-knight"
                : Id "sanguine|talent|bleak-knight"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Armored Agony"
          , description: list Unordered
              [ text
                  """When you inflict a status on a foe, you can also inflict it
                  on yourself."""
              , text
                  """You can choose not to clear negative status tokens after
                  triggering them."""
              , text
                  """When you are afflicted by 3 or more negative status tokens
                  of any kind, you gain +1 armor and your attacks deal +2 base
                  damage."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "tenacity|talent|bleak-knight"
          , name: Name "Tenacity"
          , colour: Name "Red"
          , description: seq
              [ text
                  """If you have 3 or more negative status tokens, you may
                  choose to clear them at the end of your turn, and gain 2
                  vigor. Increase this vigor by +"""
              , dice 1 D6
              , text " if you're in crisis."
              ]
          }
      , Talent
          { id: Id "torment|talent|bleak-knight"
          , name: Name "Torment"
          , colour: Name "Red"
          , description: text
              """Adjacent foes do not clear negative statuses. Foes in crisis
              additionally cannot gain vigor."""
          }
      , Talent
          { id: Id "sanguine|talent|bleak-knight"
          , name: Name "Sanguine"
          , colour: Name "Red"
          , description: seq
              [ text "You gain "
              , power
              , text
                  """ on saves if you are afflicted. If you have 3 or more
                  negative statuses, you automatically pass saves."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Chain of Misery"
          , colour: Name "Red"
          , description: text
              """You link your soul aether with an ally's, intertwining your
              suffering, and bolstering their resolve with your own boundless
              tolerance for pain."""
          , cost: One /\ 2
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """You bond yourself to an ally in range. As long as that
                      ally is in range, they take 1/2 damage while the bond is
                      active, but you """
                  , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                  , text
                      """ hp equal to the other half, before reductions. Any
                      statuses inflicted on that ally are inflicted on you
                      instead."""
                  , newline
                  , text
                      """If a bonded character is bloodied, both characters deal
                      +2 damage on hit with their attack, increased to +3 if a
                      character is in crisis. The bond snaps and ends if either
                      character is defeated."""
                  ]
              ]
          }
      , Ability
          { name: Name "Demise"
          , colour: Name "Red"
          , description: text "Pain within becomes pain without."
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """If you are suffering from 3 negative status tokens of
                      any kind, this attack gains """
                  , italic $ ref (Name "Pierce") $ text "pierce"
                  , text "."
                  ]
              , AttackStep (text "2 damage") (seq [ text "+", dice 2 D3 ])
              , Step Eff (Just D3) $ seq
                  [ text "Inflict "
                  , dice 1 D3
                  , text " "
                  , italic $ ref (Name "Daze") $ text "daze"
                  , text " on yourself."
                  ]
              ]
          }
      , Ability
          { name: Name "Masochism"
          , colour: Name "Red"
          , description: text
              """Your aether reaches out to your allies, spreading their
              suffering to you and lifting their plight."""
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Transfer all negative statuses from an ally in range
                      to you, then gain 1 vigor per status token transferred.
                      If you're bloodied, you may repeat this effect on a second
                      ally, If you're in crisis, you may repeat on """
                  , italic $ text "all"
                  , text " allies in range."
                  ]
              ]
          }
      , Ability
          { name: Name "Revenge"
          , colour: Name "Red"
          , description: text
              """You take stock of any slight, letting it fuel a terrible fire
              in your gut."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Stance")
              , KeywordTag (Name "Power Die")
              , KeywordTag (Name "Aura")
              ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text
                      """While in this stance, gain aura 1. Set out a power die,
                      or tick that die up by 1 when:"""
                  , list Unordered
                      [ text "an ally in the aura gains a status"
                      , text "an ally in the aura takes damage"
                      , text
                          """increase ticks from each effect + 1 if the ally was
                          bloodied"""
                      ]
                  , text
                      """Each condition can only trigger once a round. When the
                      die is 4 or higher, you become enraged and powered up. You
                      and allies in the aura take 1/2 damage and become """
                  , italic $ ref (Name "Unstoppable") $ text "unstoppable"
                  , text
                      ". Then exit this stance at the start of your next turn."
                  ]
              ]
          }
      , Ability
          { name: Name "Quietus"
          , colour: Name "Red"
          , description: text "Dark aether coats your blade, cutting the soul."
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep (text "2 damage") $ seq
                  [ text "Foe must also "
                  , italic $ ref (Name "Sacrifice") $ text "sacrifice"
                  , text " "
                  , dice 2 D3
                  , text
                      """+2 hp. Grant half as much as the sacrifice amount as
                      vigor to self and adjacent allies to your foe."""
                  ]
              , Step Eff Nothing $ seq
                  [ text "Inflict "
                  , italic $ ref (Name "Stun") $ text "stun"
                  , text " on yourself. Do not clear this status this turn."
                  ]
              ]
          }
      ]
  }
