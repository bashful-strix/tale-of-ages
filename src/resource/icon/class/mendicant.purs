module ToA.Resource.Icon.Class.Mendicant
  ( mendicant
  ) where

import Prelude

import Color (fromInt)

import Data.Maybe (Maybe(..))

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
import ToA.Data.Icon.Class (Class(..))
import ToA.Data.Icon.Colour (Colour(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))
import ToA.Data.Icon.Trait (Trait(..))

mendicant :: Icon
mendicant =
  { classes:
      [ Class
          { name: Name "Mendicant"
          , colour: Name "Green"
          , tagline: [ Text "Wndering healer and storyteller." ]
          , strengths:
              [ Text
                  """Strong all-rounders, with may potent effects and the
                  ability to heal or move allies and lift negative statuses."""
              ]
          , weaknesses: [ Text "Low damage and reliant on allies." ]
          , complexity: [ Text "High" ]
          , description:
              [ Text
                  """Mendicants are the itinerant priests, exorcists, and
                  healers of Arden Eld. They travel from town to town, healing
                  sicknesses of the body and soul, cleansing the damage dealt by
                  the ruins, consulting with local spirits, and setting up wards
                  against evil. Many mendicants are highly learned scholars, but
                  others come from folk practices, temple monks, green witch
                  circles, or town priesthoods. They are a highly diverse lot,
                  and attuned to the land and the people that they care for."""
              , Newline
              , Newline
              , Text
                  """Mendicants are good all-rounders but primarily focus on
                  supporting their allies - most of their abilities help to
                  bolster their team rather than helping themselves, making them
                  the lynchpin of any party."""
              ]
          , hp: 48
          , defense: 4
          , move: 4
          , trait: Name "Bless"
          , basic: Name "Glia"
          , keywords:
              [ Name "Aura"
              , Name "Brand"
              , Name "Crisis"
              , Name "Pierce"
              , Name "Stance"
              , Name "Strength"
              , Name "Unstoppable"
              ]
          , apprentice:
              [ Name "Gliaga"
              , Name "Dios"
              , Name "Megi"
              , Name "Viga"
              , Name "Aegi"
              , Name "Diaga"
              ]
          }
      ]
  , colours:
      [ Colour { name: Name "Green", value: fromInt 0x5ea500 } ] -- lime-600
  , souls:
      [ Soul
          { name: Name "Bard"
          , colour: Name "Green"
          , class: Name "Mendicant"
          , description:
              [ Text "The soul of one abrim with legend and song."
              , Newline
              , Text
                  """After all we have done, someone will carry the fire
                  forward. They shall see it burning."""
              ]
          }
      , Soul
          { name: Name "Witch"
          , colour: Name "Green"
          , class: Name "Mendicant"
          , description:
              [ Text "The soul of one bathed in moonlight."
              , Newline
              , Text
                  """The moon is a harbinger of birth and death. Old growth must
                  be cut away to make room for the new."""
              ]
          }
      , Soul
          { name: Name "Monk"
          , colour: Name "Green"
          , class: Name "Mendicant"
          , description:
              [ Text "The soul of one bound in iron discipline."
              , Newline
              , Text
                  """The fortress without is brittle and hard. The fortress
                  within is gentle and open, but loses none of its strength. Its
                  gates may be closed at will."""
              ]
          }
      , Soul
          { name: Name "Oracle"
          , colour: Name "Green"
          , class: Name "Mendicant"
          , description:
              [ Text "The soul of one who reads the stars as their guide."
              , Newline
              , Text
                  """Though the stars are distant, their bright and fiery trails
                  form a sparkling map of the heavens."""
              ]
          }
      ]
  , jobs: []
  , traits:
      [ Trait
          { name: Name "Bless"
          , description:
              [ Text
                  """You are a pillar of strength and stability on the
                  battlefield, granting the following benefits:"""
              , Newline
              , List Unordered
                  [ [ Text
                        """Once a round, before an ally in range 1-4 makes any
                        effect roll or save, you can cause them to roll it
                        with """
                    , Power
                    , Text
                        """. A roll can only benefit from this effect once at a
                        time."""
                    ]
                  , [ Text
                        """You may use Rescue to bring up allies in range 1-4
                        instead of adjacent."""
                    ]
                  , [ Text "The first time you use Rescue in a combat, it's a "
                    , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                    , Text " ability."
                    ]
                  ]
              ]
          , subItem: Nothing
          }
      ]
  , talents: []
  , abilities:
      [ Ability
          { name: Name "Glia"
          , colour: Name "Green"
          , description: [ Text "A spark of light" ]
          , cost: One
          , tags:
              [ Attack
              , RangeTag (Range (NumVar 1) (NumVar 5))
              , KeywordTag (Name "Pierce")
              ]
          , steps:
              [ Step Nothing $ AttackStep
                  [ Text "1 piercing damage" ]
                  [ Text "+1 piercing damage" ]
              , Step (Just D3) $ OnHit
                  [ Text "Gain "
                  , Italic [ Dice 1 D3 ]
                  , Text " "
                  , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                  , Text ", then distribute it in any order to allies in range."
                  ]
              ]
          }
      , Ability
          { name: Name "Gliaga"
          , colour: Name "Green"
          , description:
              [ Text
                  """A magnificent blaze of light aether invigorates your allies
                  and scours your enemies."""
              ]
          , cost: Two
          , tags:
              [ Attack
              , AreaTag (Blast (NumVar 3))
              , RangeTag (Range (NumVar 2) (NumVar 5))
              ]
          , steps:
              [ Step Nothing $ AttackStep
                  [ Text "3 damage" ]
                  [ Text "+", Dice 1 D6 ]
              , Step Nothing $ AreaEff [ Text "3 damage." ]
              , Step (Just D3) $ Eff
                  [ Text
                      """Allies in the area don't take samage but instead gain 2
                      vigor. Bloodied allies gain """
                  , Italic [ Dice 1 D3 ]
                  , Text "+1 vigor instead."
                  ]
              ]
          }
      , Ability
          { name: Name "Dios"
          , colour: Name "Green"
          , description: [ Text "You ignite a spark of divine energy." ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Zone")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              , AreaTag (Cross (NumVar 1))
              ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Zone")
                  [ Text
                      """Place a zone of scintillating dark or light energy down
                      in free space in range. It can be placed over
                      characters."""
                  , List Unordered
                      [ [ Italic [ Text "Dark: " ]
                        , Text "The entire space is "
                        , Italic [ Ref (Name "Obscured") [ Text "obscured" ] ]
                        , Text " and "
                        , Italic
                            [ Ref
                                (Name "Difficult Terrain")
                                [ Text "difficult terrain" ]
                            ]
                        , Text "."
                        ]
                      , [ Italic [ Text "Light: " ]
                        , Text
                            """Foes that start or end their turn in the area
                            gain """
                        , Italic [ Ref (Name "Brand") [ Text "brand" ] ]
                        , Text
                            """. Allies that either start or end their turn
                            there may clear 1 negative status, then save, ending
                            one more on a success."""
                        ]
                      ]
                  ]
              ]
          }
      , Ability
          { name: Name "Megi"
          , colour: Name "Green"
          , description: [ Text "Sear a mark of your divinity into your foe." ]
          , cost: One
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              ]
          , steps:
              [ Step Nothing $ KeywordStep (Name "Mark")
                  [ Text
                      """Mark a foe in range. While marked, abilities that
                      target the foe gain effect """
                  , Power
                  , Text " and that foe's abilities gain effect "
                  , Weakness
                  , Text
                      """. If the foe is defeated, you may transfer this ability
                      to a new foe in range as a """
                  , Italic [ Ref (Name "Quick") [ Text "quick" ] ]
                  , Text " ability during your turn."
                  ]
              ]
          }
      , Ability
          { name: Name "Viga"
          , colour: Name "Green"
          , description: [ Text "Spur your allies to action." ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ Step (Just D6) $ Eff
                  [ Text "An ally in range gains one (6+) two "
                  , Italic [ Ref (Name "Strength") [ Text "strength" ] ]
                  , Text " and may immediately make a free move."
                  ]
              ]
          }
      , Ability
          { name: Name "Aegi"
          , colour: Name "Green"
          , description: [ Text "You coalesce a divine shield over your ally." ]
          , cost: Two
          , tags:
              [ KeywordTag (Name "Mark")
              , RangeTag (Range (NumVar 1) (NumVar 4))
              ]
          , steps:
              [ Step (Just D6) $ KeywordStep (Name "Mark")
                  [ Text "Marked character gains "
                  , Dice 2 D3
                  , Text
                      """+4 vigor upon being marked, then takes half damage
                      while marked. The first time in a turn an ability that
                      damages them resolves, roll the effect die. On a 5+, keep
                      this mark. Otherwise, they lose the mark and all vigor."""
                  ]
              ]
          }
      , Ability
          { name: Name "Diaga"
          , colour: Name "Green"
          , description:
              [ Text "Purge toxins, curses, and brands from your ally." ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ Step Nothing $ Eff
                  [ Text
                      """A character in range can immediately save. They get rid
                      of one negative status token of their choice, and may get
                      rid of one more on a successful save."""
                  ]
              , Step Nothing $ Eff
                  [ Text "If they are bloodied, they gain "
                  , Power
                  , Text " on the save. If they are in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text
                      ", they may remove one more token on a successful save."
                  ]
              ]
          }
      ]
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
