module ToA.Page.ViewCharacter
  ( viewCharacterPage
  ) where

import Prelude
import PointFree ((~$))

import CSS (backgroundColor, color, render, renderedInline)

import Data.Array (sort)
import Data.Foldable (elem, foldMap)
import Data.Lens
  ( (^.)
  , (^?)
  , _Just
  , filtered
  , hasn't
  , preview
  , to
  , traversed
  , view
  , ifoldMapOf
  )
import Data.Lens.At (at)
import Data.Lens.Common (simple)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (only)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import Routing.Duplex (print)

import ToA.Component.Ability (renderAbility)
import ToA.Component.Markup (markup)
import ToA.Data.Env (Env, _deleteChar, _navigate)
import ToA.Data.Icon.Character
  ( Level(..)
  , _build
  , _jobs
  , _level
  , _abilities
  , _active
  , _primary
  , _talents
  )
import ToA.Data.Icon.Class (_basic, _class, _defense, _hp, _move)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Id (_id)
import ToA.Data.Icon.Job (_limitBreak)
import ToA.Data.Icon.Name (Name, _name)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Util.Html (css_, hr)
import ToA.Util.Optic ((#~), (^::))

viewCharacterPage :: Env -> Name -> Nut
viewCharacterPage env@{ characters, icon } pathChar =
  ((/\) <$> characters <*> icon)
    <#~>
      \(chars /\ icon_@{ abilities, classes, colours, jobs, talents, traits }) ->
        let
          char = chars ^. at pathChar

          job = jobs
            ^? traversed
              <<< filtered
                ( preview _name >>> eq
                    (char ^? _Just <<< _build <<< _primary)
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
                ( view _id >>> elem ~$
                    (char ^:: _Just <<< _build <<< _talents <<< traversed)
                )

          abs = sort $
            abilities
              ^:: traversed
              <<< filtered
                ( view _name >>> elem ~$
                    (char ^. _Just <<< _build <<< _abilities <<< _active)
                )

        in
          D.div
            [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
            [ D.div
                [ css_ [ "flex", "items-center", "justify-between", "gap-x-2" ] ]
                [ char # foldMap \c ->
                    D.a
                      [ DA.href_ $ print routeCodec
                          (Characters $ Just $ CombatChar $ c ^. _name)
                      , DL.click_ $
                          (env ^. _navigate)
                            (Characters $ Just $ CombatChar $ c ^. _name) <<<
                            pure
                      , css_
                          [ "px-2"
                          , "py-1"
                          , "border"
                          , "border-solid"
                          , "border-stone-700"
                          ]
                      ]
                      [ D.text_ "Combat" ]

                , char # foldMap \c ->
                    D.h2
                      [ css_ [ "font-bold", "grow" ] ]
                      [ D.text_ $ c ^. _name <<< _Newtype ]


                , char # foldMap \c ->
                    D.button
                      [ DL.runOn_ DL.click $ do
                          c # env ^. _deleteChar
                          (env ^. _navigate) (Characters Nothing)
                            Nothing
                      , css_
                          [ "px-2"
                          , "py-1"
                          , "border"
                          , "border-solid"
                          , "border-stone-700"
                          ]
                      ]
                      [ D.text_ "Delete" ]

                , char # foldMap \c ->
                    D.a
                      [ DA.href_ $ print routeCodec
                          (Characters $ Just $ EditChar $ c ^. _name)
                      , DL.click_ $
                          (env ^. _navigate)
                            (Characters $ Just $ EditChar $ c ^. _name)
                            <<< pure
                      , css_
                          [ "px-2"
                          , "py-1"
                          , "border"
                          , "border-solid"
                          , "border-stone-700"
                          ]
                      ]
                      [ D.text_ "Edit" ]
                ]

            , D.div
                [ css_
                    [ "flex"
                    , "flex-col"
                    , "sm:flex-row"
                    , "overflow-hidden"
                    , "gap-2"
                    ]
                ]
                [ D.div
                    [ css_
                        [ "flex"
                        , "flex-1"
                        , "sm:min-w-48"
                        , "sm:max-w-56"
                        , "overflow-scroll"
                        , "p-2"
                        , "gap-2"
                        , "border"
                        , "border-solid"
                        , "border-rounded-sm"
                        , "border-sky-800"
                        ]
                    ]
                    [ D.div
                        [ css_ [ "grow" ] ]
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
                            [ D.text_ $ job ^. _Just <<< _name <<< _Newtype ]

                        , D.div
                            [ css_ [ "w-max", "font-bold" ] ]
                            [ D.text_ $ cls ^. _Just <<< _name <<< _Newtype ]

                        , hr

                        , D.div
                            [ css_ [ "w-max" ] ]
                            [ D.span
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ "Level " ]
                            , D.span []
                                [ D.text_ $ char
                                    ^. _Just <<< _build <<< _level <<< to show
                                ]
                            ]

                        , D.div
                            [ css_ [ "w-max" ] ] $ char
                            # (_Just <<< _build <<< _jobs <<< itraversed)
                                `ifoldMapOf` \n l -> pure $
                                  D.div []
                                    [ D.span
                                        [ css_ [ "font-bold" ] ]
                                        [ D.text_ $
                                            (n ^. simple _Newtype) <> " "
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
                                [ D.text_ $ cls ^. _Just <<< _hp <<< to \hp ->
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
                                [ D.text_ $
                                    cls ^. _Just <<< _defense <<< to show
                                ]
                            ]

                        , D.div
                            [ css_ [ "w-max" ] ]
                            [ D.span
                                [ css_ [ "font-bold" ] ]
                                [ D.text_ "Free Move: " ]
                            , D.span []
                                [ D.text_ $
                                    cls ^. _Just <<< _move <<< to show
                                ]
                            ]
                        ]
                    ]

                , D.div
                    [ css_ [ "flex", "flex-3", "overflow-scroll", "gap-2" ] ]
                    [ D.div
                        [ css_
                            [ "flex"
                            , "flex-col"
                            , "lg:flex-row"
                            , "grow"
                            , "gap-2"
                            ]
                        ]
                        [ D.div
                            [ css_
                                [ "flex-1"
                                , "flex"
                                , "flex-col"
                                , "lg:overflow-scroll"
                                , "p-2"
                                , "gap-x-2"
                                , "gap-y-4"
                                , "border"
                                , "border-solid"
                                , "border-rounded-sm"
                                , "border-sky-800"
                                ]
                            ]
                            [ D.div
                                [ css_
                                    [ "grid"
                                    , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                                    , "gap-2"
                                    ]
                                ]
                                $ trs <#> \t ->
                                    D.div
                                      []
                                      [ D.div
                                          [ css_ [ "font-bold" ] ]
                                          [ D.text_ $ t ^. _name <<< _Newtype ]
                                      , t # _desc #~ markup icon_
                                      ]

                            , D.div
                                [ css_
                                    [ "grid"
                                    , "grid-cols-[repeat(auto-fit,minmax(100px,1fr))]"
                                    , "gap-2"
                                    ]
                                ]
                                $ tls <#> \t ->
                                    D.div
                                      []
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

                            , D.div
                                [ css_
                                    [ "grid"
                                    , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                                    , "gap-2"
                                    ]
                                ]
                                [ D.div
                                    [ css_ [ "flex", "gap-x-2" ] ]
                                    $
                                      abilities
                                        ^:: traversed
                                        <<< filtered
                                          ( preview _name >>> eq
                                              (cls ^? _Just <<< _basic)
                                          )
                                        <<< to (renderAbility icon_)

                                , guard
                                    ( char # hasn't
                                        ( _Just <<< _build <<< _level <<< only
                                            Zero
                                        )
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
                                        <<< to (renderAbility icon_)
                                ]
                            ]

                        , D.div
                            [ css_
                                [ "flex-2"
                                , "grid"
                                , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
                                , "lg:overflow-scroll"
                                , "p-2"
                                , "gap-x-2"
                                , "gap-y-6"
                                , "border"
                                , "border-solid"
                                , "border-rounded-sm"
                                , "border-sky-800"
                                ]
                            ]
                            $ abs <#> renderAbility icon_
                        ]
                    ]
                ]
            ]
