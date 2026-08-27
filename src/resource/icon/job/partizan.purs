module ToA.Resource.Icon.Job.Partizan
  ( partizan
  ) where

import ToA.Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
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
  , bold
  , dice
  , list
  , italic
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Trait (Trait(..))

import ToA.Data.Icon.Pc.Ability (Ability(..))
import ToA.Data.Icon.Pc.Talent (Talent(..))
import ToA.Data.Icon.Pc.Job (Job(..), JobLevel(..))

partizan :: Icon
partizan =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Partizan"
          , colour: Name "Red"
          , sign: Sign "icon-[game-icons--sun-spear]"
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description: text
              """Riding along the Leggio caravans, Partizans are warriors of
              extreme daring and incredible skill. They are the elite of the
              caravan watch guard, who use the hafts of their long spears as
              vaulting poles to leap from roof to roof, even when the caravan is
              in motion. They are prodigious monster hunters, using the motions
              of their poles to leap to breathtaking heights in order to plunge
              their blades ever deeper. Once the path of the Paritzan is taken
              up, a warrior does not expect to live a long life, and will throw
              themselves at all threats to the caravan with the poise and
              bravado of those closest to the sun and closest to death."""
          , trait: Name "Vault"
          , keyword: Name "Dominant"
          , abilities:
              (I /\ Name "Valkyrion")
                : (I /\ Name "Spiral Impaler")
                : (II /\ Name "Meteon")
                : (IV /\ Name "Vaulting Pole")
                : empty
          , limitBreak: Name "Drill Dive"
          , talents:
              Id "eagle|talent|partizan"
                : Id "soar|talent|partizan"
                : Id "vantage|talent|partizan"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Vault"
          , description: seq
              [ text
                  """You may sacrifice your free move as part of any ability to
                  do a spear vault."""
              , list Unordered
                  [ text
                      """That ability counts you as being +1 spaces of elevation
                      higher than your current elevation."""
                  , seq
                      [ text "If you're bloodied, you may also "
                      , italic $ ref (Name "Fly") $ text "fly"
                      , text " 2 before using the ability, or 4 if you're in "
                      , italic $ ref (Name "Crisis") $ text "crisis"
                      , text "."
                      ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "eagle|talent|partizan"
          , name: Name "Eagle"
          , colour: Name "Red"
          , description: text
              """While bloodied, increase all flight gained or granted by +1, or
              +2 if you're in crisis."""
          }
      , Talent
          { id: Id "soar|talent|partizan"
          , name: Name "Soar"
          , colour: Name "Red"
          , description: seq
              [ text "Your free move can "
              , italic $ ref (Name "Fly") $ text "fly"
              , text
                  """ 3 instead. If you end this move on higher elevation than
                  you started, gain """
              , italic $ ref (Name "Shield") $ text "shield"
              , text "."
              ]
          }
      , Talent
          { id: Id "vantage|talent|partizan"
          , name: Name "Vantage"
          , colour: Name "Red"
          , description: seq
              [ text
                  """You can choose to push or pull up elevation. Your
                  abilities gain: """
              , bold $ ref (Name "Dominant") $ text "Dominant"
              , text ": Increase all push and pull by +1."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Drill Dive"
          , colour: Name "Red"
          , description: text
              """The master art of the partizans, a powerful leap that uses
              skillful strikes from the pole to drive the attacker ever higher,
              coming to earth like a vengeful god."""
          , cost: One /\ 3
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)), End ]
          , steps:
              [ InsetStep Eff Nothing
                  ( seq
                      [ bold $ text "End your turn"
                      , text
                          """ and choose a foe in range, then gain the following
                          interrupt:"""
                      ]
                  )
                  $ AbilityInset
                      { name: Name "Drill Descent"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step TriggerStep Nothing $ text "Foe turn start."
                          , Step Eff (Just D6) $ seq
                              [ text
                                  """You soar into the air. Remove yourself from
                                  the battlefield. At the end of that foe's
                                  turn, you perform a spiralling dive. Place
                                  yourself in a free adjacent space. You deal 4
                                  damage once (2+) twice (3+) three times, (6+)
                                  six times, and """
                              , italic $ ref (Name "Daze") $ text "daze"
                              , text
                                  """ your foe. Then lower elevation under your
                                  target by 1 space."""
                              ]
                          , Step Eff Nothing $ seq
                              [ text "If you're bloodied, lower elevation by "
                              , dice 1 D3
                              , text
                                  """ spaces instead. If you're in crisis, lower
                                  elevation by -3."""
                              ]
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Valkyrion"
          , colour: Name "Red"
          , description: text
              """Soaring through the air like a vengeful spirit, you crash into
              your enemy."""
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ italic $ ref (Name "Fly") $ text "Fly", text " 1." ]
              , AttackStep (text "2 damage") $ seq [ text "+", dice 1 D6 ]
              , Step (KeywordStep (Name "Dominant")) Nothing $ text
                  """If you were 1 or more spaces higher than your target, push
                  all characters adjacent to your target 1. If you were 3 or
                  more, deal +2 damage on hit and lower terrain under your
                  target by 1 space."""
              ]
          }
      , Ability
          { name: Name "Spiral Impaler"
          , colour: Name "Red"
          , description: text
              """You heft a long spear with tremendous force, pinning your foe
              to the ground."""
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ Step (KeywordStep (Name "Dominant")) Nothing $ text
                  "Increase max range by +3 against targets on lower elevation."
              , Step Eff (Just D6) $ seq
                  [ text "You deal 2 "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text " damage to a foe in range. That foe must save or be "
                  , italic $ ref (Name "Immobile") $ text "immobilized"
                  , text
                      """ until the end of their next turn. A foe can end this
                      immobilize early by taking """
                  , dice 1 D6
                  , text " "
                  , italic $ text "piercing"
                  , text " damage any time during their turn."
                  ]
              ]
          }
      , Ability
          { name: Name "Meteon"
          , colour: Name "Red"
          , description: text
              """You deliver a spiraling strike that becomes especially
              effective from high elevation."""
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ italic $ ref (Name "Fly") $ text "Fly", text " 2." ]
              , Step (KeywordStep (Name "Dominant")) Nothing $ seq
                  [ text
                      """For every level of elevation you descend during this
                      flight, your foe takes +2 damage """
                  , italic $ text "on hit"
                  , text
                      """ (max +6). If you descend 3 or more levels, first
                      destroy all """
                  , italic $ ref (Name "Shield") $ text "shield"
                  , text " status effects and all "
                  , italic $ ref (Name "Vigor") $ text "vigor"
                  , text " on your target."
                  ]
              , AttackStep (text "4 damage") $ seq [ text "+", dice 1 D6 ]
              , Step OnHit Nothing $ text
                  "Lower elevation under your target by 1."
              ]
          }
      , Ability
          { name: Name "Vaulting Pole"
          , colour: Name "Red"
          , description: text
              """You skillfully impale a javelin in the ground that can be used
              to spring into a powerful leap."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) (Just D6) $ seq
                  [ text
                      """Create one or (5+) two javelin zones in a free space in
                      range. You can have any number of these zones without
                      replacing them."""
                  , list Unordered
                      [ text
                          """While sharing its space, you or an ally can balance
                          on the javelin and count as +1 elevation higher than
                          your current space."""
                      , seq
                          [ text
                              """You or allies that enter or exit its space can
                              use it to fling yourself, """
                          , ref (Name "Fly") $ text "flying"
                          , text " "
                          , dice 1 D3
                          , text
                              """+1 spaces but removing the javelin. You must
                              fly the maximum spaces possible in a straight
                              line."""
                          ]
                      ]
                  ]
              ]
          }
      ]
  }
