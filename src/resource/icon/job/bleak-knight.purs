module ToA.Resource.Icon.Job.BleakKnight
  ( bleakKnight
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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

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
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Also known as dark knights - a black-clad mercenary order
                  with a dread reputation, taught and tempered to embrace any
                  kind of suffering and pain. They fly a banner with no sigil,
                  and many will flee the battlefield when they see it coming."""
              , Newline
              , Newline
              , Text
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
              Name "Tenacity"
                : Name "Torment"
                : Name "Sanguine"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Armored Agony"
          , description:
              [ List Unordered
                  [ [ Text
                        """When you inflict a status on a foe, you can also
                        inflict it on yourself."""
                    ]
                  , [ Text
                        """You can choose not to clear negative status tokens
                        after triggering them."""
                    ]
                  , [ Text
                        """When you are afflicted by 3 or more negative status
                        tokens of any kind, you gain +1 armor and your attacks
                        deal +2 base damage."""
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Tenacity"
          , colour: Name "Red"
          , description:
              [ Text
                  """If you have 3 or more negative status tokens, you may
                  choose to clear them at the end of your turn, and gain 2
                  vigor. Increase this vigor by +"""
              , Dice 1 D6
              , Text " if you're in crisis."
              ]
          }
      , Talent
          { name: Name "Torment"
          , colour: Name "Red"
          , description:
              [ Text
                  """Adjacent foes do not clear negative statuses. Foes in
                  crisis additionally cannot gain vigor."""
              ]
          }
      , Talent
          { name: Name "Sanguine"
          , colour: Name "Red"
          , description:
              [ Text "You gain "
              , Power
              , Text
                  """ on saves if you are afflicted. If you have 3 or more
                  negative statuses, you automatically pass saves."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Chain of Misery"
          , colour: Name "Red"
          , description:
              [ Text
                  """You link your soul aether with an ally's, intertwining your
                  suffering, and bolstering their resolve with your own
                  boundless tolerance for pain."""
              ]
          , cost: One /\ 2
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing
                  [ Text
                      """You bond yourself to an ally in range. As long as that
                      ally is in range, they take 1/2 damage while the bond is
                      active, but you """
                  , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                  , Text
                      """ hp equal to the other half, before reductions. Any
                      statuses inflicted on that ally are inflicted on you
                      instead."""
                  , Newline
                  , Text
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
          , description: [ Text "Pain within becomes pain without." ]
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """If you are suffering from 3 negative status tokens of
                      any kind, this attack gains """
                  , Italic [ Ref (Name "Pierce") [ Text "pierce" ] ]
                  , Text "."
                  ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 2 D3 ]
              , Step Eff (Just D3)
                  [ Text "Inflict "
                  , Dice 1 D3
                  , Text " "
                  , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
                  , Text " on yourself."
                  ]
              ]
          }
      , Ability
          { name: Name "Masochism"
          , colour: Name "Red"
          , description:
              [ Text
                  """Your aether reaches out to your allies, spreading their
                  suffering to you and lifting their plight."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Transfer all negative statuses from an alliy in range
                      to you, then gain 1 vigor per status token transferred.
                      If you're blooedied, you may repeat this effect on a
                      second ally, If you're in crisis, you may repeat on """
                  , Italic [ Text "all" ]
                  , Text " allies in range."
                  ]
              ]
          }
      , Ability
          { name: Name "Revenge"
          , colour: Name "Red"
          , description:
              [ Text
                  """You take stock of any slight, letting it fuel a terrible
                  fire in your gut."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Stance")
              , KeywordTag (Name "Power Die")
              , KeywordTag (Name "Aura")
              ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing
                  [ Text
                      """While in this stance, gain aura 1. Set out a power die,
                      or tick that die up by 1 when:"""
                  , List Unordered
                      [ [ Text "an ally in the aura gains a status" ]
                      , [ Text "an ally in the aura takes damage" ]
                      , [ Text
                            """increase ticks from each effect + 1 if the ally
                            was bloodied"""
                        ]
                      ]
                  , Text
                      """Each condition can only trigger once a round. When the
                      die is 4 or higher, you become enraged and powered up. You
                      and allies in the aura take 1/2 damage and become """
                  , Italic [ Ref (Name "Unstoppable") [ Text "unstoppable" ] ]
                  , Text
                      ". Then exit this stance at the start of your next turn."
                  ]
              ]
          }
      , Ability
          { name: Name "Quietus"
          , colour: Name "Red"
          , description:
              [ Text "Dark eather coats your blade, cutting the soul." ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep
                  [ Text "2 damage" ]
                  [ Text "Foe must also "
                  , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
                  , Text " "
                  , Dice 2 D3
                  , Text
                      """+2 hp. Grant half as mush as the sacrifice amount as
                      vigor to self and adjacent allies to your foe."""
                  ]
              , Step Eff Nothing
                  [ Text "Inflict "
                  , Italic [ Ref (Name "Stun") [ Text "stun" ] ]
                  , Text " on yourself. Do not clear this status this turn."
                  ]
              ]
          }
      ]
  }
