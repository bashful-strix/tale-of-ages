module ToA.Resource.Icon.Job.Geomancer
  ( geomancer
  ) where

import Prelude

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
import ToA.Data.Icon.Markup
  ( ListKind(..)
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
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

geomancer :: Icon
geomancer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Geomancer"
          , colour: Name "Blue"
          , sign: Sign "icon-[game-icons--earth-crack]"
          , soul: Name "Earth"
          , class: Name "Wright"
          , description: seq
              [ text
                  """Geomancers belong to an old order of mystics and esoteric
                  martial artists called the Keepers of the Elden Gate. These
                  scholarly wrights are concerned with health and the flow of
                  energy, not just through the body, but through the very earth
                  itself. They consider themselves physicians of the highest
                  order - their patient being the eternal land of Arden Eld."""
              , newline
              , newline
              , text
                  """These studious wrights attune themselves to earth Aether,
                  aligning the energy channels of their body to crystalline
                  perfection with vigorous exercise and sometimes bizarre health
                  regimes. In battle, the land itself is their ally, spitting
                  forth poisonous gases, cavernous upheavals of earth, and great
                  spires of rock to crush their foes."""
              , newline
              , newline
              , text
                  """None are more concerned with the Churn than the Geomancers,
                  who view it as the greatest sickness known to Kin, and will
                  take any opportunity to fight or study it with exuberance."""
              ]
          , trait: Name "Aftershock"
          , keyword: Name "Dominant"
          , abilities:
              (I /\ Name "Geotic")
                : (I /\ Name "Helix Heel")
                : (II /\ Name "Bones of the Earth")
                : (IV /\ Name "Terraforming")
                : empty
          , limitBreak: Name "Cataclysm"
          , talents:
              Id "earthmeld|talent|geomancer"
                : Id "boulder|talent|geomancer"
                : Id "surf|talent|geomancer"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Aftershock"
          , description: seq
              [ text
                  """Once a round, after you damage a foe with an ability, you
                  can cause vibrations in that foe. At the end of their next
                  turn, if they are adjacent to any object, you may cause them
                  to take 2 piercing damage. Increase this by +"""
              , dice 1 D6
              , text
                  """ if they are adjacent to two or more objects. Then this
                  effect ends."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "earthmeld|talent|geomancer"
          , name: Name "Earthmeld"
          , colour: Name "Blue"
          , description: seq
              [ text "As a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text
                  """ ability during your turn, you may swap places with any
                  object in range 1-3."""
              ]
          }
      , Talent
          { id: Id "boulder|talent|geomancer"
          , name: Name "Boulder"
          , colour: Name "Blue"
          , description: seq
              [ text "Start combat with a height 1 boulder "
              , italic $ ref (Name "Object") $ text "object"
              , text " underneath you."
              ]
          }
      , Talent
          { id: Id "surf|talent|geomancer"
          , name: Name "Surf"
          , colour: Name "Blue"
          , description: seq
              [ text
                  """When you are standing on any object, you may push yourself
                  and that object 3 in any direction as a """
              , italic $ ref (Name "Quick") $ text "quick"
              , text " ability during your turn."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Cataclysm"
          , colour: Name "Blue"
          , description: seq
              [ text "I, protected by the holy trigram,"
              , newline
              , text "Summon the ten thousand molten kings."
              , newline
              , text "Run amok with thy furies, and rend the immortal stone,"
              , newline
              , text "Turn Heaven and Earth!"
              ]
          , cost: One /\ 2
          , tags: [ RangeTag (Range (NumVar 3) (NumVar 6)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Choose a character in range. At the end of that
                      character's turn:"""
                  , list Unordered
                      [ text
                          """create height 1 objects in every free adjacent
                          space to them"""
                      , seq
                          [ text
                              """every character in an adjacent space to them
                              gains """
                          , italic $ ref (Name "Slow") $ text "slow"
                          , text " and takes 3 piercing damage."
                          ]
                      ]
                  , text "Then push all adjacent characters "
                  , italic $ dice 1 D3
                  , text " away from the targeted character."
                  ]
              ]
          }
      , Ability
          { name: Name "Geotic"
          , colour: Name "Blue"
          , description: text
              """The stomp of a foot or the slap of a palm is magnified a
              hundred fold into rumbling death."""
          , cost: Two
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 6)) ]
          , steps:
              [ AttackStep (text "2 damage") (seq [ text "+", dice 2 D6 ])
              , Step AreaEff Nothing $ text "2 damage."
              , Step OnHit (Just D6) $ text
                  """Create one, (4+) two, or (6+) three height 1 boulder
                  objects in free space anywhere in the area after the attack
                  resolves."""
              , Step (KeywordStep (Name "Dominant")) Nothing $ seq
                  [ text "You may create a burst 2 (target) "
                  , italic $ text "area effect"
                  , text
                      """ centered on your attack target, extending the total
                      area effect."""
                  ]
              ]
          }
      , Ability
          { name: Name "Helix Heel"
          , colour: Name "Blue"
          , description: text
              """You release a fierce kick, bouncing shockwaves off the very
              stone."""
          , cost: One
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 4)) ]
          , steps:
              [ Step AreaEff Nothing $ text "2 damage."
              , Step Eff (Just D3) $ seq
                  [ text "If an "
                  , italic $ ref (Name "Object") $ text "object"
                  , text
                      """ is in the exact end space of the line, this shockwave
                      rebounds, dealing 2 damage again to all characters in the
                      area and """
                  , italic $ ref (Name "Slow") $ text "slowing"
                  , text " one character in the area. Then push that object "
                  , italic $ dice 1 D3
                  , text " spaces."
                  ]
              , Step (KeywordStep (Name "Dominant")) Nothing $ text
                  "You may extend or reduce the line by up to 2 spaces."
              ]
          }
      , Ability
          { name: Name "Bones of the Earth"
          , colour: Name "Blue"
          , description: text
              """Send a pulse of earth aether downwards, causing tectonic
              upheaval."""
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 6))
              , KeywordTag (Name "Object")
              , TargetTag Character
              ]
          , steps:
              [ Step (KeywordStep (Name "Object")) (Just D6) $ seq
                  [ text
                      """Choose yourself or a character in range. At the end of
                      that target's next turn, the ground beneath them erupts.
                      Create a height 1 or (4+) 2, or (6+) 3 spire """
                  , italic $ ref (Name "Object") $ text "object"
                  , text " under them, then push other adjacent characters 1."
                  ]
              , Step (KeywordStep (Name "Dominant")) Nothing $ text
                  """You may reverse this effect, lowering terrain under your
                  target by one, (4+) two, or (6+) three spaces instead of
                  creating an object."""
              ]
          }
      , Ability
          { name: Name "Terraforming"
          , colour: Name "Blue"
          , description: text
              """The key of creation is turned, and the land is shaped like
              clay, as the Titans once did."""
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 6))
              , AreaTag (Blast (NumVar 5))
              ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text
                      """Choose four of the following effects to create in the
                      area. You can select the same effect more than once.
                      Effects cannot be created in spaces occupied by
                      characters."""
                  , list Unordered
                      [ seq
                          [ text "Create a height 1 rock spire "
                          , italic $ ref (Name "Object") $ text "object"
                          ]
                      , text "Lower or raise terrain in a space by 1"
                      , seq
                          [ text "Create two spaces of "
                          , italic
                              $ ref (Name "Difficult Terrain")
                              $ text "difficult terrain"
                          ]
                      , seq
                          [ text "Create a space of "
                          , italic
                              $ ref (Name "Dangerous Terrain")
                              $ text "dangerous terrain"
                          ]
                      , text "Remove any difficult or dangerous terrain"
                      , text "Remove any objects you created"
                      ]
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing $ text
                  """Choose six effects instead, and you may teleport into any
                  space of the area in 1-3 after this ability resolves."""
              ]
          }
      ]
  }
