module Test.ToA.Data.Icon.Character (spec) where

import Prelude

import Data.Codec (decode, encode)
import Data.Map (fromFoldable)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Name (Name(..))

import ToA.Data.Icon.Character
  ( Character(..)
  , State(..)
  , Build(..)
  , Level(..)
  , stringCharacter
  )
import ToA.Data.Icon.Job (JobLevel(..))

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (AnyShow(..), shouldEqual)

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
              , talents: [ Name "Talent 1", Name "Talent 2" ]
              , abilities:
                  { active: [ Name "Active 1", Name "Active 2" ]
                  , inactive: [ Name "Inactive 1", Name "Inactive 2" ]
                  }
              }
          }

      (AnyShow <$> decode stringCharacter (encode stringCharacter c))
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
- Talent 2

Abilities
+ Active 1
+ Active 2
- Inactive 1
- Inactive 2"""

      (encode stringCharacter <$> decode stringCharacter t) `shouldEqual` pure t

    it "should decode an unusual text build" do
      let
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

      (AnyShow <$> (decode stringCharacter t))
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
                  , talents: [ Name "Vantage" ]
                  , abilities:
                      { active: [ Name "Bait and Switch" ]
                      , inactive: [ Name "Pincer Attack" ]
                      }
                  }
              }
          )
