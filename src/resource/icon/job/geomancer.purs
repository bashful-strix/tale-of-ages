module ToA.Resource.Icon.Job.Geomancer
  ( geomancer
  ) where

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
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
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
          , soul: Name "Earth"
          , class: Name "Wright"
          , description:
              [ Text
                  """Geomancers belong to an old order of mystics and esoteric
                  martial artists called the Keepers of the Elden Gate. These
                  scholarly wrights are concerned with health and the flow of
                  energy, not just through the body, but through the very earth
                  itself. They consider themselves physicians of the highest
                  order - their patient being the eternal land of Arden Eld."""
              , Newline
              , Newline
              , Text
                  """These studious wrights attune themselves to earth Aether,
                  aligning the energy channels of their body to crystalline
                  perfection with vigorous exercise and sometimes bizarre health
                  regimes. In battle, the land itself is their ally, spitting
                  forth poisonous gases, cavernous upheavals of earth, and great
                  spires of rock to crush their foes."""
              , Newline
              , Newline
              , Text
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
              Name "Earthmeld"
                : Name "Boulder"
                : Name "Surf"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Aftershock"
          , description:
              [ Text
                  """Once a round, after you damage a foe with an ability, you
                  can cause vibrations in that foe. At the end of their next
                  turn, if they are adjacent to any object, you may cause them
                  to take 2 piercing damage. Increase this by +"""
              , Dice 1 D6
              , Text
                  """ if they are adjacent to two or more objects. Then this
                  effect ends."""
              ]
          }
      ]

  , talents:
      [ Talent
          { name: Name "Earthmeld"
          , colour: Name "Blue"
          , description:
              [ Text "As a "
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text
                  """ ability during your turn, you may swap places with any
                  object in range 1-3."""
              ]
          }
      , Talent
          { name: Name "Boulder"
          , colour: Name "Blue"
          , description:
              [ Text "Start combat with a height 1 boulder "
              , Italic [ Ref (Name "Object") [ Text "object" ] ]
              , Text " underneath you."
              ]
          }
      , Talent
          { name: Name "Surf"
          , colour: Name "Blue"
          , description:
              [ Text
                  """When you are standing on any object, you may push yourself
                  and that object 3 in any direction as a """
              , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
              , Text " ability during your turn."
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Cataclysm"
          , colour: Name "Blue"
          , description:
              [ Text "I, protected by the holy trigram,"
              , Newline
              , Text "Summon the ten thousand molten kings."
              , Newline
              , Text "Run amok with thy furies, and rend the immortal stone,"
              , Newline
              , Text "Turn Heaven and Earth!"
              ]
          , cost: One /\ 2
          , tags: [ RangeTag (Range (NumVar 3) (NumVar 6)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text
                      """Choose a character in range. At the end of that
                      character's turn:"""
                  , List Unordered
                      [ [ Text
                            """create height 1 objects in every free adjacent
                            space to them"""
                        ]
                      , [ Text
                            """every character in an adjacent space to them
                            gains """
                        , Italic [ Ref (Name "Slow") [ Text "slow" ] ]
                        , Text " and takes 3 piercing damage."
                        ]
                      ]
                  , Text "Then push all adjacent characters "
                  , Italic [ Dice 1 D3 ]
                  , Text " away from the targeted character."
                  ]
              ]
          }
      , Ability
          { name: Name "Geotic"
          , colour: Name "Blue"
          , description:
              [ Text
                  """The stomp of a foot or the slap of a palm is magnified a
                  hundred fold into rumbling death."""
              ]
          , cost: Two
          , tags: [ Attack, RangeTag Close, AreaTag (Arc (NumVar 6)) ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 2 D6 ]
              , Step AreaEff Nothing [ Text "2 damage." ]
              , Step OnHit (Just D6)
                  [ Text
                      """Create one, (4+) two, or (6+) three height 1 boulder
                      objects in free space anywhere in the area after the
                      attack resolves."""
                  ]
              , Step (KeywordStep (Name "Dominant")) Nothing
                  [ Text "You may create a burst 2 (target) "
                  , Italic [ Text "area effect" ]
                  , Text
                      """ centered on your attack target, extending the total
                      area effect."""
                  ]
              ]
          }
      , Ability
          { name: Name "Helix Heel"
          , colour: Name "Blue"
          , description:
              [ Text
                  """You release a fierce kick, bouncing shockwaves off the very
                  stone."""
              ]
          , cost: One
          , tags: [ RangeTag Close, AreaTag (Line (NumVar 4)) ]
          , steps:
              [ Step AreaEff Nothing [ Text "2 damage." ]
              , Step Eff (Just D3)
                  [ Text "If an "
                  , Italic [ Ref (Name "Object") [ Text "object" ] ]
                  , Text
                      """ is in the exact end space of the line, this shockwave
                      rebounds, dealing 2 damage again to all characters in the
                      area and """
                  , Italic [ Ref (Name "Slow") [ Text "slowing" ] ]
                  , Text " one character in the area. Then push that object "
                  , Italic [ Dice 1 D3 ]
                  , Text " spaces."
                  ]
              , Step (KeywordStep (Name "Dominant")) Nothing
                  [ Text "You may extend or reduce the line by up to 2 spaces."
                  ]
              ]
          }
      , Ability
          { name: Name "Bones of the Earth"
          , colour: Name "Blue"
          , description:
              [ Text
                  """Send a pulse of earth aether downwards, causing tectonic
                  upheaval."""
              ]
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 2) (NumVar 6))
              , KeywordTag (Name "Object")
              , TargetTag Character
              ]
          , steps:
              [ Step (KeywordStep (Name "Object")) (Just D6)
                  [ Text
                      """Choose yourself or a chracter in range. At the end of
                      that target's next turn, the ground beneath them ereupts.
                      Create a height 1 or (4+) 2, or (6+) 3 spire """
                  , Italic [ Ref (Name "Object") [ Text "object" ] ]
                  , Text " under them, then push other adjacent characters 1."
                  ]
              , Step (KeywordStep (Name "Dominant")) Nothing
                  [ Text
                      """You may reverse this effect, lowering terrain under
                      your target by one, (4+) two, or (6+) three spaces instead
                      of creating an object."""
                  ]
              ]
          }
      , Ability
          { name: Name "Terraforming"
          , colour: Name "Blue"
          , description:
              [ Text
                  """The key of creation is turned, and the land is shaped like
                  clay, as the Titans once did."""
              ]
          , cost: Two
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 6))
              , AreaTag (Blast (NumVar 5))
              ]
          , steps:
              [ Step AreaEff Nothing
                  [ Text
                      """Choose four of the following effects to create in the
                      area. You can select the same effect more than once.
                      Effects cannot be created in spaces occupied by
                      characters."""
                  , List Unordered
                      [ [ Text "Create eight 1 rock spire "
                        , Italic [ Ref (Name "Object") [ Text "object" ] ]
                        ]
                      , [ Text "Lower or raise terrain in a space by 1" ]
                      , [ Text "Create two spaces of "
                        , Italic
                            [ Ref
                                (Name "Difficult Terrain")
                                [ Text "difficult terrain" ]
                            ]
                        ]
                      , [ Text "Create a space of "
                        , Italic
                            [ Ref
                                (Name "Dangerous Terrain")
                                [ Text "dangerous terrain" ]
                            ]
                        ]
                      , [ Text "Remove any difficult or dangerous terrain" ]
                      , [ Text "Remove any objects you created" ]
                      ]
                  ]
              , Step (KeywordStep (Name "Heavy")) Nothing
                  [ Text
                      """Choose six effects instead, and you may teleport into
                      any space of the area in 1-3 after this ability
                      resolves."""
                  ]
              ]
          }
      ]
  }
