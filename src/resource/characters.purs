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
  [ speckles
  , speckles1
  , speckles2

  , arofell
  , arofell1
  , arofell2

  , varek
  , varek1

  , nelly
  , nelly1
  ]

speckles :: Character
speckles = Character
  { name: Name "Speckles"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Zero
      , jobs: empty
      , primaryJob: Name "Workshop Knight"
      , abilities:
          [ Name "Second Wind"
          , Name "Mighty Hew"
          ]
      , prepared:
          [ Name "Second Wind"
          , Name "Mighty Hew"
          ]
      , talents: []
      }
  }

speckles1 :: Character
speckles1 = Character
  { name: Name "Speckles 1"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: One
      , jobs: fromFoldable [ Name "Workshop Knight" /\ I ]
      , primaryJob: Name "Workshop Knight"
      , abilities:
          [ Name "Second Wind"
          , Name "Mighty Hew"
          , Name "Rocket Punch"
          ]
      , prepared:
          [ Name "Second Wind"
          , Name "Mighty Hew"
          , Name "Rocket Punch"
          ]
      , talents: []
      }
  }

speckles2 :: Character
speckles2 = Character
  { name: Name "Speckles 2"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Two
      , jobs: fromFoldable [ Name "Workshop Knight" /\ II ]
      , primaryJob: Name "Workshop Knight"
      , abilities:
          [ Name "Second Wind"
          , Name "Mighty Hew"
          , Name "Rocket Punch"
          , Name "Weapon Vault"
          ]
      , prepared:
          [ Name "Second Wind"
          , Name "Mighty Hew"
          , Name "Rocket Punch"
          , Name "Weapon Vault"
          ]
      , talents: [ Name "Endure" ]
      }
  }

arofell :: Character
arofell = Character
  { name: Name "Arofell"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Zero
      , jobs: empty
      , primaryJob: Name "Spellblade"
      , abilities:
          [ Name "Cryo"
          , Name "Shift"
          ]
      , prepared:
          [ Name "Cryo"
          , Name "Shift"
          ]
      , talents: []
      }
  }

arofell1 :: Character
arofell1 = Character
  { name: Name "Arofell 1"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: One
      , jobs: fromFoldable [ Name "Spellblade" /\ I ]
      , primaryJob: Name "Spellblade"
      , abilities:
          [ Name "Cryo"
          , Name "Shift"
          , Name "Gungnir"
          ]
      , prepared:
          [ Name "Cryo"
          , Name "Shift"
          , Name "Gungnir"
          ]
      , talents: []
      }
  }

arofell2 :: Character
arofell2 = Character
  { name: Name "Arofell 2"
  , hp: 40
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Two
      , jobs: fromFoldable [ Name "Spellblade" /\ II ]
      , primaryJob: Name "Spellblade"
      , abilities:
          [ Name "Cryo"
          , Name "Shift"
          , Name "Gungnir"
          , Name "Odinforce"
          ]
      , prepared:
          [ Name "Cryo"
          , Name "Shift"
          , Name "Gungnir"
          , Name "Odinforce"
          ]
      , talents: [ Name "Vex" ]
      }
  }

varek :: Character
varek = Character
  { name: Name "Varek"
  , hp: 32
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Zero
      , jobs: empty
      , primaryJob: Name "Weeping Assassin"
      , abilities:
          [ Name "Flash Powder"
          , Name "Gouge"
          ]
      , prepared:
          [ Name "Flash Powder"
          , Name "Gouge"
          ]
      , talents: []
      }
  }

varek1 :: Character
varek1 = Character
  { name: Name "Varek 1"
  , hp: 32
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: One
      , jobs: empty
      , primaryJob: Name "Weeping Assassin"
      , abilities:
          [ Name "Flash Powder"
          , Name "Harien"
          , Name "Shadow Cloak"
          ]
      , prepared:
          [ Name "Flash Powder"
          , Name "Harien"
          , Name "Shadow Cloak"
          ]
      , talents: []
      }
  }

nelly :: Character
nelly = Character
  { name: Name "Nelly"
  , hp: 48
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: Zero
      , jobs: empty
      , primaryJob: Name "Chanter"
      , abilities:
          [ Name "Gliaga"
          , Name "Diaga"
          ]
      , prepared:
          [ Name "Gliaga"
          , Name "Diaga"
          ]
      , talents: []
      }
  }

nelly1 :: Character
nelly1 = Character
  { name: Name "Nelly 1"
  , hp: 48
  , vigor: 0
  , wounded: false
  , scars: 0
  , build: Build
      { level: One
      , jobs: empty
      , primaryJob: Name "Chanter"
      , abilities:
          [ Name "Diaga"
          , Name "Viga"
          , Name "Holy"
          ]
      , prepared:
          [ Name "Diaga"
          , Name "Viga"
          , Name "Holy"
          ]
      , talents: []
      }
  }
