module ToA.Page.Encounter.View
  ( viewEncounterPage
  ) where

import ToA.Prelude

import CSS (backgroundColor, render, renderedInline)

import Data.Array ((..), cons, nubBy, uncons)
import Data.Filterable (filter)
import Data.Foldable (foldMap, intercalate, null)
import Data.Function (on)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Int (floor)
import Data.Lens
  ( (^.)
  , (^?)
  , (.~)
  , (?~)
  , preview
  , set
  , setJust
  , view
  , filtered
  , folded
  , has
  , is
  , only
  , takeBoth
  , to
  , traversed
  , _Just
  , _1
  , _2
  )
import Data.Lens.At (at)
import Data.Lens.Common (simple)
import Data.Lens.Index (ix)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Monoid (guard)

import Deku.Core (Nut, fixed)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>), useState')

import Routing.Duplex (print)

import ToA.Data.Env (Env, _deleteEnc, _navigate, _saveEnc)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon as I
import ToA.Data.Route (Route(..), EncounterPath(..), routeCodec)

import ToA.Data.Icon.Ability (Tag(..), _abilities)
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Encounter (Encounter, FoeEntry)
import ToA.Data.Icon.Encounter
  ( _alias
  , _hp
  , _faction
  , _foes
  , _players
  , _notes
  , _state
  , _status
  , _template
  , _vigor
  , _Active
  , _Reserve
  ) as E
import ToA.Data.Icon.Keyword (_Status, _Positive, _Negative, _category)
import ToA.Data.Icon.Markup (length, text) as M
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
import ToA.Data.Icon.Foe.Class (_hp, _maxVigor) as C
import ToA.Data.Icon.Foe.Faction (_mechanic)
import ToA.Data.Icon.Foe.Job (FoeJob, Phase)
import ToA.Data.Icon.Foe.Job
  ( _Elite
  , _Legend
  , _details
  , _faction
  , _hp
  , _maxVigor
  , _phases
  ) as J
import ToA.Data.Icon.Foe.Trait (FoeTrait(..), _FoeTrait, _RoundAction)

import ToA.Component.Ability
  ( renderActionSign
  , renderAttackSign
  , renderCost
  , renderSteps
  , renderTag
  )
import ToA.Component.Encounter (exportEncounter)
import ToA.Component.Markup (markup)

