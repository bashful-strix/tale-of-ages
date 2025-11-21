module ToA.Resource.Icon.Keywords
  ( keywords
  ) where

import ToA.Data.Icon.Keyword (Keyword)
import ToA.Resource.Icon.Keyword.Faction
  ( horde
  , enrage
  , ferocity
  )
import ToA.Resource.Icon.Keyword.General
  ( adverse
  , afflicted
  , armor
  , aura
  , bloodied
  , conserve
  , cover
  , crisis
  , dangerous
  , difficult
  , dominant
  , excel
  , finishingBlow
  , fly
  , gambit
  , heavy
  , immune
  , impact
  , isolate
  , mark
  , object
  , obscured
  , overdrive
  , phasing
  , pierce
  , powerDie
  , quick
  , reckless
  , status
  , summon
  , sacrifice
  , teleport
  , vigor
  , weave
  )
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

  , evasion
  , stealth
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

  , adverse
  , afflicted
  , armor
  , aura
  , bloodied
  , conserve
  , cover
  , crisis
  , dangerous
  , difficult
  , dominant
  , excel
  , finishingBlow
  , fly
  , gambit
  , heavy
  , immune
  , impact
  , isolate
  , mark
  , object
  , obscured
  , overdrive
  , phasing
  , pierce
  , powerDie
  , quick
  , reckless
  , status
  , summon
  , sacrifice
  , teleport
  , vigor
  , weave

  , horde
  , enrage
  , ferocity

  , strength
  , keen
  , shield
  , haste

  , daze
  , blind
  , brand
  , slow
  , stun

  , evasion
  , stealth
  ]
