module ToA.Page.Jobs
  ( jobsPage
  ) where

import Prelude
import PointFree ((~$))

import Data.Filterable (filter)
import Data.Foldable (elem)
import Data.Lens
  ( (^.)
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
import Data.Maybe (Maybe(..))
import Data.Monoid (guard)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import FRP.Poll (Poll)

import ToA.Component.Ability (renderAbility)
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
import ToA.Component.Markup (markup)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Job
  ( JobLevel(..)
  , _abilities
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
            [ "w-1/5"
            , "min-w-44"
            , "max-w-64"
            , "overflow-scroll"
            , "border"
            , "border-solid"
            , "border-rounded-sm"
            , "border-sky-800"
            ]
        ]
        [ icon <#~> \{ classes, jobs, souls } ->
            D.ol
              [ css_ [ "text-black" ] ]
              $ classes <#> \c ->
                  D.li
                    [ css_ [ "bg-red-600" ] ]
                    [ D.span
                        [ DL.click_ $
                            (env ^. _navigate)
                              (Jobs $ WithClass (c ^. _name) Nothing)
                              <<< pure
                        ]
                        [ D.text_ $ viewName c ]

                    , D.ol []
                        $ filter (_class `elemOf` (c ^. _name)) souls <#> \s ->
                            D.li
                              [ css_ [ "bg-red-400" ] ]
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
                                  $ filter (_soul `elemOf` (s ^. _name)) jobs
                                      <#> \j ->
                                        D.li
                                          [ css_ [ "bg-red-200" ] ]
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
            [ case path of
                None -> D.text_ "No class selected"
                WithClass c _ -> renderClassStats icon c
                WithSoul c _ _ -> renderClassStats icon c
                WithJob c _ _ _ -> renderClassStats icon c
            ]

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
            [ case path of
                None -> mempty
                WithClass c _ -> renderClassDesc icon c
                WithSoul _ s _ -> renderSoul icon s
                WithJob _ _ j _ -> renderJobDesc icon j
            ]

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
            [ case path of
                None -> mempty
                WithClass c a -> renderClassAbilities env path c a
                WithSoul c _ a -> renderClassAbilities env path c a
                WithJob _ _ j a -> renderJobAbilities env path j a
            ]
        ]
    ]

viewName :: ∀ a. Named a => a -> String
viewName = view (_name <<< _Newtype)

renderClassStats :: Poll Icon -> Name -> Nut
renderClassStats icon name = icon <#~> \{ classes, keywords, traits } ->
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    D.div
      [ css_ [ "w-full", "flex", "flex-col" ] ]
      [ D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.h3
              [ css_ [ "bg-red-600", "text-white", "font-bold" ] ]
              [ D.text_ $ viewName c ]
          , D.h4 [ css_ [ "italic" ] ] [ c # _tagline #~ markup ]
          ]

      , D.div
          [ css_ [ "flex", "gap-2", "overflow-hidden" ] ]
          [ D.div
              [ css_ [ "basis-1/3" ] ]
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
                      , c # _complexity #~ markup
                      ]
                  ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3
                  [ css_ [ "font-bold" ] ]
                  [ D.text_ $ c ^. _trait <<< _Newtype ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ traits #
                      ( traversed
                          <<< filtered (_name `elemOf` (c ^. _trait))
                          <<< _desc
                      ) #~ markup
                  ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Keywords" ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.ol []
                      $ keywords #
                          traversed
                            <<< filtered
                              (view (_name <<< to (elem ~$ (c ^. _keywords))))
                            <<< _name
                            <<< _Newtype
                              #~ \k -> pure $ D.li [] [ D.text_ k ]
                  ]
              ]
          ]
      ]

renderClassDesc :: Poll Icon -> Name -> Nut
renderClassDesc icon name = icon <#~> \{ classes } ->
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    D.div
      [ css_ [ "w-full", "flex", "gap-2" ] ]
      [ D.div
          [ css_ [ "flex", "basis-1/3", "overflow-scroll", "gap-2" ] ]
          [ D.p [ css_ [ "italic" ] ] [ c # _desc #~ markup ] ]

      , D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Strengths" ]
          , D.div [ css_ [ "overflow-scroll" ] ] [ c # _strengths #~ markup ]
          ]

      , D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Weaknesses" ]
          , D.div [ css_ [ "overflow-scroll" ] ] [ c # _weaknesses #~ markup ]
          ]
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
                [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Basic Attack" ]
                , c # _basic #~ \a ->
                    D.div
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

            , D.div []
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
renderSoul icon name = icon <#~> \{ jobs, souls } ->
  souls # traversed <<< filtered (has (_name <<< only name)) #~ \s ->
    D.div
      [ css_ [ "w-full", "flex", "flex-col", "gap-2" ] ]
      [ D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.h3 []
              [ D.span
                  [ css_ [ "bg-red-400", "text-white", "font-bold" ] ]
                  [ D.text_ $ viewName s ]
              ]
          , D.h4 [ css_ [ "italic" ] ] [ s # _desc #~ markup ]
          ]

      , D.ul []
          $ jobs # traversed
              <<< filtered (has (_soul <<< only name))
              <<< _name
              <<< _Newtype
                #~ \jn -> pure $ D.li [ css_ [ "font-bold" ] ] [ D.text_ jn ]
      ]

renderJobDesc :: Poll Icon -> Name -> Nut
renderJobDesc icon name = icon <#~> \{ jobs, talents, traits } ->
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    D.div
      [ css_ [ "w-full", "flex", "flex-col" ] ]
      [ D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.h3
              [ css_ [ "bg-red-200", "text-black", "font-bold" ] ]
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
                  [ j # _desc #~ markup ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3
                  [ css_ [ "font-bold" ] ]
                  [ D.text_ $ j ^. _trait <<< _Newtype ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ traits #
                      ( traversed
                          <<< filtered (_name `elemOf` (j ^. _trait))
                          <<< _desc
                      ) #~ markup
                  ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Talents" ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.ul []
                      $ talents #
                          traversed
                            <<<
                              filtered
                                ( view
                                    ( _name <<< to
                                        (elem ~$ (j ^:: _talents <<< traversed))
                                    )
                                )
                                #~ \t -> pure $
                                  D.li []
                                    [ D.div
                                        [ css_ [ "text-red-600", "font-bold" ] ]
                                        [ D.text_ $ viewName t ]
                                    , D.div [] [ t # _desc #~ markup ]
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
                          , D.span []
                              [ D.text_ $ l # case _ of
                                  I -> "I"
                                  II -> "II"
                                  III -> "III"
                                  IV -> "IV"
                              ]
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
