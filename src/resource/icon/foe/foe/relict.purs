module ToA.Resource.Icon.Foe.Foe.Relict
  ( husk
  , necrosavant
  , wraith
  ) where

import Prelude

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Tag(..)
  )
import ToA.Data.Icon.Chapter (Chapter(..))
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Foe
  ( Foe(..)
  , FoeAbility(..)
  , FoeInsert(..)
  , FoeTrait(..)
  )
import ToA.Data.Icon.Markup (MarkupItem(..), ListKind(..))
import ToA.Data.Icon.Name (Name(..))

husk :: Foe
husk = Mob
  { name: Name "Husk"
  , colour: Name "Purple"
  , class: Name "Mob"
  , faction: Just $ Name "Relict"
  , description:
      [ Text
          """The shuffling mass of relict servitors, in thrall to the
          network."""
      ]
  , notes:
      [ Text
          """This mob is always present in Relict fights. When new
          husks are summoned, they add to the current mob, or create a
          new one that can act on the following round if there isn’t
          one. """
      ]
  , traits:
      [ FoeTrait
          { name: Name "Endless Dead"
          , description:
              [ Text
                  """Add to this mob by 1 at the start of every round,
                  placing a new member anywhere on the battlefield not
                  adjacent to a foe."""
              ]
          }
      , FoeTrait
          { name: Name "Fading"
          , description:
              [ Text
                  """This mob is defeated if all of its allies is
                  defeated, and disintegrates."""
              ]
          }
      ]
  , abilities:
      [ FoeAbility
          { name: Name "Frenzied Scrabbling"
          , cost: Two
          , tags: []
          , description:
              [ Italic [ Text "Effect" ]
              , Text
                  """: All husks may dash 2. Then any foes adjacent to
                  one or more husks take 2 damage."""
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Soul Sacrifice"
          , cost: Two
          , tags: []
          , description:
              [ Text
                  """Choose a bloodied character adjacent to one or more
                  husks, then destroy any number of husks adjacent to
                  that character. If that character is an ally, they gain
                  2 vigor per husk destroyed. If that character was a
                  foe, they must save or """
              , Italic [ Ref (Name "Sacrifice") [ Text "sacrifice" ] ]
              , Text
                  """ 2 per husk destroyed, or sacrifice 1 per husk on a
                  successful save."""
              ]
          , chain: Nothing
          , insert: Nothing
          }
      ]
  }

necrosavant :: Foe
necrosavant = Foe
  { name: Name "Necrosavant"
  , colour: Name "Green"
  , class: Name "Leader"
  , faction: Just $ Name "Relict"
  , chapter: Just I
  , description:
      [ Text
          """The Priests of the Black Sun were the central cult of the
          Arken Imperium and foremost in political power and influence.
          It was they, under the leadership of their sorcerer-priests,
          that orchestrated the Ur-spell that necrotized what remained of
          the empire. The process of preserving the entire population of
          the empire required a great deal of work, and therefore the
          priests classes were split into many castes that labored at
          numerous terrible projects. In the end of days, in their
          desperation, they delved into deeper and darker magics and
          sacrificed their very souls for the purpose of the Great
          Work."""
      ]
  , notes: []
  , traits: []
  , abilities:
      [ FoeAbility
          { name: Name "Unholy"
          , cost: One
          , tags: [ Attack, RangeTag (Range 2 5), AreaTag (Cross 2) ]
          , description:
              [ Text "1 piercing damage. "
              , Italic [ Text "Hit" ]
              , Text ": +1 piercing damage. "
              , Italic [ Text "Area effect" ]
              , Text ": 1 piercing damage. "
              , Italic [ Text "On hit" ]
              , Text ": All foes in the area must sacrifice "
              , Italic [ Dice 1 D3 ]
              , Text " after this ability resolves. "
              , Italic [ Ref (Name "Horde") [ Text "Horde" ] ]
              , Text ": Double sacrifice ammount."
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Rahaal"
          , cost: One
          , tags: [ RangeTag (Range 1 4) ]
          , description:
              [ Text
                  "Chose a character in range. That character chooses:"
              , List Unordered
                  [ [ Text "foe: sacrifice 4 or gain 2 "
                    , Italic [ Ref (Name "Brand") [ Text "branded" ] ]
                    , Text "."
                    ]
                  , [ Text "ally: dash 2 or clear a negative status." ]
                  ]
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Terrorize"
          , cost: One
          , tags: [ RangeTag (Range 1 3), LimitTag 1 "combat" ]
          , description:
              [ Italic [ Text "Effect" ]
              , Text
                  """: A foe in range is marked. While marked, they deal
                  half damage. They may ignore this effect while
                  adjacent to an ally. At the end of the turn, they may
                  save to end this mark. End a turn adjacent to an ally,
                  ending this mark."""
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Call the Dead"
          , cost: One
          , tags:
              [ Close
              , AreaTag (Line 4)
              , KeywordTag (Name "Zone")
              , End
              , LimitTag 1 "combat"
              ]
          , description:
              [ Italic [ Text "Area Effect" ]
              , Text
                  """: Creates a one space grasping hands zone under
                  every foe or ally in the area. Any number of these
                  zones can be active. The zones are """
              , Italic
                  [ Ref
                      (Name "Difficult Terrain")
                      [ Text "difficult terrain" ]
                  ]
              , Text " for foes. While inside, foes deal damage "
              , Weakness
              , Text " and abilities used against them trigger all "
              , Italic [ Ref (Name "Horde") [ Text "horde" ] ]
              , Text " effects."
              ]
          , chain: Nothing
          , insert: Nothing
          }
      ]
  }

wraith :: Foe
wraith = Foe
  { name: Name "Wraith"
  , colour: Name "Blue"
  , class: Name "Artillery"
  , faction: Just $ Name "Relict"
  , chapter: Just I
  , description:
      [ Text
          """Former slave wrights of the old empire, turned into living
          weapons to fight back against the Doom. Tethered to the
          network, these relict can float on the air with eerie grace,
          flickering in and out of existence."""
      ]
  , notes: []
  , traits: []
  , abilities:
      [ FoeAbility
          { name: Name "Gauntlet Bolt"
          , cost: One
          , tags:
              [ Attack, RangeTag (Range 1 5), KeywordTag (Name "Chain") ]
          , description:
              [ Text "1 damage. "
              , Italic [ Text "Hit" ]
              , Text ": +"
              , Dice 1 D6
              , Text ". "
              , Italic [ Ref (Name "Horde") [ Text "Horde" ] ]
              , Text ": Create "
              , Italic
                  [ Ref
                      (Name "Dangerous Terrain")
                      [ Text "dangerous terrain" ]
                  ]
              , Text
                  """ under the target and every adjacent all of the
                  target."""
              ]
          , chain: Just $ FoeAbility
              { name: Name "Chain Lightning"
              , cost: Two
              , tags:
                  [ Attack
                  , RangeTag (Range 2 6)
                  , AreaTag (Cross 3)
                  , KeywordTag (Name "Chain")
                  ]
              , description:
                  [ Text "2 damage. "
                  , Italic [ Text "Hit" ]
                  , Text ": +"
                  , Dice 2 D6
                  , Text ". "
                  , Italic [ Text "Area effect" ]
                  , Text ": 2 damage. "
                  , Italic [ Text "Effect" ]
                  , Text
                      """: Deals 3 damage again to all foes if catching
                      3 or more foes or """
                  , Italic [ Text "soul sparks" ]
                  , Text " in the area."
                  ]
              , chain: Nothing
              , insert: Nothing
              }
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Rift Tear"
          , cost: One
          , tags: [ RangeTag (Range 1 3) ]
          , description:
              [ Text
                  """Teleport 3. Alternatively, teleport a character in
                  range 1. """
              , Italic [ Ref (Name "Horde") [ Text "Horde" ] ]
              , Text ": Teleport +2."
              ]
          , chain: Nothing
          , insert: Nothing
          }
      , FoeAbility
          { name: Name "Soul Spark"
          , cost: One
          , tags: [ RangeTag (Range 1 6), KeywordTag (Name "Summon") ]
          , description:
              [ Text "Create a "
              , Italic [ Text "Soul Spark" ]
              , Text " summon in free space in range."
              ]
          , chain: Nothing
          , insert: Just $ SummonInsert
              { name: Name "Soul Spark"
              , colour: Name "Blue"
              , max: 3
              , effects:
                  [ [ Text
                        """All damage against foes adjacent to soul
                        sparks gain damage """
                    , Power
                    , Text " and becomes "
                    , Italic
                        [ Ref (Name "Pierce") [ Text "piercing" ] ]
                    , Text "."
                    ]
                  ]
              }
          }
      ]
  }