import ToA.Util.Html (css_, hr, style_)
import ToA.Util.Optic ((^::), (#~), (#@~))
import ToA.Util.Style as S

foeByName :: Icon -> Name -> Maybe FoeJob
foeByName icon_ name =
  icon_ ^? I._foes <. folded <. filtered (view _name >>> eq name)

viewEncounterPage :: Env -> Name -> Nut
viewEncounterPage env@{ encounters, icon } pathEnc =
  encounters <&> icon <#~> \(encs /\ icon_) ->
    let
      enc = encs ^. at pathEnc
      entries = enc ^:: _Just <. E._foes <. folded <.
        takeBoth identity (_name <. to (foeByName icon_))

    in
      D.div
        [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
        [ D.div
            [ css_ [ "flex", "items-center", "gap-x-2" ] ]
            [ enc # foldMap \c ->
                D.div
                  [ css_ [ "flex", "grow", "space-x-4" ] ]
                  [ D.h2
                      [ css_ [ "font-bold" ] ]
                      [ D.text_ $ c ^. _name <<< _Newtype ]
                  , D.span [] [ D.text_ "|" ]
                  , D.h3 []
                      [ D.text_ $ c ^. E._players <. to \p ->
                          show p <> " player" <> guard (p > 1) "s"
                      ]
                  ]

            , enc # foldMap \e ->
                D.button
                  [ css_ S.button
                  , DL.runOn_ DL.click $ do
                      e # env ^. _deleteEnc
                      (env ^. _navigate) (Encounters Nothing) Nothing
                  ]
                  [ D.text_ "Delete" ]

            , enc # foldMap \e ->
                D.a
                  [ css_ S.button
                  , DA.href_ $ print routeCodec
                      (Encounters $ Just $ EditEnc $ e ^. _name)
                  , DL.click_
                      $ (env ^. _navigate)
                          (Encounters $ Just $ EditEnc $ e ^. _name)
                      <<< pure
                  ]
                  [ D.text_ "Edit" ]

            , enc # foldMap (exportEncounter icon_ S.button)
            ]

        , D.div
            [ css_
                [ "flex"
                , "flex-col"
                , "sm:flex-row"
                , "overflow-hidden"
                -- , "gap-2"
                , "gap-x-4"
                , "gap-y-2"
                ]
            ]
            [ D.div
                [ css_
                    [ "flex"
                    , "flex-col"
                    , "flex-1"
                    , "shrink-0"
                    , "sm:min-w-3xs"
                    , "sm:max-w-xs"
                    , "max-h-fit"
                    , "sm:max-h-none"
                    , "overflow-y-auto"
                    -- , "p-2"
                    , "gap-2"
                    -- , "border"
                    -- , "border-solid"
                    -- , "border-rounded-sm"
                    -- , "border-sky-800"
                    ]
                ]
                [ guard (enc # has (_Just <. E._notes <. folded)) $ fixed
                    [ D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Notes" ]
                    , D.div
                        [ css_ [ "bg-stone-200", "dark:bg-stone-800" ] ]
                        [ enc ^. _Just <. E._notes <. folded <. to D.text_ ]
                    , hr
                    ]

                , D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Foes" ]
                , D.div
                    [ css_ [ "space-y-4" ] ]
                    [ entries # itraversed <. filtered (has (_1 <. E._Active)) #@~ foldMap (renderFoeSummary env icon_) enc
                    ]

                , guard (enc # has (_Just <. E._foes <. folded <. filtered (is E._Reserve))) $ fixed
                    [ hr
                    , D.h3 [ css_ [ "font-bold" ] ] [ D.text_ "Reserves" ]
                    , D.div
                        [ css_ [ "space-y-4" ] ]
                        [ entries # itraversed <. filtered (has (_1 <. E._Reserve)) #@~ foldMap (renderFoeSummary env icon_) enc
                        ]
                    ]
                ]

            , D.div [ css_ [ "sm:hidden" ] ] [ hr ]

            , D.div
                [ css_
                    [ "flex-2"
                    , "grid"
                    , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                    , "gap-x-4"
                    , "gap-y-6"
                    , "overflow-y-scroll"
                    -- , "p-2"
                    -- , "border"
                    -- , "border-solid"
                    -- , "border-rounded-sm"
                    -- , "border-sky-800"
                    ]
                ]
                [ entries
                    # nubBy (compare `on` view _2)
                    >>> foldMap (renderFoeEntry icon_)
                ]
            ]
        ]

renderFoeSummary :: Env -> Icon -> Encounter -> Int -> FoeEntry /\ Maybe FoeJob -> Nut
renderFoeSummary env icon@{ colours, factions, foeClasses, keywords } enc i (fe /\ foe) =
  let
    fef = factions
      ^? traversed <. filtered (preview _name >>> eq (fe ^. E._faction))
    fet = foeClasses
      ^? traversed <. filtered (preview _name >>> eq (fe ^. E._template))
    ff = factions
      ^? traversed <. filtered
        (preview _name >>> eq (foe ^? _Just <. J._faction <. _Just))
    cls = foeClasses
      ^? traversed <. filtered (preview _name >>> eq (foe ^? _Just <. _class))

  in
    fe # E._state <. itraversed #@~ \j state ->
      D.div
        [ css_ [ "bg-stone-200", "dark:bg-stone-800" ] ]
        [ D.div
            [ css_
                [ "flex"
                , "flex-wrap"
                , "justify-between"
                , "bg-stone-400"
                , "text-stone-800"
                , "dark:bg-stone-700"
                , "dark:text-stone-300"
                ]
            ]
            [ D.div
                [ css_ [ "flex", "items-center", "gap-x-1" ] ]
                [ fe # E._template <. _Just <. _Newtype #~ \tn ->
                    D.span
                      [ css_ [ "text-white", "font-bold" ]
                      , style_ $ fromMaybe (pure unit)
                          $ backgroundColor
                          <$> colours
                          ^? traversed
                            <. filtered (view _name >>> eq (Name "Purple"))
                            <. _value
                      ]
                      [ D.text_ tn ]

                , fe # E._faction <. _Just <. _Newtype #~ \fn ->
                    D.span
                      [ css_ [ "text-white", "font-bold" ]
                      , style_ $ fromMaybe (pure unit)
                          $ backgroundColor
                          <$> colours
                          ^? traversed
                            <. filtered (view _name >>> eq (Name "Purple"))
                            <. _value
                      ]
                      [ D.text_ fn ]

                , D.div
                    [ css_ [ "font-bold", "text-white" ]
                    , style_ $ fromMaybe (pure unit) $ backgroundColor <$>
                        colours ^? folded
                        <. filtered
                          (preview _name >>> eq (foe ^? _Just <. _colour))
                        <. _value
                    ]
                    [ D.text_ $ fe ^. _name <. _Newtype ]
                ]

            , fe # E._alias <. _Just #~ \fa ->
                D.span
                  [ css_ [ "mx-2", "italic" ] ]
                  [ D.text_ fa ]
            ]

        , D.div
            [ css_ [ "flex", "justify-between" ] ]
            [ D.span
                [ css_ [ "font-bold" ] ]
                [ D.text_ "HP: " ]

            , D.div
                [ css_ [ "flex" ] ] $
                let
                  hp = state ^. E._hp
                  max_ = (foe ^? _Just <. J._hp <. _Just)
                    <|> (cls ^? _Just <. C._hp)
                  max = if foe # has (_Just <. J._Legend)
                    then max_ * (enc ^? E._players)
                    else max_
                in
                  [ D.input
                      [ css_
                          [ "bg-stone-400"
                          , "text-stone-800"
                          , "dark:bg-stone-700"
                          , "dark:text-stone-300"
                          ]
                      , DA.xtypeNumber
                      , DA.min_ "0"
                      , DA.max_ $ max ^. _Just <. to show
                      , DA.value_ $ show hp
                      , DL.numberOn_ DL.change $ floor >>> \n ->
                          (env ^. _saveEnc)
                          (enc # E._foes <. ix i <. E._state <. ix j <. E._hp .~ n)
                      ]
                      []
                  , D.div
                      [ css_ $ [ "min-w-8", "text-right" ]
                          <> max ^. _Just <. to \m ->
                          if hp <= m / 4 then [ "text-red-500" ]
                          else if hp <= m / 2 then [ "text-orange-500" ]
                          else []
                      ]
                      [ D.text_ $ "/ " <> max ^. _Just <. to show ]
                  ]
            ]

        , D.div
            [ css_ [ "flex", "justify-between" ] ]
            [ D.span
                [ css_ [ "font-bold" ] ]
                [ D.text_ "Vigor: " ]

            , D.div
                [ css_ [ "flex" ] ] $
                let
                  vigor = state ^. E._vigor
                  hp = (foe ^? _Just <. J._hp <. _Just)
                    <|> (cls ^? _Just <. C._hp)
                  max = (foe ^? _Just <. J._maxVigor <. _Just)
                    <|> (cls ^? _Just <. C._maxVigor <. _Just)
                    <|> (hp ^? _Just <. to (_ / 4))
                in
                  [ D.input
                      [ css_
                          [ "bg-stone-400"
                          , "text-stone-800"
                          , "dark:bg-stone-700"
                          , "dark:text-stone-300"
                          ]
                      , DA.xtypeNumber
                      , DA.min_ "0"
                      , DA.max_ "99"
                      , DA.value_ $ show vigor
                      , DL.numberOn_ DL.change $ floor >>> \n ->
                          (env ^. _saveEnc)
                          (enc # E._foes <. ix i <. E._state <. ix j <. E._vigor .~ n)
                      ]
                      []
                  , D.div
                      [ css_ [ "min-w-8", "text-right" ] ]
                      [ D.text_ $ "/ " <> max ^. _Just <. to show ]
                  ]
            ]

        , D.div []
            [ D.div
                [ css_ [ "flex", "items-center", "justify-between", "space-x-2" ] ]
                [ D.span [ css_ [ "font-bold" ] ] [ D.text_ "Status" ]
                , Deku.do
                    setStatus /\ status <- useState'
                    let
                      renderOpt k =
                        D.option
                          [ DA.value_ $ k ^. _name <. _Newtype
                          , DA.selected $ "selected" <$ filter (eq (k ^. _name)) status
                          , DA.unset @"selected" $ filter (not <<< eq (k ^. _name)) status
                          ]
                          [ D.text_ $ k ^. _name <. _Newtype ]

                    D.div
                      [ css_ [ "flex", "items-center", "space-x-2" ] ]
                      [ D.select
                          [ css_ S.input
                          , DL.selectOn_ DL.change $ setStatus <<< Name
                          ] $
                          [ D.option [ DA.value_ "" ] [ D.text_ "--" ]
                          , D.optgroup
                              [ DA.label_ "Positive" ] $
                              keywords
                                ^:: traversed
                                <. filtered (has (_category <. _Status <. _Positive))
                                <. to renderOpt
                          , D.optgroup
                              [ DA.label_ "Negative" ] $
                              keywords
                                ^:: traversed
                                <. filtered (has (_category <. _Status <. _Negative))
                                <. to renderOpt
                          ]
                      , D.button
                          [ css_ $ S.interactable <> [ "w-6" ]
                          , DL.runOn DL.click $ status <#> \s -> do
                              (env ^. _saveEnc) $ enc #
                                E._foes <. ix i <. E._state <. ix j <. E._status
                                <. at s ?~ 0
                              setStatus (Name "")
                          ]
                          [ D.text_ "+" ]
                      ]
                ]
            , D.div
                [ css_ [ "ml-2" ] ]
                [ state # E._status <. itraversed #@~
                    renderStatus env enc i j 3
                ]
            ]

        {-
        , D.div []
            [ D.div
                [ css_ [ "flex", "items-center", "justify-between", "space-x-2" ] ]
                [ D.span [ css_ [ "font-bold" ] ] [ D.text_ "Mark" ]
                , Deku.do
                    setMark /\ mark <- useState'

                    D.div
                      [ css_ [ "flex", "items-center", "space-x-2" ] ]
                      [ D.input
                          [ css_ S.input
                          , DL.valueOn_ DL.change $ setMark
                          ]
                          []
                      , D.button
                          [ css_ $ S.interactable <> [ "w-6" ]
                          , DL.runOn DL.click $ status <#> \s -> do
                              (env ^. _saveEnc) $ enc #
                                E._foes <. ix i <. E._state <. ix j <. E._status
                                <. at s ?~ 0
                              setMark ""
                          ]
                          [ D.text_ "+" ]
                      ]
                ]
            , D.div
                [ css_ [ "ml-2" ] ]
                [ state # E._status <. itraversed #@~
                    renderStatus env enc i j 3
                ]
            ]
        -}
        ]

renderFoeEntry :: Icon -> FoeEntry /\ Maybe FoeJob -> Nut
renderFoeEntry icon@{ colours, factions, foeClasses } (fe /\ foe) =
  foe ^. _Just <. to \f ->
    let
      fef = factions
        ^? traversed
          <<< filtered (preview _name >>> eq (fe ^. E._faction))
      fet = foeClasses
        ^? traversed
          <<< filtered (preview _name >>> eq (fe ^. E._template))
      ff = factions
        ^? traversed
          <<< filtered (preview _name >>> eq (f ^. J._faction))
      cls = foeClasses
        ^? traversed
          <<< filtered (view _name >>> eq (f ^. _class))
      mcs = (fef ^:: _Just <. _mechanic) <> (ff ^:: _Just <. _mechanic)
      trs =
        (fet ^. _Just <. _trait)
          <>
            ( f ^:: filtered (has J._Elite) <. to \_ -> FoeTrait $ Trait
                { name: Name "Elite"
                , description: M.text "Takes 2 turns."
                }
            )
          <> (cls ^. _Just <. _trait)
          <> (f ^. _trait)
      abs =
        (fet ^. _Just <. _abilities)
          <> (cls ^. _Just <. _abilities)
          <> (f ^. _abilities)

    in
      D.div
        [ css_
            [ "flex"
            , "flex-col"
            , "flex-1"
            , "bg-stone-200"
            , "dark:bg-stone-800"
            ]
        ]
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
            [ D.div
                [ css_ [ "flex", "gap-x-1" ] ]
                [ fet # _Just <. _name <. _Newtype #~ \n ->
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
                      [ D.text_ n ]

                , fef # _Just <. _name <. _Newtype #~ \n ->
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
                      [ D.text_ n ]

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
                    [ D.text_ $ f ^. _name <. _Newtype ]

                ]

            , cls # foldMap \(FoeClass c) ->
                D.span
                  [ css_ [ "flex", "items-center", "gap-x-2", "mx-2" ] ]
                  [ D.span
                      [ css_ [ "flex", "items-center" ] ]
                      [ D.span
                          [ css_ [ "icon-[game-icons--checked-shield]" ]
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

        , D.div
            [ css_ [ "pl-2" ] ]
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

            , f ^. J._Legend <. J._phases <. to \ps ->
                D.div
                  [ css_ [ "flex", "flex-col", "gap-2", "px-4" ] ]
                  [ D.h4 [ css_ [ "font-bold" ] ] [ D.text_ "Phases" ]
                  , D.div [] [ markup icon $ ps ^. _desc ]
                  , hr
                  , D.div
                      [ css_ [ "flex", "gap-2" ] ]
                      $ ps ^. J._details
                      # mapWithIndex (renderPhase icon)
                  ]
            ]
        ]

renderFoeAbility :: Icon -> FoeAbility -> Nut
renderFoeAbility icon (FoeAbility fa) = renderAbility icon fa
renderFoeAbility icon (ChainAbility fas) = go fas
  where
  go = uncons >>> case _ of
    Nothing -> mempty
    Just { head, tail } ->
      renderAbility icon head <> guard (not $ null tail)
        (D.ul [ css_ [ "ml-4", "list-disc" ] ] [ D.li [] [ go tail ] ])

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
    , guard (M.length (p ^. _desc) > 0) hr

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

renderStatus :: Env -> Encounter -> Int -> Int -> Int -> Name -> Int -> Nut
renderStatus _ _ _ _ max _ _ | max <= 0 = D.div [] []
renderStatus env  enc i j max status n =
  let
    _status = E._foes <. ix i <. E._state <. ix j <. E._status
    setStatus = (env ^. _saveEnc) <<<
      (set (_status <. at status) ~$ enc)
  in
    D.div
      [ css_ [ "w-full", "flex", "items-center", "justify-between" ] ]
      [ D.div [] [ D.text_ $ status ^. simple _Newtype ]
      , D.div
          [ css_ [ "flex", "items-center", "space-x-2" ] ]
          [ D.div
              [ css_ [ "space-x-1" ] ]
              $ (1 .. max)
              <#> \x ->
                D.button
                  [ css_
                      [ "rounded"
                      , "size-[1em]"
                      , if n >= x then "bg-sky-600"
                        else "bg-stone-400 dark:bg-stone-700"
                      ]
                  , DL.runOn_ DL.click $
                      setStatus $ pure if n == x then x - 1 else x
                  ]
                  []
          , D.button
              [ css_ $ S.interactable <> [ "w-6" ]
              , DL.runOn_ DL.click $ setStatus Nothing
              ]
              [ D.text_ "-" ]
          ]
      ]
