module ToA.Resource.Icon.Job.FairWright
  ( fairWright
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
          , sign: Sign "icon-[game-icons--fairy]"
          , soul: Name "Witch"
          , class: Name "Mendicant"
          , description: seq
              [ text
                  """Trafficking with hobs and other forest spirits is an
                  incredibly fraught business. The nature gods do not see time
                  and season the same as kin. They move with the breeze and the
                  bough, the slow turn of changing leaves, the raging storm and
                  the gentle rain, the hot breezes of summer and the singing of
                  the cicadas. What may seem fixed and reliable to kin is
                  effervescent and changing to the denizens of the deep forest,
                  and a small slight or oversight as little as dipping a toe in
                  the wrong pool may instead be taken as a deep injury."""
              , newline
              , newline
              , text
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
              Id "mulch|talent|fair-wright"
                : Id "recycle|talent|fair-wright"
                : Id "incant|talent|fair-wright"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Fae Charm"
          , description: seq
              [ text "Once a round, when you "
              , italic $ text "dismiss"
              , text
                  """ a summon, you can roll the effect die and capture its
                  fleeing essence."""
              , list Unordered
                  [ text
                      """Gain vigor equal to half the effect die, or grant it to
                      an ally in range 1-3."""
                  , seq
                      [ text "On a 5+, additionally immediately "
                      , italic $ text "re-summon"
                      , text
                          """ the dismissed summon in range 1-3, triggering any
                          effect that took place on its summoning."""
                      ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "mulch|talent|fair-wright"
          , name: Name "Mulch"
          , colour: Name "Green"
          , description: seq
              [ text "Once a round, when you "
              , italic $ text "dismiss"
              , text " a summon, you can create a "
              , italic $ ref (Name "Difficult Terrain") $ text "difficult"
              , text " or "
              , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
              , text " terrain space under them."
              ]
          }
      , Talent
          { id: Id "recycle|talent|fair-wright"
          , name: Name "Recycle"
          , colour: Name "Green"
          , description: seq
              [ text
                  """You may dismiss one summon you control as part of any
                  ability to gain effect """
              , power
              , text " on the ability."
              ]
          }
      , Talent
          { id: Id "incant|talent|fair-wright"
          , name: Name "Incant"
          , colour: Name "Green"
          , description: text
              """As a quick ability, you may increase the aura size of one of
              your ability's auras by 1 until the start of your next turn. All
              other auras you control or create are reduced by 1. If reduced to
              0, an aura deactivates temporarily."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Eternal Renewal"
          , colour: Name "Green"
          , description: text
              """You reach out with terrifying power, beseeching the primal Aesi
              to forbid the normal cycle of life and death from working
              temporarily."""
          , cost: Two /\ 3
          , tags: [ KeywordTag (Name "Aura") ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Gain aura 2 until the end of your next turn, with the
                      following effects:"""
                  , list Unordered
                      [ seq
                          [ text "If "
                          , italic $ text "any"
                          , text
                              """ character (yourself, foe, or ally), inside the
                              aura would be reduced below 1 hp, roll """
                          , italic $ dice 1 D6
                          , text
                              """. On a 3+, that character remains at 1 hp
                              instead and becomes immune to all damage until the
                              end of the current turn. That character then loses
                              the benefit of this aura for the rest of
                              combat."""
                          ]
                      , text
                          """Immediately re-summon all summons that are
                          dismissed in the aura."""
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Summer's Blaze"
          , colour: Name "Green"
          , description: text
              """A splash of ceremonial liquor or the wave of a fan calls forth
              the spirits of the summer fire festivals."""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 4))
              , AreaTag (Blast (NumVar 2))
              ]
          , steps:
              [ AttackStep (text "1 piercing damage ") (text "+1 piercing")
              , Step AreaEff Nothing $ text "1 piercing damage."
              , InsetStep OnHit Nothing
                  (text "Summon a festival hob adjacent to your target.")
                  $ SummonInset
                      { name: Name "Festival Hob"
                      , colour: Name "Green"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text "The hob has aura 1. The aura is "
                              , italic
                                  $ ref (Name "Dangerous Terrain")
                                  $ text "dangerous"
                              , text " terrain."
                              ]
                          , Step SummonAction (Just D6) $ seq
                              [ text
                                  """Increase the aura of each festival hob by
                                  +1. This effect stacks (max +3) and lasts
                                  until the hob is dismissed. However, on a
                                  (1-3) the hob explodes, """
                              , italic $ text "dismissing"
                              , text
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
          , description: text
              """You summon a fickle and playful hob of spring, prancing with
              incredible leaps and bounds."""
          , cost: Two
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ InsetStep Eff Nothing
                  (text "Summon a spring hob in range.")
                  $ SummonInset
                      { name: Name "Spring Hob"
                      , colour: Name "Green"
                      , max: 2
                      , abilities:
                          [ Step SummonAction Nothing $ seq
                              [ text
                                  "Each spring hob teleports into space of the "
                              , italic $ text "furthest"
                              , text
                                  """ ally from its space, then grants 3 vigor
                                  to all adjacent allies, increased by +"""
                              , dice 1 D6
                              , text " for allies in crisis."
                              ]
                          , Step SummonEff Nothing $ seq
                              [ text
                                  """Once a round, for each hob, you may attempt
                                  to repeat the summon action by rolling the
                                  effect die. On a (1-3), """
                              , italic $ text "dismiss"
                              , text " the hob instead and leave a "
                              , italic
                                  $ ref (Name "Difficult Terrain")
                                  $ text "difficult terrain"
                              , text " flower patch in its space."
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Autumn's Rain"
          , colour: Name "Green"
          , description: text
              """With a prayer, a gentle healing rain begins falling on your
              allies."""
          , cost: Two
          , tags: [ KeywordTag (Name "Mark"), KeywordTag (Name "Aura") ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Mark an ally in range. That ally gains aura 1. At the
                      end of that ally's turn, grant 2 vigor to yourself and all
                      allies in the aura, including your marked ally (3+) and
                      create """
                  , italic
                      $ ref (Name "Difficult Terrain")
                      $ text "difficult terrain"
                  , text
                      """ under all foes in the aura (5+) and yourself and
                      allies in the aura can remove one negative status
                      token."""
                  ]
              , Step Eff Nothing $ seq
                  [ text "If the marked ally is bloodied, this gains effect "
                  , power
                  , text
                      ". If that ally is in crisis, increase aura size by +1."
                  ]
              ]
          }
      , Ability
          { name: Name "Winter's Grip"
          , colour: Name "Green"
          , description: text
              """You summon a stiff and hungry hob of deep winter, ruthless and
              gnarled with age."""
          , cost: One
          , tags: []
          , steps:
              [ InsetStep Eff Nothing
                  (text "Summon an ice hob in range 1-3.")
                  $ SummonInset
                      { name: Name "Ice Hob"
                      , colour: Name "Green"
                      , max: 3
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text
                                  """Each of these hobs links to a foe in range
                                  1-2 when summoned. If that foe ends their turn
                                  2 or more spaces away from the hob, """
                              , italic $ text "dismiss"
                              , text
                                  """ the hob and they must save. They take 2
                                  piercing damage and have """
                              , italic
                                  $ ref (Name "Difficult Terrain")
                                  $ text "difficult terrain"
                              , text
                                  """ created under them. On a failed save, they
                                  additionally become """
                              , italic $ ref (Name "Immobile") $ text "immobile"
                              , text
                                  """ until the end of their next turn, or until
                                  they take damage again."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
