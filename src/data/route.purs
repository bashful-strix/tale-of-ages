module ToA.Data.Route
  ( Route(..)
  , JobPath(..)
  , routeCodec
  ) where

import Prelude hiding ((/))

import Data.Generic.Rep (class Generic)
import Data.Lens.Iso.Newtype (_Newtype)
import Routing.Duplex (RouteDuplex', root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

import ToA.Data.Icon.Name (Name)

data Route
  = Home
  | Jobs JobPath

derive instance Eq Route
derive instance Generic Route _

routeCodec :: RouteDuplex' Route
routeCodec =
  root $ sum
    { "Home": noArgs
    , "Jobs": "jobs" / jobPath
    }

data JobPath
  = None
  | WithClass Name
  | WithSoul Name Name
  | WithJob Name Name Name

derive instance Generic JobPath _
derive instance Eq JobPath

jobPath :: RouteDuplex' JobPath
jobPath =
  sum
    { "None": noArgs
    , "WithClass": name
    , "WithSoul": name / name
    , "WithJob": name / name / name
    }

name :: RouteDuplex' Name
name = _Newtype segment
