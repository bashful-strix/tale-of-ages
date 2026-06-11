module ToA.Prelude
  ( module Prelude
  , module PointFree
  , module Alt
  , module Strong
  , module Tuple
  , module TypeRow
  ) where

import Prelude
import PointFree ((<.), (.>), (<..), (<...), (..>), (~$)) as PointFree
import Control.Alt ((<|>)) as Alt
import Data.Profunctor.Strong ((&&&)) as Strong
import Data.Tuple.Nested (type (/\), (/\)) as Tuple
import Type.Row (type (+)) as TypeRow
