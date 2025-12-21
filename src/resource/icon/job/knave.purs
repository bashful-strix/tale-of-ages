module ToA.Resource.Icon.Job.Knave
  ( knave
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

knave :: Icon
knave =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Knave"
          , colour: Name "Red"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """The advent of the Churning Age has coincided with the rise
                  of a certain class of person with heavy pockets and a long
                  list of ‘problems’ to solve. The Knaves are the solution.
                  Hedge knights, rogue warriors, duelists, deserters, and
                  veterans, they roam the land offering their services to
                  whoever has the dust to spare. Though some of them are
                  altruistically minded, they tend to go where the work, food,
                  and fighting is thickest, and never stay for long in one
                  location."""
              , Newline
              , Newline
              , Text
                  """Knaves operate under a loose moral code and an even looser
                  no-holds-barred fighting style, using hilts, head butts, and
                  gauntleted fists to inflict pain, punishment, and humiliation
                  on their opponents in equal measure. These braggadocios
                  warriors spare no effort in flexing their incredible strength
                  - if the price is right. For a freshly roasted chicken, a
                  pocket full of dust, and a polish of their boots, they’ll do
                  just about anything."""
              ]
          , trait: Name "Hatred"
          , keyword: Name "Afflicted"
          , abilities:
              (I /\ Name "Low Blow")
                : (I /\ Name "Taunt")
                : (II /\ Name "Sucker Punch")
                : (IV /\ Name "Misericorde")
                : empty
          , limitBreak: Name "Mock"
          , talents:
              Name "Brawl"
                : Name "Suffer"
                : Name "Opress"
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
