module ToA.Resource.Icon.Keyword.General
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
  ) where

import ToA.Data.Icon.Keyword (Keyword(..), Category(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

adverse :: Keyword
adverse = Keyword
  { name: Name "Adverse Terrain"
  , category: General
  , description: [ Text "Difficult or dangerous terrain." ]
  }

afflicted :: Keyword
afflicted = Keyword
  { name: Name "Afflicted"
  , category: General
  , description: [ Text "Suffering from at least one negative status." ]
  }

armor :: Keyword
armor = Keyword
  { name: Name "Armor"
  , category: General
  , description: [ Text "Reduce all damage by X." ]
  }

aura :: Keyword
aura = Keyword
  { name: Name "Aura"
  , category: General
  , description:
      [ Text
          """A persistent effect that moves with its owner, affecting all
          characters in range X and line of sight."""
      ]
  }

bloodied :: Keyword
bloodied = Keyword
  { name: Name "Bloodied"
  , category: General
  , description: [ Text "50% hp or lower." ]
  }

conserve :: Keyword
conserve = Keyword
  { name: Name "Conserve"
  , category: General
  , description:
      [ Text
          """Can only trigger if you have not attacked this turn, and
          cannot attack on any turn you trigger this effect. """
      ]
  }

cover :: Keyword
cover = Keyword
  { name: Name "Cover"
  , category: General
  , description:
      [ Text
          """Characters take half damage from abilities they have cover
          against. Characters can take cover by standing in an adjacent
          space to any obscured space, or in any space that’s 1 or more
          elevation higher than the space they are standing in. They only
          gain cover against characters on the other side of their cover.
          In addition, a character can never gain cover against adjacent
          characters. """
      ]
  }

crisis :: Keyword
crisis = Keyword
  { name: Name "Crisis"
  , category: General
  , description: [ Text "25% hp or lower." ]
  }

dangerous :: Keyword
dangerous = Keyword
  { name: Name "Dangerous Terrain"
  , category: General
  , description:
      [ Text
          """Characters voluntarily entering this space or starting their
          turn there take 2 piercing damage."""
      ]
  }

difficult :: Keyword
difficult = Keyword
  { name: Name "Difficult Terrain"
  , category: General
  , description: [ Text "Costs +1 movement to exit." ]
  }

dominant :: Keyword
dominant = Keyword
  { name: Name "Dominant"
  , category: General
  , description:
      [ Text
          """Gains extra effects depending on the elevation difference
          between you and your target."""
      ]
  }

excel :: Keyword
excel = Keyword
  { name: Name "Excel"
  , category: General
  , description:
      [ Text
          """An effect that activates when you make a total attack of
          roll of 8+. Reduced by any effect that reduces critical
          threshold."""
      ]
  }

finishingBlow :: Keyword
finishingBlow = Keyword
  { name: Name "Finishing Blow"
  , category: General
  , description:
      [ Text
          """Gains additional effects if targeting a bloodied foe or a
          foe in crisis."""
      ]
  }

fly :: Keyword
fly = Keyword
  { name: Name "Fly"
  , category: General
  , description:
      [ Text
          """Movement ignores adverse terrain and all movement penalties
          and obstruction."""
      ]
  }

gambit :: Keyword
gambit = Keyword
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

heavy :: Keyword
heavy = Keyword
  { name: Name "Heavy"
  , category: General
  , description:
      [ Text
          """Use a heavier version of an ability. If you do, you are
          unable to attack or use a heavy ability until the end of your
          next turn."""
      ]
  }

immune :: Keyword
immune = Keyword
  { name: Name "Immune"
  , category: General
  , description:
      [ Text
          """Not affected by X in any way. A character that's immune to
          damage or effects doesn't even count as taking them."""

      ]
  }

impact :: Keyword
impact = Keyword
  { name: Name "Impact"
  , category: General
  , description:
      [ Text
          """Triggers on any foe that would move into an obstruction as
          part of this ability."""
      ]
  }

isolate :: Keyword
isolate = Keyword
  { name: Name "Isolate"
  , category: General
  , description:
      [ Text
          """Gains increased effects if there are no characters other
          than you adjacent."""
      ]
  }

mark :: Keyword
mark = Keyword
  { name: Name "Mark"
  , category: General
  , description:
      [ Text
          """A persistent effect attached to a character. You can only
          place a mark from an ability once (placing it on a new
          character will remove the old mark)."""
      ]
  }

object :: Keyword
object = Keyword
  { name: Name "Object"
  , category: General
  , description:
      [ Text
          """Objects provide cover, obstruct movement, and block line of
          sight just like terrain. Objects can have a height, like
          terrain (from 0-3) and can be moved up or down in the same way.
          This could be something like a boulder, a cart, a section of
          high wall, etc. Unlike terrain, objects can often be created,
          removed, destroyed, and moved around by player abilities."""
      ]
  }

obscured :: Keyword
obscured = Keyword
  { name: Name "Obscured"
  , category: General
  , description:
      [ Text
          """Obscured spaces provide cover from all directions for
          characters inside and can be used for cover by adjacent
          characters, but do not block movement or line of sight."""
      ]
  }

overdrive :: Keyword
overdrive = Keyword
  { name: Name "Overdrive"
  , category: General
  , description: [ Text "Triggers at round 3 or later." ]
  }

phasing :: Keyword
phasing = Keyword
  { name: Name "Phasing"
  , category: General
  , description:
      [ Text "Can move through but not end your turn in obstructions." ]
  }

pierce :: Keyword
pierce = Keyword
  { name: Name "Pierce"
  , category: General
  , description: [ Text "Damage can't be reduced in any way." ]
  }

powerDie :: Keyword
powerDie = Keyword
  { name: Name "Power Die"
  , category: General
  , description:
      [ Text
          """A d6 die that is used to track benefits from an ability and
          can be spent, discarding it. Each die it tied to a specific
          ability and ticks up or down when called for."""
      ]
  }

quick :: Keyword
quick = Keyword
  { name: Name "Quick"
  , category: General
  , description:
      [ Text "An ability that doesn't take an action to use." ]
  }

reckless :: Keyword
reckless = Keyword
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

sacrifice :: Keyword
sacrifice = Keyword
  { name: Name "Sacrifice"
  , category: General
  , description:
      [ Text
          """Spend X HP. This is not damage and additionally cannot take
          you past 1 hp. You can continue to sacrifice even if it would
          take you lower than 1 hp."""
      ]
  }

status :: Keyword
status = Keyword
  { name: Name "Status"
  , category: General
  , description:
      [ Text
          """An ongoing effect, represented with a token. Discard after
          fulfilling its 'when' condition."""
      ]
  }

summon :: Keyword
summon = Keyword
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

teleport :: Keyword
teleport = Keyword
  { name: Name "Teleport"
  , category: General
  , description:
      [ Text
          """Instantly move to a space in X range, counting as moving 1
          space."""
      ]
  }

vigor :: Keyword
vigor = Keyword
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

weave :: Keyword
weave = Keyword
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
