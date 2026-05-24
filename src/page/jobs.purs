module ToA.Page.Jobs
  ( jobsPage
  ) where

import Prelude
import PointFree ((~$))

import Color (darken, lighten)
import CSS (backgroundColor, color, render, renderedInline)

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
  , _1
  , _2
  )
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (fromMaybe)
import Data.Tuple.Nested ((/\))

import Deku.Core (Nut)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>), guard, useState)

import FRP.Poll (Poll)

import ToA.Component.Ability (renderAbility, renderInset)
import ToA.Component.Markup (markup, printMarkup)
import ToA.Component.Panel (tripanel)
import ToA.Data.Env (Env, _navigate)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability (_inset)
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
import ToA.Data.Icon.Id (_id)
import ToA.Data.Icon.Job
  ( JobLevel(..)
  , _abilities
  , _limitBreak
  , _talents
  , _soul
  )
import ToA.Data.Icon.Name (class Named, Name, _name)
import ToA.Data.Icon.Sign (_sign)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), JobPath(..))
import ToA.Util.Optic ((^::), (#~))
import ToA.Util.Html (css, css_, hr)

jobsPage :: Env -> JobPath -> Nut
jobsPage env@{ icon } path = Deku.do
  setOpen /\ open <- useState false

  D.div
    [ css_ [ "flex", "grow", "gap-2" ] ]
    [ D.div
        [ css $ open <#> \o ->
            -- [ "absolute"
            -- [ "static"
            [ "flex"
            , "flex-col"
            , "grow"
            , "shrink-0"
            -- , "min-h-full"
            -- , "h-dvh"
            , "overflow-hidden"
            , "transition-[width]"
            , "ease-in-out"
            , "z-50"
            , "bg-stone-400"
            , "dark:bg-stone-800"
            , if o then "w-44" else "w-8"
            ]
        , DL.runOn_ DL.mouseenter $ setOpen true
        , DL.runOn_ DL.mouseleave $ setOpen false
        ]
        [ D.button
            [ css_
                [ "flex"
                , "shrink-0"
                , "h-8"
                , "pl-2"
                , "items-center"
                , "justify-items-center"
                , "text-center"
                , "border-b"
                , "border-sky-900"
                ]
            , DL.runOn DL.click $ setOpen <<< not <$> open
            ]
            [ D.span
                [ css $ open <#> pure <<<
                    if _ then "icon-[fa7-solid--chevron-left]"
                    else "icon-[fa7-solid--chevron-right]"
                ]
                []
            ]

        , jobList env
        ]

    , D.div
        [ css_ [ "flex", "flex-col", "grow", "gap-2", "max-h-dvh" ] ] $
        [ guard open $
            D.div -- overlay

              [ css_
                  [ "w-full"
                  , "h-full"
                  , "fixed"
                  , "transition"
                  , "ease-in-out"
                  , "bg-black/20"
                  ]
              , DL.runOn_ DL.click $ setOpen false
              ]
              []
        ] <> case path of
          None -> [ D.text_ "Nothing selected" ]
          WithClass c ->
            [ icon <#~> \icon_ -> tripanel
                (renderClassDesc icon_ c)
                (renderClassPassives icon_ c)
                (renderClassAbilities icon_ c)
            ]

          WithSoul _ s ->
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

          WithJob _ _ j ->
            [ icon <#~> \icon_ -> tripanel
                (renderJobDesc icon_ j)
                (renderJobPassives icon_ j)
                (renderJobAbilities icon_ j)
            ]
    ]

viewName :: ∀ a. Named a => a -> String
viewName = view (_name <<< _Newtype)

jobList :: Env -> Nut
jobList env@{ icon } = icon <#~> \{ classes, colours, jobs, souls } ->
  D.ol
    [ css_
        [ "flex"
        , "flex-col"
        , "overflow-x-hidden"
        , "overflow-y-scroll"
        , "text-nowrap"
        , "text-black"
        ]
    ]
    $ classes <#> \c ->
        let
          col = colours
            ^? traversed
              <<< filtered (_name `elemOf` (c ^. _colour))
              <<< _value
        in
          Deku.do
            setHoverC /\ hoverC <- useState false

            D.li
              [ DA.style $ hoverC <#> \h ->
                  fromMaybe "" $ renderedInline $ render =<<
                    (backgroundColor <<< if h then darken 0.1 else identity)
                      <$> col
              ]
              [ D.div
                  [ css_ [ "flex", "gap-x-2", "items-center" ]
                  , DL.click_ $
                      (env ^. _navigate)
                        (Jobs $ WithClass (c ^. _name)) <<< pure
                  , DL.runOn_ DL.mouseenter $ setHoverC true
                  , DL.runOn_ DL.mouseleave $ setHoverC false
                  ]
                  [ D.span
                      [ css_ [ "shrink-0", "size-8", c ^. _sign <<< _Newtype ] ]
                      []
                  , D.span [ css_ [ "grow" ] ] [ D.text_ $ viewName c ]
                  ]

              , D.ol [] $
                  filter (_class `elemOf` (c ^. _name)) souls <#> \s ->
                    Deku.do
                      setHoverS /\ hoverS <- useState false

                      D.li
                        [ DA.style $ hoverS <#> \h ->
                            fromMaybe "" $ renderedInline $ render =<<
                              ( backgroundColor <<< lighten 0.2 <<<
                                  if h then darken 0.1 else identity
                              ) <$> col
                        ]
                        [ D.div
                            [ css_ [ "flex", "gap-x-2", "items-center" ]
                            , DL.click_ $
                                (env ^. _navigate)
                                  (Jobs $ WithSoul (c ^. _name) (s ^. _name))
                                  <<< pure
                            , DL.runOn_ DL.mouseenter $ setHoverS true
                            , DL.runOn_ DL.mouseleave $ setHoverS false
                            ]
                            [ D.span
                                [ css_
                                    [ "shrink-0"
                                    , "size-8"
                                    , s ^. _sign <<< _Newtype
                                    ]
                                ]
                                []
                            , D.span [ css_ [ "grow" ] ]
                                [ D.text_ $ viewName s ]
                            ]

                        , D.ol [] $
                            filter (_soul `elemOf` (s ^. _name)) jobs <#> \j ->
                              Deku.do
                                setHoverJ /\ hoverJ <- useState false

                                D.li
                                  [ DA.style $ hoverJ <#> \h -> fromMaybe ""
                                      $ renderedInline
                                      $ render =<<
                                          ( backgroundColor <<< lighten 0.4 <<<
                                              if h then darken 0.1 else identity
                                          ) <$> col
                                  ]
                                  [ D.div
                                      [ css_
                                          [ "flex", "gap-x-2", "items-center" ]
                                      , DL.click_ $
                                          (env ^. _navigate)
                                            ( Jobs $ WithJob
                                                (c ^. _name)
                                                (s ^. _name)
                                                (j ^. _name)
                                            ) <<< pure
                                      , DL.runOn_ DL.mouseenter $ setHoverJ true
                                      , DL.runOn_ DL.mouseleave $ setHoverJ
                                          false
                                      ]
                                      [ D.span
                                          [ css_
                                              [ "shrink-0"
                                              , "size-8"
                                              , j ^. _sign <<< _Newtype
                                              ]
                                          ]
                                          []
                                      , D.span [ css_ [ "grow" ] ]
                                          [ D.text_ $ viewName j ]
                                      ]
                                  ]
                        ]
              ]

renderClassDesc :: Icon -> Name -> Array Nut
renderClassDesc icon@{ classes, colours, keywords } name =
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    [ D.div
        [ css_ [ "flex", "flex-col", "gap-2" ] ]
        [ D.h3
            [ css_
                [ "flex"
                , "gap-x-2"
                , "items-center"
                , "justify-between"
                , "px-2"
                , "text-white"
                , "font-bold"
                ]
            , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                backgroundColor <$> colours
                  ^? traversed
                    <<< filtered (view _name >>> eq (c ^. _colour))
                    <<< _value
            ]
            [ D.text_ $ viewName c
            , D.span [ css_ [ "size-8", c ^. _sign <<< _Newtype ] ] []
            ]
        , D.h4 [ css_ [ "italic" ] ] [ c # _tagline #~ markup icon ]
        ]

    , hr

    , D.div
        [ css_ [ "flex", "flex-col", "gap-2" ] ]
        [ D.div []
            [ D.h3
                [ css_ [ "font-bold" ] ]
                [ D.text_ "Strengths: " ]
            , c # _strengths #~ markup icon
            ]

        , D.div []
            [ D.h3
                [ css_ [ "font-bold" ] ]
                [ D.text_ "Weaknesses: " ]
            , c # _weaknesses #~ markup icon
            ]

        , D.div []
            [ D.span
                [ css_ [ "font-bold" ] ]
                [ D.text_ "Complexity: " ]
            , c # _complexity #~ markup icon
            ]
        ]

    , hr

    , D.p [ css_ [ "italic" ] ] [ c # _desc #~ markup icon ]

    , hr

    , D.div []
        [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Keywords" ]
        , D.div []
            [ D.ol [] $
                keywords
                  ^:: traversed
                  <<< filtered (view (_name <<< to (elem ~$ (c ^. _keywords))))
                  <<< to \k ->
                    D.li
                      [ DA.title_ $ printMarkup $ k ^. _desc
                      , css_ [ "italic", "underline" ]
                      ]
                      [ D.text_ $ k ^. _name <<< _Newtype ]
            ]
        ]
    ]

renderClassPassives :: Icon -> Name -> Array Nut
renderClassPassives icon@{ abilities, classes, traits } name =
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
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
        ]

    , D.div []
        [ D.h3
            [ css_ [ "font-bold" ] ]
            [ D.text_ $ c ^. _trait <<< _Newtype ]
        , D.div []
            [ traits #
                traversed <<< filtered (_name `elemOf` (c ^. _trait)) <<< _desc
                  #~ markup icon
            ]
        ]

    , D.div []
        [ D.div [ css_ [ "font-bold" ] ] [ D.text_ "Basic Attack" ]
        , D.div []
            [ abilities
                # traversed <<< filtered (view _name >>> eq (c ^. _basic))
                    #~ renderAbility icon
            ]
        ]
    ]

renderClassAbilities :: Icon -> Name -> Array Nut
renderClassAbilities icon@{ abilities, classes } name =
  classes # traversed <<< filtered (has (_name <<< only name)) <<< _apprentice
    #~ \as ->
      [ D.div
          [ css_
              [ "grid"
              , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
              , "gap-x-2"
              , "gap-y-6"
              ]
          ] $
          abilities
            ^:: traversed
            <<< filtered (view _name >>> (elem ~$ as))
            <<< to (renderAbility icon)
      ]

renderSoul :: Poll Icon -> Name -> Nut
renderSoul icon name = icon <#~> \icon_@{ colours, jobs, souls } ->
  souls # traversed <<< filtered (has (_name <<< only name)) #~ \s ->
    D.div
      [ css_
          [ "w-full"
          , "flex"
          , "flex-col"
          , "overflow-scroll"
          , "items-center"
          , "justify-center-safe"
          , "gap-4"
          ]
      ]
      [ D.div
          [ css_ [ "flex", "flex-col", "items-center", "gap-2" ] ]
          [ D.h3 []
              [ D.span
                  [ css_
                      [ "flex"
                      , "gap-x-2"
                      , "items-center"
                      , "justify-between"
                      , "px-2"
                      , "text-white"
                      , "font-bold"
                      ]
                  , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                      (backgroundColor <<< lighten 0.2) <$> colours
                        ^? traversed
                          <<< filtered (view _name >>> eq (s ^. _colour))
                          <<< _value
                  ]
                  [ D.text_ $ viewName s
                  , D.span [ css_ [ "size-8", s ^. _sign <<< _Newtype ] ] []
                  ]
              ]
          , D.h4
              [ css_ [ "flex", "flex-col", "items-center", "italic" ] ]
              [ s # _desc #~ markup icon_ ]
          ]

      , D.ul
          [ css_ [ "flex", "flex-col", "md:flex-row", "gap-x-2", "gap-y-6" ] ] $
          jobs
            ^:: traversed
            <<< filtered (has (_soul <<< only name))
            <<< to \j ->
              D.li
                [ css_ [ "flex-1", "flex", "flex-col" ] ]
                [ D.h5
                    [ css_ [ "font-bold" ] ]
                    [ D.text_ $ j ^. _name <<< _Newtype ]
                , D.div
                    [ css_ [ "italic" ] ]
                    [ j # _desc #~ markup icon_ ]
                ]
      ]

renderJobDesc :: Icon -> Name -> Array Nut
renderJobDesc icon@{ colours, jobs } name =
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    [ D.h3
        [ css_
            [ "flex"
            , "gap-x-2"
            , "items-center"
            , "justify-between"
            , "px-2"
            , "text-black"
            , "font-bold"
            ]
        , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
            (backgroundColor <<< lighten 0.4) <$> colours
              ^? traversed
                <<< filtered (view _name >>> eq (j ^. _colour))
                <<< _value
        ]
        [ D.text_ $ viewName j
        , D.span [ css_ [ "size-8", j ^. _sign <<< _Newtype ] ] []
        ]

    , D.h4
        [ css_ [ "italic" ] ]
        [ D.text_ $ (j ^. _soul <<< _Newtype) <> " Soul" ]

    , hr

    , D.div
        [ css_ [ "italic" ] ]
        [ j # _desc #~ markup icon ]
    ]

renderJobPassives :: Icon -> Name -> Array Nut
renderJobPassives icon@{ abilities, colours, jobs, talents, traits } name =
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    [ D.div
        [ css_ [ "flex", "flex-col" ] ]
        [ D.h3
            [ css_ [ "font-bold" ] ]
            [ D.text_ $ j ^. _trait <<< _Newtype ]
        , D.div
            [ css_ [ "overflow-scroll" ] ]
            $ traits #
                traversed <<< filtered (_name `elemOf` (j ^. _trait))
                  #~ \t ->
                    [ markup icon $ t ^. _desc
                    , t # _inset #~ renderInset icon
                    ]
        ]

    , D.div
        [ css_ [ "flex", "flex-col" ] ]
        [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Talents" ]
        , D.div
            [ css_ [ "overflow-scroll" ] ]
            [ D.ul [] $
                talents
                  ^:: traversed
                  <<< filtered
                    (view (_id <<< to (elem ~$ (j ^:: _talents <<< traversed))))
                  <<< to \t ->
                    D.li []
                      [ D.div
                          [ css_ [ "font-bold" ]
                          , DA.style_ $ fromMaybe "" $ renderedInline $
                              render =<<
                                color <$> colours
                                  ^? traversed
                                    <<< filtered
                                      (view _name >>> eq (t ^. _colour))
                                    <<< _value
                          ]
                          [ D.text_ $ viewName t ]
                      , D.div []
                          [ t # _desc #~ markup icon
                          , t # _inset #~ renderInset icon
                          ]
                      ]
            ]
        ]

    , abilities # traversed <<< filtered (view _name >>> eq (j ^. _limitBreak))
        #~ renderAbility icon
    ]

renderJobAbilities :: Icon -> Name -> Array Nut
renderJobAbilities icon@{ abilities, jobs } name =
  jobs # traversed <<< filtered (has (_name <<< only name)) <<< _abilities #~
    \as ->
      let
        lvlAbs ch =
          [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ $ show ch ]
          , D.div
              [ css_
                  [ "w-full"
                  , "flex"
                  , "flex-row"
                  , "flex-wrap"
                  , "gap-x-2"
                  , "gap-y-6"
                  ]
              ] $
              abilities
                ^:: traversed
                <<< filtered
                  ( view _name >>>
                      ( elem ~$
                          ( as ^:: traversed
                              <<< filtered (has (_1 <<< only ch))
                              <<< _2
                          )
                      )
                  )
                <<< to \a ->
                  D.div
                    [ css_ [ "flex-1", "min-w-[250px]" ] ]
                    [ renderAbility icon a ]
          ]
      in
        [ D.div
            [ css_
                [ "flex"
                , "flex-col"
                , "flex-wrap"
                , "w-full"
                , "gap-y-6"
                , "items-center"
                , "justify-items-center"
                ]
            ]
            $ lvlAbs I <> lvlAbs II <> lvlAbs IV
        ]
