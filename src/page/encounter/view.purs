module ToA.Page.Encounter.View
  ( viewEncounterPage
  ) where

import ToA.Prelude

import CSS (backgroundColor, render, renderedInline)

import Data.Foldable (foldMap, null)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Lens
  ( (^.)
  , (^?)
  , _Just
  , filtered
  , folded
  , has
  , is
  , only
  , preview
  , to
  , traversed
  , view
  )
import Data.Lens.At (at)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>))

import Routing.Duplex (print)

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability (Tag(..), _abilities)
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Encounter (FoeEntry(..))
import ToA.Data.Icon.Markup (length, text)
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Icon.Trait (Trait(..), _trait)

import ToA.Data.Icon.Foe.Ability
  ( Ability
  , FoeAbility(..)
  , _action
  , _steps
  , _tags
  )
import ToA.Data.Icon.Foe.Class (FoeClass(..))
import ToA.Data.Icon.Foe.Faction (Faction(..), _mechanic)
import ToA.Data.Icon.Foe.Job
  ( Phase
  , _Elite
  , _Legend
  , _details
  , _faction
  , _phases
  )
import ToA.Data.Icon.Foe.Trait (FoeTrait(..), _FoeTrait, _RoundAction)

import ToA.Data.Env (Env, _deleteEnc, _navigate)
import ToA.Data.Route (Route(..), EncounterPath(..), routeCodec)

import ToA.Component.Ability
  ( renderActionSign
  , renderAttackSign
  , renderCost
  , renderSteps
  , renderTag
  )
