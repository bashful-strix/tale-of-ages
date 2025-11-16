module ToA.Resource.Icon.Soul.Earth
  ( earth
  ) where

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Soul (Soul(..))

earth :: Soul
earth = Soul
  { name: Name "Earth"
  , colour: Name "Blue"
  , class: Name "Wright"
  , description:
      [ Text "The soul of one attuned to the land."
      , Newline
      , Text
          """Through earth, we are anchored to our wills and the great
          umbilical of time and matter. All things are ultimately built
          upon a foundation."""
      ]
  }
