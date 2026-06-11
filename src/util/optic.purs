module ToA.Util.Optic
  ( (^::)
  , itoListOfOn
  , (^@..)
  , (#~)
  , (#@~)
  , key
  ) where

import ToA.Prelude

import Data.Lens (Lens, foldMapOf, ifoldMapOf, itoListOf, toArrayOfOn)
import Data.Lens.Types (IndexedFold)
import Data.Lens.Record (prop)
import Data.List (List)
import Data.Monoid.Endo (Endo)
import Data.Symbol (class IsSymbol)
import Prim.Row (class Cons)
import Type.Proxy (Proxy(..))

infixl 8 toArrayOfOn as ^::
infixl 8 foldMapOf as #~

infixr 5 ifoldMapOf as #@~

itoListOfOn :: forall i s t a b
             . s
            -> IndexedFold (Endo Function (List (i /\ a))) i s t a b
            -> List (i /\ a)
itoListOfOn = flip itoListOf

infixr 5 itoListOfOn as ^@..


key
  :: ∀ @s a b r r1 r2
   . IsSymbol s
  => Cons s a r r1
  => Cons s b r r2
  => Lens (Record r1) (Record r2) a b
key = prop (Proxy :: _ s)
