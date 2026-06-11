module ToA.Page.Character.View
  ( viewCharacterPage
  ) where

import ToA.Prelude

import CSS (backgroundColor)

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

import Effect.Aff.Class (class MonadAff)

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.CSS (style)
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectAll)

import Routing.Duplex (print)

import Type.Proxy (Proxy(..))
import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Character (class Character, deleteChar)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon.Character
  ( Character
  , Level(..)
  , _build
  , _jobs
  , _level
  , _abilities
  , _active
  , _primary
  , _talents
  )
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Id (_id)
import ToA.Data.Icon.Name (Name, _name)
import ToA.Data.Icon.Trait (_trait)

import ToA.Data.Icon.Pc.Class (_basic, _defense, _hp, _move)
import ToA.Data.Icon.Pc.Job (_limitBreak)

import ToA.Component.Ability (renderAbility)
import ToA.Component.Character (exportCharacter)
import ToA.Component.Talent (renderTalent)
import ToA.Component.Trait (renderTrait)
import ToA.Util.Html (css, hr)
import ToA.Util.Optic ((^::))
import ToA.Util.Style as S

data Action
  = Receive (Connected Store Name)
  | Navigate Route (Maybe MouseEvent)
  | DeleteChar Character

viewCharacterPage
  :: ∀ q o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Character m
  => Navigate m
  => H.Component q Name o m
