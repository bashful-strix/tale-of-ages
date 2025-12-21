module ToA.Resource.Icon.Job.Fool
  ( fool
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

fool :: Icon
fool =
  { classes: []
  , colours: []
  , souls: []
  , jobs:
      [ Job
          { name: Name "Fool"
          , colour: Name "Yellow"
          , soul: Name "Thief"
          , class: Name "Vagabond"
          , description:
              [ Text
                  """Fools are dedicated defenders of the common people of Arden
                  Eld, part folk hero, and part hired killer. They have no
                  official organization, and cover their faces with masks to
                  hide their identity, wearing bells and motley to cover their
                  collections of deadly weapons and explosives. Some people fear 
                  the Fools, calling them self-interested thugs or anarchic
                  cultists of the Laughing Titan, the god of death. They may not
                  be entirely wrong, but none can deny their flair for the
                  theatrical."""
              , Newline
              , Newline
              , Text
                  """They are feared rightly by all would-be tyrants,
                  under-barons, and aspiring imperial lords. Wherever kin labor
                  under oppression, someone will take up the mask and knives and
                  sent cold jolts of fear into the hearts of the rich and
                  comfortable."""
              ]
          , trait: Name "Stacked Die"
          , keyword: Name "Finishing Blow"
          , abilities:
              (I /\ Name "Death XIII")
                : (I /\ Name "Knife Juggler")
                : (II /\ Name "Deathwheel")
                : (IV /\ Name "Gallows Humor")
                : empty
          , limitBreak: Name "Curtain Call"
          , talents:
              Name "Carnage"
                : Name "Barbs"
                : Name "Kismet"
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
