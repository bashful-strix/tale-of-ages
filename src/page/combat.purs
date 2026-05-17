module ToA.Page.Combat
  ( combatPage
  ) where

import Prelude
import PointFree ((~$), (<..))

import CSS (color, render, renderedInline)

import Data.Array ((..), sort)
import Data.Foldable (elem, foldMap)
import Data.Int (floor)
import Data.Lens
  ( (^.)
  , (^?)
  , (.~)
  , (?~)
  , _Just
  , filtered
  , has
  , hasn't
  , preview
  , setJust
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
import ToA.Data.Env (Env, _navigate, _saveChar)
import ToA.Data.Icon.Character
  ( Character
  , Level(..)
  , _build
  , _level
  , _abilities
  , _active
  , _primary
  , _talents
  , _currentHp
  , _currentVigor
  , _currentPowerDice
  , _currentStatus
  )
import ToA.Data.Icon.Class (_basic, _class, _defense, _hp, _move)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Id (_id)
import ToA.Data.Icon.Job (_limitBreak)
import ToA.Data.Icon.Keyword (_category, _Status)
import ToA.Data.Icon.Name (Name, _name)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Util.Html (css_, hr)
import ToA.Util.Optic ((#~), (^::))

combatPage :: Env -> Maybe Name -> Nut
combatPage env@{ characters, icon } pathChar = ((/\) <$> characters <*> icon)
  <#~>
    \( chars /\
         icon_@
           { abilities, classes, colours, jobs, keywords, talents, traits }
     ) ->
      let
        char = pathChar >>= \c -> chars ^. at c

        job = jobs
          ^? traversed
            <<< filtered
              (preview _name >>> eq (char ^? _Just <<< _build <<< _primary))

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
                  D.h2 [] [ D.text_ $ c ^. _name <<< _Newtype ]

              , char # foldMap \c ->
                  D.a
                    [ DA.href_ $ print routeCodec
                        (Characters $ ViewChar $ c ^? _name)
                    , DL.click_ $
                        (env ^. _navigate)
                          (Characters $ ViewChar $ c ^? _name) <<<
                          pure
                    , css_
                        [ "px-2"
                        , "py-1"
                        , "border"
                        , "border-solid"
                        , "border-stone-700"
                        ]
                    ]
                    [ D.text_ "View" ]
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
                          [ css_ [ "flex", "justify-between" ] ]
                          [ D.span
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "HP: " ]

                          , D.div
                              [ css_ [ "flex" ] ] $ char # foldMap \c ->
                              [ D.input
                                  [ css_
                                      [ "bg-stone-500"
                                      , "text-stone-800"
                                      , "dark:bg-stone-700"
                                      , "dark:text-stone-300"
                                      ]
                                  , DA.xtypeNumber
                                  , DA.min_ "0"
                                  , DA.max_ $
                                      cls ^. _Just <<< _hp <<< to show
                                  , DA.value_ $ c ^. _currentHp <<< to show
                                  , DL.numberOn_ DL.change $ floor >>> \n ->
                                      (env ^. _saveChar) (c # _currentHp .~ n)
                                  ]
                                  []
                              , D.div
                                  [ css_ [ "min-w-8", "text-right" ] ]
                                  [ D.text_ $ "/ " <>
                                      cls ^. _Just <<< _hp <<< to show
                                  ]
                              ]
                          ]

                      , D.div
                          [ css_ [ "flex", "justify-between" ] ]
                          [ D.span
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "Vigor: " ]
                          , D.div
                              [ css_ [ "flex" ] ] $ char # foldMap \c ->
                              [ D.input
                                  [ css_
                                      [ "bg-stone-500"
                                      , "text-stone-800"
                                      , "dark:bg-stone-700"
                                      , "dark:text-stone-300"
                                      ]
                                  , DA.xtypeNumber
                                  , DA.min_ "0"
                                  , DA.max_ "99"
                                  , DA.value_ $ c ^. _currentVigor <<< to show
                                  , DL.numberOn_ DL.change $ floor >>> \n ->
                                      (env ^. _saveChar)
                                        (c # _currentVigor .~ n)
                                  ]
                                  []
                              , D.div
                                  [ css_ [ "min-w-8", "text-right" ] ]
                                  [ D.text_ $ "/ " <>
                                      cls ^. _Just <<< _hp <<< to
                                        (show <<< (_ / 4))
                                  ]
                              ]
                          ]

                      , hr

                      , D.div
                          [ css_ [ "w-max" ] ]
                          [ D.span
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "Defense: " ]
                          , D.span []
                              [ D.text_ $ cls ^. _Just <<< _defense
                                  <<< to show
                              ]
                          ]

                      , D.div
                          [ css_ [ "w-max" ] ]
                          [ D.span
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "Free Move: " ]
                          , D.span []
                              [ D.text_ $ cls ^. _Just <<< _move <<<
                                  to show
                              ]
                          ]

                      , hr

                      , D.div
                          [ css_
                              [ "flex"
                              , "flex-col"
                              , "w-full"
                              , "overflow-hidden"
                              ]
                          ] $ char # foldMap \c ->
                          keywords
                            ^:: traversed
                            <<< filtered (has (_category <<< _Status))
                            <<< to \k -> renderStatus env c (k ^. _name) 3

                      , hr

                      , D.div
                          [ css_
                              [ "flex"
                              , "flex-col"
                              , "w-full"
                              , "overflow-hidden"
                              ]
                          ] $
                          [ D.div
                              [ css_ [ "font-bold" ] ]
                              [ D.text_ "Power Dice" ]
                          ] <>
                            ( char # foldMap \c ->
                                ( c # (_currentPowerDice <<< itraversed)
                                    `ifoldMapOf`
                                      (pure <.. renderPowerDie env c)
                                ) <>
                                  [ D.div
                                      [ css_
                                          [ "w-full"
                                          , "flex"
                                          , "justify-center"
                                          ]
                                      ]
                                      [ D.button
                                          [ DL.runOn_ DL.click $
                                              (env ^. _saveChar)
                                                ( c #
                                                    _currentPowerDice <<< at ""
                                                      ?~ 0
                                                )
                                          ]
                                          [ D.text_ "+" ]
                                      ]
                                  ]
                            )
                      ]
                  ]

              , D.div
                  [ css_ [ "flex", "flex-3", "overflow-scroll", "gap-2" ] ]
                  [ D.div
                      [ css_
                          [ "flex", "flex-col", "lg:flex-row", "grow", "gap-2" ]
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
                              $ trs ^:: traversed <<< to \t ->
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

renderStatus :: Env -> Character -> Name -> Int -> Nut
renderStatus _ _ _ max | max <= 0 = D.div [] []
renderStatus env char status max =
  let
    n = char ^. _currentStatus <<< at status <<< to (fromMaybe 0)
    setStatus = (env ^. _saveChar) <<<
      (setJust (_currentStatus <<< at status) ~$ char)
  in
    D.div
      [ css_ [ "w-full", "flex", "justify-between" ] ]
      [ D.div [] [ D.text_ $ status ^. simple _Newtype ]
      , D.div
          [ css_ [ "space-x-1" ] ]
          $ (1 .. max) <#> \x ->
              D.button
                [ css_
                    [ "rounded"
                    , "size-[1em]"
                    , if n >= x then "bg-sky-600"
                      else "bg-stone-500 dark:bg-stone-700"
                    ]
                , DL.runOn_ DL.click $
                    setStatus if n == x then x - 1 else x
                ]
                []
      ]

renderPowerDie :: Env -> Character -> String -> Int -> Nut
renderPowerDie env char name n =
  D.div
    [ css_ [ "flex", "flex-col", "my-2" ] ]
    [ D.div
        [ css_ [ "flex", "justify-between" ] ]
        [ D.input
            [ css_
                [ "bg-stone-500"
                , "text-stone-800"
                , "dark:bg-stone-700"
                , "dark:text-stone-300"
                ]
            , DA.value_ name
            , DL.valueOn_ DL.change $ \value -> (env ^. _saveChar)
                ( char
                    # _currentPowerDice <<< at name .~ Nothing
                    # _currentPowerDice <<< at value ?~ n
                )
            ]
            []
        , D.button
            [ DL.runOn_ DL.click $ (env ^. _saveChar)
                (char # _currentPowerDice <<< at name .~ Nothing)
            ]
            [ D.text_ "-" ]
        ]

    , D.div
        [ css_ [ "mt-1", "space-x-1" ] ]
        $ (1 .. 6) <#> \x ->
            D.button
              [ css_
                  [ "rounded"
                  , "size-[1em]"
                  , if n >= x then "bg-sky-600"
                    else "bg-stone-500 dark:bg-stone-700"
                  ]
              , DL.runOn_ DL.click $ (env ^. _saveChar)
                  ( char # _currentPowerDice <<< at name ?~
                      if n == x then x - 1 else x
                  )
              ]
              []
    ]
