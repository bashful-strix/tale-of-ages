module ToA.Resource.Icon.Job.Partizan
  ( partizan
  ) where

import Prelude

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
  , SubItem(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

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
          , soul: Name "Berserker"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """Riding along the Leggio caravans, Partizans are warriors of
                  extreme daring and incredible skill. They are the elite of the
                  caravan watch guard, who use the hafts of their long spears as
                  vaulting poles to leap from roof to roof, even when the
                  caravan is in motion. They are prodigious monster hunters,
                  using the motions of their poles to leap to breathtaking
                  heights in order to plunge their blades every deeper. Once the
                  path of the Paritzan is taken up, a warrior does not expect to
                  live a long life, and will throw themselves at all threats to
                  the caravan with the poise and bravado of those closest to the
                  sun and closest to death."""
              ]
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
              Name "Eagle"
                : Name "Soar"
                : Name "Vantage"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Vault"
          , description:
              [ Text
                  """You may sacrifice your free move as part of any ability to
                  do a spear vault."""
              , List Unordered
                  [ [ Text
                        """That ability counts you as being +1 spaces of
                        elevation higher than your current elevation."""
                    ]
                  , [ Text "If you're bloodied. you may also "
                    , Italic [ Ref (Name "Fly") [ Text "fly" ] ]
                    , Text " 2 before using the ability, or 4 if you're in "
                    , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                    , Text "."
                    ]
                  ]
              ]
          , subItem: Nothing
          }
      ]

  , talents:
      [ Talent
          { name: Name "Eagle"
          , colour: Name "Red"
          , description:
              [ Text
                  """While bloodied, increase all flight gained or granted by
                  +1, or +2 if you're in crisis."""
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Soar"
          , colour: Name "Red"
          , description:
              [ Text "Your free move can "
              , Italic [ Ref (Name "Fly") [ Text "fly" ] ]
              , Text
                  """ 3 instead. If you end this move on higher elevation than
                  you started, gain """
              , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
              , Text "."
              ]
          , subItem: Nothing
          }
      , Talent
          { name: Name "Vantage"
          , colour: Name "Red"
          , description:
              [ Text
                  """You can choose to push or pull up elemation. Your
                  abilities gain: """
              , Bold [ Ref (Name "Dominant") [ Text "Dominant" ] ]
              , Text ": Increase all push and pull by +1."
              ]
          , subItem: Nothing
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Drill Dive"
          , colour: Name "Red"
          , description:
              [ Text
                  """The master art of the partizans, a powerful leap that uses
                  skillful strikes from the pole to drive the attacker ever
                  higher, coming to earth like a vengeful god."""
              ]
          , cost: One /\ 3
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 5)), End ]
          , steps:
              [ SubStep Nothing
                  ( AbilityItem
                      { name: Name "Drill Descent"
                      , colour: Name "Red"
                      , cost: Interrupt (NumVar 1)
                      , tags: []
                      , steps:
                          [ Step Nothing $ TriggerStep
                              [ Text "Foe turn start." ]
                          , Step (Just D6) $ Eff
                              [ Text
                                  """You soar into the air. Remove yourself from
                                  the battlefield. At the end of that foe's
                                  turn, you perform a spiralling dive. Place
                                  yourself in a free adjacent space. You deal 4
                                  damage once (2+) twice (3+) three times, (6+)
                                  six times, and """
                              , Italic [ Ref (Name "Daze") [ Text "daze" ] ]
                              , Text
                                  """ your foe. Then lower elevation under your
                                  target by 1 space."""
                              ]
                          , Step Nothing $ Eff
                              [ Text "If you're bloodied, lower elevation by "
                              , Dice 1 D3
                              , Text
                                  """ spaces instead. If you're in crisis, lower
                                  elevation by -3."""
                              ]
                          ]
                      }
                  )
                  $ Eff
                      [ Bold [ Text "End your turn" ]
                      , Text
                          """ and choose a foe in range, then gain the following
                          interrupt: """
                      ]
              ]
          }
      , Ability
          { name: Name "Valkyrion"
          , colour: Name "Red"
          , description:
              [ Text
                  """Soaring through the air like a vengeful spirit, you crash
                  into your enemy."""
              ]
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Nothing $ Eff
                  [ Italic [ Ref (Name "Fly") [ Text "Fly" ] ]
                  , Text " 1."
                  ]
              , Step Nothing $ AttackStep
                  [ Text "2 damage" ]
                  [ Text "+", Dice 1 D6 ]
              , Step Nothing $ KeywordStep (Name "Dominant")
                  [ Text
                      """If you were 1 or more spaces higher than your target,
                      push all characters adjacent to your target 1. If you were
                      3 or more, deal +2 damage on hit and lower terrain under
                      your target by 1 space."""
                  ]
              ]
          }
      , Ability
          { name: Name "Spiral Impaler"
          , colour: Name "Red"
          , description:
              [ Text
                  """You heft a long spear with termendous force, pinning your
                  foe to the ground."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 3)) ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Dominant")
                  [ Text
                      """Increase max range by +3 against targets on lower
                      elevation."""
                  ]
              , Step (Just D6) $ Eff
                  [ Text "You deal 2 "
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage to a foe in range. That foe must save or be "
                  , Italic [ Ref (Name "Immobile") [ Text "immobilized" ] ]
                  , Text
                      """ until the end of their next turn. A foe can end this
                      immobilize early by taking """
                  , Dice 1 D6
                  , Text " "
                  , Italic [ Text "piercing" ]
                  , Text " damage any time during their turn."
                  ]
              ]
          }
      , Ability
          { name: Name "Meteon"
          , colour: Name "Red"
          , description:
              [ Text
                  """You deliver a spiraling strike that becomes especially
                  effective from high elevation."""
              ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Nothing $ Eff
                  [ Italic [ Ref (Name "Fly") [ Text "Fly" ] ]
                  , Text " 2."
                  ]
              , Step Nothing $ KeywordStep (Name "Dominant")
                  [ Text
                      """For every level of elevation you descend during this
                      flight, your foe takes +2 damage """
                  , Italic [ Text "on hit" ]
                  , Text
                      """ (max +6). If you descend 3 or more levels, first
                      destroy all """
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text " status effects and all "
                  , Italic [ Ref (Name "Vigor") [ Text "vigor" ] ]
                  , Text " on your target."
                  ]
              , Step Nothing $ AttackStep
                  [ Text "4 damage" ]
                  [ Text "+", Dice 1 D6 ]
              , Step Nothing $ OnHit
                  [ Text "Lower elevation under your target by 1." ]
              ]
          }
      , Ability
          { name: Name "Vaulting Pole"
          , colour: Name "Red"
          , description:
              [ Text
                  """You skillfully impale a javelin in the ground that can be
                  used to spring into a powerful leap."""
              ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              ]
          , steps:
              [ Step (Just D6) $ KeywordStep (Name "Zone")
                  [ Text
                      """Create one or (5+) two javelin zones in a free space in
                      range. You can have any number of these zones without
                      replacing them."""
                  , List Unordered
                      [ [ Text
                            """While sharing its space, you or an ally can
                            balance on the javelin and count as +1 elevation
                            higher than your current space."""
                        ]
                      , [ Text
                            """You or allies that enter or exit its space can
                            use it to fling  yourself, """
                        , Ref (Name "Fly") [ Text "flying" ]
                        , Text " "
                        , Dice 1 D3
                        , Text
                            """+1 spaces but reomving the javelin. You must fly
                            the maximum spaces possible in a straight line."""
                        ]
                      ]
                  ]
              ]
          }
      ]
  }
