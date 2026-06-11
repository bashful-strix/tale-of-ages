module ToA.Page.Encounter.View
  ( viewEncounterPage
  ) where

import ToA.Prelude

import CSS (backgroundColor)

import Data.Array ((..), nubBy, uncons)
import Data.Foldable (foldMap, null)
import Data.Function (on)
import Data.FunctorWithIndex (mapWithIndex)
import Data.Int (fromString, toNumber)
import Data.Lens
  ( (^.)
  , (^?)
  , (.~)
  , preview
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
import Data.Maybe (Maybe(..), fromMaybe, isNothing)
import Data.Map (empty)
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
import Web.HTML.Common as WC
import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Encounter (class Encounter, deleteEnc, saveEnc)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Icon (Icon)
import ToA.Data.Route (Route(..), EncounterPath(..), routeCodec)
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon as I
import ToA.Data.Icon.Ability (Tag(..), _abilities)
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Encounter (Encounter)
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
  ( FoeAbility(..)
  , _action
  , _steps
  , _tags
  )
import ToA.Data.Icon.Foe.Class (FoeClass(..))
import ToA.Data.Icon.Foe.Class (_hp, _maxVigor) as C
import ToA.Data.Icon.Foe.Faction (_mechanic)
import ToA.Data.Icon.Foe.Job (FoeJob)
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

import ToA.Util.Html (css, hr)
import ToA.Util.Optic ((^::), (#~), (#@~))
import ToA.Util.Style as S

foeByName :: Icon -> Name -> Maybe FoeJob
foeByName icon_ name =
  icon_ ^? I._foes <. folded <. filtered (view _name >>> eq name)

data Action
  = Receive (Connected Store Name)
  | Navigate Route (Maybe MouseEvent)
  | SetHp Int Int String
  | SetVigour Int Int String
  | SetStatuses Int Int (Maybe Name)
  | AddStatus Int Int (Maybe Name)
  | SetStatus Int Int Name (Maybe Int)
  | DeleteEnc Encounter

viewEncounterPage
  :: ∀ q o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Encounter m
  => Navigate m
  => H.Component q Name o m
viewEncounterPage =
  connect selectAll $ H.mkComponent
    { initialState: \{ context: { encounters, icon }, input } ->
        { icon, enc: encounters ^. at input, statuses: empty }
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where

  act = case _ of
    Receive { context: { encounters, icon }, input } ->
      H.modify_ _ { icon = icon, enc = encounters ^. at input }
    Navigate r e -> navigate r e
    DeleteEnc e -> do
      deleteEnc e
      navigate (Encounters Nothing) Nothing

    SetHp i j hpStr ->
      H.gets _.enc >>= (_ /\ fromString hpStr) >>> case _ of
        Just enc /\ Just hp -> saveEnc $ enc
          # E._foes <. ix i <. E._state <. ix j <. E._hp .~ hp
        _ -> pure unit
    SetVigour i j vigStr ->
      H.gets _.enc >>= (_ /\ fromString vigStr) >>> case _ of
        Just enc /\ Just vigour -> saveEnc $ enc
          # E._foes <. ix i <. E._state <. ix j <. E._vigor .~ vigour
        _ -> pure unit

    SetStatuses i j status ->
      H.modify_ \s -> s { statuses = s.statuses # at (i /\ j) .~ status }
    SetStatus i j status n ->
      H.gets _.enc >>= foldMap \enc -> saveEnc $ enc
        # E._foes <. ix i <. E._state <. ix j <. E._status <. at status .~ n
    AddStatus i j mstatus -> mstatus # foldMap \status -> do
      act (SetStatuses i j Nothing)
      act (SetStatus i j status $ pure 0)

  render { icon, enc, statuses } =
    let
      entries = enc ^:: _Just <. E._foes <. folded <.
        takeBoth identity (_name <. to (foeByName icon))

    in
      HD.div
        [ css [ "flex", "flex-col", "grow", "gap-2" ] ]
        [ HD.div
            [ css [ "flex", "items-center", "gap-x-2" ] ] $ join
            [ enc # foldMap \c -> pure $
                HD.div
                  [ css [ "flex", "grow", "space-x-4" ] ]
                  [ HD.h2
                      [ css [ "font-bold" ] ]
                      [ HD.text $ c ^. _name <<< _Newtype ]
                  , HD.span [] [ HD.text "|" ]
                  , HD.h3 []
                      [ HD.text $ c ^. E._players <. to \p ->
                          show p <> " player" <> guard (p > 1) "s"
                      ]
                  ]

            , enc # foldMap \e -> pure $
                HD.button
                  [ css S.button
                  , HP.type_ HP.ButtonButton
                  , HE.onClick \_ -> DeleteEnc e
                  ]
                  [ HD.text "Delete" ]

            , enc # foldMap \e -> pure $
                HD.a
                  [ css S.button
                  , HP.href $ print routeCodec
                      (Encounters $ Just $ EditEnc $ e ^. _name)
                  , HE.onClick $ Navigate
                      (Encounters $ Just $ EditEnc $ e ^. _name) <<< pure
                  ]
                  [ HD.text "Edit" ]

            , enc # foldMap \e -> pure $
                HD.slot_ (Proxy :: _ "exportEnc") unit (exportEncounter [] [] e)
                  unit
            ]

        , HD.div
            [ css
                [ "flex"
                , "flex-col"
                , "sm:flex-row"
                , "overflow-hidden"
                -- , "gap-2"
                , "gap-x-4"
                , "gap-y-2"
                ]
            ]
            [ HD.div
                [ css
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
                ] $ join
                [ guard (enc # has (_Just <. E._notes <. folded)) $
                    [ HD.h3 [ css [ "font-bold" ] ] [ HD.text "Notes" ]
                    , HD.div
                        [ css [ "bg-stone-200", "dark:bg-stone-800" ] ]
                        [ HD.text $ enc ^. _Just <. E._notes <. folded ]
                    , hr
                    ]

                , [ HD.h3 [ css [ "font-bold" ] ] [ HD.text "Foes" ]
                  , HD.div
                      [ css [ "space-y-4" ] ]
                      $ entries # itraversed <. filtered (has (_1 <. E._Active)) #@~ foldMap (renderFoeSummary icon statuses) enc
                  ]

                , guard (enc # has (_Just <. E._foes <. folded <. filtered (is E._Reserve)))
                    [ hr
                    , HD.h3 [ css [ "font-bold" ] ] [ HD.text "Reserves" ]
                    , HD.div
                        [ css [ "space-y-4" ] ]
                        $ entries # itraversed <. filtered (has (_1 <. E._Reserve)) #@~ foldMap (renderFoeSummary icon statuses) enc
                    ]
                ]

            , HD.div [ css [ "sm:hidden" ] ] [ hr ]

            , HD.div
                [ css
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
                $ entries # nubBy (compare `on` view _2)
                    >>> foldMap (renderFoeEntry icon)
            ]
        ]

  renderFoeSummary
    icon@{ colours, factions, foeClasses, keywords }
    statuses
    enc
    i
    (fe /\ foe) =
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
      fe # E._state <. itraversed #@~ \j state -> pure $
        HD.div
          [ css [ "bg-stone-200", "dark:bg-stone-800" ] ]
          [ HD.div
              [ css
                  [ "flex"
                  , "flex-wrap"
                  , "justify-between"
                  , "bg-stone-400"
                  , "text-stone-800"
                  , "dark:bg-stone-700"
                  , "dark:text-stone-300"
                  ]
              ] $ join
              [ [ HD.div
                    [ css [ "flex", "items-center", "gap-x-1" ] ] $ join
                    [ fe # E._template <. _Just <. _Newtype #~ \tn -> pure $
                        HD.span
                          [ css [ "text-white", "font-bold" ]
                          , style $ fromMaybe (pure unit)
                              $ backgroundColor
                              <$> colours
                              ^? traversed
                                <. filtered (view _name >>> eq (Name "Purple"))
                                <. _value
                          ]
                          [ HD.text tn ]

                    , fe # E._faction <. _Just <. _Newtype #~ \fn -> pure $
                        HD.span
                          [ css [ "text-white", "font-bold" ]
                          , style $ fromMaybe (pure unit)
                              $ backgroundColor
                              <$> colours
                              ^? traversed
                                <. filtered (view _name >>> eq (Name "Purple"))
                                <. _value
                          ]
                          [ HD.text fn ]

                    , [ HD.div
                          [ css [ "font-bold", "text-white" ]
                          , style $ fromMaybe (pure unit) $ backgroundColor <$>
                              colours ^? folded
                              <. filtered
                                (preview _name >>> eq (foe ^? _Just <. _colour))
                              <. _value
                          ]
                          [ HD.text $ fe ^. _name <. _Newtype ]
                      ]
                    ]
                ]

              , fe # E._alias <. _Just #~ \fa -> pure $
                  HD.span
                    [ css [ "mx-2", "italic" ] ]
                    [ HD.text fa ]
              ]

          , HD.div
              [ css [ "flex", "justify-between" ] ]
              [ HD.span
                  [ css [ "font-bold" ] ]
                  [ HD.text "HP: " ]

              , HD.div
                  [ css [ "flex" ] ] $
                  let
                    hp = state ^. E._hp
                    max_ = (foe ^? _Just <. J._hp <. _Just)
                      <|> (cls ^? _Just <. C._hp)
                    max = if foe # has (_Just <. J._Legend)
                      then max_ * (enc ^? E._players)
                      else max_
                  in
                    [ HD.input
                        [ css
                            [ "bg-stone-400"
                            , "text-stone-800"
                            , "dark:bg-stone-700"
                            , "dark:text-stone-300"
                            ]
                        , HP.type_ HP.InputNumber
                        , HP.min 0.0
                        , HP.max $ toNumber $ fromMaybe 0 max
                        , HP.value $ show hp
                        , HE.onValueChange $ SetHp i j
                        ]
                    , HD.div
                        [ css $ [ "min-w-8", "text-right" ]
                            <> max ^. _Just <. to \m ->
                            if hp <= m / 4 then [ "text-red-500" ]
                            else if hp <= m / 2 then [ "text-orange-500" ]
                            else []
                        ]
                        [ HD.text $ "/ " <> max ^. _Just <. to show ]
                    ]
              ]

          , HD.div
              [ css [ "flex", "justify-between" ] ]
              [ HD.span
                  [ css [ "font-bold" ] ]
                  [ HD.text "Vigor: " ]

              , HD.div
                  [ css [ "flex" ] ] $
                  let
                    vigour = state ^. E._vigor
                    hp = (foe ^? _Just <. J._hp <. _Just)
                      <|> (cls ^? _Just <. C._hp)
                    max = (foe ^? _Just <. J._maxVigor <. _Just)
                      <|> (cls ^? _Just <. C._maxVigor <. _Just)
                      <|> (hp ^? _Just <. to (_ / 4))
                  in
                    [ HD.input
                        [ css
                            [ "bg-stone-400"
                            , "text-stone-800"
                            , "dark:bg-stone-700"
                            , "dark:text-stone-300"
                            ]
                        , HP.type_ HP.InputNumber
                        , HP.min 0.0
                        , HP.max 99.0
                        , HP.value $ show vigour
                        , HE.onValueChange $ SetVigour i j
                        ]
                    , HD.div
                        [ css [ "min-w-8", "text-right" ] ]
                        [ HD.text $ "/ " <> max ^. _Just <. to show ]
                    ]
              ]

          , HD.div []
              [ HD.div
                  [ css [ "flex", "items-center", "justify-between", "space-x-2" ] ]
                  [ HD.span [ css [ "font-bold" ] ] [ HD.text "Status" ]

                  , let
                      status = statuses ^. at (i /\ j)
                      renderOpt k =
                        HD.option
                          [ HP.value $ k ^. _name <. _Newtype
                          , HP.selected $ k ^? _name == status
                          ]
                          [ HD.text $ k ^. _name <. _Newtype ]
                    in
                      HD.div
                        [ css [ "flex", "items-center", "space-x-2" ] ]
                        [ HD.select
                            [ css S.input
                            , HE.onValueChange
                                $ SetStatuses i j <<< pure <<< Name
                            ]
                            [ HD.option [ HP.value "" ] [ HD.text "--" ]
                            , HD.optgroup
                                [ HP.prop (WC.PropName "label") "Positive" ] $
                                keywords
                                  ^:: traversed
                                  <. filtered (has (_category <. _Status <. _Positive))
                                  <. to renderOpt
                            , HD.optgroup
                                [ HP.prop (WC.PropName "label") "Negative" ] $
                                keywords
                                  ^:: traversed
                                  <. filtered (has (_category <. _Status <. _Negative))
                                  <. to renderOpt
                            ]
                        , HD.button
                            [ css $ S.interactable <> [ "w-6" ]
                            , HP.disabled $ isNothing status
                            , HE.onClick \_ -> AddStatus i j status
                            ]
                            [ HD.text "+" ]
                        ]
                  ]

              , HD.div
                  [ css [ "ml-2" ] ]
                  $ state # E._status <. itraversed #@~
                      pure <.. renderStatus i j 3
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

  renderFoeEntry icon@{ colours, factions, foeClasses } (fe /\ foe) =
    foe ^. _Just <. to \f -> pure $
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
        HD.div
          [ css
              [ "flex"
              , "flex-col"
              , "flex-1"
              , "bg-stone-200"
              , "dark:bg-stone-800"
              ]
          ]
          [ HD.div
              [ css
                  [ "flex"
                  , "justify-between"
                  , "bg-stone-400"
                  , "text-stone-800"
                  , "dark:bg-stone-700"
                  , "dark:text-stone-300"
                  ]
              ] $ join
              [ [ HD.div
                    [ css [ "flex", "gap-x-1" ] ] $ join
                    [ fet # _Just <. _name <. _Newtype #~ \n -> pure $
                        HD.span
                          [ css [ "text-white", "font-bold" ]
                          , style $ fromMaybe (pure unit) $ backgroundColor
                              <$> colours
                              ^? traversed
                                <<< filtered
                                  (view _name >>> eq (Name "Purple"))
                                <<< _value
                          ]
                          [ HD.text n ]

                    , fef # _Just <. _name <. _Newtype #~ \n -> pure $
                        HD.span
                          [ css [ "text-white", "font-bold" ]
                          , style $ fromMaybe (pure unit) $ backgroundColor
                              <$> colours
                              ^? traversed
                                <<< filtered
                                  (view _name >>> eq (Name "Purple"))
                                <<< _value
                          ]
                          [ HD.text n ]

                    , [ HD.span
                          [ css [ "text-white", "font-bold" ]
                          , style $ fromMaybe (pure unit) $ backgroundColor
                              <$> colours
                              ^? traversed
                                <<< filtered (view _name >>> eq (f ^. _colour))
                                <<< _value
                          ]
                          [ HD.text $ f ^. _name <. _Newtype ]
                      ]
                    ]
                ]

              , cls # foldMap \(FoeClass c) -> pure $
                  HD.span
                    [ css [ "flex", "items-center", "gap-x-2", "mx-2" ] ]
                    [ HD.span
                        [ css [ "flex", "items-center" ] ]
                        [ HD.span
                            [ css [ "icon-[game-icons--checked-shield]" ]
                            , HP.title "Defense"
                            ]
                            []
                        , HD.span [] [ HD.text $ show c.defense ]
                        ]
                    , HD.span
                        [ css [ "flex", "items-center" ] ]
                        [ HD.span
                            [ css [ "icon-[game-icons--wingfoot]" ]
                            , HP.title "Free move"
                            ]
                            []
                        , HD.span [] [ HD.text $ show c.move ]
                        ]
                    ]
              ]

          , HD.div
              [ css [ "pl-2" ] ] $ join
              [ [ HD.div
                    [ css [ "flex", "flex-col", "gap-2" ] ]
                    $ mcs
                    <#> \m ->
                      HD.div []
                        [ HD.div
                            [ css [ "font-bold" ] ]
                            [ HD.text $ m ^. _name <. _Newtype ]
                        , markup icon $ m ^. _desc
                        ]
                ]

              , guard (not $ null mcs) [ hr ]

              , [ HD.div
                    [ css [ "flex", "flex-col", "gap-2" ] ]
                    $ trs
                    ^:: folded
                    <. filtered (has _FoeTrait)
                    <. to (renderTrait icon)
                ]

              , guard (trs # has (folded <. _FoeTrait)) [ hr ]

              , [ HD.div
                    [ css [ "flex", "flex-col", "gap-2" ] ]
                    $ trs
                    ^:: folded
                    <. filtered (has _RoundAction)
                    <. to (renderTrait icon)
                ]

              , guard (trs # has (folded <. _RoundAction)) [ hr ]

              , [ HD.div
                    [ css [ "flex", "flex-col", "gap-2" ] ]
                    $ abs >>= renderFoeAbility icon
                ]

              , f ^. J._Legend <. J._phases <. to \ps -> pure $
                  HD.div
                    [ css [ "flex", "flex-col", "gap-2", "px-4" ] ]
                    [ HD.h4 [ css [ "font-bold" ] ] [ HD.text "Phases" ]
                    , HD.div [] [ markup icon $ ps ^. _desc ]
                    , hr
                    , HD.div
                        [ css [ "flex", "gap-2" ] ]
                        $ ps ^. J._details
                        # mapWithIndex (renderPhase icon)
                    ]
              ]
          ]

  renderFoeAbility icon (FoeAbility fa) = [ renderAbility icon fa ]
  renderFoeAbility icon (ChainAbility fas) = go fas
    where
    go = uncons >>> case _ of
      Nothing -> mempty
      Just { head, tail } ->
        [ renderAbility icon head ] <> guard (not $ null tail)
          [ HD.ul [ css [ "ml-4", "list-disc" ] ] [ HD.li [] $ go tail ] ]

  renderAbility icon a =
    HD.div
      [ css [ "flex", "flex-col", "gap-y-1" ] ]
      [ HD.div
          [ css
              [ "flex"
              , "justify-between"
              , "bg-stone-400"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              ]
          ]
          [ HD.h3
              [ css [ "text-white", "font-bold" ] ]
              [ HD.text $ a ^. _name <<< _Newtype ]
          , HD.div
              [ css [ "flex", "items-center", "gap-2", "mr-2" ] ] $ join
              [ a
                  ^. _tags
                    <<< traversed
                    <<< filtered (has $ only Attack)
                    <<< to \_ -> [ renderAttackSign ]
              , [ renderActionSign $ a ^. _action ]
              ]
          ]

      , HD.div
          [ css [ "flex", "flex-wrap", "gap-1" ] ] $ join
          [ a # _action #~ pure <<< renderCost
          , a # _tags <<< traversed #~ pure <<< renderTag
          ]

      , renderSteps icon $ a ^. _steps
      ]

  renderPhase icon i p =
    HD.div [] $ join
      [ [ HD.div
            [ css [ "font-bold" ] ]
            [ HD.text $ "Phase " <> show (i + 1) ]
        ]

      , [ markup icon $ p ^. _desc ]

      , guard (M.length (p ^. _desc) > 0) [ hr ]

      , [ HD.div
            [ css [ "flex", "flex-col", "gap-2" ] ]
            $ p
            ^:: _trait
            <. folded
            <. filtered (has _FoeTrait)
            <. to (renderTrait icon)
        ]

      , guard (p # has (_trait <. folded <. _FoeTrait)) [ hr ]

      , [ HD.div
            [ css [ "flex", "flex-col", "gap-2" ] ]
            $ p
            ^:: _trait
            <. folded
            <. filtered (has _RoundAction)
            <. to (renderTrait icon)
        ]

      , guard (p # has (_trait <. folded <. _RoundAction)) [ hr ]

      , [ HD.div
            [ css [ "flex", "flex-col", "gap-2" ] ]
            $ p ^. _abilities >>= renderFoeAbility icon
        ]
      ]

  renderTrait icon ft =
    HD.div []
      [ HD.div
          [ css [ "font-bold" ] ]
          [ HD.text
              $ ft ^. _trait <. _name <. _Newtype
              <> guard (ft # is _RoundAction) " (Round Action)"
          ]
      , markup icon $ ft ^. _trait <. _desc
      ]

  renderStatus _ _ max _ _ | max <= 0 = HD.div [] []
  renderStatus i j max status n =
    HD.div
      [ css [ "w-full", "flex", "items-center", "justify-between" ] ]
      [ HD.div [] [ HD.text $ status ^. simple _Newtype ]
      , HD.div
          [ css [ "flex", "items-center", "space-x-2" ] ]
          [ HD.div
              [ css [ "space-x-1" ] ]
              $ (1 .. max)
              <#> \x ->
                HD.button
                  [ css
                      [ "rounded"
                      , "size-[1em]"
                      , if n >= x then "bg-sky-600"
                        else "bg-stone-400 dark:bg-stone-700"
                      ]
                  , HP.type_ HP.ButtonButton
                  , HE.onClick \_ -> SetStatus i j status $ pure
                      if n == x then x - 1 else x
                  ]
                  []
          , HD.button
              [ css $ S.interactable <> [ "w-6" ]
              , HP.type_ HP.ButtonButton
              , HE.onClick \_ -> SetStatus i j status Nothing
              ]
              [ HD.text "-" ]
          ]
      ]
