module Test.ToA.Data.Icon.Encounter (spec) where

import Prelude

import Data.Codec (decode, encode)
import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Name (Name(..))

import ToA.Data.Icon.Encounter
  ( Encounter(..)
  , FoeEntry(..)
  , stringEncounter
  )

import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (AnyShow(..), shouldEqual)

spec :: Spec Unit
spec = do
  describe "encounter codec" do
    it "should roundtrip encounters" do
      let
        e = Encounter
          { name: Name "Test Name"
          , notes: Just "Some notes."
          , foes:
              [ FoeEntry
                  { name: Name "Foe 1"
                  , alias: Just "Foe 1 Alias"
                  , count: 1
                  , faction: Just $ Name "Faction"
                  , template: Just $ Name "Template"
                  }
              , FoeEntry
                  { name: Name "Foe 2"
                  , alias: Nothing
                  , count: 2
                  , faction: Just $ Name "Faction"
                  , template: Nothing
                  }
              ]
          , reserves:
              [ FoeEntry
                  { name: Name "Foe 3"
                  , alias: Just "Foe 3 Alias"
                  , count: 3
                  , faction: Nothing
                  , template: Just $ Name "Template"
                  }
              , FoeEntry
                  { name: Name "Foe 4"
                  , alias: Nothing
                  , count: 4
                  , faction: Nothing
                  , template: Nothing
                  }
              ]
          }

      (AnyShow <$> decode stringEncounter (encode stringEncounter e))
        `shouldEqual` pure (AnyShow e)

    it "should roundtrip text" do
      let
        t =
          """Name :: Test Name

Notes
Some notes.

Foes
- 1x {Template} [Faction] Foe 1 | Foe 1 Alias
- 2x [Faction] Foe 2

Reserves
- 3x {Template} Foe 3 | Foe 3 Alias
- 4x Foe 4"""

      (encode stringEncounter <$> decode stringEncounter t) `shouldEqual` pure t

    it "should decode an unusual text encounter" do
      let
        t =
          """Name: Test Name

Foes
- 1x { Template } [Faction Name] Foe 1 | Foe 1 Alias

Reserves
"""

      (AnyShow <$> decode stringEncounter t) `shouldEqual`
        ( pure $ AnyShow $ Encounter
            { name: Name "Test Name"
            , notes: Nothing
            , foes:
                [ FoeEntry
                    { name: Name "Foe 1"
                    , alias: Just "Foe 1 Alias"
                    , count: 1
                    , faction: Just $ Name "Faction Name"
                    , template: Just $ Name "Template"
                    }
                ]
            , reserves: []
            }
        )
