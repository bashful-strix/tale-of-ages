module ToA.Page.Encounters
  ( encountersPage
  ) where

import Prelude

import Color (lighten)
import CSS (backgroundColor, render, renderedInline)

import Data.Filterable (filter)
import Data.Foldable (foldMap, intercalate, null)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Lens
  ( (^.)
  , (^?)
  , _Just
  , _Nothing
  , filtered
  , preview
  , to
  , traversed
  , view
  )
import Data.Lens.At (at)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (is, isn't)
import Data.Map (keys)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)
import Data.Newtype (unwrap, wrap)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import ToA.Component.Ability (renderStep)
import ToA.Component.Markup (markup)
import ToA.Data.Env (Env, _navigate)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Pattern(..)
  , Range(..)
  , Tag(..)
  )
import ToA.Data.Icon.Ability (Target(..)) as AT
import ToA.Data.Icon.Colour (_value)
import ToA.Data.Icon.Encounter (FoeEntry(..))
import ToA.Data.Icon.Foe
  ( Foe(..)
  , FoeAbility(..)
  , FoeInsert(..)
  , FoeTrait(..)
  , Faction(..)
  )
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Route (Route(..), _Encounters)
import ToA.Util.Html (css_, hr)
import ToA.Util.Optic ((^::))

encountersPage :: Env -> Maybe Name -> Nut
encountersPage env@{ encounters, icon, route } pathEnc =
  ((/\) <$> encounters <*> icon)
    <#~>
      \(encs /\ icon_) ->
        let
          enc = pathEnc >>= \e -> encs ^. at e

        in
          D.div
            [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
            [ D.div
                [ css_ [ "flex", "justify-between", "gap-x-2" ] ]
                [ D.select
                    [ DL.selectOn_ DL.change $ \e ->
                        (env ^. _navigate)
                          ( Encounters $
                              if e == mempty then Nothing else pure (Name e)
                          )
                          Nothing
                    , css_
                        [ "grow"
                        , "px-2"
                        , "py-1"
                        , "border"
                        , "border-solid"
                        , "border-stone-700"
                        ]
                    ]
                    ( [ D.option
                          [ DA.value_ mempty
                          , DA.selected $ "selected" <$ filter
                              (is (_Just <<< _Encounters <<< _Nothing))
                              route
                          , DA.unset @"selected" $ filter
                              (isn't (_Just <<< _Encounters <<< _Nothing))
                              route
                          ]
                          [ D.text_ "Select encounter" ]
                      ] <>
                        ( keys encs # foldMap \e ->
                            let
                              prs = _Just <<< _Encounters <<< _Just <<< filtered
                                (eq e)
                            in
                              [ D.option
                                  [ DA.value_ $ e ^. simple _Newtype
                                  , DA.selected $ "selected" <$ filter (is prs)
                                      route
                                  , DA.unset @"selected" $ filter (isn't prs)
                                      route
                                  ]
                                  [ D.text_ $ e ^. simple _Newtype ]
                              ]
                        )
                    )
                ]

            , D.div
                [ css_ [ "flex", "grow", "overflow-hidden", "gap-2" ] ]
                [ D.div
                    [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
                    [ guard
                        ( not $ null $
                            enc
                              ^:: _Just
                              <<< simple _Newtype
                              <<< to _.notes
                              <<< traversed
                        ) $
                        D.div
                          [ css_
                              [ "flex"
                              , "flex-col"
                              , "shrink-0"
                              , "p-2"
                              , "gap-1"
                              , "border"
                              , "border-solid"
                              , "border-rounded-sm"
                              , "border-sky-800"
                              ]
                          ]
                          [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Notes:" ]
                          , D.div []
                              [ enc
                                  ^. _Just
                                    <<< simple _Newtype
                                    <<< to _.notes
                                    <<< _Just
                                    <<< to D.text_
                              ]
                          ]

                    , D.div
                        [ css_
                            [ "flex"
                            , "flex-col"
                            , "overflow-hidden"
                            , "p-2"
                            , "gap-1"
                            , "border"
                            , "border-solid"
                            , "border-rounded-sm"
                            , "border-sky-800"
                            ]
                        ]
                        [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Foes:" ]
                        , D.div
                            [ css_ [ "flex", "gap-2", "overflow-hidden" ] ]
                            ( enc
                                ^:: _Just
                                <<< simple _Newtype
                                <<< to _.foes
                                <<< traversed
                                <<< to (renderFoeEntry icon_)
                            )
                        ]

                    , guard
                        ( not $ null $
                            enc
                              ^:: _Just
                              <<< simple _Newtype
                              <<< to _.reserves
                              <<< traversed
                        ) $
                        D.div
                          [ css_
                              [ "flex"
                              , "flex-col"
                              , "overflow-hidden"
                              , "p-2"
                              , "gap-1"
                              , "border"
                              , "border-solid"
                              , "border-rounded-sm"
                              , "border-sky-800"
                              ]
                          ]
                          [ D.h3
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "Reserves:" ]
                          , D.div
                              [ css_ [ "flex", "gap-2", "overflow-hidden" ] ]
                              ( enc
                                  ^:: _Just
                                  <<< simple _Newtype
                                  <<< to _.reserves
                                  <<< traversed
                                  <<< to (renderFoeEntry icon_)
                              )
                          ]
                    ]
                ]
            ]

renderFoeEntry :: Icon -> FoeEntry -> Nut
renderFoeEntry icon@{ colours, factions, foes, foeClasses } (FoeEntry fe) =
  foes
    ^. traversed
      <<< filtered (view _name >>> eq fe.name)
      <<< to case _ of
        Foe f ->
          let
            fef = factions
              ^? traversed
                <<< filtered (preview _name >>> eq fe.faction)
            fet = foeClasses
              ^? traversed
                <<< filtered (preview _name >>> eq fe.template)
            ff = factions
              ^? traversed
                <<< filtered (preview _name >>> eq f.faction)
            cls = foeClasses
              ^? traversed
                <<< filtered (view _name >>> eq f.class)
            trs =
              foldMap (unwrap >>> _.traits) fet
                <> foldMap (unwrap >>> _.traits) cls
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) fef
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) ff
                <> f.traits
            abs =
              foldMap (unwrap >>> _.abilities) fet
                <> foldMap (unwrap >>> _.abilities) cls
                <> f.abilities
          in
            D.div
              [ css_ [ "flex", "flex-col", "flex-1", "overflow-hidden" ] ]
              [ D.div
                  [ css_
                      [ "flex"
                      , "justify-between"
                      , "bg-stone-500"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      ]
                  ]
                  [ D.div
                      [ css_ [ "flex", "gap-x-1" ] ]
                      [ fe.template # foldMap \(Name tn) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ tn ]
                      , fef # foldMap \(Faction fef_) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ $ fef_.name ^. simple _Newtype ]
                      , D.span
                          [ css_ [ "text-white", "font-bold" ]
                          , DA.style_ $ fromMaybe "" $ renderedInline $ render
                              =<<
                                backgroundColor <$> colours
                                  ^? traversed
                                    <<< filtered (view _name >>> eq f.colour)
                                    <<< _value
                          ]
                          [ D.text_ $ f.name ^. simple _Newtype
                          ]
                      , D.span
                          [ css_ [ "font-bold" ] ]
                          [ D.text_ $ "x" <> show fe.count ]
                      ]
                  , fe.alias # foldMap \fa ->
                      D.span
                        [ css_ [ "mx-2", "italic" ] ]
                        [ D.text_ fa ]
                  ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ trs <#> \(FoeTrait ft) ->
                          D.div []
                            [ D.div
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ $ unwrap ft.name ]
                            , markup icon ft.description
                            ]
                  , guard (not $ null trs) hr
                  , D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ abs <#> renderAbility icon
                  ]
              ]

        Mob f ->
          let
            fef = factions
              ^? traversed
                <<< filtered (preview _name >>> eq fe.faction)
            fet = foeClasses
              ^? traversed
                <<< filtered (preview _name >>> eq fe.template)
            ff = factions
              ^? traversed
                <<< filtered (preview _name >>> eq f.faction)
            cls = foeClasses
              ^? traversed
                <<< filtered (view _name >>> eq f.class)
            trs =
              foldMap (unwrap >>> _.traits) fet
                <> foldMap (unwrap >>> _.traits) cls
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) fef
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) ff
                <> f.traits
            abs =
              foldMap (unwrap >>> _.abilities) fet
                <> foldMap (unwrap >>> _.abilities) cls
                <> f.abilities
          in
            D.div
              [ css_ [ "flex", "flex-col", "flex-1", "overflow-hidden" ] ]
              [ D.div
                  [ css_
                      [ "flex"
                      , "justify-between"
                      , "bg-stone-500"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      ]
                  ]
                  [ D.div
                      [ css_ [ "flex", "gap-x-1" ] ]
                      [ fe.template # foldMap \(Name tn) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ tn ]
                      , fef # foldMap \(Faction fef_) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ $ fef_.name ^. simple _Newtype ]
                      , D.span
                          [ css_ [ "text-white", "font-bold" ]
                          , DA.style_ $ fromMaybe "" $ renderedInline $ render
                              =<<
                                backgroundColor <$> colours
                                  ^? traversed
                                    <<< filtered (view _name >>> eq f.colour)
                                    <<< _value
                          ]
                          [ D.text_ $ f.name ^. simple _Newtype ]
                      ]
                  , fe.alias # foldMap \fa ->
                      D.span
                        [ css_ [ "mx-2", "italic" ] ]
                        [ D.text_ fa ]
                  ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ trs <#> \(FoeTrait ft) ->
                          D.div []
                            [ D.div
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ $ unwrap ft.name ]
                            , markup icon ft.description
                            ]
                  , guard (not $ null trs) hr
                  , D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ abs <#> renderAbility icon
                  ]
              ]

        Elite f ->
          let
            fef = factions
              ^? traversed
                <<< filtered (preview _name >>> eq fe.faction)
            fet = foeClasses
              ^? traversed
                <<< filtered (preview _name >>> eq fe.template)
            ff = factions
              ^? traversed
                <<< filtered (preview _name >>> eq f.faction)
            cls = foeClasses
              ^? traversed
                <<< filtered (view _name >>> eq f.class)
            el = foeClasses
              ^? traversed
                <<< filtered (view _name >>> eq (Name "Elite"))
            trs =
              foldMap (unwrap >>> _.traits) el
                <> foldMap (unwrap >>> _.traits) fet
                <> foldMap (unwrap >>> _.traits) cls
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) fef
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) ff
                <> f.traits
            abs =
              foldMap (unwrap >>> _.abilities) fet
                <> foldMap (unwrap >>> _.abilities) cls
                <> f.abilities
          in
            D.div
              [ css_ [ "flex", "flex-col", "flex-1", "overflow-hidden" ] ]
              [ D.div
                  [ css_
                      [ "flex"
                      , "justify-between"
                      , "bg-stone-500"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      ]
                  ]
                  [ D.div
                      [ css_ [ "flex", "gap-x-1" ] ]
                      [ fe.template # foldMap \(Name tn) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<< backgroundColor <$> colours
                                  ^? traversed
                                    <<< filtered
                                      (view _name >>> eq (Name "Purple"))
                                    <<< _value
                            ]
                            [ D.text_ tn ]
                      , fef # foldMap \(Faction fef_) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ $ fef_.name ^. simple _Newtype ]
                      , D.span
                          [ css_ [ "text-white", "font-bold" ]
                          , DA.style_ $ fromMaybe "" $ renderedInline $ render
                              =<<
                                backgroundColor <$> colours
                                  ^? traversed
                                    <<< filtered (view _name >>> eq f.colour)
                                    <<< _value
                          ]
                          [ D.text_ $ f.name ^. simple _Newtype ]
                      , D.span
                          [ css_ [ "font-bold" ] ]
                          [ D.text_ $ "x" <> show fe.count ]
                      ]
                  , fe.alias # foldMap \fa ->
                      D.span
                        [ css_ [ "mx-2", "italic" ] ]
                        [ D.text_ fa ]
                  ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ trs <#> \(FoeTrait ft) ->
                          D.div []
                            [ D.div
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ $ unwrap ft.name ]
                            , markup icon ft.description
                            ]
                  , guard (not $ null trs) hr
                  , D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ abs <#> renderAbility icon
                  ]
              ]

        Legend f ->
          let
            fef = factions
              ^? traversed
                <<< filtered (preview _name >>> eq fe.faction)
            fet = foeClasses
              ^? traversed
                <<< filtered (preview _name >>> eq fe.template)
            ff = factions
              ^? traversed
                <<< filtered (preview _name >>> eq f.faction)
            cls = foeClasses
              ^? traversed
                <<< filtered (view _name >>> eq f.class)
            trs =
              foldMap (unwrap >>> _.traits) fet
                <> foldMap (unwrap >>> _.traits) cls
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) fef
                <> foldMap (unwrap >>> _.mechanic >>> wrap >>> pure) ff
                <> f.traits
            ras =
              foldMap (unwrap >>> _.roundActions) fet
                <> foldMap (unwrap >>> _.roundActions) cls
                <> f.roundActions
          in
            D.div
              [ css_ [ "flex", "flex-col", "flex-1", "overflow-hidden" ] ]
              [ D.div
                  [ css_
                      [ "flex"
                      , "justify-between"
                      , "bg-stone-500"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      ]
                  ]
                  [ D.div
                      [ css_ [ "flex", "gap-x-1" ] ]
                      [ fe.template # foldMap \(Name tn) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ tn ]
                      , fef # foldMap \(Faction fef_) ->
                          D.span
                            [ css_ [ "text-white", "font-bold" ]
                            , DA.style_ $ fromMaybe "" $ renderedInline $ render
                                =<<
                                  backgroundColor <$> colours
                                    ^? traversed
                                      <<< filtered
                                        (view _name >>> eq (Name "Purple"))
                                      <<< _value
                            ]
                            [ D.text_ $ fef_.name ^. simple _Newtype ]
                      , D.span
                          [ css_ [ "text-white", "font-bold" ]
                          , DA.style_ $ fromMaybe "" $ renderedInline $ render
                              =<<
                                backgroundColor <$> colours
                                  ^? traversed
                                    <<< filtered (view _name >>> eq f.colour)
                                    <<< _value
                          ]
                          [ D.text_ $ f.name ^. simple _Newtype
                          ]
                      , D.span
                          [ css_ [ "font-bold" ] ]
                          [ D.text_ $ "x" <> show fe.count ]
                      ]
                  , fe.alias # foldMap \fa ->
                      D.span
                        [ css_ [ "mx-2", "italic" ] ]
                        [ D.text_ fa ]
                  ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ trs <#> \(FoeTrait ft) ->
                          D.div []
                            [ D.div
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ $ unwrap ft.name ]
                            , markup icon ft.description
                            ]
                  , guard (not $ null trs) hr
                  , D.div
                      [ css_ [ "flex", "flex-col", "gap-2" ] ]
                      $ ras <#> \(FoeTrait ft) ->
                          D.div []
                            [ D.div
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ $ unwrap ft.name <> " (round action)"
                                ]
                            , markup icon ft.description
                            ]
                  , guard (not $ null ras) hr
                  , D.div
                      [ css_ [ "flex", "flex-col", "gap-2", "px-4" ] ]
                      [ D.h4 [ css_ [ "font-bold" ] ] [ D.text_ "Phases" ]
                      , D.div [] [ markup icon f.phases.description ]
                      , hr
                      , D.div
                          [ css_ [ "flex", "gap-2" ] ]
                          $ f.phases.details # mapWithIndex \i p ->
                              D.div []
                                [ D.div
                                    [ css_ [ "font-bold" ] ]
                                    [ D.text_ $ "Phase " <> show (i + 1) ]
                                , markup icon p.description
                                , guard (not $ null p.description) hr
                                , D.div
                                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                                    $ p.traits <#> \(FoeTrait ft) ->
                                        D.div []
                                          [ D.div
                                              [ css_ [ "font-bold" ] ]
                                              [ D.text_ $ unwrap ft.name ]
                                          , markup icon ft.description
                                          ]
                                , guard (not $ null p.traits) hr
                                , D.div
                                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                                    $ p.roundActions <#> \(FoeTrait ft) ->
                                        D.div []
                                          [ D.div
                                              [ css_ [ "font-bold" ] ]
                                              [ D.text_ $ unwrap ft.name <>
                                                  " (round action)"
                                              ]
                                          , markup icon ft.description
                                          ]
                                , guard (not $ null p.roundActions) hr
                                , D.div
                                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                                    $ p.abilities <#> renderAbility icon
                                ]
                      ]
                  ]
              ]

