module ToA.Resource.Characters
  ( characters
  ) where

import Data.Map (empty, fromFoldable)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Character (Build(..), Character(..), Level(..))
import ToA.Data.Icon.Job (JobLevel(..))
import ToA.Data.Icon.Name (Name(..))

characters :: Array Character
characters =
  [ testana
  , testina
  ]

testana :: Character
testana = Character
  { name: Name "Testana"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Zero
      , jobs: empty
      , primaryJob: Name "Tactician"
      , abilities:
          [ Name "Hook", Name "Mighty Hew" ]
      , prepared:
          [ Name "Hook", Name "Mighty Hew" ]
      , talents: []
      }
  }

testina :: Character
testina = Character
  { name: Name "Testina"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: One
      , jobs: fromFoldable [ Name "Tactician" /\ I ]
      , primaryJob: Name "Tactician"
      , abilities:
          [ Name "Hook", Name "Mighty Hew", Name "Mighty Command" ]
      , prepared:
          [ Name "Hook", Name "Mighty Hew", Name "Mighty Command" ]
      , talents: []
      }
  }
