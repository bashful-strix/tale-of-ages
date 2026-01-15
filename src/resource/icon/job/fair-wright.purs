module ToA.Resource.Icon.Job.FairWright
  ( fairWright
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
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

fairWright :: Icon
fairWright =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Fair Wright"
          , colour: Name "Green"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description:
              [ Text
                  """Trafficking with hobs and other forest spirits is an
                  incredibly fraught business. The nature gods do not see time
                  and season the same as kin. They move with the breeze and the
                  bough, the slow turn of changing leaves, the raging storm and
                  the gentle rain, the hot breezes of summer and the singing of
                  the cicadas. What may seem fixed and reliable to kin is
                  effervescent and changing to the denizens of the deep forest,
                  and a small slight or oversight as little as dipping a toe in
                  the wrong pool may instead be taken as a deep injury."""
              , Newline
              , Newline
              , Text
                  """Nevertheless, the villages of the Green rely on the
                  blessings of the Aesi and the hobs for good harvest, weather,
                  and fortune. Some honor them through the old priesthood,
                  others by accidents of faery-blessed birth, and yet others
                  through long stints surviving in the wilds. Maintaining these
                  relationships is a matter of patience, respect, and a little
                  old fashioned trickery."""
              ]
          , trait: Name "Fae Charm"
          , keyword: Name "Arua"
          , abilities:
              (I /\ Name "Summer's Blaze")
                : (I /\ Name "Spring's Bounty")
                : (II /\ Name "Autumn's Rain")
                : (IV /\ Name "Winter's Grip")
                : empty
          , limitBreak: Name "Eternal Renewal"
          , talents:
              Name "Mulch"
                : Name "Recycle"
                : Name "Incant"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Fae Charm"
          , description:
              [ Text "Once a round, when you "
              , Italic [ Text "dismiss" ]
              , Text
                  """ a summon, you can roll the effect die and capture its
                  fleeing essence."""
              , List Unordered
                  [ [ Text
                        """Gain vigor equal to half the effect die, or grant it
                        to an ally in range 1-3."""
                    ]
                  , [ Text "On a 5+, additionally immediately "
                    , Italic [ Text "re-summon" ]
                    , Text
                        """ the dismissed summon in range 1-3, triggering any
                        effect that took place on its summoning."""
                    ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Mulch"
          , colour: Name "Green"
          , description:
              [ Text "Once a round, when you "
              , Italic [ Text "dismiss" ]
              , Text " a summon, you can create a "
              , Italic [ Ref (Name "Difficult Terrain") [ Text "difficult" ] ]
              , Text " or "
              , Italic [ Ref (Name "Dangerous Terrain") [ Text "dangerous" ] ]
              , Text " terrain space under them."
              ]
          }
      , Talent
          { name: Name "Recycle"
          , colour: Name "Green"
          , description:
              [ Text
                  """You may dismiss one summon you control as part of any
                  ability to gain effect """
              , Power
              , Text " on the ability."
              ]
          }
      , Talent
          { name: Name "Incant"
          , colour: Name "Green"
          , description:
              [ Text
                  """As a quick ability, you may increase the aura size of one
                  of your ability's auras by 1 until the start of your next
                  turn. All other auras you control or create are reduced by 1.
                  If reduced to 0, an aura deactivates temporarily."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Eternal Renewal"
          , colour: Name "Green"
          , description:
              [ Text
                  """You reach out with terrifying power, beseeching the primal
                  Aesi to forbid the normal cycle of life and death from working
                  temporarily."""
              ]
          , cost: Two /\ 3
          , tags: [ KeywordTag (Name "Aura") ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Gain aura 2 until the end of your next turn, with the
                      following effects:"""
                  , List Unordered
                      [ [ Text "If "
                        , Italic [ Text "any" ]
                        , Text
                            """ character (yourself, foe, or ally), inside the
                            aura would be reduced below 1 hp, roll """
                        , Italic [ Dice 1 D6 ]
                        , Text
                            """. On a 3+, that character remains at 1 hp instead
                            and becomes immune to all damage until the end of
                            the current turn. That character then loses the
                            benefit of this aura for the rest of combat."""
                        ]
                      , [ Text
                            """Immediately re-summon all summons that are
                            dismissed in the aura."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Summer's Blaze"
          , colour: Name "Green"
          , description:
              [ Text
                  """A splash of ceremonial liquor or the wave of a fan calls
                  forth the spirits of the summer fire festivals."""
              ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 4))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ AttackStep [ Text "1 piercing damage " ] [ Text "+1 piercing" ]
              , Step AreaEff Nothing [ Text "1 piercing damage." ]
              , InsetStep OnHit Nothing
                  [ Text "Summon a festival hob adjacent to your target." ]
                  $ SummonInset
                      { name: Name "Festival Hob"
                      , colour: Name "Green"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text "The hob as aura 1. The aura is "
                              , Italic
                                  [ Ref
                                      (Name "Dangerous Terrain")
                                      [ Text "dangerous" ]
                                  ]
                              , Text " terrain."
                              ]
                          , Step SummonAction (Just D6)
                              [ Text
                                  """Increase the aura of each festival hob by
                                  +1. This effect stakcs (max +3) and lasts
                                  until the hob is dismissed. However, on a
                                  (1-3) the hob explodes, """
                              , Italic [ Text "dismissing" ]
                              , Text
                                  """ it and dealing 2 piercing damage to all
                                  characters inside the aura."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Spring's Bounty"
          , colour: Name "Green"
          , description:
              [ Text
                  """You summon a fickle and playful hob of spring, prancing
                  with incredible leaps and bounds."""
              ]
          , cost: Two
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ InsetStep Eff Nothing
                  [ Text "Summon a spring hob in range." ]
                  $ SummonInset
                      { name: Name "Spring Hob"
                      , colour: Name "Green"
                      , max: 2
                      , abilities:
                          [ Step SummonAction Nothing
                              [ Text
                                  "Each spring hob teleports into space of the "
                              , Italic [ Text "furthest" ]
                              , Text
                                  """ ally from its space, then grants 3 vigor
                                  to all adjacent allies, increased by +"""
                              , Dice 1 D6
                              , Text " for allies in crisis."
                              ]
                          , Step SummonEff Nothing
                              [ Text
                                  """Once a round, for each hob, you may attempt
                                  to repeat the summon action by rolling the
                                  effect die. On a (1-3), """
                              , Italic [ Text "dismiss" ]
                              , Text " the hob instead and leave a "
                              , Italic
                                  [ Ref
                                      (Name "Difficult Terrain")
                                      [ Text "difficult terrain" ]
                                  ]
                              , Text " flower patch in its space."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Autumn's Rain"
          , colour: Name "Green"
          , description:
              [ Text
                  """With a prayer, a gentle healing rain begins falling on your
                  allies."""
              ]
          , cost: Two
          , tags: [ KeywordTag (Name "Mark"), KeywordTag (Name "Aura") ]
          , steps:
              [ Step Eff (Just D6)
                  [ Text
                      """Mark an ally in range. That ally gains aura 1. At the
                      end of that ally's turn, grant 2 vigor to yourself and all
                      allies in the aura, including your marked ally (3+) and
                      create """
                  , Italic
                      [ Ref
                          (Name "Difficult Terrain")
                          [ Text "difficult terrain" ]
                      ]
                  , Text
                      """ under all foes in the aura (5+) and yourself and
                      allies in the aura can remove one negative status
                      token."""
                  ]
              , Step Eff Nothing
                  [ Text "If the marked ally is bloodied, this gains effect "
                  , Power
                  , Text
                      ". If that ally is in crisis, increase aura size by +1."
                  ]
              ]
          }
      , Ability
          { name: Name "Winter's Grip"
          , colour: Name "Green"
          , description:
              [ Text
                  """You summon a stiff and hungry hob of deep winter, ruthless
                  and gnarled with age."""
              ]
          , cost: One
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  [ Text "Summon an ice hob in range 1-3." ]
                  $ SummonInset
                      { name: Name "Ice Hob"
                      , colour: Name "Green"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing
                              [ Text
                                  """Each of these hobs links to a foe in range
                                  1-2 when summoned. If that foe ends their turn
                                  2 or more spaces away from the hob, """
                              , Italic [ Text "dimiss" ]
                              , Text
                                  """ the hob and they must save. They take 2
                                  piercing damage and have """
                              , Italic
                                  [ Ref
                                      (Name "Difficult Terrain")
                                      [ Text "difficult terrain" ]
                                  ]
                              , Text
                                  """ created under them. On a failed save, they
                                  additionally become """
                              , Italic
                                  [ Ref (Name "Immobile") [ Text "immobile" ] ]
                              , Text
                                  """ until the end of their next turn, or until
                                  they take damage again."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
