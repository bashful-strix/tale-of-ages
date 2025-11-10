module ToA.Component.Ability
  ( renderAbility
  ) where

import Prelude

import Data.Foldable (foldMap, intercalate)
import Data.Lens ((^.), traversed)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)

import Deku.Core (Nut)
import Deku.DOM as D

import ToA.Data.Icon.Ability
  ( Ability
  , Action(..)
  , Damage(..)
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
import ToA.Component.Markup (markup)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Name (_name)
import ToA.Util.Optic ((#~))
import ToA.Util.Html (css_)

renderAbility :: Ability -> Nut
renderAbility a =
  D.div
    [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
    [ D.h3
        [ css_ [ "bg-red-600", "text-white", "font-bold" ] ]
        [ D.text_ $ a ^. _name <<< _Newtype ]

    , D.div
        []
        [ D.span []
            [ D.text_
                $ intercalate ", "
                $
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
                            Burst n x -> "Burst " <> show n <> "("
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
                      )
            ]
        ]

    , D.div [ css_ [ "italic" ] ] [ markup $ a ^. _desc ]

    , D.div []
        [ D.ol
            [ css_ [ "flex", "flex-col", "gap-y-1" ] ]
            $ a # _steps <<< traversed #~ pure <<< \(Step d s) ->
                D.li
                  []
                  [ D.span
                      [ css_ [ "font-bold" ] ]
                      [ case s of
                          Eff _ -> D.text_ "Effect"
                          AttackStep _ _ -> D.text_ "Attack"
                          OnHit _ -> D.text_ "On hit"
                          AreaEff _ -> D.text_ "Area effect"
                          KeywordStep k _ -> D.text_ $ k ^. simple _Newtype
                          TriggerStep _ -> D.text_ "Trigger"
                          OtherStep k _ -> markup k
                      , D.text_ $ foldMap (const " [X]") d
                      , D.text_ ": "
                      ]

                  , D.span []
                      [ case s of
                          Eff t -> markup t
                          AttackStep m h ->
                            D.span []
                              [ m # foldMap case _ of
                                  Flat x -> D.text_ $ show x <> " damage."
                                  Roll n x -> D.text_ $ show n <> show x <>
                                    " damage."
                              , h # foldMap \hd ->
                                  D.span []
                                    [ D.span [ css_ [ "italic" ] ]
                                        [ D.text_ " Hit: " ]
                                    , D.text_ "+"
                                    , case hd of
                                        Flat x -> D.text_ $ show x <>
                                          "  damage."
                                        Roll n x -> D.text_ $ show n <> show x
                                          <> " damage."
                                    ]
                              ]
                          OnHit t -> markup t
                          AreaEff t -> markup t
                          KeywordStep _ t -> markup t
                          TriggerStep t -> markup t
                          OtherStep _ t -> markup t
                      ]
                  ]
        ]
    ]
