module ToA.Data.Route
  ( Route(..)
  , JobPath(..)
  , CharacterPath(..)
  , EncounterPath(..)
  , routeCodec
  , _Characters
  , _Encounters
  , _Jobs
  , _ability
  , _ViewChar
  , _ViewEnc
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
  | Encounters EncounterPath

_Jobs :: Prism' Route JobPath
_Jobs = prism' Jobs case _ of
  Jobs p -> Just p
  _ -> Nothing

_Characters :: Prism' Route CharacterPath
_Characters = prism' Characters case _ of
  Characters c -> Just c
  _ -> Nothing

_Encounters :: Prism' Route EncounterPath
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
  , "Encounters": "encounters" / encounterPath
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
  = EditChar (Maybe Name)
  | ViewChar (Maybe Name)

derive instance Generic CharacterPath _
derive instance Eq CharacterPath

characterPath :: RouteDuplex' CharacterPath
characterPath = sum
  { "EditChar": "edit" / optional (name segment)
  , "ViewChar": optional (name segment)
  }

_ViewChar :: Prism' CharacterPath (Maybe Name)
_ViewChar = prism' ViewChar case _ of
  ViewChar c -> Just c
  _ -> Nothing

data EncounterPath
  = EditEnc (Maybe Name)
  | ViewEnc (Maybe Name)

derive instance Generic EncounterPath _
derive instance Eq EncounterPath

encounterPath :: RouteDuplex' EncounterPath
encounterPath = sum
  { "EditEnc": "edit" / optional (name segment)
  , "ViewEnc": optional (name segment)
  }

_ViewEnc :: Prism' EncounterPath (Maybe Name)
_ViewEnc = prism' ViewEnc case _ of
  ViewEnc c -> Just c
  _ -> Nothing
