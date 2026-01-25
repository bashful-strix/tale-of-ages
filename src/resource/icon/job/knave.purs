module ToA.Resource.Icon.Job.Knave
  ( knave
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability(..)
  , Action(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Variable(..)
  )
import ToA.Data.Icon.Dice (Die(..))
import ToA.Data.Icon.Id (Id(..))
import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Keyword (Keyword(..), Category(..), StatusType(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))
import ToA.Data.Icon.Talent (Talent(..))
import ToA.Data.Icon.Trait (Trait(..))

knave :: Icon
knave =
  { classes: []
  , colours: []
  , souls: []
  , foes: []
  , foeClasses: []
  , factions: []

  , keywords:
      [ Keyword
          { name: Name "Hatred"
          , category: Status Negative
          , description:
              [ Text
                  """Hatred is a unique negative status. A character suffering
                  from hatred deals 1/2 dmaage to all characters other than you
                  as long as you are not immune """
              , Italic [ Ref (Name "Immune") [ Text "immune" ] ]
              , Text
                  """ to damage, and in line of sight and range 1-3 from them. A
                  characters removed one hatred after using any ability that
                  damages you."""
              ]
          }
      ]

  , jobs:
      [ Job
          { name: Name "Knave"
          , colour: Name "Red"
          , soul: Name "Mercenary"
          , class: Name "Stalwart"
          , description:
              [ Text
                  """The advent of the Churning Age has coincided with the rise
                  of a certain class of person with heavy pockets and a long
                  list of ‘problems’ to solve. The Knaves are the solution.
                  Hedge knights, rogue warriors, duelists, deserters, and
                  veterans, they roam the land offering their services to
                  whoever has the dust to spare. Though some of them are
                  altruistically minded, they tend to go where the work, food,
                  and fighting is thickest, and never stay for long in one
                  location."""
              , Newline
              , Newline
              , Text
                  """Knaves operate under a loose moral code and an even looser
                  no-holds-barred fighting style, using hilts, head butts, and
                  gauntleted fists to inflict pain, punishment, and humiliation
                  on their opponents in equal measure. These braggadocios
                  warriors spare no effort in flexing their incredible strength
                  - if the price is right. For a freshly roasted chicken, a
                  pocket full of dust, and a polish of their boots, they’ll do
                  just about anything."""
              ]
          , trait: Name "Hatred"
          , keyword: Name "Afflicted"
          , abilities:
              (I /\ Name "Low Blow")
                : (I /\ Name "Taunt")
                : (II /\ Name "Sucker Punch")
                : (IV /\ Name "Misericorde")
                : empty
          , limitBreak: Name "Mock"
          , talents:
              Name "Brawl"
                : Name "Suffer"
                : Name "Oppress"
                : empty
          }
      ]

  , traits:
      [ Trait
          { name: Name "Hatred"
          , description:
              [ Text
                  """Once a round, when you damage a target, you may inflict
                  them with """
              , Italic [ Ref (Name "Hatred") [ Text "hatred (-)" ] ]
              , Text
                  """. Hatred is a unique negative status. A character suffering
                  from hatred deals 1/2 dmaage to all characters other than you
                  as long as you are not immune """
              , Italic [ Ref (Name "Immune") [ Text "immune" ] ]
              , Text
                  """ to damage, and in line of sight and range 1-3 from them. A
                  characters removed one hatred after using any ability that
                  damages you."""
              ]
          }
      ]

  , talents:
      [ Talent
          { id: Id "brawl|talent|knave"
          , name: Name "Brawl"
          , colour: Name "Red"
          , description:
              [ Text "Improve the effect of "
              , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
              , Text
                  """ to -3 damage on attacks against you and adjacent allies.
                  When you critical hit, you may inflict """
              , Italic [ Text "dazed" ]
              , Text "."
              ]
          }
      , Talent
          { id: Id "suffer|talent|knave"
          , name: Name "Suffer"
          , colour: Name "Red"
          , description:
              [ Text
                  """Once a round, when a foe in range 1-3 is defeated, you may
                  transfer all stacks of one of its negatice statuses to any
                  other foe in range 1-3."""
              ]
          }
      , Talent
          { id: Id "oppress|talent|knave"
          , name: Name "Oppress"
          , colour: Name "Red"
          , description:
              [ Text
                  """When you hit an attack against a foe, you may increase one
                  of its statuses by +1 after the attack resolves, or +2 if that
                  foe was in crisis."""
              ]
          }
      ]

  , abilities:
      [ LimitBreak
          { name: Name "Mock"
          , colour: Name "Red"
          , description:
              [ Text
                  """There are innumerable words in innumerable tongues for what
                  I am about to say to you. Fortunately, I have picked the very
                  best."""
              ]
          , cost: One /\ 3
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 5)) ]
          , steps:
              [ Step Eff Nothing
                  [ Text "Target foe takes "
                  , Dice 1 D3
                  , Text " "
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage, then gains 3 "
                  , Italic [ Ref (Name "Daze") [ Text "dazed" ] ]
                  , Text ", 3 "
                  , Italic [ Ref (Name "Stun") [ Text "stun" ] ]
                  , Text ", and becomes "
                  , Italic [ Ref (Name "Immobile") [ Text "immobile" ] ]
                  , Text
                      """ and unable to take interrupts until the start of its
                      next turn."""
                  ]
              , Step Eff Nothing
                  [ Text
                      """If you defeat a legend or elite foe with this ability,
                      immediately gain 1 personal resolve or grant 1 to an
                      ally."""
                  ]
              ]
          }
      , Ability
          { name: Name "Low Blow"
          , colour: Name "Red"
          , description: [ Text "Hit them right in the gronch." ]
          , cost: One
          , tags: [ Attack ]
          , steps:
              [ Step Eff Nothing [ Text "Dash 1." ]
              , AttackStep [ Text "2 damage" ] [ Text "+", Dice 1 D3 ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text
                      """Deal 2 damage again. If your target has 3 or more
                      negative status tokens of any kind, deal 4 damage again
                      instead."""
                  ]
              ]
          }
      , Ability
          { name: Name "Taunt"
          , colour: Name "Red"
          , description:
              [ Text
                  """With well places words, you rile up your foe into moving
                  out of position."""
              ]
          , cost: One
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 4)) ]
          , steps:
              [ Step Eff (Just D3)
                  [ Text "Gain "
                  , Italic [ Ref (Name "Shield") [ Text "shield" ] ]
                  , Text
                      """. A foe in range is pulled 1, then must save or be
                      pulled +"""
                  , Dice 1 D3
                  , Text " spaces, become "
                  , Italic [ Ref (Name "Immobile") [ Text "immobile" ] ]
                  , Text
                      """, and become unable to take interrupts. These effects
                      last until the start of theur next turn."""
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text "Foes take 2 "
                  , Italic [ Ref (Name "Pierce") [ Text "piercing" ] ]
                  , Text " damage, or "
                  , Dice 2 D3
                  , Text " if they are affilcted by 3 or more statuses."
                  ]
              ]
          }
      , Ability
          { name: Name "Sucker Punch"
          , colour: Name "Red"
          , description:
              [ Text
                  """There's nothing that can't be solved with the liberal
                  application of fists to faces."""
              ]
          , cost: Interrupt (NumVar 1)
          , tags: [ RangeTag (Range (NumVar 1) (NumVar 2)) ]
          , steps:
              [ Step TriggerStep Nothing
                  [ Text
                      "An enemy in range rolls a save and you see the result."
                  ]
              , Step Eff Nothing
                  [ Text
                      """The enemy must re-roll the save keeping the second
                      result. If they fail the save, you may gain 2 vigor or
                      clear a negative status."""
                  ]
              , Step (KeywordStep (Name "Afflicted")) Nothing
                  [ Text "Gain one more use of this interrupt this round." ]
              ]
          }
      , Ability
          { name: Name "Misericorde"
          , colour: Name "Red"
          , description: [ Text "Put them out of their misery." ]
          , cost: Two
          , tags: [ Attack, RangeTag Melee ]
          , steps:
              [ AttackStep [ Text "2 damage" ] [ Text "+", Dice 2 D6 ]
              , Step OnHit Nothing
                  [ Text
                      """Deal +1 damage for each separate type of negative
                      status token your foe is suffering from (max +6)."""
                  ]
              , Step Eff Nothing
                  [ Text "If your foe is in "
                  , Italic [ Ref (Name "Crisis") [ Text "crisis" ] ]
                  , Text ", also destroy "
                  , Dice 2 D6
                  , Text " vigor on the target before dealing damage."
                  ]
              ]
          }
      ]
  }
