module ToA.Resource.Icon.Ability.WeepingAssassin
  ( hollow
  , harien
  , shadowCloak
  , nightsCaress
  , suddenStrike
  , swallowTheStars
  ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

hollow :: Ability
hollow = LimitBreak
  { name: Name "Hollow"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You draw the night around you, becoming a shadowy being of
          pure, writhing darkness."""
      ]
  , cost: Quick /\ 3
  , tags: [ TargetTag Self ]
  , steps:
      [ Step Nothing $ Eff
          [ Text "You gain 3 "
          , Italic [ Ref (Name "Haste") [ Text "haste" ] ]
          , Text
              """, then take on a shadowy form. While in this form, you
              are immune to all damage, gain """
          , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
          , Text ", and may "
          , Italic [ Ref (Name "Fly") [ Text "fly" ] ]
          , Text
              """ when you take your free move. You exit this form when
              you enter any space in range 1-2 of a foe, or when a foe
              enters any space in range 1-2 of you, but re-enter as soon
              as either of these cease to be true. It ends completely at
              the end of you next turn."""
          ]
      , Step Nothing $ Eff
          [ Text
              """You can transfer this effect to an ally instead. If you
              do, """
          , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
          , Text
              """ 25% of you maximum hp, and it lasts until the end of
              their next turn."""
          ]
      ]
  }

harien :: Ability
harien = Ability
  { name: Name "Harien"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You strike from the darkness. When your opponent turns, you
          have faded into the night."""
      ]
  , cost: One
  , tags: [ Attack, Close, AreaTag (Arc 3) ]
  , steps:
      [ Step Nothing $ Eff [ Text "Dash 2." ]
      , Step Nothing $ AttackStep
          [ Text "2 damage" ]
          [ Text "+", Dice 1 D3 ]
      , Step Nothing $ AreaEff [ Text "2 damage." ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text "Dash 2, then gain "
          , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
          , Text
              """. If there are no characters other than you in range
              1-2, increase dash to 4."""
          ]
      ]
  }

shadowCloak :: Ability
shadowCloak = Ability
  { name: Name "Shadow Cloak"
  , colour: Name "Yellow"
  , description: [ Text "Pull the shadows tighter around you." ]
  , cost: Two
  , tags:
      [ KeywordTag (Name "Mark")
      , RangeTag (Range 1 2)
      , KeywordTag (Name "Power Die")
      ]
  , steps:
      [ Step Nothing $ KeywordStep (Name "Mark")
          [ Text
              """Mark self or an ally in range and set out a d6 power
              die, starting at 6. The marked character has """
          , Italic [ Ref (Name "Phasing") [ Text "phasing" ] ]
          , Text " and permanent "
          , Italic [ Ref (Name "Evasion") [ Text "evasion" ] ]
          , Text
              """. After evasion triggers, successful or not, tick the
              power die down by 2. When the die is 0, discard it and end
              this mark, and the marked character may teleport 2 and
              gain """
          , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
          , Text "."
          ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text
              """If the marked character ends their turn with no other
              characters adjacent, they may tick the die up by 2, or by
              +4 if there are no characters other then you in range 2."""
          ]
      ]
  }

nightsCaress :: Ability
nightsCaress = Ability
  { name: Name "Night's Caress"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You relentlessly hunt your prey, following them through a
          shadowy rift even if they flee."""
      ]
  , cost: One
  , tags: [ RangeTag (Range 1 3) ]
  , steps:
      [ SubStep Nothing (Name "Sudden Strike") $ KeywordStep (Name "Mark")
          [ Text
              """Mark a foe then gain the following interrupt at the
              start of each round while they are marked."""
          ]
      ]
  }

suddenStrike :: Ability
suddenStrike = Ability
  { name: Name "Sudden Strike"
  , colour: Name "Yellow"
  , description: []
  , cost: Interrupt 1
  , tags: []
  , steps:
      [ Step Nothing $ TriggerStep 
          [ Text "Your marked foe end their turn." ]
      , Step Nothing $ Eff
          [ Text
              """If your foe is in range 1-3, teleport to a free space
              adjacent to them. They must save or take """
          , Dice 3 D3
          , Text
              """ or just 3 damage on a successful save. Then end your
              mark. Otherwise, teleport 1 and keep the mark."""
          ]
      , Step Nothing $ KeywordStep (Name "Isolate")
          [ Text
              """Deal +2 damage, or +4 if there are no characters other
              than you in range 1-2."""
          ]
      ]
  }

swallowTheStars :: Ability
swallowTheStars = Ability
  { name: Name "Swallow the Stars"
  , colour: Name "Yellow"
  , description:
      [ Text
          """Dark aether coats your blade, preparing final rest for you
          foe."""
      ]
  , cost: One
  , tags: [ End ]
  , steps:
      [ Step Nothing $ Eff
          [ Bold [ Text "End you turn" ]
          , Text " and gain "
          , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
          , Text ". Your next attack gains:"
          , List Unordered
              [ [ Italic [ Text "On hit" ]
                , Text ": If your foe is in "
                , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                , Text ", they must save or take "
                , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                , Text " damage equal to 25% hp of their max hp, or 2 "
                , Italic [ Text "piercing" ]
                , Text
                    """ damage on a successful save. If they are not in
                    crisis, they take 2 """
                , Italic [ Text "piercing" ]
                , Text " damage instead."
                ]
              , [ Italic [ Text "Effect" ]
                , Text ": Legend characters take 2 "
                , Italic [ Text "piercing" ]
                , Text
                    " damage on hit instead of the above effect, or 6 "
                , Italic [ Text "piercing" ]
                , Text " damage on a failed save if they are in crisis."
                ]
              ]
          ]
      , Step Nothing $ KeywordStep (Name "Afflicted")
          [ Text "Foe gains ", Weakness, Text " on the save." ]
      ]
  }
