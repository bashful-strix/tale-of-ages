module ToA.Component.Encounter
  ( encounterSummary
  , exportEncounter
  , importEncounter
  ) where

import ToA.Prelude

import Promise.Aff (toAffE)
import CSS (backgroundColor)

import Codec.JSON.DecodeError (print) as CJDE
import Data.Array (length, null)
import Data.Bifunctor (lmap)
import Data.Codec (decode, encode)
import Data.Codec.JSON (decode, encode) as CJ
import Data.Filterable (compact, partition)
import Data.Lens
  ( (^.)
  , (^?)
  , is
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
import Data.Traversable (for_, traverse_)

import Data.MediaType.Common (applicationJSON, textPlain)
import DOM.HTML.Indexed.InputAcceptType (mediaType)

import Effect.Aff (attempt, message)
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (liftEffect)

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.CSS (style)
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectEq)

import JSON (parse, print) as J
import JSURI (encodeURIComponent)
import Parsing.String (parseErrorHuman)
import Web.Clipboard (clipboard, writeText)
import Web.File.File (File, toBlob)
import Web.File.FileReader.Aff (readAsText)
import Web.HTML (window)
import Web.HTML.Common as WC
import Web.HTML.HTMLDialogElement (close, fromHTMLElement, showModal)
import Web.HTML.Window (navigator)

import ToA.Capability.Encounter (class Encounter, saveEnc)
import ToA.Data.Async (AsyncData(..), fromEither)
import ToA.Data.FileFormat (FileFormat(..))
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Encounter
  ( Encounter
  , FoeEntry
  , _foes
  , _alias
  , _faction
  , _state
  , _template
  , _Active
  , jsonEncounter
  , stringEncounter
  )
import ToA.Data.Icon.Name (Name(..), _name)

import ToA.Util.Html (css)
import ToA.Util.Style as S

encounterSummary :: ∀ w i. Icon -> Encounter -> HD.HTML w i
encounterSummary icon enc =
  HD.div
    [ css [ "flex", "flex-col", "grow", "gap-2" ] ]
    [ HD.h3
        [ css [ "font-bold" ] ]
        [ HD.text $ enc ^. _name <. _Newtype ]

    , HD.div
        [ css
            [ "grid", "sm:grid-cols-2", "gap-x-4", "gap-y-2" ]
        ] $ join
        [ [ HD.div []
              [ HD.h4 [ css [ "font-bold" ] ] [ HD.text "Foes" ]
              , renderFoeList icon foes
              ]
          ]
        , guard (not $ null reserves) $
            [ HD.div []
                [ HD.h4 [ css [ "font-bold" ] ] [ HD.text "Reserves" ]
                , renderFoeList icon reserves
                ]
            ]
        ]
    ]
  where
  { yes: foes, no: reserves } = partition (is _Active) (enc ^. _foes)

