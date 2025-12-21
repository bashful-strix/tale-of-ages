module ToA.Resource.Icon.Talent.WeepingAssassin
  ( commiserate
  , infiltrate
  , shimmer
  ) where

import Data.Maybe (Maybe(..))

import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))

commiserate :: Talent
commiserate = Talent
  { name: Name "Commiserate"
  , colour: Name "Yellow"
  , description:
      [ Text
          """You can ignore up to one ally in range 1-2 for the purposes
          of """
      , Italic [ Ref (Name "Isolate") [ Text "isolate" ] ]
      , Text "."
      ]
  , subItem: Nothing
  }

infiltrate :: Talent
infiltrate = Talent
  { name: Name "Infiltrate"
  , colour: Name "Yellow"
  , description:
      [ Text "As a quick ability, you can spend "
      , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
      , Text " on yourself to teleport 3."
      , Newline
      , Italic [ Ref (Name "Isolate") [ Text "Isolate" ] ]
      , Text
          """: if you end this teleport with no other characters in range
          1-2, regain """
      , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
      , Text "."
      ]
  , subItem: Nothing
  }

shimmer :: Talent
shimmer = Talent
  { name: Name "Shimmer"
  , colour: Name "Yellow"
  , description:
      [ Text "If an ability ends your turn, it grants you "
      , Italic [ Ref (Name "Stealth") [ Text "stealth" ] ]
      , Text "."
      ]
  , subItem: Nothing
  }
