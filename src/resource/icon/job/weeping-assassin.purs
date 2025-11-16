module ToA.Resource.Icon.Job.WeepingAssassin
  ( weepingAssassin
  ) where

import Data.FastVect.FastVect ((:), empty)
import Data.Tuple.Nested ((/\))

import ToA.Data.Icon.Job (Job(..), JobLevel(..))
import ToA.Data.Icon.Markup (MarkupItem(..))
import ToA.Data.Icon.Name (Name(..))

weepingAssassin :: Job
weepingAssassin = Job
  { name: Name "Weeping Assassin"
  , colour: Name "Yellow"
  , soul: Name "Shadow"
  , class: Name "Vagabond"
  , description:
      [ Text
          """The Weeper is the titan of night, the poor, and untimely
          death. Her Tears can be found in black springs in lightless
          shrines underground, sealed in some forgotten era. The journey
          to these shrines is perilous and haunting, and only the most
          determined make the journey - those that are set on joining the
          Weeping Assassins. These disciples of the departed titan have
          undertaken communion by drinking her tears. This gives them the
          uncanny ability to sense when someone is in deep sorrow, an
          effect that sometimes also causes an assassin to weep
          sympathetic black tears."""
      , Newline
      , Newline
      , Text
          """As night is a mother to all, it accepts all grief and
          answers all prayers. Sometimes, comfort is only found in
          absolute vengeance."""
      ]
  , trait: Name "Tears of the Weeper"
  , keyword: Name "Isolate"
  , abilities:
      (I /\ Name "Harien")
        : (I /\ Name "Shadow Cloak")
        : (II /\ Name "Night's Caress")
        : (IV /\ Name "Swallow the Stars")
        : empty
  , limitBreak: Name "Hollow"
  , talents:
      Name "Commiserate"
        : Name "Infiltrate"
        : Name "Shimmer"
        : empty
  }
