module ToA.Resource.Icon.Job.Sealer
  ( sealer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

sealer :: Job
sealer = Job
  { name: Name "Sealer"
  , colour: Name "Green"
  , soul: Name "Monk"
  , class: Name "Mendicant"
  , description:
      [ Text
          """The Sealers are a famous chronicler order of legendary
          monster hunters and exorcists of unbelievable prowess and
          unshakeable faith. Whenever an especially bad blight or an
          arch demon appears, the Sealers are usually there to drive it
          back with blessed brands, martial arts, and flaming blows from
          their hands or weapons."""
      , Newline
      , Newline
      , Text
          """It is the Sealers who were originally responsible for the
          great Chambers of the Chroniclers, where old evils, or great
          and ancient powers and artifacts too monumental to permanently
          destroy were incarcerated using ancient sealing magic. These
          days, many of the Chambers lie open and the order works
          fervently at recovering their contents. Modern Sealers do not
          bemoan their lack of capable vessels, and often seal evil
          spirits into specially prepared jars, portable iron vessels, or
          even weapons, which Sealers may then put to use in the service
          of destroying further opponents."""
      ]
  , trait: Name "Mantra of Sealing"
  , keyword: Name "Excel"
  , abilities:
      (I /\ Name "God Hand")
        : (I /\ Name "Matsuri")
        : (II /\ Name "Evil Crushing Fist")
        : (IV /\ Name "Condemn")
        : empty
  , limitBreak: Name "Passage to the Afterlife"
  , talents:
      Name "Surge"
        : Name "Flash"
        : Name "Ascension"
        : empty
  }
