module ToA.Component.Character
  ( characterSummary
  , exportCharacter
  , importCharacter
  ) where

import ToA.Prelude

import Promise.Aff (toAffE)
import CSS (backgroundColor)

import Codec.JSON.DecodeError (print) as CJDE
import Data.Bifunctor (lmap)
import Data.Codec (decode, encode)
import Data.Codec.JSON (decode, encode) as CJ
import Data.Foldable (intercalate)
import Data.Lens
  ( (^.)
  , (^?)
  , preview
  , view
  , ifoldMapOf
  , findOf
  , filtered
  , to
  , traversed
  , _Just
  )
import Data.Lens.Common (simple)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Traversable (for, for_, traverse, traverse_)

import Deku.Core (Nut, attributeAtYourOwnRisk, fixed)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.DOM.Self as Self
import Deku.Hooks ((<#~>), useHotRant, useState, useState')

import Effect.Aff (attempt, launchAff_, message)
import Effect.Class (liftEffect)

import JSON (parse, print) as J
import JSURI (encodeURIComponent)
import Parsing.String (parseErrorHuman)
import Web.Clipboard (clipboard, writeText)
import Web.Event.Event (target)
import Web.File.File (toBlob)
import Web.File.FileList (item)
import Web.File.FileReader.Aff (readAsText)
import Web.HTML (window)
import Web.HTML.HTMLDialogElement (close, fromElement, showModal)
import Web.HTML.HTMLInputElement (files, fromEventTarget)
import Web.HTML.Window (navigator)

import ToA.Data.Async (AsyncData(..), fromEither)
import ToA.Data.Env (Env, _saveChar)
import ToA.Data.FileFormat (FileFormat(..))
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Character
  ( Character
  , jsonCharacter
  , stringCharacter
  , _build
  , _jobs
  , _level
  , _primary
  )
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Icon.Sign (_sign)
import ToA.Util.Html (css, css_, style_)
import ToA.Util.Optic ((^::))
import ToA.Util.Style as S

characterSummary :: Icon -> Character -> Nut
characterSummary { colours, jobs } char =
  let
    primary = char ^. _build <. _primary
    job = jobs # traversed `findOf` (view _name >>> eq primary)
  in
    D.div
      [ css_ [ "flex", "items-center", "gap-2" ] ]
      [ D.div
          [ css_ $ [ "shrink-0", "size-16" ]
              <> (job ^:: _Just <. _sign <. _Newtype)
          ]
          []
      , D.div
          [ css_ [ "flex", "flex-col" ] ]
          [ D.h3
              [ css_ [ "font-bold" ] ]
              [ D.text_ $ char ^. _name <. _Newtype ]

          , D.div
              [ css_ [ "flex", "gap-2" ] ]
              [ D.div []
                  [ D.text_ $ "L " <> char ^. _build <. _level <. to show ]
              , D.text_ "∷"
              , D.div
                  [ css_ [ "font-bold", "text-white" ]
                  , style_ $ fromMaybe (pure unit) $
                      colours
                      ^? traversed
                        <. filtered
                          (preview _name >>> eq (job ^? _Just <. _colour))
                        <. _value
                        <. to backgroundColor
                  ]
                  [ D.text_ $ primary ^. simple _Newtype ]
              ]

          , D.div []
              [ D.text_
                  $ intercalate " | "
                  $ char
                  # (_build <. _jobs <. itraversed) `ifoldMapOf` \n l ->
                      [ (n ^. simple _Newtype) <> " " <> show l ]
              ]
          ]
      ]

exportCharacter :: Icon -> Array String -> Character -> Nut
exportCharacter icon_ styles char = Deku.do
  setDialog /\ dialog' <- useState'
  dialog <- useHotRant dialog'

  fixed
    [ D.button
        [ css_ styles
        , DL.runOn DL.click $ dialog <#> fromElement >>> traverse_ showModal
        ]
        [ D.text_ "Export" ]

    , D.dialog
        [ css_
            [ "w-sm"
            , "m-auto"
            , "p-2"
            , "bg-stone-300"
            , "text-stone-700"
            , "dark:bg-stone-900"
            , "dark:text-stone-400"
            ]
        , pure $ attributeAtYourOwnRisk "closedby" "any"
        , Self.self_ setDialog
        ]
        [ D.div
            [ css_ [ "flex", "flex-col", "gap-2" ]
            , DA.autofocus_ "true"
            ]
            [ D.h2 [ css_ [ "font-bold" ] ] [ D.text_ "Export" ]
            , D.h3 [] [ D.text_ $ char ^. _name <. _Newtype ]
            , D.div
                [ css_ [ "flex", "gap-1" ] ]
                [ (encodeURIComponent $ encode (stringCharacter icon_) char)
                    # maybe mempty \charData ->
                        D.a
                          [ css_ $ S.button <>
                              [ "flex", "grow", "justify-center", "py-2" ]
                          , DA.href_ $ "data:text/plain;charset=utf8," <>
                              charData
                          , DA.download_ $ (char ^. _name <<< _Newtype) <>
                              ".txt"
                          ]
                          [ D.text_ "Text" ]

                , (encodeURIComponent $ J.print $ CJ.encode jsonCharacter char)
                    # maybe mempty \charData ->
                        D.a
                          [ css_ $ S.button <>
                              [ "flex", "grow", "justify-center", "py-2" ]
                          , DA.href_ $ "data:application/json;charset=utf8," <>
                              charData
                          , DA.download_ $ (char ^. _name <<< _Newtype) <>
                              ".json"
                          ]
                          [ D.text_ "JSON" ]

                , D.button
                    [ css_ $ S.button <>
                        [ "flex", "grow", "justify-center", "gap-2", "py-2" ]
                    , DA.xtypeButton
                    , DL.runOn DL.click $ dialog <#> \d -> do
                        mcb <- clipboard =<< navigator =<< window
                        for_ mcb \cb -> launchAff_ do
                          toAffE $
                            writeText (encode (stringCharacter icon_) char) cb
                          liftEffect $ for_ (fromElement d) (close Nothing)
                    ]
                    [ D.text_ "Copy" ]
                ]

            , D.button
                [ css_ $ S.button <>
                    [ "flex", "justify-center", "gap-2", "py-2" ]
                , DA.xtypeButton
                , DL.runOn DL.click $ dialog
                    <#> fromElement
                    >>> traverse_ (close Nothing)
                ]
                [ D.text_ "Close" ]
            ]
        ]
    ]

importCharacter :: Env -> Nut
importCharacter env = Deku.do
  setDialog /\ dialog' <- useState'
  dialog <- useHotRant dialog'

  fixed
    [ D.button
        [ css_ $ S.button <> [ "py-2" ]
        , DL.runOn DL.click $ dialog <#> fromElement >>> traverse_ showModal
        ]
        [ D.text_ "Import" ]

    , D.dialog
        [ css_
            [ "w-full"
            , "sm:max-w-3/5"
            , "md:max-w-2/5"
            , "h-3/4"
            , "m-auto"
            , "p-2"
            , "bg-stone-300"
            , "text-stone-700"
            , "dark:bg-stone-900"
            , "dark:text-stone-400"
            ]
        , pure $ attributeAtYourOwnRisk "closedby" "any"
        , Self.self_ setDialog
        ]
        [ Deku.do
            setFormat /\ format <- useState Text
            setFile /\ file <- useState NotAsked

            let
              fileChar = ado
                icon_ <- env.icon
                fo <- format
                afi <- file
                in
                  afi >>= fromEither <<< \fi ->
                    case fo of
                      Text -> lmap (parseErrorHuman fi 20) $
                        decode (stringCharacter icon_) fi
                      Json -> lmap pure
                        $ J.parse fi
                        >>= (CJ.decode jsonCharacter >>> lmap CJDE.print)

            D.form
              [ css_
                  [ "flex"
                  , "flex-col"
                  , "h-full"
                  , "justify-between"
                  , "gap-2"
                  ]
              , DA.autofocus_ "true"
              , DA.method_ "dialog"
              ]
              [ D.div
                  [ css_ [ "flex", "flex-col", "gap-2" ] ]
                  [ D.h2 [ css_ [ "font-bold" ] ] [ D.text_ "Import" ]
                  , D.div
                      [ css_ [ "flex", "flex-wrap", "gap-2" ] ]
                      [ D.div
                          [ css_ [ "flex", "items-center", "gap-1" ] ]
                          $ [ Text, Json ]
                          <#> \f ->
                            D.button
                              [ css
                                  $ pure
                                      [ "flex-1"
                                      , "p-2"
                                      , "rounded"
                                      , "text-white"
                                      ]
                                  <>
                                    ( format <#> eq f >>>
                                        if _ then [ "bg-sky-600" ]
                                        else
                                          [ "cursor-pointer"
                                          , "disabled:cursor-not-allowed"
                                          , "bg-stone-500"
                                          , "dark:bg-stone-700"
                                          , "hover:bg-stone-400"
                                          , "focus:bg-stone-400"
                                          , "dark:hover:bg-stone-500"
                                          , "dark:focus:bg-stone-500"
                                          ]
                                    )
                              , DA.xtypeButton
                              , DL.runOn_ DL.click $ setFormat f
                              ]
                              [ D.text_ $ show f ]

                      , D.input
                          [ css_ $ S.button <>
                              [ "flex"
                              , "grow"
                              , "items-center"
                              , "gap-2"
                              , "py-2"
                              ]
                          , DA.xtypeFile
                          , DA.accept $ format <#> case _ of
                              Text -> "text/plain"
                              Json -> "application/json"
                          , DL.change_ \e -> do
                              fs <- traverse files
                                (fromEventTarget =<< target e)
                              launchAff_ $ void
                                $ for (item 0 =<< join fs)
                                $ toBlob
                                >>> readAsText
                                >>> attempt
                                >=> lmap (pure <<< message)
                                >>> fromEither
                                >>> setFile
                                >>> liftEffect
                          ]
                          []
                      ]
                  ]

              , fileChar <#~> case _ of
                  NotAsked -> mempty
                  Loading -> D.div [] [ D.text_ "Loading..." ]
                  Success c -> env.icon <#~> \icon ->
                    D.div
                      [ css_
                          [ "w-full"
                          , "max-w-7/8"
                          , "self-center"
                          , "p-2"
                          , "bg-stone-500"
                          , "text-stone-800"
                          , "dark:bg-stone-700"
                          , "dark:text-stone-300"
                          ]
                      ]
                      [ characterSummary icon c ]
                  Error e ->
                    D.div
                      [ css_
                          [ "w-full"
                          , "max-w-7/8"
                          , "self-center"
                          ]
                      ]
                      [ D.div [] [ D.text_ "Invalid file:" ]
                      , D.div
                          [ css_
                              [ "p-2"
                              , "font-mono"
                              , "bg-stone-500"
                              , "dark:bg-stone-700"
                              , "text-red-600"
                              ]
                          ]
                          $ e
                          <#> \l -> D.div [] [ D.text_ l ]
                      ]

              , D.div
                  [ css_ [ "flex", "gap-2", "justify-end-safe" ] ]
                  [ D.button
                      [ css_ $ S.button <>
                          [ "flex", "justify-center", "gap-2", "py-2" ]
                      , DA.xtypeSubmit
                      , DA.disabled $ fileChar <#> show <<< case _ of
                          Success _ -> false
                          _ -> true
                      , DL.runOn DL.click $ fileChar <#> case _ of
                          Success c -> (env ^. _saveChar) c
                          _ -> pure unit
                      ]
                      [ D.text_ "Import" ]

                  , D.button
                      [ css_ $ S.button <>
                          [ "flex", "justify-center", "gap-2", "py-2" ]
                      , DL.runOn DL.click $ dialog
                          <#> fromElement
                          >>> traverse_ (close Nothing)
                      ]
                      [ D.text_ "Cancel" ]
                  ]
              ]
        ]
    ]
