module ToA.Data.Icon.Keywords
  ( keywords
  ) where

import ToA.Data.Icon.Keyword (Keyword)
import ToA.Data.Icon.Keyword.Status
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
import ToA.Data.Icon.Keyword.Tag
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
