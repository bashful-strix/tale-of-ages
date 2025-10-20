module ToA.Util.Optic
  ( (^::)
  , (#~)
  , key
  ) where

import Data.Lens (Lens, foldMapOf, toArrayOfOn)
import Data.Lens.Record (prop)
import Data.Symbol (class IsSymbol)
import Prim.Row (class Cons)
import Type.Proxy (Proxy(..))

infixl 8 toArrayOfOn as ^::
infixl 8 foldMapOf as #~

key
  :: ∀ @s a b r r1 r2
   . IsSymbol s
  => Cons s a r r1
  => Cons s b r r2
  => Lens (Record r1) (Record r2) a b
key = prop (Proxy :: _ s)
