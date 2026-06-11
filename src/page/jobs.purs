module ToA.Page.Jobs
  ( jobsPage
  ) where

import ToA.Prelude

import Color (lighten)
import CSS (backgroundColor, color)

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
import Data.Maybe (Maybe, fromMaybe)
import Data.Monoid (guard)

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.CSS (style)
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectEq)

import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), JobPath(..))
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability (_inset)
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Id (_id)
import ToA.Data.Icon.Name (class Named, Name, _name)
import ToA.Data.Icon.Sign (_sign)
import ToA.Data.Icon.Trait (_trait)

import ToA.Data.Icon.Pc.Class
  ( _apprentice
  , _basic
  , _complexity
  , _defense
  , _hp
  , _keywords
  , _move
  , _strengths
  , _tagline
  , _weaknesses
  )
import ToA.Data.Icon.Pc.Job
  ( JobLevel(..)
  , _abilities
  , _limitBreak
  , _talents
  , _soul
  )

import ToA.Component.Ability (renderAbility, renderInset)
import ToA.Component.Markup (markup, printMarkup)
import ToA.Component.Panel (tripanel)
import ToA.Util.Optic ((^::), (#~))
import ToA.Util.Html (css, hr)

viewName :: ∀ a. Named a => a -> String
viewName = view (_name <<< _Newtype)

data Action
  = Receive (Connected Icon JobPath)
  | Navigate Route (Maybe MouseEvent)
  | SetOpen Boolean

jobsPage
  :: ∀ q o m
   . MonadStore StoreAction Store m
  => Navigate m
  => H.Component q JobPath o m
jobsPage =
  connect (selectEq _.icon) $ H.mkComponent
    { initialState: \{ context, input } ->
        { icon: context
        , path: input
        , open: case input of
            None -> true
            _ -> false
        }
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where
  act = case _ of
    Receive { context, input } ->
      H.modify_ _ { icon = context, path = input }
    Navigate r e -> navigate r e
    SetOpen open -> H.modify_ _ { open = open }

  render { icon, path, open } =
    HD.div
      [ css [ "flex", "grow", "gap-2" ] ]
      [ HD.div
          [ css 
              [ "flex"
              , "flex-col"
              , "grow"
              , "shrink-0"
              , "overflow-hidden"
              , "transition-[width]"
              , "ease-in-out"
              , "z-50"
              , "bg-stone-400"
              , "dark:bg-stone-800"
              , if open then "w-44" else "w-8"
              ]
          , HE.onMouseEnter \_ -> SetOpen true
          , HE.onMouseLeave \_ -> SetOpen false
          ]
          [ HD.button
              [ css
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
              , HP.type_ HP.ButtonButton
              , HE.onClick \_ -> SetOpen (not open)
              ]
              [ HD.span
                  [ css
                      [ if open then "icon-[fa7-solid--chevron-left]"
                        else "icon-[fa7-solid--chevron-right]"
                      ]
                  ]
                  []
              ]

          , jobList icon
          ]

      , HD.div
          [ css [ "flex", "flex-col", "grow", "gap-2", "max-h-dvh" ] ] $ join
          [ guard open
              [ HD.div
                  [ css
                      [ "w-full"
                      , "h-full"
                      , "fixed"
                      , "transition"
                      , "ease-in-out"
                      , "bg-black/20"
                      ]
                  , HE.onClick \_ -> SetOpen false
                  ]
                  []
              ]
          , case path of
            None -> [ HD.text "Nothing selected" ]
            WithClass c ->
              [ tripanel
                  (renderClassDesc icon c)
                  (renderClassPassives icon c)
                  (renderClassAbilities icon c)
              ]

            WithSoul _ s ->
              [ HD.div
                  [ css
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
                  $ renderSoul icon s
              ]

            WithJob _ _ j ->
              [ tripanel
                  (renderJobDesc icon j)
                  (renderJobPassives icon j)
                  (renderJobAbilities icon j)
              ]
          ]
      ]

jobList :: ∀ w. Icon -> HD.HTML w Action
jobList { classes, colours, jobs, souls } =
  HD.ol
    [ css
        [ "flex"
        , "flex-col"
        , "overflow-x-hidden"
        , "overflow-y-auto"
        , "scrollbar-none"
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
          HD.li
            [ style $ fromMaybe (pure unit) $ backgroundColor <$> col
            ]
            [ HD.div
                [ css
                    [ "flex"
                    , "gap-x-2"
                    , "items-center"
                    , "hover:backdrop-brightness-80"
                    ]
                , HE.onClick $ Navigate (Jobs $ WithClass (c ^. _name)) <<< pure
                ]
                [ HD.span
                    [ css [ "shrink-0", "size-8", c ^. _sign <<< _Newtype ] ]
                    []
                , HD.span [ css [ "grow" ] ] [ HD.text $ viewName c ]
                ]

            , HD.ol [] $
                filter (_class `elemOf` (c ^. _name)) souls <#> \s ->
                  HD.li
                    [ style $ fromMaybe (pure unit) $
                          (backgroundColor <<< lighten 0.2) <$> col
                    ]
                    [ HD.div
                        [ css
                            [ "flex"
                            , "gap-x-2"
                            , "items-center"
                            , "hover:backdrop-brightness-80"
                            ]
                        , HE.onClick $ Navigate
                            (Jobs $ WithSoul (c ^. _name) (s ^. _name))
                            <<< pure
                        ]
                        [ HD.span
                            [ css
                                [ "shrink-0"
                                , "size-8"
                                , s ^. _sign <<< _Newtype
                                ]
                            ]
                            []
                        , HD.span [ css [ "grow" ] ] [ HD.text $ viewName s ]
                        ]

                    , HD.ol [] $
                        filter (_soul `elemOf` (s ^. _name)) jobs <#> \j ->
                          HD.li
                            [ style $ fromMaybe (pure unit) $
                                (backgroundColor <<< lighten 0.4) <$> col
                            ]
                            [ HD.div
                                [ css
                                    [ "flex"
                                    , "gap-x-2"
                                    , "items-center"
                                    , "hover:backdrop-brightness-80"
                                    ]
                                , HE.onClick $ Navigate
                                    ( Jobs $ WithJob
                                        (c ^. _name)
                                        (s ^. _name)
                                        (j ^. _name)
                                    ) <<< pure
                                ]
                                [ HD.span
                                    [ css
                                        [ "shrink-0"
                                        , "size-8"
                                        , j ^. _sign <<< _Newtype
                                        ]
                                    ]
                                    []
                                , HD.span [ css [ "grow" ] ]
                                    [ HD.text $ viewName j ]
                                ]
                            ]
                    ]
            ]

renderClassDesc :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderClassDesc icon@{ classes, colours, keywords } name =
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    [ HD.div
        [ css [ "flex", "flex-col", "gap-2" ] ]
        [ HD.h3
            [ css
                [ "flex"
                , "gap-x-2"
                , "items-center"
                , "justify-between"
                , "px-2"
                , "text-white"
                , "font-bold"
                ]
            , style $ fromMaybe (pure unit) $
                backgroundColor <$> colours
                  ^? traversed
                    <<< filtered (view _name >>> eq (c ^. _colour))
                    <<< _value
            ]
            [ HD.text $ viewName c
            , HD.span [ css [ "size-8", c ^. _sign <<< _Newtype ] ] []
            ]
        , HD.h4 [ css [ "italic" ] ] [ c # _tagline #~ markup icon ]
        ]

    , hr

    , HD.div
        [ css [ "flex", "flex-col", "gap-2" ] ]
        [ HD.div []
            [ HD.h3
                [ css [ "font-bold" ] ]
                [ HD.text "Strengths: " ]
            , c # _strengths #~ markup icon
            ]

        , HD.div []
            [ HD.h3
                [ css [ "font-bold" ] ]
                [ HD.text "Weaknesses: " ]
            , c # _weaknesses #~ markup icon
            ]

        , HD.div []
            [ HD.span
                [ css [ "font-bold" ] ]
                [ HD.text "Complexity: " ]
            , c # _complexity #~ markup icon
            ]
        ]

    , hr

    , HD.p [ css [ "italic" ] ] [ c # _desc #~ markup icon ]

    , hr

    , HD.div []
        [ HD.h3 [ css [ "font-bold" ] ] [ HD.text "Keywords" ]
        , HD.div []
            [ HD.ol [] $
                keywords
                  ^:: traversed
                  <<< filtered (view (_name <<< to (elem ~$ (c ^. _keywords))))
                  <<< to \k ->
                    HD.li
                      [ HP.title $ printMarkup $ k ^. _desc
                      , css [ "italic", "underline" ]
                      ]
                      [ HD.text $ k ^. _name <<< _Newtype ]
            ]
        ]
    ]

renderClassPassives :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderClassPassives icon@{ abilities, classes, traits } name =
  classes # traversed <<< filtered (has (_name <<< only name)) #~ \c ->
    [ HD.div []
        [ HD.div []
            [ HD.span
                [ css [ "font-bold" ] ]
                [ HD.text "HP: " ]
            , HD.text
                $ (c ^. _hp <<< to show)
                    <> " (25% HP: "
                    <> (c ^. _hp <<< to (_ / 4) <<< to show)
                    <> ")"
            ]

        , HD.div []
            [ HD.span
                [ css [ "font-bold" ] ]
                [ HD.text "Defense: " ]
            , HD.text $ c ^. _defense <<< to show
            ]

        , HD.div []
            [ HD.span
                [ css [ "font-bold" ] ]
                [ HD.text "Free Move: " ]
            , HD.text $ c ^. _move <<< to show
            ]
        ]

    , HD.div []
        [ HD.h3
            [ css [ "font-bold" ] ]
            [ HD.text $ c ^. _trait <<< _Newtype ]
        , HD.div [] $
            traits #
              traversed <<< filtered (_name `elemOf` (c ^. _trait)) <<< _desc
                #~ pure <<< markup icon
        ]

    , HD.div []
        [ HD.div [ css [ "font-bold" ] ] [ HD.text "Basic Attack" ]
        , HD.div [] $
            abilities
              # traversed <<< filtered (view _name >>> eq (c ^. _basic))
                  #~ pure <<< renderAbility icon
        ]
    ]

renderClassAbilities :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderClassAbilities icon@{ abilities, classes } name =
  classes # traversed <<< filtered (has (_name <<< only name)) <<< _apprentice
    #~ \as ->
      [ HD.div
          [ css
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

renderSoul :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderSoul icon@{ colours, jobs, souls } name =
  souls # traversed <<< filtered (has (_name <<< only name)) #~ \s ->
    [ HD.div
        [ css
            [ "w-full"
            , "flex"
            , "flex-col"
            , "items-center"
            , "justify-center-safe"
            , "gap-4"
            ]
        ]
        [ HD.div
            [ css [ "flex", "flex-col", "items-center", "gap-2" ] ]
            [ HD.h3 []
                [ HD.span
                    [ css
                        [ "flex"
                        , "gap-x-2"
                        , "items-center"
                        , "justify-between"
                        , "px-2"
                        , "text-white"
                        , "font-bold"
                        ]
                    , style $ fromMaybe (pure unit) $
                        (backgroundColor <<< lighten 0.2) <$> colours
                          ^? traversed
                            <<< filtered (view _name >>> eq (s ^. _colour))
                            <<< _value
                    ]
                    [ HD.text $ viewName s
                    , HD.span [ css [ "size-8", s ^. _sign <<< _Newtype ] ] []
                    ]
                ]
            , HD.h4
                [ css [ "flex", "flex-col", "items-center", "italic" ] ]
                [ s # _desc #~ markup icon ]
            ]

        , HD.ul
            [ css [ "flex", "flex-col", "md:flex-row", "gap-x-2", "gap-y-6" ] ] $
            jobs
              ^:: traversed
              <<< filtered (has (_soul <<< only name))
              <<< to \j ->
                HD.li
                  [ css [ "flex-1", "flex", "flex-col" ] ]
                  [ HD.h5
                      [ css [ "font-bold" ] ]
                      [ HD.text $ j ^. _name <<< _Newtype ]
                  , HD.div
                      [ css [ "italic" ] ]
                      [ j # _desc #~ markup icon ]
                  ]
        ]
    ]

renderJobDesc :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderJobDesc icon@{ colours, jobs } name =
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    [ HD.h3
        [ css
            [ "flex"
            , "gap-x-2"
            , "items-center"
            , "justify-between"
            , "px-2"
            , "text-black"
            , "font-bold"
            ]
        , style $ fromMaybe (pure unit) $
            (backgroundColor <<< lighten 0.4) <$> colours
              ^? traversed
                <<< filtered (view _name >>> eq (j ^. _colour))
                <<< _value
        ]
        [ HD.text $ viewName j
        , HD.span [ css [ "size-8", j ^. _sign <<< _Newtype ] ] []
        ]

    , HD.h4
        [ css [ "italic" ] ]
        [ HD.text $ (j ^. _soul <<< _Newtype) <> " Soul" ]

    , hr

    , HD.div
        [ css [ "italic" ] ]
        [ j # _desc #~ markup icon ]
    ]

renderJobPassives :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderJobPassives icon@{ abilities, colours, jobs, talents, traits } name =
  jobs # traversed <<< filtered (has (_name <<< only name)) #~ \j ->
    [ HD.div
        [ css [ "flex", "flex-col" ] ]
        [ HD.h3
            [ css [ "font-bold" ] ]
            [ HD.text $ j ^. _trait <<< _Newtype ]
        , HD.div []
            $ traits #
                traversed <<< filtered (_name `elemOf` (j ^. _trait))
                  #~ \t -> join
                    [ [ markup icon $ t ^. _desc ]
                    , t # _inset #~ pure <<< renderInset icon
                    ]
        ]

    , HD.div
        [ css [ "flex", "flex-col" ] ]
        [ HD.h3 [ css [ "font-bold" ] ] [ HD.text "Talents" ]
        , HD.div []
            [ HD.ul [] $
                talents
                  ^:: traversed
                  <<< filtered
                    (view (_id <<< to (elem ~$ (j ^:: _talents <<< traversed))))
                  <<< to \t ->
                    HD.li []
                      [ HD.div
                          [ css [ "font-bold" ]
                          , style $ fromMaybe (pure unit) $
                                color <$> colours
                                  ^? traversed
                                    <<< filtered
                                      (view _name >>> eq (t ^. _colour))
                                    <<< _value
                          ]
                          [ HD.text $ viewName t ]
                      , HD.div [] $ join
                          [ [ t # _desc #~ markup icon ]
                          , t # _inset #~ pure <<< renderInset icon
                          ]
                      ]
            ]
        ]
    ]
    <> (abilities # traversed <<< filtered (view _name >>> eq (j ^. _limitBreak))
        #~ pure <<< renderAbility icon)

renderJobAbilities :: ∀ w i. Icon -> Name -> Array (HD.HTML w i)
renderJobAbilities icon@{ abilities, jobs } name =
  jobs # traversed <<< filtered (has (_name <<< only name)) <<< _abilities #~
    \as ->
      let
        lvlAbs ch =
          [ HD.h3 [ css [ "font-bold" ] ] [ HD.text $ show ch ]
          , HD.div
              [ css
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
                  HD.div
                    [ css [ "flex-1", "min-w-[250px]" ] ]
                    [ renderAbility icon a ]
          ]
      in
        [ HD.div
            [ css
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
