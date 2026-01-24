module ToA.Component.Ability
  ( renderAbility
  , renderCost
  , renderInset
  , renderStep
  , renderTags
  ) where

import Prelude

import CSS (backgroundColor, lighten, render, renderedInline)

import Data.Foldable (foldMap, intercalate, length)
import Data.Lens ((^.), (^?), filtered, has, only, to, traversed, view)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe, fromMaybe)
import Data.Monoid (guard)

import Deku.Core (Nut)
import Deku.DOM as D
import Deku.DOM.Attributes as DA

import ToA.Component.Markup (markup)
import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Ability
  , Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  , _action
  , _resolve
  , _steps
  , _tags
  )
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Name (_name)
import ToA.Util.Optic ((#~))
import ToA.Util.Html (css_)

renderAbility :: Icon -> Ability -> Nut
renderAbility icon@{ colours } a =
  D.div
    [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
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
        [ D.h3
            [ css_ [ "text-white", "font-bold" ]
            , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                backgroundColor <$> colours
                  ^? traversed
                    <<< filtered (view _name >>> eq (a ^. _colour))
                    <<< _value
            ]
            [ D.text_ $ a ^. _name <<< _Newtype ]
        , D.div
            [ css_ [ "flex", "items-center", "gap-2", "mr-2" ] ]
            [ a
                ^. _tags
                  <<< traversed
                  <<< filtered (has $ only Attack)
                  <<< to \_ ->
                    D.span
                      [ css_ [ "icon-[game-icons--crossed-swords]" ]
                      , DA.title_ "Attack"
                      ]
                      []
            , a ^. _action <<< to case _ of
                Quick ->
                  D.span
                    [ css_ [ "icon-[game-icons--quick-slash]" ]
                    , DA.title_ "Quick"
                    ]
                    []
                One ->
                  D.span
                    [ css_ [ "icon-[game-icons--serrated-slash]" ]
                    , DA.title_ "1 action"
                    ]
                    []
                Two ->
                  D.span
                    [ css_ [ "flex" ]
                    , DA.title_ "2 actions"
                    ]
                    [ D.span [ css_ [ "icon-[game-icons--serrated-slash]" ] ] []
                    , D.span [ css_ [ "icon-[game-icons--serrated-slash]" ] ] []
                    ]
                Interrupt n ->
                  D.span
                    [ css_ [ "icon-[game-icons--divert]" ]
                    , DA.title_ $ "Interrupt " <> show n
                    ]
                    []
            ]
        ]

    , D.div
        []
        [ D.span []
            [ D.text_ $ intercalate ", " $
                [ a # _action #~ case _ of
                    Quick -> "Quick"
                    One -> "1 action"
                    Two -> "2 actions"
                    Interrupt n -> "Interrupt " <> show n
                ]
                  <> (a # _resolve #~ pure <<< (_ <> " resolve") <<< show)
                  <>
                    ( a # _tags <<< traversed #~ pure <<< case _ of
                        Attack -> "Attack"
                        End -> "End"
                        RangeTag r -> case r of
                          Range i j -> "Range " <> show i <> "-" <> show j
                          Close -> "Close"
                          Melee -> "Melee"
                          Adjacent -> "Adjacent"
                        AreaTag p -> case p of
                          Line n -> "Line " <> show n
                          Arc n -> "Arc " <> show n
                          Blast n -> "Blast " <> show n
                          Burst n x -> "Burst " <> show n <> " ("
                            <> (if x then "self" else "target")
                            <> ")"
                          Cross n -> "Cross " <> show n
                        TargetTag t -> case t of
                          Self -> "Self"
                          Ally -> "Ally"
                          Foe -> "Foe"
                          Summon -> "Summon"
                          Space -> "Space"
                          Object -> "Object"
                          Character -> "Character"
                        KeywordTag k -> k ^. simple _Newtype
                        LimitTag n l -> show n <> "/" <> l
                    )
            ]
        ]

    , D.div [ css_ [ "italic" ] ] [ markup icon $ a ^. _desc ]

    , renderSteps icon $ a ^. _steps
    ]

renderCost :: Action -> String
renderCost = case _ of
  Quick -> "Quick"
  One -> "1 action"
  Two -> "2 actions"
  Interrupt n -> "Interrupt " <> show n

renderTags :: Array Tag -> Array String
renderTags = map case _ of
  Attack -> "Attack"
  End -> "End"
  RangeTag r -> case r of
    Range i j -> "Range " <> show i <> "-" <> show j
    Close -> "Close"
    Melee -> "Melee"
    Adjacent -> "Adjacent"
  AreaTag p -> case p of
    Line n -> "Line " <> show n
    Arc n -> "Arc " <> show n
    Blast n -> "Blast " <> show n
    Burst n x -> "Burst " <> show n
      <> " ("
      <> (if x then "self" else "target")
      <> ")"
    Cross n -> "Cross " <> show n
  TargetTag t -> case t of
    Self -> "Self"
    Ally -> "Ally"
    Foe -> "Foe"
    Summon -> "Summon"
    Space -> "Space"
    Object -> "Object"
    Character -> "Character"
  KeywordTag k -> k ^. simple _Newtype
  LimitTag n l -> show n <> "/" <> l

renderSteps :: Icon -> Array Step -> Nut
renderSteps icon steps =
  D.div []
    [ D.ol
        [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
        $ renderStep icon <$> steps
    ]

renderStep :: Icon -> Step -> Nut
renderStep icon = case _ of
  Step s d t ->
    D.li [] [ renderStepName icon s d, D.span [] [ markup icon t ] ]
  AttackStep m h ->
    D.li []
      [ D.span []
          [ D.span
              [ css_ [ "font-bold" ] ]
              [ D.text_ "Attack" ]
          , D.text_ ": "
          ]
      , D.span []
          [ markup icon m
          , D.span [] [ D.text_ "." ]
          , guard (length h > 0) $
              D.span []
                [ D.span [ css_ [ "italic" ] ] [ D.text_ " Hit: " ]
                , markup icon h
                ]
          ]
      ]
  InsetStep d s t ins ->
    D.li []
      [ renderStepName icon d s
      , D.span [] [ markup icon t]
      , D.div
          [ css_ [ "pl-8" ] ]
          [ renderInset icon ins ]
      ]

renderStepName :: Icon -> StepType -> Maybe Die -> Nut
renderStepName icon s d =
  D.span
    [ css_ [ "font-bold" ] ]
    [ label s
    , D.text_ $ foldMap (const " [X]") d
    , D.text_ ": "
    ]
  where
  label = case _ of
    Eff -> D.text_ "Effect"
    OnHit -> D.text_ "On hit"
    AreaEff -> D.text_ "Area effect"
    TriggerStep -> D.text_ "Trigger"
    KeywordStep k -> D.text_ $ k ^. simple _Newtype
    VariableKeywordStep k n ->
      D.text_ $ k ^. simple _Newtype <> " " <> show n
    AltStep ss ->
      intercalate
        (D.span [ css_ [ "font-normal" ] ] [ D.text_ ", or " ])
        (label <$> ss)
    SummonEff -> D.text_ "Summon effect"
    SummonAction -> D.text_ "Summon action"
    OtherStep k -> markup icon k

renderInset :: Icon -> Inset -> Nut
renderInset icon@{ colours } = case _ of
  SummonInset si ->
    D.div
      [ css_ [ "ml-8" ] ]
      [ D.div
          [ css_
              [ "flex"
              , "gap-x-1"
              , "bg-stone-500"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              ]
          ]
          [ D.span
              [ css_ [ "text-white", "font-bold" ]
              , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                  (backgroundColor <<< lighten 0.2) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq si.colour)
                      <<< _value
              ]
              [ D.text_ $ si.name ^. simple _Newtype ]
          ]
      , D.div
          [ css_ [ "italic" ] ]
          [ D.text_ $ "Summon (" <> show si.max <> ")" ]
      , renderSteps icon si.abilities
      ]

  AbilityInset ai ->
    D.div
      [ css_ [ "ml-8" ] ]
      [ D.div
          [ css_
              [ "flex"
              , "gap-x-1"
              , "bg-stone-500"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              ]
          ]
          [ D.span
              [ css_ [ "text-white", "font-bold" ]
              , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                  (backgroundColor <<< lighten 0.2) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq ai.colour)
                      <<< _value
              ]
              [ D.text_ $ ai.name ^. simple _Newtype ]
          ]
      , D.div
          [ css_ [ "italic" ] ]
          [ D.text_ $ intercalate ", " $
              [ renderCost ai.cost ] <> renderTags ai.tags
          ]
      , D.div []
          [ D.ol
              [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
              $ ai.steps <#> renderStep icon
          ]
      ]

  KeywordInset ki ->
    D.div
      [ css_ [ "ml-8" ] ]
      [ D.div
          [ css_
              [ "flex"
              , "gap-x-1"
              , "bg-stone-500"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              ]
          ]
          [ D.span
              [ css_ [ "text-white", "font-bold" ]
              , DA.style_ $ fromMaybe "" $ renderedInline $ render =<<
                  (backgroundColor <<< lighten 0.2) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq ki.colour)
                      <<< _value
              ]
              [ D.text_ $ ki.name ^. simple _Newtype ]
          ]
      , D.div
          [ css_ [ "italic" ] ]
          [ D.text_ $ ki.keyword ^. simple _Newtype ]
      , D.div []
          [ D.ol
              [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
              $ ki.steps <#> renderStep icon
          ]
      ]
