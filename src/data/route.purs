module ToA.Data.Route
  ( Route(..)
  , JobPath(..)
  , CharacterPath(..)
  , routeCodec
  , _Characters
  , _Encounters
  , _Jobs
  , _ability
  , _View
  ) where

import Prelude hiding ((/))

import Data.Generic.Rep (class Generic)
import Data.Lens (Lens', lens')
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (Prism', prism')
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Routing.Duplex (RouteDuplex', optional, param, root, segment)
import Routing.Duplex.Generic (noArgs, sum)
import Routing.Duplex.Generic.Syntax ((/))

import ToA.Data.Icon.Name (Name)

data Route
  = Home
  | Jobs JobPath
  | Characters CharacterPath
  | Encounters (Maybe Name)

_Jobs :: Prism' Route JobPath
_Jobs = prism' Jobs case _ of
  Jobs p -> Just p
  _ -> Nothing

_Characters :: Prism' Route CharacterPath
_Characters = prism' Characters case _ of
  Characters c -> Just c
  _ -> Nothing

_Encounters :: Prism' Route (Maybe Name)
_Encounters = prism' Encounters case _ of
  Encounters e -> Just e
  _ -> Nothing

derive instance Eq Route
derive instance Generic Route _

routeCodec :: RouteDuplex' Route
routeCodec = root $ sum
  { "Home": noArgs
  , "Jobs": "jobs" / jobPath
  , "Characters": "characters" / characterPath
  , "Encounters": "encounters" / optional (name segment)
  }

data JobPath
  = None
  | WithClass Name (Maybe Name)
  | WithSoul Name Name (Maybe Name)
  | WithJob Name Name Name (Maybe Name)

_ability :: Lens' JobPath (Maybe Name)
_ability = lens' case _ of
  None -> Nothing /\ const None
  (WithClass c a) -> a /\ WithClass c
  (WithSoul c s a) -> a /\ WithSoul c s
  (WithJob c s j a) -> a /\ WithJob c s j

derive instance Generic JobPath _
derive instance Eq JobPath

jobPath :: RouteDuplex' JobPath
jobPath = sum
  { "None": noArgs
  , "WithClass": name segment / optional (name ability)
  , "WithSoul": name segment / name segment / optional (name ability)
  , "WithJob": name segment / name segment / name segment / optional
      (name ability)
  }

name :: RouteDuplex' String -> RouteDuplex' Name
name = simple _Newtype

ability :: RouteDuplex' String
ability = param "ability"

data CharacterPath
  = Edit (Maybe Name)
  | View (Maybe Name)

derive instance Generic CharacterPath _
derive instance Eq CharacterPath

characterPath :: RouteDuplex' CharacterPath
characterPath = sum
  { "Edit": "edit" / optional (name segment)
  , "View": optional (name segment)
  }

_View :: Prism' CharacterPath (Maybe Name)
_View = prism' View case _ of
  View c -> Just c
  _ -> Nothing
