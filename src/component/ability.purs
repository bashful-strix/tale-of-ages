module ToA.Component.Ability
  ( renderAbility
  , renderCost
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
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , SubItem(..)
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
import ToA.Util.Optic ((^::), (#~))
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
                        Close -> "Close"
                        RangeTag r -> case r of
                          Range i j -> "Range " <> show i <> "-" <> show j
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
                        KeywordTag k -> k ^. simple _Newtype
                        LimitTag n l -> show n <> "/" <> l
                    )
            ]
        ]

    , D.div [ css_ [ "italic" ] ] [ markup icon $ a ^. _desc ]

    , D.div []
        [ D.ol
            [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
            $ a ^:: _steps <<< traversed <<< to (renderStep icon)
        ]
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
  Close -> "Close"
  RangeTag r -> case r of
    Range i j -> "Range " <> show i <> "-" <> show j
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
  KeywordTag k -> k ^. simple _Newtype
  LimitTag n l -> show n <> "/" <> l

renderStep :: Icon -> Step -> Nut
renderStep icon = case _ of
  Step d s ->
    D.li [] [ renderStepName icon d s, renderStepDesc icon s ]
  SubStep d sub s ->
    D.li []
      [ renderStepName icon d s
      , renderStepDesc icon s
      , D.div
          [ css_ [ "pl-8" ] ]
          [ renderSubItem icon sub ]
      ]

renderSubItem :: Icon -> SubItem -> Nut
renderSubItem icon@{ colours } = case _ of
  SummonItem si ->
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
      , D.div []
          [ D.ol
              [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
              $ si.actions <#> \act ->
                  D.li []
                    [ D.span
                        [ css_ [ "font-bold" ] ]
                        [ D.text_ "Summon action: " ]
                    , markup icon act
                    ]
          ]
      , D.div []
          [ D.ol
              [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
              $ si.effects <#> \eff ->
                  D.li []
                    [ D.span
                        [ css_ [ "font-bold" ] ]
                        [ D.text_ "Summon effect: " ]
                    , markup icon eff
                    ]
          ]
      ]

  AbilityItem ai ->
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

  KeywordItem ki ->
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

renderStepName :: Icon -> Maybe Die -> StepType -> Nut
renderStepName icon d s =
  D.span
    [ css_ [ "font-bold" ] ]
    [ case s of
        Eff _ -> D.text_ "Effect"
        AttackStep _ _ -> D.text_ "Attack"
        OnHit _ -> D.text_ "On hit"
        AreaEff _ -> D.text_ "Area effect"
        KeywordStep k _ -> D.text_ $ k ^. simple _Newtype
        TriggerStep _ -> D.text_ "Trigger"
        OtherStep k _ -> markup icon k
    , D.text_ $ foldMap (const " [X]") d
    , D.text_ ": "
    ]

renderStepDesc :: Icon -> StepType -> Nut
renderStepDesc icon s =
  D.span []
    [ case s of
        Eff t -> markup icon t
        AttackStep m h ->
          D.span []
            [ markup icon m
            , D.span [] [ D.text_ "." ]
            , guard (length h > 0) $
                D.span []
                  [ D.span [ css_ [ "italic" ] ] [ D.text_ " Hit: " ]
                  , markup icon h
                  ]
            ]
        OnHit t -> markup icon t
        AreaEff t -> markup icon t
        KeywordStep _ t -> markup icon t
        TriggerStep t -> markup icon t
        OtherStep _ t -> markup icon t
    ]
