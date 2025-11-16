module ToA.Component.Ability
  ( renderAbility
  , renderStep
  ) where

import Prelude

import CSS (backgroundColor, render, renderedInline)

import Data.Foldable (foldMap, intercalate, length)
import Data.Lens ((^.), (^?), filtered, to, traversed, view)
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

renderStep :: Icon -> Step -> Nut
renderStep icon@{ abilities, summons } = case _ of
  Step d s ->
    D.li [] [ renderStepName icon d s, renderStepDesc icon s ]
  SubStep d n s ->
    D.li []
      [ renderStepName icon d s
      , renderStepDesc icon s
      , D.div
          [ css_ [ "pl-8" ] ]
          [ abilities
              # traversed
                  <<< filtered (view _name >>> eq n)
                    #~ renderAbility icon
          ]
      ]
  SummonStep d n s ->
    D.li []
      [ renderStepName icon d s
      , renderStepDesc icon s
      , summons
          # traversed
              <<< filtered (eq n)
              <<< _Newtype
                #~ D.text_
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
