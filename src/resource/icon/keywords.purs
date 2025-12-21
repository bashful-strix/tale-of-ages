module ToA.Resource.Icon.Keywords
  ( keywords
  ) where

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

keywords :: Icon
keywords =
  { classes: []
  , colours: []
  , souls: []
  , jobs: []
  , traits: []
  , talents: []
  , abilities: []
  , keywords:
      -- general
      [ Keyword
          { name: Name "Adverse Terrain"
          , category: General
          , description: [ Text "Difficult or dangerous terrain." ]
          }
      , Keyword
          { name: Name "Afflicted"
          , category: General
          , description: [ Text "Suffering from at least one negative status." ]
          }
      , Keyword
          { name: Name "Armor"
          , category: General
          , description: [ Text "Reduce all damage by X." ]
          }
      , Keyword
          { name: Name "Aura"
          , category: General
          , description:
              [ Text
                  """A persistent effect that moves with its owner, affecting
                  all characters in range X and line of sight."""
              ]
          }
      , Keyword
          { name: Name "Bloodied"
          , category: General
          , description: [ Text "50% hp or lower." ]
          }
      , Keyword
          { name: Name "Conserve"
          , category: General
          , description:
              [ Text
                  """Can only trigger if you have not attacked this turn, and
                  cannot attack on any turn you trigger this effect. """
              ]
          }
      , Keyword
          { name: Name "Cover"
          , category: General
          , description:
              [ Text
                  """Characters take half damage from abilities they have cover
                  against. Characters can take cover by standing in an adjacent
                  space to any obscured space, or in any space that’s 1 or more
                  elevation higher than the space they are standing in. They
                  only gain cover against characters on the other side of their
                  cover. In addition, a character can never gain cover against
                  adjacent characters. """
              ]
          }
      , Keyword
          { name: Name "Crisis"
          , category: General
          , description: [ Text "25% hp or lower." ]
          }
      , Keyword
          { name: Name "Dangerous Terrain"
          , category: General
          , description:
              [ Text
                  """Characters voluntarily entering this space or starting
                  their turn there take 2 piercing damage."""
              ]
          }
      , Keyword
          { name: Name "Difficult Terrain"
          , category: General
          , description: [ Text "Costs +1 movement to exit." ]
          }
      , Keyword
          { name: Name "Dominant"
          , category: General
          , description:
              [ Text
                  """Gains extra effects depending on the elevation difference
                  between you and your target."""
              ]
          }
      , Keyword
          { name: Name "Excel"
          , category: General
          , description:
              [ Text
                  """An effect that activates when you make a total attack of
                  roll of 8+. Reduced by any effect that reduces critical
                  threshold."""
              ]
          }
      , Keyword
          { name: Name "Finishing Blow"
          , category: General
          , description:
              [ Text
                  """Gains additional effects if targeting a bloodied foe or a
                  foe in crisis."""
              ]
          }
      , Keyword
          { name: Name "Fly"
          , category: General
          , description:
              [ Text
                  """Movement ignores adverse terrain and all movement penalties
                  and obstruction."""
              ]
          }
      , Keyword
          { name: Name "Gambit"
          , category: General
          , description:
              [ Text
                  """Roll the effect die and immediately gain the listed effect,
                  usually with a negative effect on a lower die. Unlike other
                  effects, gambits are optional, and effects are not
                  cumulative."""
              ]
          }
      , Keyword
          { name: Name "Heavy"
          , category: General
          , description:
              [ Text
                  """Use a heavier version of an ability. If you do, you are
                  unable to attack or use a heavy ability until the end of your
                  next turn."""
              ]
          }
      , Keyword
          { name: Name "Immune"
          , category: General
          , description:
              [ Text
                  """Not affected by X in any way. A character that's immune to
                  damage or effects doesn't even count as taking them."""
              ]
          }
      , Keyword
          { name: Name "Impact"
          , category: General
          , description:
              [ Text
                  """Triggers on any foe that would move into an obstruction as
                  part of this ability."""
              ]
          }
      , Keyword
          { name: Name "Isolate"
          , category: General
          , description:
              [ Text
                  """Gains increased effects if there are no characters other
                  than you adjacent."""
              ]
          }
      , Keyword
          { name: Name "Mark"
          , category: General
          , description:
              [ Text
                  """A persistent effect attached to a character. You can only
                  place a mark from an ability once (placing it on a new
                  character will remove the old mark)."""
              ]
          }
      , Keyword
          { name: Name "Object"
          , category: General
          , description:
              [ Text
                  """Objects provide cover, obstruct movement, and block line of
                  sight just like terrain. Objects can have a height, like
                  terrain (from 0-3) and can be moved up or down in the same
                  way. This could be something like a boulder, a cart, a section
                  of high wall, etc. Unlike terrain, objects can often be
                  created, removed, destroyed, and moved around by player
                  abilities."""
              ]
          }
      , Keyword
          { name: Name "Obscured"
          , category: General
          , description:
              [ Text
                  """Obscured spaces provide cover from all directions for
                  characters inside and can be used for cover by adjacent
                  characters, but do not block movement or line of sight."""
              ]
          }
      , Keyword
          { name: Name "Overdrive"
          , category: General
          , description: [ Text "Triggers at round 3 or later." ]
          }
      , Keyword
          { name: Name "Phasing"
          , category: General
          , description:
              [ Text "Can move through but not end your turn in obstructions." ]
          }
      , Keyword
          { name: Name "Pierce"
          , category: General
          , description: [ Text "Damage can't be reduced in any way." ]
          }
      , Keyword
          { name: Name "Power Die"
          , category: General
          , description:
              [ Text
                  """A d6 die that is used to track benefits from an ability and
                  can be spent, discarding it. Each die it tied to a specific
                  ability and ticks up or down when called for."""
              ]
          }
      , Keyword
          { name: Name "Quick"
          , category: General
          , description:
              [ Text "An ability that doesn't take an action to use." ]
          }
      , Keyword
          { name: Name "Reckless"
          , category: General
          , description:
              [ Text
                  """Push yourself to the limit, gaining extra effects but
                  inflicting yourself with the Reckless (-) unique status. You
                  take +1 damage from all sources per stack of reckless. You may
                  only discard reckless with effects that clear a negative
                  status."""
              ]
          }
      , Keyword
          { name: Name "Sacrifice"
          , category: General
          , description:
              [ Text
                  """Spend X HP. This is not damage and additionally cannot take
                  you past 1 hp. You can continue to sacrifice even if it would
                  take you lower than 1 hp."""
              ]
          }
      , Keyword
          { name: Name "Status"
          , category: General
          , description:
              [ Text
                  """An ongoing effect, represented with a token. Discard after
                  fulfilling its 'when' condition."""
              ]
          }
      , Keyword
          { name: Name "Summon"
          , category: General
          , description:
              [ Text
                  """Summons are entities with an effect or ability attached to
                  them. They don't occupy space or obstruct and can share space
                  with characters. They are not characters and don't typically
                  take damage or trigger effects unless abilities specifically
                  mentioned. Summons have a maximum number active in
                  (parentheses) and may have a summon action, which can be
                  activated as a quick ability, or a passive summon effect. When
                  they are dismissed, remove them from the battlefield."""
              ]
          }
      , Keyword
          { name: Name "Teleport"
          , category: General
          , description:
              [ Text
                  """Instantly move to a space in X range, counting as moving 1
                  space."""
              ]
          }
      , Keyword
          { name: Name "Vigor"
          , category: General
          , description:
              [ Text
                  """Temporary hit points. Damage goes to vigor first, and it
                  benefits from all damage reductions and effects. Lose all vigor
                  at the end of combat. A character can't have more than 25% of
                  their max hp in vigor."""
              ]
          }
      , Keyword
          { name: Name "weave"
          , category: General
          , description:
              [ Text
                  """When you use a weave effect, you gain the effect
                  immediately, and then may repeat a copy of it as part of very
                  next ability you use. If multiple weave effects trigger, you
                  can choose the order. Copies of a weave cannot weave
                  further."""
              ]
          }

      -- status
      , Keyword
          { name: Name "Strength"
          , category: Status Positive
          , description: [ Text "When attacking, gain +2 base damage" ]
          }
      , Keyword
          { name: Name "Keen"
          , category: Status Positive
          , description: [ Text "When attacking, gain attack ", Power ]
          }
      , Keyword
          { name: Name "Shield"
          , category: Status Positive
          , description: [ Text "When attacked, gain +2 DF" ]
          }
      , Keyword
          { name: Name "Haste"
          , category: Status Positive
          , description: [ Text "When free moving, move +2 spaces" ]
          }
      , Keyword
          { name: Name "Daze"
          , category: Status Negative
          , description: [ Text "When attacking, gain -2 base damage" ]
          }
      , Keyword
          { name: Name "Blind"
          , category: Status Negative
          , description: [ Text "When attacking, gain attack ", Weakness ]
          }
      , Keyword
          { name: Name "Brand"
          , category: Status Negative
          , description: [ Text "When attacked, gain -2 DF" ]
          }
      , Keyword
          { name: Name "Slow"
          , category: Status Negative
          , description: [ Text "When free moving, move -2 spaces" ]
          }
      , Keyword
          { name: Name "Stun"
          , category: Status Negative
          , description:
              [ Text "When taking a turn, deal half damage this turn" ]
          }
      , Keyword
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
      , Keyword
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

      -- tag
      , Keyword
          { name: Name "Immobile"
          , category: Tag
          , description: [ Text "Can't voluntarily move" ]
          }
      , Keyword
          { name: Name "Push"
          , category: Tag
          , description: [ Text "Move a character X spaces away from you" ]
          }
      , Keyword
          { name: Name "Stance"
          , category: Tag
          , description:
              [ Text
                  """A powerful ongoing effect. You can only maintain one
                  stance at a time. You may exit any stance vonuntarily at the
                  start of your turn."""
              ]
          }
      , Keyword
          { name: Name "Unstoppable"
          , category: Tag
          , description:
              [ Text
                  """Can't be forcibly moved. Immune to the effects of all
                  negative statuses. Movement cannot be reduced or stopped
                  for any reason."""
              ]
          }
      , Keyword
          { name: Name "Zone"
          , category: Tag
          , description:
              [ Text
                  """Changes or affects an area of the battlefield, causing
                  persistent effects. Unless specified, placing a new zone
                  replaces the last one placed. Zones from self or allies
                  cannot overlap each other. You can dismiss a zone as a
                  quick ability."""
              ]
          }
      ]
  , foes: []
  , foeClasses: []
  , factions: []
  }