renderFoeList :: ∀ w i. Icon -> Array FoeEntry -> HD.HTML w i
renderFoeList { colours, foes } foeEntries =
  let
    purple = colours
      ^? folded
        <. filtered (view _name >>> eq (Name "Purple"))
        <. _value
  in
    HD.ul [] $ foeEntries <#> \foe ->
      HD.li
        [ css [ "flex", "gap-2", "items-end-safe" ] ]
        [ HD.span
            [ css
                [ "flex"
                , "flex-wrap"
                , "grow"
                , "gap-x-1"
                , "text-white"
                , "font-bold"
                ]
            ]
            [ foe ^? _template <. _Just <. _Newtype # maybe (HD.text "")
                \template ->
                  HD.span
                    [ style $ fromMaybe (pure unit)
                        $ backgroundColor
                        <$> purple
                    ]
                    [ HD.text template ]

            , foe ^? _faction <. _Just <. _Newtype # maybe (HD.text "")
                \faction ->
                  HD.span
                    [ style $ fromMaybe (pure unit)
                        $ backgroundColor
                        <$> purple
                    ]
                    [ HD.text faction ]

            , HD.span
                [ style $ fromMaybe (pure unit) $ backgroundColor <$> colours
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
                [ HD.text $ foe ^. _name <. _Newtype ]
            ]

        , foe ^? _alias <. _Just # maybe (HD.text "") \alias ->
            HD.span
              [ css [ "italic" ] ]
              [ HD.text alias ]

        , HD.span []
            [ HD.text $ "x" <> foe ^. _state <. to (length >>> show) ]
        ]

data ExportAction i
  = ReceiveExport (Connected Icon i)
  | OpenExport
  | CloseExport
  | CopyExport

exportEncounter
  :: ∀ q i o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Array String
  -> Array String
  -> Encounter
  -> H.Component q i o m
exportEncounter containerCss buttonCss enc =
  connect (selectEq _.icon) $ H.mkComponent
    { initialState: _.context
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = Just <<< ReceiveExport
        }
    }
  where
  dialog = H.RefLabel "dialog"

  act = case _ of
    ReceiveExport input ->
      H.put $ _.context input
    OpenExport -> do
      d <- H.getHTMLElementRef dialog
      liftEffect $ traverse_ showModal (fromHTMLElement =<< d)
    CloseExport -> do
      d <- H.getHTMLElementRef dialog
      liftEffect $ traverse_ (close Nothing) (fromHTMLElement =<< d)
    CopyExport -> do
      mcb <- liftEffect $ clipboard =<< navigator =<< window
      icon <- H.get
      for_ mcb \cb -> do
        liftAff $ toAffE $
          writeText (encode (stringEncounter icon) enc) cb
      d <- H.getHTMLElementRef dialog
      liftEffect $ traverse_ (close Nothing) (fromHTMLElement =<< d)

  render icon =
    HD.div
      [ css containerCss ]
      [ HD.button
          [ css $ S.button <> buttonCss
          , HP.type_ HP.ButtonButton
          , HE.onClick \_ -> OpenExport
          ]
          [ HD.text "Export" ]

      , HD.dialog
          [ css
              [ "w-sm"
              , "m-auto"
              , "p-2"
              , "bg-stone-300"
              , "text-stone-700"
              , "dark:bg-stone-900"
              , "dark:text-stone-400"
              ]
          , HP.prop (WC.PropName "closedby") "any"
          , HP.ref dialog
          ]
          [ HD.div
              [ css [ "flex", "flex-col", "gap-2" ]
              -- , HP.autofocus true
              ]
              [ HD.h2 [ css [ "font-bold" ] ] [ HD.text "Export" ]
              , HD.h3 [] [ HD.text $ enc ^. _name <. _Newtype ]
              , HD.div
                  [ css [ "flex", "gap-1" ] ] $ compact
                  [ (encodeURIComponent $ encode (stringEncounter icon) enc)
                      <#> \encData ->
                        HD.a
                          [ css $ S.button <>
                              [ "flex", "grow", "justify-center", "py-2" ]
                          , HP.href $ "data:text/plain;charset=utf8," <>
                              encData
                          , HP.download $ (enc ^. _name <<< _Newtype) <> ".txt"
                          ]
                          [ HD.text "Text" ]

                  , (encodeURIComponent $ J.print $ CJ.encode jsonEncounter enc)
                      <#> \encData ->
                        HD.a
                          [ css $ S.button <>
                              [ "flex", "grow", "justify-center", "py-2" ]
                          , HP.href $ "data:application/json;charset=utf8," <>
                              encData
                          , HP.download $ (enc ^. _name <<< _Newtype) <>
                              ".json"
                          ]
                          [ HD.text "JSON" ]

                  , pure $ HD.button
                      [ css $ S.button <>
                          [ "flex", "grow", "justify-center", "gap-2", "py-2" ]
                      , HP.type_ HP.ButtonButton
                      , HE.onClick \_ -> CopyExport
                      ]
                      [ HD.text "Copy" ]
                  ]

              , HD.button
                  [ css $ S.button <>
                      [ "flex", "justify-center", "gap-2", "py-2" ]
                  , HP.type_ HP.ButtonButton
                  , HE.onClick \_ -> CloseExport
                  ]
                  [ HD.text "Close" ]
              ]
          ]
      ]

data ImportAction i
  = ReceiveImport (Connected Icon i)
  | OpenImport
  | CloseImport
  | SetFormat FileFormat
  | SetFile (Maybe File)
  | Import

importEncounter
  :: ∀ q i o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Encounter m
  => H.Component q i o m
