module Test.ToA.Data.Icon.Character (spec) where

import Prelude

import Data.Codec (decode, encode)
import Data.FastVect.FastVect ((:), empty, set)
import Data.FastVect.Common (term)
import Data.Lens.Setter ((.~), (%~), (<>~))
import Data.Map (fromFoldable)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon, _abilities, _jobs, _talents)
import ToA.Data.Icon.Ability (Ability(..), Action(..)) as A
import ToA.Data.Icon.Id (Id(..), _id)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Job (_talents) as J
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Icon.Talent (Talent(..))

import ToA.Data.Icon.Character
  ( Character(..)
  , State(..)
  , Build(..)
  , Level(..)
  , stringCharacter
  )

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (AnyShow(..), shouldEqual)

job :: Job
job = Job
  { name: Name "Job"
  , colour: Name "Col"
  , soul: Name "Soul"
  , class: Name "Class"
  , description: []
  , trait: Name "Trait"
  , keyword: Name "Keyword"
  , abilities:
      (I /\ Name "A1")
        : (I /\ Name "A2")
        : (II /\ Name "A3")
        : (IV /\ Name "A4")
        : empty
  , limitBreak: Name "LB"
  , talents:
      Id "T1" : Id "T2" : Id "T3" : empty
  }

talent :: Talent
talent = Talent
  { id: Id "id|talent"
  , name: Name "Talent"
  , colour: Name "Col"
  , description: []
  }

ability :: A.Ability
ability = A.Ability
  { name: Name "Ability"
  , colour: Name "Col"
  , description: []
  , cost: A.One
  , tags: []
  , steps: []
  }

icon :: Icon
icon = mempty
  # _jobs <>~
      [ job # _name .~ Name "Primary"
      , job # _name .~ Name "Job 1"
            # J._talents %~ set (term :: _ 0) (Id "talent-1|talent|job-1")
            # J._talents %~ set (term :: _ 0) (Id "talent-2|talent|job-1")
      , job # _name .~ Name "Job 2"
            # J._talents %~ set (term :: _ 1) (Id "talent-2|talent|job-2")
      , job # _name .~ Name "Job 3"
      , job # _name .~ Name "Job 4"
      ]
  # _talents <>~
      [ talent # _id .~ Id "talent-1|talent|job-1"
               # _name .~ Name "Talent 1"
      , talent # _id .~ Id "talent-2|talent|job-1"
               # _name .~ Name "Talent 2"
      , talent # _id .~ Id "talent-2|talent|job-2"
               # _name .~ Name "Talent 2"
      ]
  # _abilities <>~
      [ ability # _name .~ Name "Active 1"
      , ability # _name .~ Name "Active 2"
      , ability # _name .~ Name "Inactive 1"
      , ability # _name .~ Name "Inactive 2"
      ]

spec :: Spec Unit
spec = do
  describe "character codec" do
    it "should roundtrip characters" do
      let
        c = Character
          { name: Name "Test Name"
          , state: State {}
          , build: Build
              { level: One
              , primary: Name "Primary"
              , jobs: fromFoldable
                  [ Name "Job 1" /\ I
                  , Name "Job 2" /\ II
                  , Name "Job 3" /\ III
                  , Name "Job 4" /\ IV
                  ]
              , talents:
                  [ Id "talent-1|talent|job-1"
                  , Id "talent-2|talent|job-1"
                  ]
              , abilities:
                  { active: [ Name "Active 1", Name "Active 2" ]
                  , inactive: [ Name "Inactive 1", Name "Inactive 2" ]
                  }
              }
          }

      ( AnyShow <$> decode (stringCharacter icon)
          (encode (stringCharacter icon) c)
      )
        `shouldEqual` pure (AnyShow c)

    it "should roundtrip text" do
      let
        t =
          """Name :: Test Name
Level :: 1
Primary :: Primary
Jobs :: Job 1 I | Job 2 II | Job 3 III | Job 4 IV

Talents
- Talent 1
- Talent 2 | Job 1

Abilities
+ Active 1
+ Active 2
- Inactive 1
- Inactive 2"""

      (encode (stringCharacter icon) <$> decode (stringCharacter icon) t)
        `shouldEqual` pure t

    it "should decode an unusual text build" do
      let
        i = mempty
          # _jobs <>~
              [ job # _name .~ Name "Tactician"
                    # J._talents %~ set (term :: _ 0)
                        (Id "vantage|talent|tactician")
              , job # _name .~ Name "Spellblade"
              , job # _name .~ Name "Weeping Assassin"
              ]
          # _talents <>~
              [ talent # _id .~ Id "vantage|talent|tactician"
                       # _name .~ Name "Vantage"
              ]
          # _abilities <>~
              [ ability # _name .~ Name "Pincer Attack"
              , ability # _name .~ Name "Bait and Switch"
              ]
        t =
          """
Name: Testina
Level :: 1
Primary :: Tactician

Jobs :: Tactician I
      | Spellblade II
      / Weeping Assassin I

Talents
- Vantage

Abilities ::
- Pincer Attack
+ Bait and Switch
          """

      (AnyShow <$> (decode (stringCharacter i) t))
        `shouldEqual`
          ( pure $ AnyShow $ Character
              { name: Name "Testina"
              , state: State {}
              , build: Build
                  { level: One
                  , primary: Name "Tactician"
                  , jobs: fromFoldable
                      [ Name "Tactician" /\ I
                      , Name "Spellblade" /\ II
                      , Name "Weeping Assassin" /\ I
                      ]
                  , talents: [ Id "vantage|talent|tactician" ]
                  , abilities:
                      { active: [ Name "Bait and Switch" ]
                      , inactive: [ Name "Pincer Attack" ]
                      }
                  }
              }
          )
