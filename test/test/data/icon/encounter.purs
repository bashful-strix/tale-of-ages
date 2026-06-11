module Test.ToA.Data.Icon.Encounter (spec) where

import Prelude

import Data.Codec (decode, encode)
import Data.Maybe (Maybe(..))
import Data.Map (empty)

import ToA.Data.Icon.Name (Name(..))

import ToA.Data.Icon.Encounter
  ( Encounter(..)
  , FoeEntry(..)
  , FoeState(..)
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
          , players: 1
          , notes: Just "Some notes."
          , foes:
              [ Active
                  { name: Name "Foe 1"
                  , alias: Just "Foe 1 Alias"
                  , faction: Just $ Name "Faction"
                  , template: Just $ Name "Template"
                  , state: [ FoeState { hp: 0, vigor: 0, status: empty } ]
                  }
              , Active
                  { name: Name "Foe 2"
                  , alias: Nothing
                  , faction: Just $ Name "Faction"
                  , template: Nothing
                  , state:
                      [ FoeState { hp: 0, vigor: 0, status: empty }
                      , FoeState { hp: 0, vigor: 0, status: empty }
                      ]
                  }
              , Reserve
                  { name: Name "Foe 3"
                  , alias: Just "Foe 3 Alias"
                  , faction: Nothing
                  , template: Just $ Name "Template"
                  , state:
                      [ FoeState { hp: 0, vigor: 0, status: empty }
                      , FoeState { hp: 0, vigor: 0, status: empty }
                      , FoeState { hp: 0, vigor: 0, status: empty }
                      ]
                  }
              , Reserve
                  { name: Name "Foe 4"
                  , alias: Nothing
                  , faction: Nothing
                  , template: Nothing
                  , state:
                      [ FoeState { hp: 0, vigor: 0, status: empty }
                      , FoeState { hp: 0, vigor: 0, status: empty }
                      , FoeState { hp: 0, vigor: 0, status: empty }
                      , FoeState { hp: 0, vigor: 0, status: empty }
                      ]
                  }
              ]
          }

      ( AnyShow <$> decode (stringEncounter mempty)
          (encode (stringEncounter mempty) e)
      )
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

      (encode (stringEncounter mempty) <$> decode (stringEncounter mempty) t)
        `shouldEqual` pure t

    it "should decode an unusual text encounter" do
      let
        t =
          """Name: Test Name

Foes
- 1x { Template } [Faction Name] Foe 1 | Foe 1 Alias

Reserves
"""

      (AnyShow <$> decode (stringEncounter mempty) t) `shouldEqual`
        ( pure $ AnyShow $ Encounter
            { name: Name "Test Name"
            , players: 1
            , notes: Nothing
            , foes:
                [ Active
                    { name: Name "Foe 1"
                    , alias: Just "Foe 1 Alias"
                    , faction: Just $ Name "Faction Name"
                    , template: Just $ Name "Template"
                    , state: [ FoeState { hp: 0, vigor: 0, status: empty } ]
                    }
                ]
            }
        )
