module ToA.Resource.Icon.Keywords
  ( keywords
  ) where

import ToA.Data.Icon.Keyword (Keyword)
import ToA.Resource.Icon.Keyword.Status
  ( strength
  , keen
  , shield
  , haste

  , daze
  , blind
  , brand
  , slow
  , stun
  )
import ToA.Resource.Icon.Keyword.Tag
  ( immobile
  , push
  , stance
  , unstoppable
  , zone
  )

keywords :: Array Keyword
keywords =
  [ immobile
  , push
  , stance
  , unstoppable
  , zone

  , strength
  , keen
  , shield
  , haste

  , daze
  , blind
  , brand
  , slow
  , stun
  ]
