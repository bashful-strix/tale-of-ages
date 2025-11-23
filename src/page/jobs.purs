module ToA.Page.Jobs
  ( jobsPage
  ) where

import Prelude
import PointFree ((~$))

import Color (lighten)
import CSS (backgroundColor, color, render, renderedInline)

import Data.Filterable (filter)
import Data.Foldable (elem)
import Data.Lens
  ( (^.)
  , (^?)
  , (.~)
  , preview
  , view
  , elemOf
  , filtered
  , has
  , only
  , to
  , traversed
  , _Just
  )
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import FRP.Poll (Poll)

import ToA.Component.Ability (renderAbility)
import ToA.Component.Markup (markup, printMarkup)
import ToA.Data.Env (Env, _navigate)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability (Step(..), _steps)
import ToA.Data.Icon.Class
  ( _apprentice
  , _basic
  , _class
  , _complexity
  , _defense
  , _hp
  , _keywords
  , _move
  , _strengths
  , _tagline
  , _weaknesses
  )
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Job
  ( _abilities
  , _limitBreak
  , _talents
  , _soul
  )
import ToA.Data.Icon.Name (Name, class Named, _name)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), JobPath(..), _ability)
import ToA.Util.Optic ((^::), (#~))
import ToA.Util.Html (css_)

jobsPage :: Env -> JobPath -> Nut
jobsPage env@{ icon } path =
  D.div
    [ css_ [ "flex", "grow", "gap-2" ] ]
    [ D.div
        [ css_
            [ "w-44"
            , "shrink-0"
            , "overflow-scroll"
            , "border"
            , "border-solid"
            , "border-rounded-sm"
            , "border-sky-800"
            ]
        ]
        [ icon <#~> \{ classes, colours, jobs, souls } ->
            D.ol
              [ css_ [ "text-black" ] ]
              $ classes <#> \c ->
                  let
                    col = colours
                      ^? traversed
                        <<< filtered (view _name >>> eq (c ^. _colour))
                        <<< _value
                  in
                    D.li
                      [ DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                          backgroundColor <$> col
                      ]
                      [ D.span
                          [ DL.click_ $
                              (env ^. _navigate)
                                (Jobs $ WithClass (c ^. _name) Nothing)
                                <<< pure
                          ]
                          [ D.text_ $ viewName c ]

                      , D.ol []
                          $ filter (_class `elemOf` (c ^. _name)) souls <#>
                              \s ->
                                D.li
                                  [ DA.style_ $ fromMaybe "" $ renderedInline $
                                      render =<<
                                        (backgroundColor <<< lighten 0.2) <$>
                                          col
                                  ]
                                  [ D.span
                                      [ DL.click_ $
                                          (env ^. _navigate)
                                            ( Jobs $ WithSoul
                                                (c ^. _name)
                                                (s ^. _name)
                                                Nothing
                                            ) <<< pure
                                      ]
                                      [ D.text_ $ viewName s ]

                                  , D.ol []
                                      $
                                        filter (_soul `elemOf` (s ^. _name))
                                          jobs
                                          <#> \j ->
                                            D.li
                                              [ DA.style_ $ fromMaybe ""
                                                  $ renderedInline
                                                  $ render =<<
                                                      ( backgroundColor <<<
                                                          lighten 0.4
                                                      ) <$> col
                                              ]
                                              [ D.span
                                                  [ DL.click_ $
                                                      (env ^. _navigate)
                                                        ( Jobs $ WithJob
                                                            (c ^. _name)
                                                            (s ^. _name)
                                                            (j ^. _name)
                                                            Nothing
                                                        ) <<< pure
                                                  ]
                                                  [ D.text_ $ viewName j ]
                                              ]
                                  ]
                      ]
        ]

    , D.div
        [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
        $ case path of
            None -> [ D.text_ "Nothing selected" ]
            WithClass c a ->
              [ D.div
                  [ css_
                      [ "flex"
                      , "basis-1/3"
                      , "overflow-hidden"
                      , "p-2"
                      , "border"
                      , "border-solid"
                      , "border-rounded-sm"
                      , "border-sky-800"
                      ]
                  ]
                  [ renderClassStats icon c ]

              , D.div
                  [ css_
                      [ "flex"
                      , "basis-1/3"
                      , "overflow-hidden"
                      , "p-2"
                      , "border"
                      , "border-solid"
                      , "border-rounded-sm"
                      , "border-sky-800"
                      ]
                  ]
                  [ renderClassDesc icon c ]

              , D.div
                  [ css_
                      [ "flex"
                      , "basis-1/3"
                      , "overflow-hidden"
                      , "p-2"
                      , "border"
                      , "border-solid"
                      , "border-rounded-sm"
                      , "border-sky-800"
                      ]
                  ]
                  [ renderClassAbilities env path c a ]
              ]

            WithSoul _ s _ ->
              [ D.div
                  [ css_
                      [ "flex"
                      , "grow"
                      , "overflow-hidden"
                      , "p-2"
                      , "border"
                      , "border-solid"
                      , "border-rounded-sm"
                      , "border-sky-800"
                      ]
                  ]
                  [ renderSoul icon s ]
              ]

            WithJob _ _ j a ->
              [ D.div
                  [ css_
                      [ "flex"
                      , "basis-1/2"
                      , "overflow-hidden"
                      , "p-2"
                      , "border"
                      , "border-solid"
                      , "border-rounded-sm"
                      , "border-sky-800"
                      ]
                  ]
                  [ renderJobDesc icon j ]

              , D.div
                  [ css_
                      [ "flex"
                      , "basis-1/2"
                      , "overflow-hidden"
                      , "p-2"
                      , "border"
                      , "border-solid"
                      , "border-rounded-sm"
                      , "border-sky-800"
                      ]
                  ]
                  [ renderJobAbilities env path j a ]
              ]
    ]

viewName :: ∀ a. Named a => a -> String
viewName = view (_name <<< _Newtype)

renderClassStats :: Poll Icon -> Name -> Nut
renderClassStats icon name = icon <#~>
  \icon_@{ classes, colours, keywords } ->
    classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
      D.div
        [ css_ [ "w-full", "flex", "flex-col" ] ]
        [ D.div
            [ css_ [ "flex", "gap-2" ] ]
            [ D.h3
                [ css_ [ "text-white", "font-bold" ]
                , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                    backgroundColor <$> colours
                      ^? traversed
                        <<< filtered (view _name >>> eq (c ^. _colour))
                        <<< _value
                ]
                [ D.text_ $ viewName c ]
            , D.h4 [ css_ [ "italic" ] ] [ c # _tagline #~ markup icon_ ]
            ]

        , D.div
            [ css_ [ "flex", "gap-2", "overflow-hidden" ] ]
            [ D.div
                [ css_ [ "flex", "basis-1/3", "overflow-scroll", "gap-2" ] ]
                [ D.p [ css_ [ "italic" ] ] [ c # _desc #~ markup icon_ ] ]

            , D.div
                [ css_
                    [ "basis-1/3"
                    , "flex"
                    , "flex-col"
                    , "overflow-scroll"
                    , "gap-2"
                    ]
                ]
                [ D.div []
                    [ D.div []
                        [ D.span
                            [ css_ [ "font-bold" ] ]
                            [ D.text_ "HP: " ]
                        , D.text_
                            $ (c ^. _hp <<< to show)
                                <> " (25% HP: "
                                <> (c ^. _hp <<< to (_ / 4) <<< to show)
                                <> ")"
                        ]

                    , D.div []
                        [ D.span
                            [ css_ [ "font-bold" ] ]
                            [ D.text_ "Defense: " ]
                        , D.text_ $ c ^. _defense <<< to show
                        ]

                    , D.div []
                        [ D.span
                            [ css_ [ "font-bold" ] ]
                            [ D.text_ "Free Move: " ]
                        , D.text_ $ c ^. _move <<< to show
                        ]

                    , D.div []
                        [ D.span
                            [ css_ [ "font-bold" ] ]
                            [ D.text_ "Complexity: " ]
                        , c # _complexity #~ markup icon_
                        ]
                    ]

                , D.div []
                    [ D.h3
                        [ css_ [ "font-bold" ] ]
                        [ D.text_ "Strengths" ]
                    , c # _strengths #~ markup icon_
                    ]

                , D.div []
                    [ D.h3
                        [ css_ [ "font-bold" ] ]
                        [ D.text_ "Weaknesses" ]
                    , c # _weaknesses #~ markup icon_
                    ]
                ]

            , D.div
                [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
                [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Keywords" ]
                , D.div
                    [ css_ [ "overflow-scroll" ] ]
                    [ D.ol [] $
                        keywords
                          ^:: traversed
                          <<< filtered
                            (view (_name <<< to (elem ~$ (c ^. _keywords))))
                          <<< to \k ->
                            D.li
                              [ DA.title_ $ printMarkup $ k ^. _desc
                              , css_ [ "italic", "underline" ]
                              ]
                              [ D.text_ $ k ^. _name <<< _Newtype ]
                    ]
                ]
            ]
        ]

renderClassDesc :: Poll Icon -> Name -> Nut
renderClassDesc icon name = icon <#~> \icon_@{ abilities, classes, traits } ->
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    D.div
      [ css_ [ "w-full", "flex", "gap-2" ] ]
      [ D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          [ D.h3
              [ css_ [ "font-bold" ] ]
              [ D.text_ $ c ^. _trait <<< _Newtype ]
          , D.div
              [ css_ [ "overflow-scroll" ] ]
              [ traits #
                  traversed
                    <<< filtered (_name `elemOf` (c ^. _trait))
                    <<< _desc
                      #~ markup icon_
              ]
          ]

      , D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Basic Attack" ]
          , D.div
              [ css_ [ "overflow-scroll" ] ]
              [ abilities
                  # traversed <<< filtered (view _name >>> eq (c ^. _basic))
                      #~ renderAbility icon_
              ]
          ]

      , D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          []
      ]

renderClassAbilities :: Env -> JobPath -> Name -> Maybe Name -> Nut
renderClassAbilities env@{ icon } path name ability = icon <#~>
  \icon_@{ abilities, classes } ->
    classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
      D.div
        [ css_ [ "w-full", "flex", "gap-2" ] ]
        [ D.div
            [ css_ [ "basis-1/3", "overflow-scroll" ] ]
            [ D.div []
                [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Abilities" ]
                , D.ol []
                    $ c # _apprentice <<< traversed #~ \a ->
                        pure $ D.li
                          [ css_ $
                              [ "hover:bg-stone-500"
                              , "focus:bg-stone-500"
                              , "hover:text-stone-800"
                              , "dark:hover:text-stone-300"
                              ] <> guard (pure a == ability)
                                [ "bg-stone-500"
                                , "dark:bg-stone-700"
                                , "text-stone-800"
                                , "dark:text-stone-300"
                                ]
                          ]
                          [ D.span
                              [ DL.click_ $
                                  (env ^. _navigate)
                                    (Jobs $ path # _ability .~ Just a)
                                    <<< pure
                              ]
                              [ D.text_ $ a ^. simple _Newtype ]
                          ]
                ]
            ]

        , D.div
            [ css_ [ "basis-1/3", "overflow-scroll" ] ]
            [ abilities # traversed <<< filtered (eq ability <<< preview _name)
                #~ renderAbility icon_
            ]

        , D.div
            [ css_ [ "basis-1/3", "overflow-scroll" ] ]
            [ D.text_ $ abilities
                # traversed
                    <<< filtered (eq ability <<< preview _name)
                    <<< _steps
                    <<< traversed
                    <<< to
                      ( case _ of
                          SummonStep _ n _ -> Just n
                          _ -> Nothing
                      )
                    <<< _Just
                    <<< simple _Newtype
                      #~ identity
            ]
        ]

renderSoul :: Poll Icon -> Name -> Nut
renderSoul icon name = icon <#~> \icon_@{ colours, jobs, souls } ->
  souls # traversed <<< filtered (has (_name <<< only name)) #~ \s ->
    D.div
      [ css_
          [ "w-full"
          , "flex"
          , "flex-col"
          , "overflow-hidden"
          , "items-center"
          , "justify-center"
          , "gap-4"
          ]
      ]
      [ D.div
          [ css_ [ "flex", "flex-col", "items-center", "gap-2" ] ]
          [ D.h3 []
              [ D.span
                  [ css_ [ "text-white", "font-bold" ]
                  , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                      (backgroundColor <<< lighten 0.2) <$> colours
                        ^? traversed
                          <<< filtered (view _name >>> eq (s ^. _colour))
                          <<< _value
                  ]
                  [ D.text_ $ viewName s ]
              ]
          , D.h4
              [ css_ [ "flex", "flex-col", "items-center", "italic" ] ]
              [ s # _desc #~ markup icon_ ]
          ]

      , D.ul
          [ css_ [ "flex", "gap-2", "overflow-hidden" ] ]
          $
            jobs
              ^:: traversed
              <<< filtered (has (_soul <<< only name))
              <<< to \j ->
                D.li
                  [ css_ [ "flex-1", "flex", "flex-col", "overflow-hidden" ] ]
                  [ D.h5
                      [ css_ [ "font-bold" ] ]
                      [ D.text_ $ j ^. _name <<< _Newtype ]
                  , D.div
                      [ css_ [ "overflow-scroll", "italic" ] ]
                      [ j # _desc #~ markup icon_ ]
                  ]
      ]

renderJobDesc :: Poll Icon -> Name -> Nut
renderJobDesc icon name = icon <#~> \icon_@{ colours, jobs, talents, traits } ->
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    D.div
      [ css_ [ "w-full", "flex", "flex-col" ] ]
      [ D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.h3
              [ css_ [ "bg-red-200", "text-black", "font-bold" ]
              , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                  (backgroundColor <<< lighten 0.4) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq (j ^. _colour))
                      <<< _value
              ]
              [ D.text_ $ viewName j ]
          , D.h4
              [ css_ [ "italic" ] ]
              [ D.text_ $ (j ^. _soul <<< _Newtype) <> " Soul" ]
          ]

      , D.div
          [ css_ [ "flex", "gap-2", "overflow-hidden" ] ]
          [ D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.div
                  [ css_ [ "overflow-scroll", "italic" ] ]
                  [ j # _desc #~ markup icon_ ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3
                  [ css_ [ "font-bold" ] ]
                  [ D.text_ $ j ^. _trait <<< _Newtype ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ traits #
                      traversed
                          <<< filtered (_name `elemOf` (j ^. _trait))
                          <<< _desc
                      #~ markup icon_
                  ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Talents" ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.ul [] $
                      talents
                        ^:: traversed
                        <<< filtered
                          ( view
                              ( _name <<< to
                                  (elem ~$ (j ^:: _talents <<< traversed))
                              )
                          )
                        <<< to \t ->
                          D.li []
                            [ D.div
                                [ css_ [ "text-red-600", "font-bold" ]
                                , DA.style_ $ fromMaybe "" $ renderedInline $
                                    render =<<
                                      color <$> colours
                                        ^? traversed
                                          <<< filtered
                                            (view _name >>> eq (t ^. _colour))
                                          <<< _value
                                ]
                                [ D.text_ $ viewName t ]
                            , D.div [] [ t # _desc #~ markup icon_ ]
                            ]
                  ]
              ]
          ]
      ]

renderJobAbilities :: Env -> JobPath -> Name -> Maybe Name -> Nut
renderJobAbilities env@{ icon } path name ability = icon <#~>
  \icon_@{ abilities, jobs } ->
    jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
      D.div
        [ css_ [ "w-full", "flex", "gap-2" ] ]
        [ D.div
            [ css_ [ "basis-1/3", "overflow-scroll" ] ]
            [ D.div []
                [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Limit Break" ]
                , j # _limitBreak #~ \a ->
                    D.div
                      [ css_ $
                          [ "hover:bg-stone-500"
                          , "focus:bg-stone-500"
                          , "hover:text-stone-300"
                          , "focus:text-stone-300"
                          ] <> guard (pure a == ability)
                            [ "bg-stone-400"
                            , "text-stone-900"
                            , "dark:bg-stone-700"
                            , "dark:text-stone-300"
                            ]
                      ]
                      [ D.span
                          [ DL.click_ $
                              (env ^. _navigate)
                                (Jobs $ path # _ability .~ Just a)
                                <<< pure
                          ]
                          [ D.text_ $ a ^. simple _Newtype ]
                      ]
                ]

            , D.div []
                [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Abilities" ]
                , D.ol []
                    $ j # _abilities <<< traversed #~ \(l /\ a) ->
                        pure $ D.li
                          [ css_ $
                              [ "flex"
                              , "justify-between"
                              , "hover:bg-stone-500"
                              , "focus:bg-stone-500"
                              , "hover:text-stone-300"
                              , "focus:text-stone-300"
                              ] <> guard (pure a == ability)
                                [ "bg-stone-400"
                                , "text-stone-900"
                                , "dark:bg-stone-700"
                                , "dark:text-stone-300"
                                ]
                          ]
                          [ D.span
                              [ DL.click_ $
                                  (env ^. _navigate)
                                    (Jobs $ path # _ability .~ Just a)
                                    <<< pure
                              ]
                              [ D.text_ $ a ^. simple _Newtype ]
                          , D.span [] [ D.text_ $ show l ]
                          ]
                ]
            ]

        , D.div
            [ css_ [ "basis-1/3", "overflow-scroll" ] ]
            [ abilities # traversed <<< filtered (eq ability <<< preview _name)
                #~ renderAbility icon_
            ]

        , D.div
            [ css_ [ "basis-1/3", "overflow-scroll" ] ]
            [ D.text_ $ abilities
                # traversed
                    <<< filtered (eq ability <<< preview _name)
                    <<< _steps
                    <<< traversed
                    <<< to
                      ( case _ of
                          SummonStep _ n _ -> Just n
                          _ -> Nothing
                      )
                    <<< _Just
                    <<< simple _Newtype
                      #~ identity
            ]
        ]
