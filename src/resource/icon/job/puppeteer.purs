module ToA.Resource.Icon.Job.Puppeteer
  ( puppeteer
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
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (dice, italic, newline, ref, seq, text)
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

puppeteer :: Icon
puppeteer =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Puppeteer"
          , colour: Name "Yellow"
          , sign: Sign "icon-[game-icons--puppet]"
          , soul: Name "Shadow"
          , class: Name "Vagabond"
          , description: seq
              [ text
                  """Of all the major Leggio caravans, the story of the
                  thirteenth is perhaps the most tragic. Known most for its
                  mastery of the puppet theatre and its lifelike, life-sized
                  marionettes, its history, once carved into the wooden flanks
                  of its colorful wagons, has been lost, chipped into splinters,
                  and fed to the flames when it was betrayed by the guilds. Its
                  people were scattered to the winds, absorbed by other
                  caravans, or left to live a meagre existence as refugees."""
              , newline
              , newline
              , text
                  """According to legend, there were no other survivors. Yet
                  occasionally, defeated guild members are found in the trees,
                  swinging in the breeze, strung up like a marionette on
                  beautiful white strings."""
              ]
          , trait: Name "Master Puppet"
          , keyword: Name "Summon"
          , abilities:
              (I /\ Name "White Strings")
                : (I /\ Name "Black Strings")
                : (II /\ Name "Umbral Echo")
                : (IV /\ Name "Razor Top")
                : empty
          , limitBreak: Name "Gran Guignol"
          , talents:
              Id "marionette|talent|puppeteer"
                : Id "malinger|talent|puppeteer"
                : Id "deftness|talent|puppeteer"
                : empty
          }
      ]

  , traits:
      [ InsetTrait
          { name: Name "Master Puppet"
          , description: text
              """You start combat with a master puppet summon placed in range
              1-2 of you, a custom build companion. If the summon is removed or
              dismissed for any reason, you can place it again in range with a
              quick ability on your turn."""
          , inset: SummonInset
              { name: Name "Master Puppet"
              , colour: Name "Yellow"
              , max: 1
              , abilities:
                  [ Step SummonAction Nothing $ seq
                      [ text "Push or pull the puppet "
                      , dice 1 D3
                      , text "+2 spaces."
                      ]
                  , Step SummonAction Nothing $ text
                      "The puppet swaps places with a character in range 1-2."
                  , Step SummonEff Nothing $ seq
                      [ text
                          """When the puppet would enter the space of a foe or
                          it would be swapped with a foe, you may deal 2 damage
                          to that foe, or """
                      , dice 2 D3
                      , text " if the foe is in "
                      , italic $ ref (Name "Crisis") $ text "crisis"
                      , text "."
                      ]
                  ]
              }
          }
      ]

  , talents:
      [ Talent
          { id: Id "marionette|talent|puppeteer"
          , name: Name "Marionette"
          , colour: Name "Yellow"
          , description: seq
              [ text "As a "
              , italic $ ref (Name "Quick") $ text "quick"
              , text
                  """ ability, you may push or pull a summon or object in range
                  2-4 of you 2 spaces."""
              ]
          }
      , Talent
          { id: Id "malinger|talent|puppeteer"
          , name: Name "Malinger"
          , colour: Name "Yellow"
          , description: seq
              [ text "Once a round, when you "
              , italic $ ref (Name "Dismiss") $ text "dismiss"
              , text " a summon, you may create an "
              , italic $ ref (Name "Obscured") $ text "obscured"
              , text " space in the space it vacated."
              ]
          }
      , Talent
          { id: Id "deftness|talent|puppeteer"
          , name: Name "Deftness"
          , colour: Name "Yellow"
          , description: text
              """You can push or pull diagonally, You can always choose to push
              or pull 1 space instead of any other number."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Gran Guignol"
          , colour: Name "Yellow"
          , description: text
              """The strings are flexible, yet tough as steel, reinforced with
              soul aether. They are nearly invisible until you will them into
              motion. Then your foes will discover who is truly free to choose
              their own fate."""
          , cost: One /\ 2
          , tags: [ RangeTag (Range (NumVar 2) (NumVar 4)) ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Choose one of the following: foes, allies, summons, or
                      all, then choose a space in range. Remove all that qualify
                      in range of this ability from the battlefield. Place them
                      in free adjacent space to the chosen space, in any order
                      you like. If there in no free space, place them back in
                      their original location. They become """
                  , italic $ ref (Name "Immobile") $ text "immobilized"
                  , text
                      """ and unable to take interrupts until the start of their
                      next turn."""
                  ]
              ]
          }
      , Ability
          { name: Name "White Strings"
          , colour: Name "Yellow"
          , description: text
              """Whip-thin white strings retract from your gauntlet, snapping
              around limbs."""
          , cost: One
          , tags: [ Attack, RangeTag (Range (NumVar 2) (NumVar 5)) ]
          , steps:
              [ AttackStep (text "2 damage") $ seq [ text "+", dice 1 D3 ]
              , Step OnHit Nothing $ text
                  """Pull your foe 3 spaces towards yourself, an ally or an
                  allied summon in range. The first time during this pull they
                  would enter your space or the space of an ally or allied
                  summon, they take damage equal to the space they were pulled
                  before entering that character's space (max 6)."""
              , Step Eff Nothing $ text
                  "If your target is in crisis, they take this damage twice."
              ]
          }
      , Ability
          { name: Name "Black Strings"
          , colour: Name "Yellow"
          , description: text
              """Detach shadowy strings that hook into the soul aether of your
              target, dragging them where you will."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 2) (NumVar 4))
              ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) (Just D3) $ seq
                  [ text
                      """Mark a character or summon in range. At their turn
                      start, pull your target """
                  , dice 1 D3
                  , text "+2 spaces towards you with "
                  , italic $ ref (Name "Phasing") $ text "phasing"
                  , text
                      """. This ability does not require line of sight. If your
                      target is a foe, for every ally, object, or allied summon
                      your character passes through during this movement, your
                      target takes 2 damage. A foe can pass a save at the end of
                      their turn to remove this mark."""
                  ]
              ]
          }
      , Ability
          { name: Name "Umbral Echo"
          , colour: Name "Yellow"
          , description: text
              """You create shadow twins of yourself and allies, confounding
              foes."""
          , cost: Two
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 1) (NumVar 3))
              , KeywordTag (Name "Swap")
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) (Just D6)
                  ( text
                      """Summon two or (4+) three or (6+) five umbral echoes in
                      free space in range."""
                  )
                  $ SummonInset
                      { name: Name "Umbral Echo"
                      , colour: Name "Yellow"
                      , max: 4
                      , abilities:
                          [ Step SummonAction Nothing $ seq
                              [ text
                                  """Swap yourself or an ally with an echo in
                                  range 1-3. Characters swapped gain """
                              , italic $ ref (Name "Stealth") $ text "stealth"
                              , text
                                  """. After swapping with an echo, dismiss the
                                  echo and create an """
                              , italic $ ref (Name "Obscured") $ text "obscured"
                              , text " space where you dismissed it."
                              ]
                          , Step SummonEff Nothing $ text
                              """Allies can take the above summon action on
                              their turn as long as you have at least one
                              echo."""
                          ]
                      }
              ]
          }
      , Ability
          { name: Name "Razor Top"
          , colour: Name "Yellow"
          , description: text "With a flash, you summon whirling death."
          , cost: One
          , tags:
              [ KeywordTag (Name "Summon")
              , RangeTag (Range (NumVar 2) (NumVar 4))
              ]
          , steps:
              [ InsetStep (KeywordStep (Name "Summon")) Nothing
                  (text "Summon a razor top in range.")
                  $ SummonInset
                      { name: Name "Razor Top"
                      , colour: Name "Yellow"
                      , max: 2
                      , abilities:
                          [ Step SummonEff Nothing $ seq
                              [ text "The top is "
                              , italic
                                  $ ref (Name "Dangerous Terrain")
                                  $ text "dangerous terrain"
                              , text " as well as a summon."
                              ]
                          , Step SummonEff Nothing $ text
                              """The top can be targeted by effects that push,
                              pull or teleport a character. Once a round, after
                              you push, pull or teleport a top, it spins and
                              deal 2 damage to all adjacent foes."""
                          , Step (KeywordStep (Name "Isolate")) Nothing $ seq
                              [ text "Damage gains "
                              , italic $ ref (Name "Pierce") $ text "piercing"
                              , text ", or becomes "
                              , dice 1 D3
                              , text "+2 "
                              , italic $ text "piercing"
                              , text
                                  """ if there are no characters other than you
                                  in range 1-2."""
                              ]
                          ]
                      }
              ]
          }
      ]
  }
