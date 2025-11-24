module ToA.Page.Characters
  ( charactersPage
  ) where

import Prelude
import PointFree ((~$))

import CSS (backgroundColor, color, render, renderedInline)

import Data.Filterable (filter)
import Data.Foldable (elem)
import Data.Lens
  ( (^.)
  , (^?)
  , _Just
  , _Nothing
  , filtered
  , hasn't
  , preview
  , to
  , traversed
  , view
  , ifoldMapOf
  )
import Data.Lens.Common (simple)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (is, isn't, only)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import ToA.Component.Ability (renderAbility)
import ToA.Component.Markup (markup)
import ToA.Data.Env (Env, _navigate)
import ToA.Data.Icon.Character
  ( Level(..)
  , _build
  , _jobs
  , _level
  , _prepared
  , _primaryJob
  , _talents
  )
import ToA.Data.Icon.Class (_basic, _class, _defense, _hp, _move)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Job (_limitBreak)
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), _Characters)
import ToA.Util.Html (css_, hr)
import ToA.Util.Optic ((#~), (^::))

charactersPage :: Env -> Maybe Name -> Nut
charactersPage env@{ characters, icon, route } pathChar =
  ((/\) <$> characters <*> icon)
    <#~>
      \(chars /\ icon_@{ abilities, classes, colours, jobs, talents, traits }) ->
        let
          char = chars
            ^? traversed
              <<< filtered (preview _name >>> eq pathChar)

          job = jobs
            ^? traversed
              <<< filtered
                ( preview _name >>> eq
                    (char ^? _Just <<< _build <<< _primaryJob)
                )

          cls = classes
            ^? traversed
              <<< filtered (preview _name >>> eq (job ^? _Just <<< _class))

          trs =
            traits
              ^:: traversed
              <<< filtered
                ( preview _name >>>
                    ( ( ( \_ -> pure Zero /=
                            (char ^? _Just <<< _build <<< _level)
                        )
                          && (eq (job ^? _Just <<< _trait))
                      ) ||
                        (eq (cls ^? _Just <<< _trait))
                    )
                )

          tls =
            talents
              ^:: traversed
              <<< filtered
                ( view _name >>> elem ~$
                    (char ^:: _Just <<< _build <<< _talents <<< traversed)
                )

        in
          D.div
            [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
            [ D.select
                [ DL.selectOn_ DL.change $ \c ->
                    (env ^. _navigate)
                      ( Characters $
                          if c == mempty then Nothing else pure (Name c)
                      )
                      Nothing
                ]
                ( [ D.option
                      [ DA.value_ mempty
                      , DA.selected $ "selected" <$ filter
                          (is (_Just <<< _Characters <<< _Nothing))
                          route
                      , DA.unset @"selected" $ filter
                          (isn't (_Just <<< _Characters <<< _Nothing))
                          route
                      ]
                      [ D.text_ "Select charater" ]
                  ] <>
                    ( chars <#> \c ->
                        let
                          prs = _Just <<< _Characters <<< _Just <<< filtered
                            (eq (c ^. _name))
                        in
                          D.option
                            [ DA.value_ $ c ^. _name <<< _Newtype
                            , DA.selected $ "selected" <$ filter (is prs) route
                            , DA.unset @"selected" $ filter (isn't prs) route
                            ]
                            [ D.text_ $ c ^. _name <<< _Newtype ]
                    )
                )

            , D.div
                [ css_ [ "flex", "grow", "overflow-hidden", "gap-2" ] ]
                [ D.div
                    [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
                    [ D.div
                        [ css_
                            [ "flex"
                            , "basis-1/2"
                            , "overflow-hidden"
                            , "p-2"
                            , "gap-2"
                            , "border"
                            , "border-solid"
                            , "border-rounded-sm"
                            , "border-sky-800"
                            ]
                        ]
                        [ D.div
                            [ css_ [ "w-max" ] ]
                            [ D.div
                                [ css_ [ "w-max", "font-bold", "text-white" ]
                                , DA.style_ $ fromMaybe "" $ renderedInline $
                                    render =<<
                                      backgroundColor <$> colours
                                        ^? traversed
                                          <<< filtered
                                            ( preview _name >>> eq
                                                (job ^? _Just <<< _colour)
                                            )
                                          <<< _value
                                ]
                                [ D.text_ $ job ^. _Just <<< _name <<< _Newtype
                                ]
                            , D.div
                                [ css_ [ "w-max", "font-bold" ] ]
                                [ D.text_ $ cls ^. _Just <<< _name <<< _Newtype
                                ]

                            , hr

                            , D.div []
                                [ D.div
                                    [ css_ [ "w-max" ] ]
                                    [ D.span
                                        [ css_ [ "font-bold" ] ]
                                        [ D.text_ "Level " ]
                                    , D.span []
                                        [ D.text_ $ char
                                            ^. _Just
                                              <<< _build
                                              <<< _level
                                              <<< to show
                                        ]
                                    ]
                                , D.div
                                    [ css_ [ "w-max" ] ] $ char
                                    #
                                      ( _Just
                                          <<< _build
                                          <<< _jobs
                                          <<< itraversed
                                      )
                                        `ifoldMapOf` \n l -> pure $
                                          D.div []
                                            [ D.span
                                                [ css_ [ "font-bold" ] ]
                                                [ D.text_ $
                                                    (n ^. simple _Newtype)
                                                      <> " "
                                                ]
                                            , D.span [] [ D.text_ $ show l ]
                                            ]

                                , hr

                                , D.div
                                    [ css_ [ "w-max" ] ]
                                    [ D.span
                                        [ css_ [ "font-bold" ] ]
                                        [ D.text_ "HP: " ]
                                    , D.span []
                                        [ D.text_ $ cls ^. _Just <<< _hp <<< to
                                            \hp ->
                                              show hp
                                                <> " (25% HP: "
                                                <> show (hp / 4)
                                                <> ")"
                                        ]
                                    ]

                                , D.div
                                    [ css_ [ "w-max" ] ]
                                    [ D.span
                                        [ css_ [ "font-bold" ] ]
                                        [ D.text_ "Defense: " ]
                                    , D.span []
                                        [ D.text_ $ cls ^. _Just <<< _defense
                                            <<<
                                              to show
                                        ]
                                    ]

                                , D.div
                                    [ css_ [ "w-max" ] ]
                                    [ D.span
                                        [ css_ [ "font-bold" ] ]
                                        [ D.text_ "Free Move: " ]
                                    , D.span []
                                        [ D.text_ $ cls ^. _Just <<< _move <<<
                                            to
                                              show
                                        ]
                                    ]
                                ]
                            ]

                        , D.div
                            [ css_ [ "flex", "gap-x-2" ] ]
                            $ trs ^:: traversed <<< to \t ->
                                D.div
                                  [ css_ [ "flex-1", "overflow-scroll" ] ]
                                  [ D.div
                                      [ css_ [ "font-bold" ] ]
                                      [ D.text_ $ t ^. _name <<< _Newtype ]
                                  , t # _desc #~ markup icon_
                                  ]

                        , D.div
                            [ css_ [ "flex", "gap-x-2" ] ]
                            $ tls ^:: traversed <<< to \t ->
                                D.div
                                  [ css_ [ "flex-1", "overflow-scroll" ] ]
                                  [ D.div
                                      [ css_ [ "font-bold" ]
                                      , DA.style_ $ fromMaybe ""
                                          $ renderedInline
                                          $ render =<<
                                              color <$> colours
                                                ^? traversed
                                                  <<< filtered
                                                    ( view _name >>> eq
                                                        (t ^. _colour)
                                                    )
                                                  <<< _value
                                      ]
                                      [ D.text_ $ t ^. _name <<< _Newtype ]
                                  , t # _desc #~ markup icon_
                                  ]

                        , guard
                            ( char # hasn't
                                (_Just <<< _build <<< _level <<< only Zero)
                            )
                            $ D.div
                                [ css_ [ "flex", "gap-x-2" ] ]
                            $
                              abilities
                                ^:: traversed
                                <<< filtered
                                  ( preview _name >>>
                                      eq (job ^? _Just <<< _limitBreak)
                                  )
                                <<< to \a ->
                                  D.div
                                    [ css_ [ "flex-1", "overflow-scroll" ] ]
                                    [ renderAbility icon_ a ]
                        ]

                    , D.div
                        [ css_
                            [ "flex"
                            , "basis-1/2"
                            , "overflow-hidden"
                            , "p-2"
                            , "gap-x-2"
                            , "border"
                            , "border-solid"
                            , "border-rounded-sm"
                            , "border-sky-800"
                            ]
                        ]
                        ( ( abilities
                              ^:: traversed
                              <<< filtered
                                (preview _name >>> eq (cls ^? _Just <<< _basic))
                              <<< to \a ->
                                D.div
                                  [ css_ [ "flex-1", "overflow-scroll" ] ]
                                  [ renderAbility icon_ a ]
                          ) <>
                            ( abilities
                                ^:: traversed
                                <<< filtered
                                  ( view _name >>> elem ~$
                                      (char ^. _Just <<< _build <<< _prepared)
                                  )
                                <<< to \a ->
                                  D.div
                                    [ css_ [ "flex-1", "overflow-scroll" ] ]
                                    [ renderAbility icon_ a ]
                            )
                        )
                    ]
                ]
            ]
