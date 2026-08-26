module ToA.Resource.Icon.Job.Warden
  ( warden
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
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup
  ( ListKind(..)
  , bold
  , dice
  , list
  , italic
  , newline
  , power
  , ref
  , seq
  , text
  , weakness
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

warden :: Icon
warden =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Warden"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--wolverine-claws]"
          , soul: Name "Ranger"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """The Wardens are the protectors and keepers of the Deep
                  Green, the old and untamed parts of Arden Eld, lorded over by
                  the beasts and the ancient trees. They are both the keepers
                  and the servants of the herd and root, tending to their
                  health, and culling them when it becomes necessary. They sleep
                  under the stars and make their home under bough and root,
                  making staunch allies of the ferocious beasts of the deep
                  wilds through a combination of rigorous training and mutual
                  respect."""
              , newline
              , newline
              , text
                  """Wardens are the keepers of the green kenning, the old
                  ranger arts, that allow one to travel noiselessly, hide in
                  plain sight, live off the land, and become immune to even the
                  most deadly of toxins. Their fierce defense of the wild
                  sometimes puts them at odds with civilization, which they tend
                  to have a distaste for."""
              ]
          , trait: Name "Beast Companion"
          , keyword: Name "Heavy"
          , abilities:
              (I /\ Name "Apex")
                : (I /\ Name "Gwynt")
                : (II /\ Name "Oak Splitter")
                : (IV /\ Name "Strength of the Pack")
                : empty
          , limitBreak: Name "Stampede"
          , talents:
              Id "boost|talent|warden"
                : Id "hunters|talent|warden"
                : Id "corner|talent|warden"
                : empty
          }
      ]

  , traits:
      [ InsetTrait
          { name: Name "Beast Companion"
          , description: seq
              [ text "You start combat with a "
              , italic $ text "great beast"
              , text
                  """ summon placed in range 1-2 of you. If the summon is
                  dismissed or removed for any reason, you can place it as a
                  quick ability on your turn."""
              ]
          , inset: SummonInset
              { name: Name "Great Beast"
              , colour: Name "Yellow"
              , max: 1
              , abilities:
                  [ Step SummonAction Nothing $ seq
                      [ text
                          """Dash 2, then may deal 2 damage to an adjacent foe.
                          If you didn't attack this turn, increase dash by +2,
                          and damage to """
                      , dice 1 D3
                      , text "+1."
                      ]
                  , Step SummonEff Nothing $ text
                      """You or allies can ride the beast by entering its space,
                      and dismount by exiting its space. While riding the beast,
                      a character moves when it moves, counting as voluntarily
                      movement. If they are forced to stop for any reason or if
                      they exit the beast's space, they fall off and the beast
                      moves without them. Only one character can ride the beast
                      at once."""
                  ]
              }
          }
      ]

  , talents:
      [ Talent
          { id: Id "boost|talent|warden"
          , name: Name "Boost"
          , colour: Name "Yellow"
          , description: text
              """Spaces occupied by allies or allied summons cost a maximum of 1
              movement for you to enter or exit."""
          }
      , Talent
          { id: Id "hunters|talent|warden"
          , name: Name "Hunters"
          , colour: Name "Yellow"
          , description: text "Your summons deal +2 damage to foes in crisis."
          }
      , Talent
          { id: Id "corner|talent|warden"
          , name: Name "Corner"
          , colour: Name "Yellow"
          , description: seq
              [ text "Your attacks deal damage "
              , power
              , text
                  """ to any foe adjacent to 3 or more allies or allied summons.
                  If that foe was also in crisis, they gain +2 base damage."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Stampede"
          , colour: Name "Yellow"
          , description: text
              """With a bellow or a clenched fist, you summon an immense horde
              of beasts of the woods and hills to pound your enemies."""
          , cost: One /\ 2
          , tags: [ End, RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ InsetStep Eff (Just D6)
                  ( seq
                      [ text "All foes in range are pushed "
                      , italic $ dice 1 D3
                      , text " spaces in the same direction. Then summon "
                      , italic $ dice 1 D3
                      , text "+2 "
                      , italic $ text "beasts"
                      , text " in range and "
                      , bold $ text "end your turn"
                      , text "."
                      ]
                  )
                  $ SummonInset
                      { name: Name "Beast"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonAction Nothing $ seq
                              [ text
                                  """Dash 3, then deal 2 damage to an adjacent
                                  foe. Increase to """
                              , dice 2 D3
                              , text
                                  """ against foes in crisis. Then, dismiss the
                                  beast."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Push +2 and summon +4 beasts."
              ]
          }
      , Ability
          { name: Name "Apex"
          , colour: Name "Yellow"
          , description: text
              """Your strike is a clarion call to the forest, the plains, and
              the deep places of the Green, bringing forth their denizens to
              fight for you."""
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 2) (NumVar 4))
              , KeywordTag (Name "Summon")
              ]
          , steps:
              [ AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , InsetStep OnHit (Just D6)
                  ( seq
                      [ text "At the end of your turn, summon one or (5+) two "
                      , italic $ text "beasts"
                      , text " in free adjacent space to your target."
                      ]
                  )
                  $ SummonInset
                      { name: Name "Beast"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonAction Nothing $ seq
                              [ text
                                  """Dash 3, then deal 2 damage to an adjacent
                                  foe. Increase to """
                              , dice 2 D3
                              , text
                                  """ against foes in crisis. Then dismiss the
                                  beast."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Summon twice as many beasts."
              ]
          }
      , Ability
          { name: Name "Gwynt"
          , colour: Name "Yellow"
          , description: text
              "With catlike reflexes, you pounce, spurring allies to action."
          , cost: One
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Adjacent foes are pushed 1, then adjacent allies and
                      allied summons may dash 2 (5+) 4 spaces. Then, any foe
                      adjacent to one or more allies or summons that moved this
                      way takes 2 damage, or """
                  , dice 2 D3
                  , text " if they're in crisis. Then gain "
                  , italic $ ref (Name "Haste") $ text "haste"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Affects all allies, foes, and summons in range 1-2."
              ]
          }
      , Ability
          { name: Name "Oak Splitter"
          , colour: Name "Yellow"
          , description: text
              """You loose a massive shot, powerful enough to split the most
              tenebrous bark."""
          , cost: One
          , tags: [ AreaTag (Line (NumVar 4)) ]
          , steps:
              [ Step Eff (Just D6) $ seq
                  [ text
                      """Push all foes in the line 1 or (5+) 2 to either side of
                      the line. Then, the first ally or allied summon in the
                      line is pushed to the end of the line, or as far as
                      possible before stopping. Allies moved this way then
                      gain """
                  , italic $ ref (Name "Evasion") $ text "evasion"
                  , text "."
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  """Line +4 and also affects the second ally or allied summon
                  in the area."""
              ]
          }
      , Ability
          { name: Name "Strength of the Pack"
          , colour: Name "Yellow"
          , description: text
              "Your senses sync with those of the herd, and you strike as one."
          , cost: Two
          , tags: [ KeywordTag (Name "Stance"), KeywordTag (Name "Aura") ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text "In this stance, you gain aura 1:"
                  , list Unordered
                      [ seq
                          [ text
                              """If there are 3 or more allies or allied summons
                              in the area, attacks against you and allies in the
                              aura gain """
                          , weakness
                          , text ". Increase this to "
                          , weakness
                          , weakness
                          , text " against your or any ally in "
                          , italic $ ref (Name "Crisis") $ text "crisis"
                          , text "."
                          ]
                      , text "Foes in the aura take +1 damage from summons."
                      ]
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ seq
                  [ text
                      """Reduce the action cost of this ability to 1. If there
                      are 3 or more adjacent allies or allied summons to you,
                      reduce it further to """
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text "."
                  ]
              ]
          }
      ]
  }
