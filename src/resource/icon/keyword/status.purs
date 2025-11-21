module ToA.Resource.Icon.Keyword.Status
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
  ) where

import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

strength :: Keyword
strength = Keyword
  { name: Name "Strength"
  , category: Status Positive
  , description: [ Text "When attacking, gain +2 base damage" ]
  }

keen :: Keyword
keen = Keyword
  { name: Name "Keen"
  , category: Status Positive
  , description: [ Text "When attacking, gain attack ", Power ]
  }

shield :: Keyword
shield = Keyword
  { name: Name "Shield"
  , category: Status Positive
  , description: [ Text "When attacked, gain +2 DF" ]
  }

haste :: Keyword
haste = Keyword
  { name: Name "Haste"
  , category: Status Positive
  , description: [ Text "When free moving, move +2 spaces" ]
  }

daze :: Keyword
daze = Keyword
  { name: Name "Daze"
  , category: Status Negative
  , description: [ Text "When attacking, gain -2 base damage" ]
  }

blind :: Keyword
blind = Keyword
  { name: Name "Blind"
  , category: Status Negative
  , description: [ Text "When attacking, gain attack ", Weakness ]
  }

brand :: Keyword
brand = Keyword
  { name: Name "Brand"
  , category: Status Negative
  , description: [ Text "When attacked, gain -2 DF" ]
  }

slow :: Keyword
slow = Keyword
  { name: Name "Slow"
  , category: Status Negative
  , description: [ Text "When free moving, move -2 spaces" ]
  }

stun :: Keyword
stun = Keyword
  { name: Name "Stun"
  , category: Status Negative
  , description:
      [ Text "When taking a turn, deal half damage this turn" ]
  }

evasion :: Keyword
evasion = Keyword
  { name: Name "Evasion"
  , category: Status Positive
  , description:
      [ Text "Status. Roll "
      , Dice 1 D6
      , Text
          """ before being attacked. On a 5+, the attack automatically
          misses."""
      ]
  }

stealth :: Keyword
stealth = Keyword
  { name: Name "Stealth"
  , category: Status Positive
  , description:
      [ Text
          """Positive status. As long as you have one stealth token,
          cannot be directly targeted by foes except from adjacent
          spaces. After using any ability, or when ending any turn
          adjacent to a foe, dscard one."""
      ]
  }
