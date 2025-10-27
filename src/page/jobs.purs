module ToA.Page.Jobs
  ( jobsPage
  ) where

import Prelude
import PointFree ((~$))

import Data.Filterable (filter)
import Data.Foldable (elem)
import Data.Lens
  ( (^.)
  , (^?)
  , view
  , elemOf
  , filtered
  , has
  , only
  , to
  , traversed
  , _2
  )
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (maybe)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import FRP.Poll (Poll)

import ToA.Data.Env (Env, _navigate)
import ToA.Data.Icon (Icon)
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
import ToA.Data.Icon.Job (_abilities, _limitBreak, _talents, _soul)
import ToA.Data.Icon.Name (Name, class Named, _name)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), JobPath(..))
import ToA.Util.Optic ((^::), (#~))
import ToA.Util.Html (css_)

jobsPage :: Env -> JobPath -> Nut
jobsPage env@{ icon } path =
  D.div
    [ css_ [ "flex", "grow", "gap-2" ]
    ]
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
                            (env ^. _navigate) (Jobs $ WithClass $ c ^. _name)
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
                                        ( Jobs $ WithSoul (c ^. _name)
                                            (s ^. _name)
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
                WithClass c -> renderClassStats icon c
                WithSoul c _ -> renderClassStats icon c
                WithJob c _ _ -> renderClassStats icon c
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
                WithClass c -> renderClassDesc icon c
                WithSoul _ s -> renderSoul icon s
                WithJob _ _ j -> renderJobDesc icon j
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
                WithClass c -> renderClassAbilities icon c
                WithSoul c _ -> renderClassAbilities icon c
                WithJob _ _ j -> renderJobAbilities icon j
            ]
        ]
    ]

viewName :: ∀ a. Named a => a -> String
viewName = view (_name <<< _Newtype)

renderClassStats :: Poll Icon -> Name -> Nut
renderClassStats icon name = icon <#~> \{ classes, keywords, traits } ->
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    D.div
      [ css_ [ "flex", "flex-col" ] ]
      [ D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.h3
              [ css_ [ "bg-red-600", "text-white", "font-bold" ] ]
              [ D.text_ $ viewName c ]
          , D.h4 [ css_ [ "italic" ] ] [ D.text_ $ c ^. _tagline ]
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
                      , D.text_ $ c ^. _complexity
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
                  [ D.text_ $ traits ^.
                      ( traversed
                          <<< filtered (_name `elemOf` (c ^. _trait))
                          <<< _desc
                      )
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
                          <<< filtered (elem ~$ (c ^. _keywords))
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
      [ css_ [ "flex", "overflow-hidden" ] ]
      [ D.div
          [ css_ [ "flex", "basis-1/3", "overflow-scroll", "gap-2" ] ]
          [ D.p [ css_ [ "italic" ] ] [ D.text_ $ c ^. _desc ] ]

      , D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Strengths" ]
          , D.div [ css_ [ "overflow-scroll" ] ] [ D.text_ $ c ^. _strengths ]
          ]

      , D.div
          [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
          [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Weaknesses" ]
          , D.div [ css_ [ "overflow-scroll" ] ] [ D.text_ $ c ^. _weaknesses ]
          ]
      ]

renderClassAbilities :: Poll Icon -> Name -> Nut
renderClassAbilities icon name = icon <#~> \{ abilities, classes } ->
  classes ^? traversed <<< filtered (has (_name <<< only name))
    # maybe mempty \c ->
        D.div
          [ css_ [ "overflow-scroll" ] ]
          [ D.div []
              [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Basic Attack" ]
              , D.text_ $ abilities
                  ^. traversed
                    <<< filtered (has (_name <<< only (c ^. _basic)))
                    <<< _name
                    <<< _Newtype
              ]

          , D.div []
              [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Abilities" ]
              , D.ol []
                  $ abilities #
                      ( traversed
                          <<< filtered
                            (view (_name <<< to (elem ~$ (c ^. _apprentice))))
                          <<< _name
                          <<< _Newtype
                      ) #~ \a ->
                        pure $ D.li [] [ D.text_ a ]
              ]
          ]

renderSoul :: Poll Icon -> Name -> Nut
renderSoul icon name = icon <#~> \{ jobs, souls } ->
  souls # traversed <<< filtered (has (_name <<< only name)) #~ \s ->
    D.div
      []
      [ D.div
          [ css_ [ "flex", "gap-2" ] ]
          [ D.h3 []
              [ D.span
                  [ css_ [ "bg-red-400", "text-white", "font-bold" ] ]
                  [ D.text_ $ viewName s ]
              ]
          , D.h4 [ css_ [ "italic" ] ] [ D.text_ $ s ^. _desc ]
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
      [ css_ [ "flex", "flex-col" ] ]
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
                  [ D.text_ $ j ^. _desc ]
              ]

          , D.div
              [ css_ [ "flex", "flex-col", "basis-1/3", "overflow-hidden" ] ]
              [ D.h3
                  [ css_ [ "font-bold" ] ]
                  [ D.text_ $ j ^. _trait <<< _Newtype ]
              , D.div
                  [ css_ [ "overflow-scroll" ] ]
                  [ D.text_ $ traits ^.
                      ( traversed
                          <<< filtered (_name `elemOf` (j ^. _trait))
                          <<< _desc
                      )
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
                                    , D.div [] [ D.text_ $ t ^. _desc ]
                                    ]
                  ]
              ]
          ]
      ]

renderJobAbilities :: Poll Icon -> Name -> Nut
renderJobAbilities icon name = icon <#~> \{ abilities, jobs, limitBreaks } ->
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    D.div
      [ css_ [ "flex", "gap-2" ] ]
      [ D.div
          [ css_ [ "basis-1/3", "overflow-scroll" ] ]
          [ D.div []
              [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Limit Break" ]
              , D.text_ $ limitBreaks
                  ^. traversed
                    <<< filtered (has (_name <<< only (j ^. _limitBreak)))
                    <<< _name
                    <<< _Newtype
              ]

          , D.div []
              [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Abilities" ]
              , D.ol []
                  $ abilities #
                      ( traversed
                          <<< filtered
                            ( view
                                ( _name <<< to
                                    ( elem ~$
                                        (j ^:: _abilities <<< traversed <<< _2)
                                    )
                                )
                            )
                          <<< _name
                          <<< _Newtype
                      ) #~ \a ->
                        pure $ D.li [] [ D.text_ a ]
              ]
          ]

      , D.div
          [ css_ [ "basis-1/3", "overflow-scroll" ] ]
          [ abilities #
              ( traversed
                  <<< filtered
                    ( view
                        ( _name <<< to
                            ( elem ~$
                                (j ^:: _abilities <<< traversed <<< _2)
                            )
                        )
                    )
                  <<< _desc
              ) #~ markup
          ]
      ]
