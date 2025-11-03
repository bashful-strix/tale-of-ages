module ToA.Resource.Icon.LimitBreaks
  ( limitBreaks
  ) where

import ToA.Data.Icon.LimitBreak (LimitBreak)
import ToA.Resource.Icon.LimitBreak.Tactician (mightyCommand)

limitBreaks :: Array LimitBreak
limitBreaks =
  [ mightyCommand
  ]
