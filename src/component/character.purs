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
import Data.Filterable (compact)
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
import Data.Maybe (Maybe(..), fromMaybe)
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

import ToA.Capability.Character (class Character, saveChar)
import ToA.Data.Async (AsyncData(..), fromEither)
import ToA.Data.FileFormat (FileFormat(..))
import ToA.Data.Store (Store, StoreAction)

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

import ToA.Util.Html (css)
import ToA.Util.Optic ((^::))
import ToA.Util.Style as S

characterSummary :: ∀ w i. Icon -> Character -> HD.HTML w i
characterSummary { colours, jobs } char =
  let
    primary = char ^. _build <. _primary
    job = jobs # traversed `findOf` (view _name >>> eq primary)
  in
    HD.div
      [ css [ "flex", "items-center", "gap-2" ] ]
      [ HD.div
          [ css $ [ "shrink-0", "size-16" ]
              <> (job ^:: _Just <. _sign <. _Newtype)
          ]
          []
      , HD.div
          [ css [ "flex", "flex-col" ] ]
          [ HD.h3
              [ css [ "font-bold" ] ]
              [ HD.text $ char ^. _name <. _Newtype ]

          , HD.div
              [ css [ "flex", "gap-2" ] ]
              [ HD.div []
                  [ HD.text $ "L " <> char ^. _build <. _level <. to show ]
              , HD.text "∷"
              , HD.div
                  [ css [ "font-bold", "text-white" ]
                  , style $ fromMaybe (pure unit) $
                      colours
                      ^? traversed
                        <. filtered
                          (preview _name >>> eq (job ^? _Just <. _colour))
                        <. _value
                        <. to backgroundColor
                  ]
                  [ HD.text $ primary ^. simple _Newtype ]
              ]

          , HD.div []
              [ HD.text
                  $ intercalate " | "
                  $ char
                  # (_build <. _jobs <. itraversed) `ifoldMapOf` \n l ->
                      [ (n ^. simple _Newtype) <> " " <> show l ]
              ]
          ]
      ]

data ExportAction i
  = ReceiveExport (Connected Icon i)
  | OpenExport
  | CloseExport
  | CopyExport

exportCharacter
  :: ∀ q i o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Array String
  -> Array String
  -> Character
  -> H.Component q i o m
exportCharacter containerCss buttonCss char =
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
          writeText (encode (stringCharacter icon) char) cb
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
              , HD.h3 [] [ HD.text $ char ^. _name <. _Newtype ]
              , HD.div
                  [ css [ "flex", "gap-1" ] ] $ compact
                  [ (encodeURIComponent $ encode (stringCharacter icon) char)
                      <#> \charData ->
                        HD.a
                          [ css $ S.button <>
                              [ "flex", "grow", "justify-center", "py-2" ]
                          , HP.href $ "data:text/plain;charset=utf8," <>
                              charData
                          , HP.download $ (char ^. _name <<< _Newtype) <> ".txt"
                          ]
                          [ HD.text "Text" ]

                  , ( encodeURIComponent $ J.print $ CJ.encode jsonCharacter
                        char
                    )
                      <#> \charData ->
                        HD.a
                          [ css $ S.button <>
                              [ "flex", "grow", "justify-center", "py-2" ]
                          , HP.href $ "data:application/json;charset=utf8," <>
                              charData
                          , HP.download $ (char ^. _name <<< _Newtype) <>
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

importCharacter
  :: ∀ q i o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Character m
  => H.Component q i o m
importCharacter =
  connect (selectEq _.icon) $ H.mkComponent
    { initialState: \{ context } ->
        { icon: context
        , format: Text
        , fileChar: NotAsked
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
            fileChar = f >>= fromEither <<< \fi -> case format of
              Text -> lmap (parseErrorHuman fi 20) $
                decode (stringCharacter icon) fi
              Json -> lmap pure
                $ J.parse fi
                >>= (CJ.decode jsonCharacter >>> lmap CJDE.print)
          H.modify_ _ { fileChar = fileChar }
    Import ->
      H.gets _.fileChar >>= case _ of
        Success c -> saveChar c
        _ -> pure unit

  render { icon, format, fileChar } =
    HD.div []
      [ HD.button
          [ css $ S.button <> [ "py-2" ]
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
                                      , "bg-stone-500"
                                      , "dark:bg-stone-700"
                                      , "hover:bg-stone-400"
                                      , "focus:bg-stone-400"
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

              , case fileChar of
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
                      [ characterSummary icon c ]
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
                      , HP.disabled case fileChar of
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
