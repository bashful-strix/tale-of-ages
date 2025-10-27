module ToA.Data.Icon.Job.Tactician
  ( tactician
  ) where

import Prelude

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Name (Name(..))

tactician :: Job
tactician = Job
  { name: Name "Tactician"
  , soul: Name "Knight"
  , class: Name "Stalwart"
  , description:
      "Veterans, advisors, and upstart geniuses, tacticians "
        <> "wield their understanding of battle like a well "
        <> "balanced blade. The hammering of metal on metal and "
        <> "cries of men and horses beat like a drum for them, "
        <> "an instrument that they have learned to play deftly "
        <> "and with keen precision. The few that become known by "
        <> "this moniker generally go on to become generals of "
        <> "incredible repute, and are well sought after by the "
        <> "city guilds.\n\n"
        <> "They are a relatively new sight in Arden Eld, which "
        <> "has seen little need for warfare until the current "
        <> "era."
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
