module ToA.Util.FRP
  ( pair
  , (<&>)
  ) where

import Prelude
import Data.Tuple.Nested (type (/\), (/\))
import FRP.Event.Class (class IsEvent)

pair :: ∀ e a b. IsEvent e => Applicative e =>  e a -> e b -> e (a /\ b)
pair ea eb = (/\) <$> ea <*> eb

infixl 4 pair as <&>
