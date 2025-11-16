module ToA.Resource.Icon.Job.Puppeteer
  ( puppeteer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

puppeteer :: Job
puppeteer = Job
  { name: Name "Puppeteer"
  , colour: Name "Yellow"
  , soul: Name "Shadow"
  , class: Name "Vagabond"
  , description:
      [ Text
          """Of all the major Leggio caravans, the story of the
          thirteenth is perhaps the most tragic. Known most for its
          mastery of the puppet theatre and its lifelike, life-sized
          marionettes, Its history, once carved into the wooden flanks of
          its colorful wagons, has been lost, chipped into splinters, an
          fed to the flames when it was betrayed by the guilds. Its
          people were scattered to the winds, absorbed by other caravans,
          or left to live a meagre existence as refugees."""
      , Newline
      , Newline
      , Text
          """According to legend, there were no other survivors. Yet
          occasionally, defeated guild members are found in the trees,
          swinging in the breeze, strung up like a marionette on
          beautiful white strings."""
      ]
  , trait: Name "Master Puppet"
  , keyword: Name "Summon"
  , abilities:
      (I /\ Name "White Strings")
        : (I /\ Name "Black Strings")
        : (II /\ Name "Umbral Echo")
        : (IV /\ Name "Razor Top")
        : empty
  , limitBreak: Name "Gran Guignol"
  , talents:
      Name "Marionette"
        : Name "Maligner"
        : Name "Deftness"
        : empty
  }
