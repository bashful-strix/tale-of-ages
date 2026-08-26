module ToA.Resource.Icon.Job.Celestian
  ( celestian
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
  , ref
  , seq
  , text
  )
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Sign (Sign(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

celestian :: Icon
celestian =
  { classes: []
  , colours: []
  , souls: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []

  , jobs:
      [ Job
          { name: Name "Celestian"
          , colour: Name "Green"
          , sign: Sign "icon-[game-icons--eclipse]"
          , soul: Name "Oracle"
          , class: Name "Mendicant"
          , description: seq
              [ text
                  """Across Arden Eld, the great Sages have often observed and
                  written that the position of the stars affects the ebb and
                  flow of Aether, something even sung about in the great Chant.
                  Some take this a step further, believing that the stars affect
                  the fate of mortals, the providence of the gods, and the
                  fortune of those born under their sign."""
              , newline
              , newline
              , text
                  """Celestians are a mix of both types - wrights and priests
                  that through diligent practice have found the ability to
                  actually tap into the unique Aether currents produced by the
                  heavenly bodies. Their power is therefore highly dependent on
                  their position, and they spend a good deal of their time
                  charting and studying the movements and energies of their
                  celestial patrons, while their mundane ones keep them busy
                  with horoscopes, fortune tellings, and portents."""
              ]
          , trait: Name "Heavenly Orrery"
          , keyword: Name "Isolate"
          , abilities:
              (I /\ Name "Astra")
                : (I /\ Name "Lunar Cleansing")
                : (II /\ Name "Polaris")
                : (IV /\ Name "Meteor")
                : empty
          , limitBreak: Name "Cosmic Doom"
          , talents:
              Id "dissolution|talent|celestian"
                : Id "hearken|talent|celestian"
                : Id "crater|talent|celestian"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Heavenly Orrery"
          , description: seq
              [ text
                  """At the start of the round, roll the effect die to see which
                  position the heavens are in. Your abilities become altered
                  this round based on what you roll."""
              , list Unordered
                  [ seq
                      [ bold $ text "(1-2) Solar syzergy"
                      , text
                          """: Increase all area damage by +2 and all blasts by
                          +1. Reduce all vigor granted to 1."""
                      ]
                  , seq
                      [ bold $ text "(3-4) Lunar confluence"
                      , text
                          """: Deal half damage. Increase all vigor granted by
                          +2 and increase the size of all lines by +3."""
                      ]
                  , seq
                      [ bold $ text "(5-6) Astral alignment"
                      , text
                          """: Increase all crosses by +2. Once a round,
                          increase a positive or negative status granted by
                          +1."""
                      ]
                  ]
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "dissolution|talent|celestian"
          , name: Name "Dissolution"
          , colour: Name "Green"
          , description: seq
              [ text
                  """Increase the effects of brand to -3 defense against the
                  attacks of you and adjacent allies. When you critical hit, you
                  can inflict """
              , italic $ ref (Name "Brand") $ text "brand"
              , text "."
              ]
          }
      , Talent
          { id: Id "hearken|talent|celestian"
          , name: Name "Hearken"
          , colour: Name "Green"
          , description: seq
              [ text
                  """Once a round, you may spend a free move to teleport
                  adjacent to any """
              , italic $ ref (Name "Isolate") $ text "isolated"
              , text " ally, or teleport any "
              , italic $ text "isolated"
              , text " ally adjacent to you."
              ]
          }
      , Talent
          { id: Id "crater|talent|celestian"
          , name: Name "Crater"
          , colour: Name "Green"
          , description: text
              """Your area effects deal +1 damage to foes 4 or more spaces away
              from you, increased to +2 at 7 or more spaces."""
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Cosmic Doom"
          , colour: Name "Green"
          , description: text
              """You twist a foe's fate in the life current, knocking their fate
              out of the normal flow of cosmic providence into something much
              more unfortunate."""
          , cost: One /\ 2
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)) ]
          , steps:
              [ Step (KeywordStep (Name "Mark")) Nothing $ seq
                  [ text
                      """You read a foe's ill fortune, then mark your foe. This
                      mark cannot be cleared. At the end of each of their turns
                      for the rest of combat, roll """
                  , italic $ dice 1 D6
                  , text " to see what fate befalls them this round: "
                  , list Unordered
                      [ seq
                          [ text "(1-2) "
                          , bold $ text "Solar Blast"
                          , text
                              """: Blast 3, including your foe. Your foe and all
                              other foes inside take 2 piercing damage. Your foe
                              is """
                          , italic $ ref (Name "Brand") $ text "branded"
                          , text "."
                          ]
                      , seq
                          [ text "(3-4) "
                          , bold $ text "Lunar Beam"
                          , text
                              """: Line 4, including your foe. All allies inside
                              gain 2 vigor and may remove 1 negative status.
                              Increase by +"""
                          , dice 1 D3
                          , text " vigor and grant 1 "
                          , italic $ ref (Name "Strength") $ text "strength"
                          , text " for allies in crisis."
                          ]
                      , seq
                          [ text "(5-6) "
                          , bold $ text "Astral Crush"
                          , text
                              """: Cross 1, including your foe, 2 damage. Your
                              foe must save or be """
                          , italic $ ref (Name "Stun") $ text "stunned"
                          , text
                              """, then has a height 1 meteor object created
                              adjacent to them."""
                          ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Astra"
          , colour: Name "Green"
          , description: text
              "You call down the heavens themselves on your foes."
          , cost: Two
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 3) (NumVar 6))
              , AreaTag (Blast (NumVar 4))
              ]
          , steps:
              [ AttackStep (text "3 damage") (seq [ text "+", dice 1 D3 ])
              , Step AreaEff Nothing $ text "3 damage to foes only."
              , Step Eff Nothing $ text
                  """Area effect deals 3 damage again if there is at least one
                  ally in the area."""
              , Step (KeywordStep (Name "Isolate")) Nothing $ text
                  """All isolated foes in the area take 3 damage again after
                  this ability resolves."""
              ]
          }
      , Ability
          { name: Name "Lunar Cleansing"
          , colour: Name "Green"
          , description: text
              "The pale light of the moon washes across the battlefield."
          , cost: One
          , tags:
              [ RangeTag (Range (NumVar 1) (NumVar 3))
              , AreaTag (Line (NumVar 3))
              ]
          , steps:
              [ Step AreaEff Nothing $ seq
                  [ text
                      """The first ally in the line gains 2 vigor and may clear
                      a negative status token. Foes in the line """
                  , italic $ text "after"
                  , text " the ally take 2 damage."
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing $ text
                  """If your ally is not adjacent to any other characters,
                  increase vigor and damage by +2 and clear 2 negative status
                  tokens instead."""
              ]
          }
      , Ability
          { name: Name "Polaris"
          , colour: Name "Green"
          , description: text
              """A distant glint in the heavens, portents of the devastation to
              come."""
          , cost: One
          , tags:
              [ End, RangeTag (Range (NumVar 3) (NumVar 5)) ]
          , steps:
              [ Step (KeywordStep (Name "Zone")) Nothing $ seq
                  [ bold $ text "End your turn"
                  , text
                      """ and call a meteor onto the battlefield that begins its
                      descent. You may have any number of these zones active.
                      The first time in a round a character enters one of these
                      zones, roll the effect die. If you roll equal to or under
                      the round number, a meteor lands in the space, """
                  , italic $ ref (Name "Brand") $ text "branding"
                  , text
                      """ that character and creating a cross 1 explosion
                      centered on them for """
                  , dice 1 D6
                  , text "+4 damage (save for half). Then remove the zone."
                  ]
              , Step (KeywordStep (Name "Isolate")) Nothing $ seq
                  [ text "Damage becomes "
                  , italic $ ref (Name "Pierce") $ text "piercing"
                  , text "."
                  ]
              ]
          }
      , Ability
          { name: Name "Meteor"
          , colour: Name "Green"
          , description: text
              """You pull a burning iron rock out of orbit and send it on
              collision course with your unlucky foe."""
          , cost: One
          , tags:
              [ KeywordTag (Name "Object")
              , RangeTag (Range (NumVar 3) (NumVar 10))
              ]
          , steps:
              [ Step Eff Nothing $ seq
                  [ text
                      """Choose a foe in range, and choose a number from 1-3. At
                      the end of that many of your foe's turns, they are struck
                      by a massive meteor. You may re-target the meteor to a new
                      foe in range as a """
                  , italic $ ref (Name "Quick") $ text "quick"
                  , text
                      """ ability if your targeted foe is defeated, keeping the
                      countdown timer. This ability also re-targets if you use
                      it again while a meteor is active. Characters caught in
                      the area (including the targeted character) may save to
                      halve damage."""
                  , list Ordered
                      [ seq [ dice 1 D6, text " damage, cross 1" ]
                      , seq
                          [ dice 1 D6
                          , text
                              """+4 damage, blast 3 with at least one space on
                              your foe, and push all characters 1 from the
                              target. Create difficult terrain under your
                              target."""
                          ]
                      , seq
                          [ dice 6 D6
                          , text
                              """ damage, blast 5 with at least one space on
                              your foe, and push all characters 2 from the
                              target. Lower terrain under the target by 1 and
                              create difficult terrain under them."""
                          ]
                      ]
                  ]
              , Step Eff Nothing $ text
                  """After this ability resolves, create a height 1 meteor
                  object adjacent to your target."""
              , Step (KeywordStep (Name "Isolate")) Nothing $ seq
                  [ italic $ ref (Name "Stun") $ text "Stuns"
                  , text " target if no other character is caught in the area."
                  ]
              ]
          }
      ]
  }
