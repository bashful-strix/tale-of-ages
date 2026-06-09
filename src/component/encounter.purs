module ToA.Component.Encounter
  ( encounterSummary
  , exportEncounter
  , importEncounter
  ) where

import ToA.Prelude

import Promise.Aff (toAffE)
import CSS (backgroundColor)

import Codec.JSON.DecodeError (print) as CJDE
import Data.Array (null)
import Data.Bifunctor (lmap)
import Data.Codec (decode, encode)
import Data.Codec.JSON (decode, encode) as CJ
import Data.Lens
  ( (^.)
  , (^?)
  , preview
  , view
  , elemOf
  , filtered
  , folded
  , to
  , _Just
  )
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Monoid (guard)
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
import ToA.Data.Env (Env, _saveEnc)
import ToA.Data.FileFormat (FileFormat(..))
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Encounter
  ( Encounter
  , FoeEntry
  , _foes
  , _reserves
  , _alias
  , _count
  , _faction
  , _template
  , jsonEncounter
  , stringEncounter
  )
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Util.Html (css, css_, style_)
import ToA.Util.Optic ((#~))

encounterSummary :: Icon -> Encounter -> Nut
encounterSummary icon enc =
  D.div
    [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
    [ D.h3
        [ css_ [ "font-bold" ] ]
        [ D.text_ $ enc ^. _name <. _Newtype ]

    , D.div
        [ css_
            [ "grid", "sm:grid-cols-2", "gap-x-4", "gap-y-2" ]
        ]
        [ D.div []
            [ D.h4 [ css_ [ "font-bold" ] ] [ D.text_ "Foes" ]
            , enc # _foes #~ renderFoeList icon
            ]
        , guard (not $ null $ enc ^. _reserves) $
            D.div []
              [ D.h4 [ css_ [ "font-bold" ] ] [ D.text_ "Reserves" ]
              , enc # _reserves #~ renderFoeList icon
              ]
        ]
    ]

renderFoeList :: Icon -> Array FoeEntry -> Nut
renderFoeList { colours, foes } foeEntries =
  let
    purple = colours
      ^? folded
        <. filtered (view _name >>> eq (Name "Purple"))
        <. _value
  in
    D.ul [] $ foeEntries <#> \foe ->
      D.li
        [ css_ [ "flex", "gap-2", "items-end-safe" ] ]
        [ D.span
            [ css_
                [ "flex"
                , "flex-wrap"
                , "grow"
                , "gap-x-1"
                , "text-white"
                , "font-bold"
                ]
            ]
            [ foe # _template <. _Just <. _Newtype #~ \template ->
                D.span
                  [ style_ $ fromMaybe (pure unit)
                      $ backgroundColor
                      <$> purple
                  ]
                  [ D.text_ template ]

            , foe # _faction <. _Just <. _Newtype #~ \faction ->
                D.span
                  [ style_ $ fromMaybe (pure unit)
                      $ backgroundColor
                      <$> purple
                  ]
                  [ D.text_ faction ]

            , D.span
                [ style_ $ fromMaybe (pure unit) $ backgroundColor <$> colours
                    ^? folded
                      <. filtered
                        ( preview _name >>> eq
                            ( foes
                                ^? folded
                                  <. filtered (_name `elemOf` (foe ^. _name))
                                  <. _colour
                            )
                        )
                      <. _value
                ]
                [ D.text_ $ foe ^. _name <. _Newtype ]
            ]

        , foe # _alias <. _Just #~ \alias ->
            D.span
              [ css_ [ "italic" ] ]
              [ D.text_ alias ]

        , D.span []
            [ D.text_ $ "x" <> foe ^. _count <. to show ]
        ]

exportEncounter :: Array String -> Encounter -> Nut
exportEncounter styles enc = Deku.do
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
            , D.h3 [] [ D.text_ $ enc ^. _name <. _Newtype ]
            , D.div
                [ css_ [ "flex", "gap-1" ] ]
                [ (encodeURIComponent $ encode stringEncounter enc)
                    # maybe mempty \encData ->
                        D.a
                          [ css_
                              [ "flex"
                              , "grow"
                              , "justify-center"
                              , "p-2"
                              , "bg-stone-500"
                              , "text-stone-800"
                              , "dark:bg-stone-700"
                              , "dark:text-stone-300"
                              , "hover:bg-stone-400"
                              , "focus:bg-stone-400"
                              , "dark:hover:bg-stone-500"
                              , "dark:focus:bg-stone-500"
                              ]
                          , DA.href_ $ "data:text/plain;charset=utf8," <>
                              encData
                          , DA.download_ $ (enc ^. _name <<< _Newtype) <> ".txt"
                          ]
                          [ D.text_ "Text" ]

                , (encodeURIComponent $ J.print $ CJ.encode jsonEncounter enc)
                    # maybe mempty \encData ->
                        D.a
                          [ css_
                              [ "flex"
                              , "grow"
                              , "justify-center"
                              , "p-2"
                              , "bg-stone-500"
                              , "text-stone-800"
                              , "dark:bg-stone-700"
                              , "dark:text-stone-300"
                              , "hover:bg-stone-400"
                              , "focus:bg-stone-400"
                              , "dark:hover:bg-stone-500"
                              , "dark:focus:bg-stone-500"
                              ]
                          , DA.href_ $ "data:application/json;charset=utf8," <>
                              encData
                          , DA.download_ $ (enc ^. _name <<< _Newtype) <>
                              ".json"
                          ]
                          [ D.text_ "JSON" ]

                , D.button
                    [ css_
                        [ "flex"
                        , "grow"
                        , "justify-center"
                        , "gap-2"
                        , "p-2"
                        , "bg-stone-500"
                        , "text-stone-800"
                        , "dark:bg-stone-700"
                        , "dark:text-stone-300"
                        , "hover:bg-stone-400"
                        , "focus:bg-stone-400"
                        , "dark:hover:bg-stone-500"
                        , "dark:focus:bg-stone-500"
                        ]
                    , DA.xtypeButton
                    , DL.runOn DL.click $ dialog <#> \d -> do
                        mcb <- clipboard =<< navigator =<< window
                        for_ mcb \cb -> launchAff_ do
                          toAffE $
                            writeText (encode stringEncounter enc) cb
                          liftEffect $ for_ (fromElement d) (close Nothing)
                    ]
                    [ D.text_ "Copy" ]
                ]

            , D.button
                [ css_
                    [ "flex"
                    , "justify-center"
                    , "gap-2"
                    , "p-2"
                    , "rounded"
                    , "bg-stone-500"
                    , "text-stone-800"
                    , "dark:bg-stone-700"
                    , "dark:text-stone-300"
                    , "hover:bg-stone-400"
                    , "focus:bg-stone-400"
                    , "dark:hover:bg-stone-500"
                    , "dark:focus:bg-stone-500"
                    ]
                , DA.xtypeButton
                , DL.runOn DL.click $ dialog
                    <#> fromElement
                    >>> traverse_ (close Nothing)
                ]
                [ D.text_ "Close" ]
            ]
        ]
    ]