importEncounter =
  connect (selectEq _.icon) $ H.mkComponent
    { initialState: \{ context } ->
        { icon: context
        , format: Text
        , fileEnc: NotAsked
        }
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = Just <<< ReceiveImport
        }
    }
  where
  dialog = H.RefLabel "dialog"

  act = case _ of
    ReceiveImport { context } ->
      H.modify_ _ { icon = context }
    OpenImport -> do
      d <- H.getHTMLElementRef dialog
      liftEffect $ traverse_ showModal (fromHTMLElement =<< d)
    CloseImport -> do
      d <- H.getHTMLElementRef dialog
      liftEffect $ traverse_ (close Nothing) (fromHTMLElement =<< d)
    SetFormat format ->
      H.modify_ _ { format = format }
    SetFile fs -> do
      case fs of
        Nothing -> pure unit
        Just file -> do
          f <- liftAff
            $ fromEither
            <<< lmap (pure <<< message)
            <$> attempt (readAsText $ toBlob file)
          { icon, format } <- H.get
          let
            fileEnc = f >>= fromEither <<< \fi -> case format of
              Text -> lmap (parseErrorHuman fi 20) $
                decode (stringEncounter icon) fi
              Json -> lmap pure
                $ J.parse fi
                >>= (CJ.decode jsonEncounter >>> lmap CJDE.print)
          H.modify_ _ { fileEnc = fileEnc }
    Import ->
      H.gets _.fileEnc >>= case _ of
        Success c -> saveEnc c
        _ -> pure unit

  render { icon, format, fileEnc } =
    HD.div
      [ css [ "flex" ] ]
      [ HD.button
          [ css S.button
          , HP.type_ HP.ButtonButton
          , HE.onClick \_ -> OpenImport
          ]
          [ HD.text "Import" ]

      , HD.dialog
          [ css
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
          , HP.prop (WC.PropName "closedby") "any"
          , HP.ref dialog
          ]
          [ HD.form
              [ css
                  [ "flex"
                  , "flex-col"
                  , "h-full"
                  , "justify-between"
                  , "gap-2"
                  ]
              -- , HP.autofocus true
              , HP.method HP.Dialog
              ]
              [ HD.div
                  [ css [ "flex", "flex-col", "gap-2" ] ]
                  [ HD.h2 [ css [ "font-bold" ] ] [ HD.text "Import" ]
                  , HD.div
                      [ css [ "flex", "flex-wrap", "gap-2" ] ]
                      [ HD.div
                          [ css [ "flex", "items-center", "gap-1" ] ]
                          $ [ Text, Json ]
                          <#> \f ->
                            HD.button
                              [ css
                                  $
                                    [ "flex-1"
                                    , "p-2"
                                    , "rounded"
                                    , "text-white"
                                    ]
                                  <>
                                    if format == f then [ "bg-sky-600" ]
                                    else
                                      [ "cursor-pointer"
                                      , "disabled:cursor-not-allowed"
                                      , "bg-stone-400"
                                      , "dark:bg-stone-700"
                                      , "hover:bg-stone-500"
                                      , "focus:bg-stone-500"
                                      , "dark:hover:bg-stone-500"
                                      , "dark:focus:bg-stone-500"
                                      ]
                              , HP.type_ HP.ButtonButton
                              , HE.onClick \_ -> SetFormat f
                              ]
                              [ HD.text $ show f ]

                      , HD.input
                          [ css $ S.button <>
                              [ "flex"
                              , "grow"
                              , "items-center"
                              , "gap-2"
                              , "py-2"
                              ]
                          , HP.type_ HP.InputFile
                          , HP.accept case format of
                              Text -> mediaType textPlain
                              Json -> mediaType applicationJSON
                          , HE.onFileUpload SetFile
                          ]
                      ]
                  ]

              , case fileEnc of
                  NotAsked -> HD.span [] []
                  Loading -> HD.div [] [ HD.text "Loading..." ]
                  Success c ->
                    HD.div
                      [ css
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
                    HD.div
                      [ css
                          [ "w-full"
                          , "max-w-7/8"
                          , "self-center"
                          ]
                      ]
                      [ HD.div [] [ HD.text "Invalid file:" ]
                      , HD.div
                          [ css
                              [ "p-2"
                              , "font-mono"
                              , "bg-stone-500"
                              , "dark:bg-stone-700"
                              , "text-red-600"
                              ]
                          ]
                          $ e
                          <#> \l -> HD.div [] [ HD.text l ]
                      ]

              , HD.div
                  [ css [ "flex", "gap-2", "justify-end-safe" ] ]
                  [ HD.button
                      [ css $ S.button <>
                          [ "flex", "justify-center", "gap-2", "py-2" ]
                      , HP.type_ HP.ButtonSubmit
                      , HP.disabled case fileEnc of
                          Success _ -> false
                          _ -> true
                      , HE.onClick \_ -> Import
                      ]
                      [ HD.text "Import" ]

                  , HD.button
                      [ css $ S.button <>
                          [ "flex", "justify-center", "gap-2", "py-2" ]
                      , HP.type_ HP.ButtonButton
                      , HE.onClick \_ -> CloseImport
                      ]
                      [ HD.text "Cancel" ]
                  ]
              ]
          ]
      ]
