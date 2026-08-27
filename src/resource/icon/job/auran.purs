module ToA.Resource.Icon.Job.Auran
  ( auran
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
  , Target(..)
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
  , newline
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

auran :: Icon
auran =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Auran"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--metal-bar]"
          , soul: Name "Earth"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Also known as metalwrights, Aurans are a relatively new
                  order of upstart earth wrights found chiefly among the churner
                  camps and great cities. Flashy, technically skilled, and
                  ambitious in comparison to their more slow-moving elder
                  orders, they work in the guild workshops, machine factories,
                  under-gangs, and churner excavation crews."""
              , newline
              , newline
              , text
                  """The elden civilizations revered metal, weighed it
                  carefully, and worked it with skill and grace. In this age,
                  the new Aether-tech cities of the guilders and the great
                  mobile city camps of the churners whirr have none of this
                  respect. They contort metal into new, monstrous forms, burn it
                  into fumes, and hammer it into pieces that crunch and grind in
                  an unholy chorus. The great machine churns and whirrs as it
                  climbs closer to heaven."""
              ]
          , trait: Name "Metal Shell"
          , keyword: Name "Heavy"
          , abilities:
              (I /\ Name "Steel Thorn")
                : (I /\ Name "Metal Flash")
                : (II /\ Name "Iron Flesh")
                : (IV /\ Name "Midas")
                : empty
          , limitBreak: Name "Wrecking Ball"
          , talents:
              Id "effigy|talent|auran"
                : Id "weight|talent|auran"
                : Id "stomp|talent|auran"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Metal Shell"
          , description: seq
              [ text
                  """If you don't attack during your turn, you gain a shell of
                  metal surrounding you. The next time you would take 5 or more
                  damage from an ability, reduce it to 1, then create a height 1
                  metal shell """
              , italic $ ref (Name "Object") $ text "object"
              , text " in a free adjacent space."
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "effigy|talent|auran"
          , name: Name "Effigy"
          , colour: Name "Blue"
          , description: seq
              [ text
                  """The first time in combat you would take 5 or more damage
                  from an ability, create a height 1 metal shell """
              , italic $ ref (Name "Object") $ text "object"
              , text " in a free adjacent space."
              ]
          }
      , Talent
          { id: Id "weight|talent|auran"
          , name: Name "Weight"
          , colour: Name "Blue"
          , description: text
              """When you use a heavy ability you can push one of its targets 3
              after it resolves."""
          }
      , Talent
          { id: Id "stomp|talent|auran"
          , name: Name "Stomp"
          , colour: Name "Blue"
          , description: seq
              [ text "As a quick ability, you can push any adjacent object "
              , dice 1 D3
              , text
                  """+1 spaces. If it would enter the space of a character, they
                  gain """
              , italic $ ref (Name "Slow") $ text "slow"
              , text "."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Wrecking Ball"
          , colour: Name "Blue"
          , description: text
              """You surround yourself in screeching layers of metal, forming an
              invincible, bladed shell and becoming a blunt instrument."""
          , cost: One /\ 3
          , tags: [ End ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Remove yourself from the battlefield, then replace
                      yourself with a height 1 """
                  , italic $ text "wrecking ball"
                  , text " object."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """Then, push the object 3 in a straight line in any
                      direction. The object can also be pushed by allies as
                      though it were a character, or an ally can push it using
                      the """
                  , italic $ ref (Name "Interact") $ text "interact (1 action)"
                  , text " ability to push it 3 spaces."
                  , list Unordered
                      [ seq
                          [ text
                              """If the wrecking ball enters the space of a
                              character, they take """
                          , dice 2 D3
                          , text " piercing damage, are pushed "
                          , italic $ dice 2 D3
                          , text ", and gain "
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text
                              """. A character can suffer these effects once a
                              turn but any number of times a round."""
                          ]
                      , text
                          """If the wrecking ball enters the space of another
                          object, remove it."""
                      ]
                  ]
              , Step Eff Nothing $ text
                  """At the start of your next turn, remove the object and
                  replace it with you."""
              ]
          }
      , Ability
          { name: Name "Steel Thorn"
          , colour: Name "Blue"
          , description: text
              """Spikes of iron whip from the earth, piercing the limbs of your
              foes."""
          , cost: Two
          , tags: [ Attack, AreaTag (Burst (NumVar 2) true) ]
          , steps:
              [ AttackStep
                  (text "2 piercing damage")
                  (seq [ text "+", dice 1 D6, text "piercing" ])
              , Step AreaEff Nothing $ text "2 piercing damage."
              , Step OnHit (Just D6) $ seq
                  [ text "Create one (4+) two or (6+) three spaces of "
                  , italic $ ref (Name "Dangerous Terrain") $ text "dangerous"
                  , text " terrain in free space in the area."
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ seq
                  [ text
                      """Any character touching the edge of the burst, both
                      inside and outside the area, takes """
                  , dice 1 D3
                  , text "+1 piercing damage again."
                  ]
              ]
          }
      , Ability
          { name: Name "Metal Flash"
          , colour: Name "Blue"
          , description: text
              """You turn into liquid metal, flowing along the ground until you
              reach your target."""
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 6)), End ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text "Choose a character in range and "
                  , bold $ text "end your turn"
                  , text ". At the end of that character's turn, you may "
                  , italic $ ref (Name "Teleport") $ text "teleport"
                  , text " yourself into free space adjacent to your target."
                  ]
              , Step Eff Nothing $ seq
                  [ text
                      """Then you may create a burst 1 (self) area effect for 2
                      piercing damage and push 1. If this explosion includes an
                      object, inflict 1 """
                  , italic $ ref (Name "Slow") $ text "slow"
                  , text
                      """ on a target in the area. If there are two or more
                      objects in the area, double damage and push."""
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  """You can choose two characters in range, triggering the
                  effect at each of the end of their turns."""
              ]
          }
      , Ability
          { name: Name "Iron Flesh"
          , colour: Name "Blue"
          , description: text
              """Your skin develops a swirling iron shell. When struck, it
              hardens and intensifies."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Stance")
              , TargetTag Self
              , KeywordTag (Name "Power Die")
              ]
          , steps:
              [ Step (KeywordStep (Name "Stance")) Nothing $ seq
                  [ text
                      """When you enter this stance, gain a d6 power die,
                      starting at 1. Once a turn, but any number of times a
                      round, tick it up by 1 after a foe uses an ability that
                      damages you. At 4+, you take half damage from all sources.
                      At the end of """
                  , italic $ text "any"
                  , text
                      """ turn the die is at 6, discard it. At the start of your
                      turn, if you don't have a die, gain a new die at 1."""
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Start the die at 3."
              ]
          }
      , Ability
          { name: Name "Midas"
          , colour: Name "Blue"
          , description: text
              """You use a flash of metal aether to briefly petrify yourself or
              an ally, removing them from further harm."""
          , cost: One
          , tags: [ TargetTag Self ]
          , steps:
              [ InsetStep Eff Nothing
                  ( text
                      """You gain one use of the following interrupt until the
                      start of your next turn."""
                  )
                  $ AbilityInset
                      { name: Name "Flesh to Metal"
                      , colour: Name "Blue"
                      , cost: Interrupt (NumVar 1)
                      , tags:
                          [ RangeTag (Range (NumVar 1) (NumVar 4))
                          , TargetTag Self
                          , TargetTag Ally
                          ]
                      , steps:
                          [ Step TriggerStep Nothing $ text
                              "Your target is damaged by a foe's ability."
                          , Step Eff Nothing $ seq
                              [ text
                                  """You transmute your target into solid stone,
                                  metal, or gemstone. After the triggering
                                  ability resolves, remove that character from
                                  the battlefield and replace them with a height
                                  1 statue """
                              , italic $ ref (Name "Object") $ text "object"
                              , text
                                  """. At the start of their next turn, or if
                                  the object is removed sooner, replace the
                                  object with the original character. Any
                                  characters or objects on top of the statue
                                  when it is replaced are placed in a free
                                  adjacent space or as close as possible."""
                              ]
                          ]
                      }
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  "Gain two uses of the interrupt."
              ]
          }
      ]
  }