importEncounter :: Env -> Nut
importEncounter env = Deku.do
  setDialog /\ dialog' <- useState'
  dialog <- useHotRant dialog'

  fixed
    [ D.button
        [ css_
            [ "p-2"
            , "rounded"
            , "bg-stone-500"
            , "text-stone-800"
            , "dark:bg-stone-700"
            , "dark:text-stone-300"
            , "hover:bg-stone-400"
            , "focus:bg-stone-400"
            , "dark:hover:bg-stone-500"
            , "dark:focus:bg-stone-500"
            ]
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
              fileEnc = ado
                fo <- format
                afi <- file
                in
                  afi >>= fromEither <<< \fi ->
                    case fo of
                      Text -> lmap (parseErrorHuman fi 20) $
                        decode stringEncounter fi
                      Json -> lmap pure
                        $ J.parse fi
                        >>= (CJ.decode jsonEncounter >>> lmap CJDE.print)

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
                                          [ "bg-stone-500"
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
                          [ css_
                              [ "flex"
                              , "grow"
                              , "items-center"
                              , "gap-2"
                              , "p-2"
                              , "rounded"
                              , "bg-stone-500"
                              , "text-stone-800"
                              , "dark:bg-stone-700"
                              , "dark:text-stone-300"
                              , "hover:bg-stone-400"
                              , "focus:bg-stone-400"
                              , "dark:hover:bg-stone-500"
                              , "dark:focus:bg-stone-500"
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

              , fileEnc <#~> case _ of
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
                      [ encounterSummary icon c ]
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
                      [ css_
                          [ "flex"
                          , "justify-center"
                          , "gap-2"
                          , "p-2"
                          , "rounded"
                          , "bg-stone-500"
                          , "text-stone-800"
                          , "dark:bg-stone-700"
                          , "dark:text-stone-300"
                          , "hover:bg-stone-400"
                          , "focus:bg-stone-400"
                          , "dark:hover:bg-stone-500"
                          , "dark:focus:bg-stone-500"
                          ]
                      , DA.xtypeSubmit
                      , DA.disabled $ fileEnc <#> show <<< case _ of
                          Success _ -> false
                          _ -> true
                      , DL.runOn DL.click $ fileEnc <#> case _ of
                          Success c -> (env ^. _saveEnc) c
                          _ -> pure unit
                      ]
                      [ D.text_ "Import" ]

                  , D.button
                      [ css_
                          [ "flex"
                          , "justify-center"
                          , "gap-2"
                          , "p-2"
                          , "rounded"
                          , "bg-stone-500"
                          , "text-stone-800"
                          , "dark:bg-stone-700"
                          , "dark:text-stone-300"
                          , "hover:bg-stone-400"
                          , "focus:bg-stone-400"
                          , "dark:hover:bg-stone-500"
                          , "dark:focus:bg-stone-500"
                          ]
                      , DL.runOn DL.click $ dialog
                          <#> fromElement
                          >>> traverse_ (close Nothing)
                      ]
                      [ D.text_ "Cancel" ]
                  ]
              ]
        ]
    ]
