module ToA.Resource.Icon.Classes
  ( classes
  ) where

import ToA.Data.Icon.Class (Class)
import ToA.Resource.Icon.Class.Stalwart (stalwart)
import ToA.Resource.Icon.Class.Wright (wright)

classes :: Array Class
classes =
  [ stalwart
  , wright
  ]
