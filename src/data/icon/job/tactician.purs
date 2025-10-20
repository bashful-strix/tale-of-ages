module ToA.Data.Icon.Job.Tactician
  ( tactician
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Name (Name(..))

tactician :: Job
tactician = Job
  { name: Name "Tactician"
  , soul: Name "Knight"
  , class: Name "Stalwart"
  , description: ""
  , trait: Name "Press the Fight"
  , keyword: Name "Crisis"
  , abilities:
      (One /\ Name "Pincer Attack")
        : (One /\ Name "Bait and Switch")
        : (Two /\ Name "Hold the Center")
        : (Four /\ Name "Mighty Standard")
        : empty
  , limitBreak: Name "Mighty Command"
  , talents:
      Name "Mastermind"
        : Name "Spur"
        : Name "Fieldwork"
        : empty
  }