viewCharacterPage =
  connect selectAll $ H.mkComponent
    { initialState: \{ context, input } -> { env: context, pathChar: input }
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where

  act = case _ of
    Receive { context, input } ->
      H.modify_ _ { env = context, pathChar = input }
    Navigate r e -> navigate r e
    DeleteChar c -> do
      deleteChar c
      navigate (Characters Nothing) Nothing

  render
    { env:
        { characters
        , icon: icon@{ abilities, classes, colours, jobs, talents, traits }
        }
    , pathChar
    } =
    let
      char = characters ^. at pathChar

      job = jobs
        ^? traversed
          <. filtered
            (preview _name >>> eq (char ^? _Just <. _build <. _primary))

      cls = classes
        ^? traversed
          <. filtered (preview _name >>> eq (job ^? _Just <. _class))

      trs =
        traits
          ^:: traversed
          <. filtered
            ( preview _name >>>
                ( ( (\_ -> pure Zero /= (char ^? _Just <. _build <. _level))
                      && (eq (job ^? _Just <. _trait))
                  ) ||
                    (eq (cls ^? _Just <. _trait))
                )
            )

      tls =
        talents
          ^:: traversed
          <. filtered
            ( view _id >>> elem ~$
                (char ^:: _Just <. _build <. _talents <. traversed)
            )

      abs = sort
        $ abilities
        ^:: traversed
        <. filtered
          ( view _name >>> elem ~$
              (char ^. _Just <. _build <. _abilities <. _active)
          )

    in
      HD.div
        [ css [ "flex", "flex-col", "grow", "gap-2" ] ]
        [ HD.div
            [ css [ "flex", "items-center", "gap-x-2" ] ] $ join
            [ char # foldMap \c -> pure $
                HD.a
                  [ css
                      [ "px-2"
                      , "py-1"
                      , "rounded"
                      , "bg-stone-400"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      , "hover:bg-stone-500"
                      , "focus:bg-stone-500"
                      , "dark:hover:bg-stone-500"
                      , "dark:focus:bg-stone-500"
                      ]
                  , HP.href $ print routeCodec
                      (Characters $ Just $ CombatChar $ c ^. _name)
                  , HE.onClick $ Navigate
                      (Characters $ Just $ CombatChar $ c ^. _name) <<< pure
                  ]
                  [ HD.text "Combat" ]

            , char # foldMap \c -> pure $
                HD.h2
                  [ css [ "font-bold", "grow" ] ]
                  [ HD.text $ c ^. _name <<< _Newtype ]

            , char # foldMap \c -> pure $
                HD.button
                  [ css S.buttonDanger
                  , HE.onClick $ \_ -> DeleteChar c
                  ]
                  [ HD.text "Delete" ]

            , char # foldMap \c -> pure $
                HD.a
                  [ css
                      [ "px-2"
                      , "py-1"
                      , "rounded"
                      , "bg-stone-400"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      , "hover:bg-stone-500"
                      , "focus:bg-stone-500"
                      , "dark:hover:bg-stone-500"
                      , "dark:focus:bg-stone-500"
                      ]
                  , HP.href $ print routeCodec
                      (Characters $ Just $ EditChar $ c ^. _name)
                  , HE.onClick $ Navigate
                      (Characters $ Just $ EditChar $ c ^. _name)
                      <<< pure
                  ]
                  [ HD.text "Edit" ]

            , char # foldMap \c -> pure $
                HD.slot_
                  (Proxy :: _ "export")
                  unit
                  ( exportCharacter
                      []
                      [ "px-2"
                      , "py-1"
                      , "rounded"
                      , "bg-stone-400"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      , "hover:bg-stone-500"
                      , "focus:bg-stone-500"
                      , "dark:hover:bg-stone-500"
                      , "dark:focus:bg-stone-500"
                      ]
                      c
                  )
                  unit
            ]

        , HD.div
            [ css
                [ "flex"
                , "flex-col"
                , "sm:flex-row"
                , "overflow-hidden"
                , "gap-2"
                ]
            ]
            [ HD.div
                [ css
                    [ "flex"
                    , "flex-1"
                    , "sm:min-w-48"
                    , "sm:max-w-56"
                    , "overflow-y-auto"
                    , "p-2"
                    , "gap-2"
                    , "border"
                    , "border-solid"
                    , "border-rounded-sm"
                    , "border-sky-800"
                    ]
                ]
                [ HD.div
                    [ css [ "grow" ] ]
                    [ HD.div
                        [ css [ "w-max", "font-bold", "text-white" ]
                        , style $ fromMaybe (pure unit) $
                            backgroundColor
                            <$> colours
                            ^? traversed
                              <<< filtered
                                ( preview _name >>> eq
                                    (job ^? _Just <<< _colour)
                                )
                              <<< _value
                        ]
                        [ HD.text $ job ^. _Just <<< _name <<< _Newtype ]

                    , HD.div
                        [ css [ "w-max", "font-bold" ] ]
                        [ HD.text $ cls ^. _Just <<< _name <<< _Newtype ]

                    , hr

                    , HD.div
                        [ css [ "w-max" ] ]
                        [ HD.span
                            [ css [ "font-bold" ] ]
                            [ HD.text "Level " ]
                        , HD.span []
                            [ HD.text $ char
                                ^. _Just <<< _build <<< _level <<< to show
                            ]
                        ]

                    , HD.div
                        [ css [ "w-max" ] ] $ char
                        # (_Just <<< _build <<< _jobs <<< itraversed)
                            `ifoldMapOf` \n l -> pure $
                              HD.div []
                                [ HD.span
                                    [ css [ "font-bold" ] ]
                                    [ HD.text
                                        $ (n ^. simple _Newtype)
                                        <> " "
                                    ]
                                , HD.span [] [ HD.text $ show l ]
                                ]

                    , hr

                    , HD.div
                        [ css [ "w-max" ] ]
                        [ HD.span
                            [ css [ "font-bold" ] ]
                            [ HD.text "HP: " ]
                        , HD.span []
                            [ HD.text $ cls ^. _Just <<< _hp <<< to \hp ->
                                show hp
                                  <> " (25% HP: "
                                  <> show (hp / 4)
                                  <> ")"
                            ]
                        ]

                    , HD.div
                        [ css [ "w-max" ] ]
                        [ HD.span
                            [ css [ "font-bold" ] ]
                            [ HD.text "Defense: " ]
                        , HD.span []
                            [ HD.text $ cls ^. _Just <<< _defense <<< to show ]
                        ]

                    , HD.div
                        [ css [ "w-max" ] ]
                        [ HD.span
                            [ css [ "font-bold" ] ]
                            [ HD.text "Free Move: " ]
                        , HD.span []
                            [ HD.text $ cls ^. _Just <<< _move <<< to show ]
                        ]
                    ]
                ]

            , HD.div
                [ css [ "flex", "flex-3", "overflow-y-auto", "gap-2" ] ]
                [ HD.div
                    [ css
                        [ "flex"
                        , "flex-col"
                        , "lg:flex-row"
                        , "grow"
                        , "gap-2"
                        ]
                    ]
                    [ HD.div
                        [ css
                            [ "flex-1"
                            , "flex"
                            , "flex-col"
                            , "lg:overflow-y-auto"
                            , "p-2"
                            , "gap-x-2"
                            , "gap-y-4"
                            , "border"
                            , "border-solid"
                            , "border-rounded-sm"
                            , "border-sky-800"
                            ]
                        ]
                        [ HD.div
                            [ css
                                [ "grid"
                                , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                                , "gap-2"
                                ]
                            ]
                            $ trs
                            <#> renderTrait icon

                        , HD.div
                            [ css
                                [ "grid"
                                , "grid-cols-[repeat(auto-fit,minmax(100px,1fr))]"
                                , "gap-2"
                                ]
                            ]
                            $ tls
                            <#> renderTalent icon

                        , HD.div
                            [ css
                                [ "grid"
                                , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                                , "gap-2"
                                ]
                            ] $ join
                            [ [ HD.div
                                  [ css [ "flex", "gap-x-2" ] ]
                                  $
                                    abilities
                                  ^:: traversed
                                  <<< filtered
                                    ( preview _name >>> eq
                                        (cls ^? _Just <<< _basic)
                                    )
                                  <<< to (renderAbility icon)
                              ]

                            , guard
                                ( char # hasn't
                                    ( _Just <<< _build <<< _level <<< only
                                        Zero
                                    )
                                )
                                $ pure
                                $ HD.div [ css [ "flex", "gap-x-2" ] ]
                                $
                                  abilities
                                ^:: traversed
                                <<< filtered
                                  ( preview _name >>>
                                      eq (job ^? _Just <<< _limitBreak)
                                  )
                                <<< to (renderAbility icon)
                            ]
                        ]

                    , HD.div
                        [ css
                            [ "flex-2"
                            , "grid"
                            , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
                            , "lg:overflow-y-auto"
                            , "p-2"
                            , "gap-x-2"
                            , "gap-y-6"
                            , "border"
                            , "border-solid"
                            , "border-rounded-sm"
                            , "border-sky-800"
                            ]
                        ]
                        $ abs
                        <#> renderAbility icon
                    ]
                ]
            ]
        ]