renderCost :: Action -> String
renderCost = case _ of
  Quick -> "Quick"
  One -> "1 action"
  Two -> "2 actions"
  Interrupt n -> "Interrupt " <> show n

renderTags :: Array Tag -> Array String
renderTags = map case _ of
  Attack -> "Attack"
  End -> "End"
  Close -> "Close"
  RangeTag r -> case r of
    Range i j -> "Range " <> show i <> "-" <> show j
    Melee -> "Melee"
    Adjacent -> "Adjacent"
  AreaTag p -> case p of
    Line n -> "Line " <> show n
    Arc n -> "Arc " <> show n
    Blast n -> "Blast " <> show n
    Burst n x -> "Burst " <> show n <> " ("
      <> (if x then "self" else "target")
      <> ")"
    Cross n -> "Cross " <> show n
  TargetTag t -> case t of
    AT.Self -> "Self"
    AT.Ally -> "Ally"
    AT.Foe -> "Foe"
    AT.Summon -> "Summon"
    AT.Space -> "Space"
    AT.Object -> "Object"
  KeywordTag k -> k ^. simple _Newtype
  LimitTag n l -> show n <> "/" <> l

renderAbility :: Icon -> FoeAbility -> Nut
renderAbility icon@{ colours } (FoeAbility fa) =
  D.div []
    [ D.div
        [ css_ [ "font-bold" ] ]
        [ D.text_ $ unwrap fa.name ]
    , D.div
        [ css_ [ "italic" ] ]
        [ D.text_ $ intercalate ", " $
            [ renderCost fa.cost ] <> renderTags fa.tags
        ]
    , markup icon fa.description
    , fa.chain # foldMap \fac ->
        D.ul
          [ css_ [ "ml-4", "list-disc" ] ]
          [ D.li [] [ renderAbility icon fac ] ]
    , fa.insert # foldMap case _ of
        AbilityInsert ai ->
          D.div
            [ css_ [ "ml-8" ] ]
            [ D.div
                [ css_
                    [ "flex"
                    , "gap-x-1"
                    , "bg-stone-500"
                    , "text-stone-800"
                    , "dark:bg-stone-700"
                    , "dark:text-stone-300"
                    ]
                ]
                [ D.span
                    [ css_ [ "text-white", "font-bold" ]
                    , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                        (backgroundColor <<< lighten 0.2) <$> colours
                          ^? traversed
                            <<< filtered (view _name >>> eq ai.colour)
                            <<< _value
                    ]
                    [ D.text_ $ unwrap ai.name ]
                ]
            , D.div
                [ css_ [ "italic" ] ]
                [ D.text_ $ intercalate ", " $
                    [ renderCost ai.cost ] <> renderTags ai.tags
                ]
            , D.div []
                [ D.ol
                    [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
                    $ ai.steps <#> renderStep icon
                ]
            ]

        SummonInsert si ->
          D.div
            [ css_ [ "ml-8" ] ]
            [ D.div
                [ css_
                    [ "flex"
                    , "gap-x-1"
                    , "bg-stone-500"
                    , "text-stone-800"
                    , "dark:bg-stone-700"
                    , "dark:text-stone-300"
                    ]
                ]
                [ D.span
                    [ css_ [ "text-white", "font-bold" ]
                    , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                        (backgroundColor <<< lighten 0.2) <$> colours
                          ^? traversed
                            <<< filtered (view _name >>> eq si.colour)
                            <<< _value
                    ]
                    [ D.text_ $ unwrap si.name ]
                ]
            , D.div
                [ css_ [ "italic" ] ]
                [ D.text_ $ "Summon (" <> show si.max <> ")" ]
            , D.div []
                [ D.ol
                    [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
                    $ si.effects <#> \eff ->
                        D.li []
                          [ D.span
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "Summon effect: " ]
                          , markup icon eff
                          ]
                ]
            ]
    ]
