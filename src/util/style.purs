module ToA.Util.Style
  ( interactable
  , interactableDanger
  , button
  , buttonDanger
  , input
  ) where

import Prelude

interactable :: Array String
interactable =
  [ "cursor-pointer"
  , "disabled:cursor-not-allowed"
  , "bg-stone-500"
  , "text-stone-800"
  , "dark:bg-stone-700"
  , "dark:text-stone-300"
  , "hover:not-disabled:bg-stone-400"
  , "focus:not-disabled:bg-stone-400"
  , "dark:hover:not-disabled:bg-stone-500"
  , "dark:focus:not-disabled:bg-stone-500"
  , "disabled:bg-stone-600"
  , "disabled:text-stone-400"
  , "disabled:dark:text-stone-800"
  ]

interactableDanger :: Array String
interactableDanger =
  [ "cursor-pointer"
  , "disabled:cursor-not-allowed"
  , "bg-stone-500"
  , "text-stone-800"
  , "dark:bg-stone-700"
  , "dark:text-stone-300"
  , "hover:not-disabled:bg-red-400"
  , "focus:not-disabled:bg-red-400"
  , "disabled:bg-stone-600"
  , "disabled:text-stone-400"
  , "disabled:dark:text-stone-800"
  ]

button :: Array String
button =
  [ "px-2"
  , "py-1"
  , "rounded"
  ] <> interactable

buttonDanger :: Array String
buttonDanger =
  [ "px-2"
  , "py-1"
  , "rounded"
  ] <> interactableDanger

input :: Array String
input =
  [ "px-1", "bg-stone-400", "dark:bg-stone-800" ]