import ToA.Component.Markup (markup)
import ToA.Util.Html (css_, hr)
import ToA.Util.Optic ((^::), (#~))

viewEncounterPage :: Env -> Name -> Nut
viewEncounterPage env@{ encounters, icon } pathEnc =
  encounters <&> icon <#~> \(encs /\ icon_) ->
    let
      enc = encs ^. at pathEnc

    in
      D.div
        [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
        [ D.div
            [ css_ [ "flex", "justify-between", "gap-x-2" ] ]
            [ enc # foldMap \e ->
                D.button
                  [ DL.runOn_ DL.click $ do
                      e # env ^. _deleteEnc
                      (env ^. _navigate) (Encounters Nothing) Nothing
                  , css_
                      [ "px-2"
                      , "py-1"
                      , "border"
                      , "border-solid"
                      , "border-stone-700"
                      ]
                  ]
                  [ D.text_ "Delete" ]

            , enc # foldMap \e ->
                D.a
                  [ DA.href_ $ print routeCodec
                      (Encounters $ Just $ EditEnc $ e ^. _name)
                  , DL.click_
                      $ (env ^. _navigate)
                          (Encounters $ Just $ EditEnc $ e ^. _name)
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

            , D.a
                [ DA.href_ $ print routeCodec
                    (Encounters $ Just CreateEnc)
                , DL.click_
                    $ (env ^. _navigate) (Encounters $ Just CreateEnc)
                    <<< pure
                , css_
                    [ "px-2"
                    , "py-1"
                    , "border"
                    , "border-solid"
                    , "border-stone-700"
                    ]
                ]
                [ D.text_ "Create" ]
            ]

        , D.div
            [ css_ [ "flex", "grow", "overflow-hidden", "gap-2" ] ]
            [ D.div
                [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
                [ guard
                    ( not $ null
                        $ enc
                        ^:: _Just
                        <. simple _Newtype
                        <. to _.notes
                        <. traversed
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
                    ( not $ null $ enc
                        ^. _Just
                          <<< simple _Newtype
                          <<< to _.reserves
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
      <. filtered (view _name >>> eq fe.name)
      <. to \f ->
        let
          fef = factions
            ^? traversed
              <<< filtered (preview _name >>> eq fe.faction)
          fet = foeClasses
            ^? traversed
              <<< filtered (preview _name >>> eq fe.template)
          ff = factions
            ^? traversed
              <<< filtered (preview _name >>> eq (f ^. _faction))
          cls = foeClasses
            ^? traversed
              <<< filtered (view _name >>> eq (f ^. _class))
          mcs = (fef ^:: _Just <. _mechanic) <> (ff ^:: _Just <. _mechanic)
          trs =
            fet
              ^. _Just <. _trait
                <>
                  ( f ^:: filtered (has _Elite) <. to \_ -> FoeTrait $ Trait
                      { name: Name "Elite"
                      , description: text "Takes 2 turns."
                      }
                  )
                <> cls
              ^. _Just <. _trait
                <> f
              ^. _trait
          abs =
            fet
              ^. _Just <. _abilities
                <> cls
              ^. _Just <. _abilities
                <> f
              ^. _abilities

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
                                backgroundColor
                              <$> colours
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
                                backgroundColor
                              <$> colours
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
                              backgroundColor
                            <$> colours
                            ^? traversed
                              <<< filtered (view _name >>> eq (f ^. _colour))
                              <<< _value
                        ]
                        [ D.text_ $ f ^. _name <. _Newtype
                        ]
                    , cls # foldMap \(FoeClass c) ->
                        D.span
                          [ css_ [ "flex", "items-center", "gap-x-2", "ml-2" ]
                          ]
                          [ D.span
                              [ css_ [ "flex", "items-center" ] ]
                              [ D.span
                                  [ css_
                                      [ "icon-[game-icons--checked-shield]" ]
                                  , DA.title_ "Defense"
                                  ]
                                  []
                              , D.span [] [ D.text_ $ show c.defense ]
                              ]
                          , D.span
                              [ css_ [ "flex", "items-center" ] ]
                              [ D.span
                                  [ css_ [ "icon-[game-icons--wingfoot]" ]
                                  , DA.title_ "Free move"
                                  ]
                                  []
                              , D.span [] [ D.text_ $ show c.move ]
                              ]
                          ]
                    ]
                , D.span []
                    [ fe.alias # foldMap \fa ->
                        D.span
                          [ css_ [ "ml-2", "italic" ] ]
                          [ D.text_ fa ]
                    , D.span
                        [ css_ [ "mx-2", "font-bold" ] ]
                        [ D.text_ $ "x" <> show fe.count ]
                    ]
                ]

            , D.div
                [ css_ [ "overflow-y-auto" ] ]
                [ D.div
                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                    $ mcs
                    <#> \m ->
                      D.div []
                        [ D.div
                            [ css_ [ "font-bold" ] ]
                            [ D.text_ $ m ^. _name <. _Newtype ]
                        , markup icon $ m ^. _desc
                        ]

                , guard (not $ null mcs) hr

                , D.div
                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                    $ trs
                    ^:: folded
                    <. filtered (has _FoeTrait)
                    <. to (renderTrait icon)

                , guard (trs # has (folded <. _FoeTrait)) hr

                , D.div
                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                    $ trs
                    ^:: folded
                    <. filtered (has _RoundAction)
                    <. to (renderTrait icon)

                , guard (trs # has (folded <. _RoundAction)) hr

                , D.div
                    [ css_ [ "flex", "flex-col", "gap-2" ] ]
                    $ abs
                    <#> renderFoeAbility icon

                , f ^. _Legend <. _phases <. to \ps ->
                    D.div
                      [ css_ [ "flex", "flex-col", "gap-2", "px-4" ] ]
                      [ D.h4 [ css_ [ "font-bold" ] ] [ D.text_ "Phases" ]
                      , D.div [] [ markup icon $ ps ^. _desc ]
                      , hr
                      , D.div
                          [ css_ [ "flex", "gap-2" ] ]
                          $ ps ^. _details
                          # mapWithIndex (renderPhase icon)
                      ]
                ]
            ]

renderFoeAbility :: Icon -> FoeAbility -> Nut
renderFoeAbility icon (FoeAbility fa) = renderAbility icon fa
renderFoeAbility icon (ChainAbility fa) =
  D.div []
    [ D.ul
        [ css_ [ "ml-4", "list-disc" ] ]
        $ fa
        ^:: traversed
        <. to \a ->
          D.li [] [ renderAbility icon a ]
    ]

renderAbility :: Icon -> Ability -> Nut
renderAbility icon a =
  D.div
    [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
    [ D.div
        [ css_
            [ "flex"
            , "justify-between"
            , "bg-stone-400"
            , "text-stone-800"
            , "dark:bg-stone-700"
            , "dark:text-stone-300"
            ]
        ]
        [ D.h3
            [ css_ [ "text-white", "font-bold" ] ]
            [ D.text_ $ a ^. _name <<< _Newtype ]
        , D.div
            [ css_ [ "flex", "items-center", "gap-2", "mr-2" ] ]
            [ a
                ^. _tags
                  <<< traversed
                  <<< filtered (has $ only Attack)
                  <<< to \_ -> renderAttackSign
            , renderActionSign $ a ^. _action
            ]
        ]

    , D.div
        [ css_ [ "flex", "flex-wrap", "gap-1" ] ]
        [ a # _action #~ renderCost
        , a # _tags <<< traversed #~ renderTag
        ]

    , renderSteps icon $ a ^. _steps
    ]

renderPhase :: Icon -> Int -> Phase -> Nut
renderPhase icon i p =
  D.div []
    [ D.div
        [ css_ [ "font-bold" ] ]
        [ D.text_ $ "Phase " <> show (i + 1) ]

    , markup icon $ p ^. _desc
    , guard (length (p ^. _desc) > 0) hr

    , D.div
        [ css_ [ "flex", "flex-col", "gap-2" ] ]
        $ p
        ^:: _trait
        <. folded
        <. filtered (has _FoeTrait)
        <. to (renderTrait icon)

    , guard (p # has (_trait <. folded <. _FoeTrait)) hr

    , D.div
        [ css_ [ "flex", "flex-col", "gap-2" ] ]
        $ p
        ^:: _trait
        <. folded
        <. filtered (has _RoundAction)
        <. to (renderTrait icon)

    , guard (p # has (_trait <. folded <. _RoundAction)) hr

    , D.div
        [ css_ [ "flex", "flex-col", "gap-2" ] ]
        $ p ^. _abilities <#> renderFoeAbility icon
    ]

renderTrait :: Icon -> FoeTrait -> Nut
renderTrait icon ft =
  D.div []
    [ D.div
        [ css_ [ "font-bold" ] ]
        [ D.text_
            $ ft ^. _trait <. _name <. _Newtype
            <> guard (ft # is _RoundAction) " (Round Action)"
        ]
    , markup icon $ ft ^. _trait <. _desc
    ]
