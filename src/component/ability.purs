module ToA.Component.Ability
  ( printCost
  , printTag

  , renderAbility
  , renderActionSign
  , renderAttackSign
  , renderCost
  , renderTagBox
  , renderTag
  , renderInset
  , renderStep
  , renderSteps
  ) where

import Prelude

import CSS (backgroundColor, lighten)

import Data.Array.NonEmpty (intersperse, toArray)
import Data.Foldable (foldMap)
import Data.Lens ((^.), (^?), filtered, has, is, only, to, traversed, view)
import Data.Lens.Common (simple)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Maybe (Maybe, fromMaybe)
import Data.Monoid (guard)

import Halogen.HTML as HD
import Halogen.HTML.CSS (style)
import Halogen.HTML.Properties as HP

import ToA.Data.Icon (Icon)
import ToA.Data.Icon.Ability
  ( Action(..)
  , Inset(..)
  , Pattern(..)
  , Range(..)
  , Step(..)
  , StepType(..)
  , Tag(..)
  , Target(..)
  )
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Dice (Die)
import ToA.Data.Icon.Markup (length)
import ToA.Data.Icon.Name (_name)
import ToA.Data.Icon.Pc.Ability (Ability, _action, _resolve, _steps, _tags)

import ToA.Component.Markup (markup)
import ToA.Util.Html (css)
import ToA.Util.Optic ((^::), (#~))

printCost :: Action -> String
printCost = case _ of
  Quick -> "Quick"
  One -> "1 action"
  Two -> "2 actions"
  Interrupt n -> "Interrupt " <> show n

printTag :: Tag -> String
printTag = case _ of
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

renderAbility :: ∀ w i. Icon -> Ability -> HD.HTML w i
renderAbility icon@{ colours } a =
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
            [ css [ "text-white", "font-bold" ]
            , style $ fromMaybe (pure unit) $ backgroundColor <$> colours
                ^? traversed
                  <<< filtered (view _name >>> eq (a ^. _colour))
                  <<< _value
            ]
            [ HD.text $ a ^. _name <<< _Newtype ]
        , HD.div
            [ css [ "flex", "items-center", "gap-2", "mr-2" ] ] $
            ( a
                ^:: _tags
                  <<< traversed
                  <<< filtered (has $ only Attack)
                  <<< to \_ -> renderAttackSign
            ) <> [ renderActionSign $ a ^. _action ]
        ]

    , HD.div
        [ css [ "flex", "flex-wrap", "gap-1" ] ] $ join
        [ a # _action #~ pure <<< renderCost
        , a # _resolve #~ pure <<< renderTagBox [ "bg-amber-500", "text-white" ]
            <<< (_ <> " resolve")
            <<< show
        , a # _tags <<< traversed #~ pure <<< renderTag
        ]

    , HD.div [ css [ "italic" ] ] [ markup icon $ a ^. _desc ]

    , renderSteps icon $ a ^. _steps
    ]

renderActionSign :: ∀ w i. Action -> HD.HTML w i
renderActionSign = case _ of
  Quick ->
    HD.span
      [ css [ "icon-[game-icons--quick-slash]" ]
      , HP.title "Quick"
      ]
      []
  One ->
    HD.span
      [ css [ "icon-[game-icons--serrated-slash]" ]
      , HP.title "1 action"
      ]
      []
  Two ->
    HD.span
      [ css [ "flex" ]
      , HP.title "2 actions"
      ]
      [ HD.span [ css [ "icon-[game-icons--serrated-slash]" ] ] []
      , HD.span [ css [ "icon-[game-icons--serrated-slash]" ] ] []
      ]
  Interrupt n ->
    HD.span
      [ css [ "icon-[game-icons--divert]" ]
      , HP.title $ "Interrupt " <> show n
      ]
      []

renderAttackSign :: ∀ w i. HD.HTML w i
renderAttackSign =
  HD.span
    [ css [ "icon-[game-icons--crossed-swords]" ]
    , HP.title "Attack"
    ]
    []

renderTagBox :: ∀ w i. Array String -> String -> HD.HTML w i
renderTagBox styles name =
  HD.div
    [ css $ [ "shrink-0", "px-1", "rounded" ] <> styles ]
    [ HD.text name ]

renderCost :: ∀ w i. Action -> HD.HTML w i
renderCost =
  renderTagBox [ "bg-indigo-500", "text-white" ] <<< printCost

renderTag :: ∀ w i. Tag -> HD.HTML w i
renderTag tag =
  renderTagBox
    [ if tag # is (only Attack) then "bg-rose-500" else "bg-sky-500"
    , "text-white"
    ] $ printTag tag

renderSteps :: ∀ w i. Icon -> Array Step -> HD.HTML w i
renderSteps icon steps =
  HD.div []
    [ HD.ol
        [ css [ "flex", "flex-col", "gap-y-1" ] ]
        $ renderStep icon <$> steps
    ]

