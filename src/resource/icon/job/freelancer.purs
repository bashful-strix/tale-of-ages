module ToA.Resource.Icon.Job.Freelancer
  ( freelancer
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

freelancer :: Icon
freelancer =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Freelancer"
          , colour: Name "Yellow"
          , soul: Name "Gunner"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Freelancers are free-roaming exorcists and hired guns,
                  roaming the land and fighting blights, demons and bandits in
                  the name of justice. They tend to act as wild cards: highly
                  independent, highly effective, and sticking to their codes of
                  honor."""
              , Newline
              , Newline
              , Text
                  """Freelancers have their history in an ancient disgraced
                  knightly order from one of the Seven Families of the Thrynn.
                  They each wield a bright metal six gun, a bow, or a long rifle
                  with extreme skill, the bullets, shot, or arrows of which they
                  infuse with raw Aether drawn from their very souls. Each
                  weapon is a relic passed down from master to student over the
                  years, and can only be won in a duel with another Freelancer.
                  It supernaturally inherits a fragment of the soul aether of
                  each of its wielders, an unbroken line going back to the First
                  Founders"""
              ]
          , trait: Name "Gun Soul Sutra"
          , keyword: Name "Excel"
          , abilities:
              (I /\ Name "Fan The Hammer")
                : (I /\ Name "Astral Chain")
                : (II /\ Name "Coolhand")
                : (IV /\ Name "Trigrammaton")
                : empty
          , limitBreak: Name "Paradiso"
          , talents:
              Name "Steady"
                : Name "Flourish"
                : Name "Kickoff"
                : empty
          }
      ]
  , traits: []
  , talents: []
  , abilities: []
  , keywords: []
  , foes: []
  , foeClasses: []
  , factions: []
  }