renderStep :: ∀ w i. Icon -> Step -> HD.HTML w i
renderStep icon = case _ of
  Step s d t ->
    HD.li [] [ renderStepName icon s d, HD.span [] [ markup icon t ] ]

  AttackStep m h ->
    HD.li []
      [ HD.span []
          [ HD.span
              [ css [ "font-bold" ] ]
              [ HD.text "Attack" ]
          , HD.text ": "
          ]
      , HD.span [] $
          [ markup icon m ] <>
            guard (length h > 0)
              [ HD.span [] [ HD.text "." ]
              , HD.span [] $
                  [ HD.span [ css [ "italic" ] ] [ HD.text " Hit: " ]
                  , markup icon h
                  ]
              ]
      ]

  InsetStep d s t ins ->
    HD.li []
      [ renderStepName icon d s
      , HD.span [] [ markup icon t ]
      , HD.div
          [ css [ "pl-8" ] ]
          [ renderInset icon ins ]
      ]

renderStepName :: ∀ w i. Icon -> StepType -> Maybe Die -> HD.HTML w i
renderStepName icon s d =
  HD.span
    [ css [ "font-bold" ] ]
    [ label s
    , HD.text $ foldMap (const " [X]") d
    , HD.text ": "
    ]
  where
  label = case _ of
    Eff -> HD.text "Effect"
    OnHit -> HD.text "On hit"
    AreaEff -> HD.text "Area effect"
    TriggerStep -> HD.text "Trigger"
    KeywordStep k -> HD.text $ k ^. simple _Newtype
    VariableKeywordStep k n ->
      HD.text $ k ^. simple _Newtype <> " " <> show n
    AltStep ss ->
      HD.span [] $ toArray $ intersperse
        (HD.span [ css [ "font-normal" ] ] [ HD.text ", or " ])
        (label <$> ss)
    SummonEff -> HD.text "Summon effect"
    SummonAction -> HD.text "Summon action"
    OtherStep k -> markup icon k

renderInset :: ∀ w i. Icon -> Inset -> HD.HTML w i
renderInset icon@{ colours } = case _ of
  SummonInset si ->
    HD.div
      [ css [ "ml-8" ] ]
      [ HD.div
          [ css
              [ "flex"
              , "gap-x-1"
              , "bg-stone-400"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              ]
          ]
          [ HD.span
              [ css [ "text-white", "font-bold" ]
              , style $ fromMaybe (pure unit) $
                  (backgroundColor <<< lighten 0.2) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq si.colour)
                      <<< _value
              ]
              [ HD.text $ si.name ^. simple _Newtype ]
          ]
      , HD.div
          [ css [ "italic" ] ]
          [ HD.text $ "Summon (" <> show si.max <> ")" ]
      , renderSteps icon si.abilities
      ]

  AbilityInset ai ->
    HD.div
      [ css [ "flex", "flex-col", "gap-y-1", "ml-8" ] ]
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
          [ HD.h4
              [ css [ "text-white", "font-bold" ]
              , style $ fromMaybe (pure unit) $
                  (backgroundColor <<< lighten 0.2) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq ai.colour)
                      <<< _value
              ]
              [ HD.text $ ai.name ^. simple _Newtype ]
          , HD.div
              [ css [ "flex", "items-center", "gap-2", "mr-2" ] ] $
              ( ai.tags
                  ^:: traversed
                    <<< filtered (has $ only Attack)
                    <<< to \_ -> renderAttackSign
              ) <> [ renderActionSign ai.cost ]
          ]
      , HD.div
          [ css [ "flex", "flex-wrap", "gap-1" ] ] $
          [ renderCost ai.cost ] <> (renderTag <$> ai.tags)
      , HD.div []
          [ HD.ol
              [ css [ "flex", "flex-col", "gap-y-1" ] ]
              $ ai.steps <#> renderStep icon
          ]
      ]

  KeywordInset ki ->
    HD.div
      [ css [ "ml-8" ] ]
      [ HD.div
          [ css
              [ "flex"
              , "gap-x-1"
              , "bg-stone-400"
              , "text-stone-800"
              , "dark:bg-stone-700"
              , "dark:text-stone-300"
              ]
          ]
          [ HD.span
              [ css [ "text-white", "font-bold" ]
              , style $ fromMaybe (pure unit) $
                  (backgroundColor <<< lighten 0.2) <$> colours
                    ^? traversed
                      <<< filtered (view _name >>> eq ki.colour)
                      <<< _value
              ]
              [ HD.text $ ki.name ^. simple _Newtype ]
          ]
      , HD.div
          [ css [ "italic" ] ]
          [ HD.text $ ki.keyword ^. simple _Newtype ]
      , HD.div []
          [ HD.ol
              [ css [ "flex", "flex-col", "gap-y-1" ] ]
              $ ki.steps <#> renderStep icon
          ]
      ]
