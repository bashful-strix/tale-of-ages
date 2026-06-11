module ToA.Page.Character.Combat
  ( combatCharacterPage
  ) where

import ToA.Prelude

import CSS (color)

import Data.Array ((..), sort)
import Data.Foldable (elem, foldMap)
import Data.Int (fromString, toNumber)
import Data.Lens
  ( (^.)
  , (^?)
  , (.~)
  , (?~)
  , has
  , hasn't
  , preview
  , view
  , filtered
  , to
  , traversed
  , _Just
  )
import Data.Lens.At (at)
import Data.Lens.Common (simple)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Lens.Prism (only)
import Data.Maybe (Maybe(..), fromMaybe)
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

import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Character (class Character, saveChar)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), CharacterPath(..), routeCodec)
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon.Character
  ( Level(..)
  , _build
  , _level
  , _abilities
  , _active
  , _primary
  , _talents
  , _currentHp
  , _currentVigor
  , _currentPowerDice
  , _currentStatus
  , _currentPerRes
  , _currentParRes
  )
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Description (_desc)
import ToA.Data.Icon.Id (_id)
import ToA.Data.Icon.Keyword (_category, _Status)
import ToA.Data.Icon.Name (Name, _name)
import ToA.Data.Icon.Trait (_trait)

import ToA.Data.Icon.Pc.Class (_basic, _defense, _hp, _move)
import ToA.Data.Icon.Pc.Job (_limitBreak)

import ToA.Component.Ability (renderAbility)
import ToA.Component.Markup (markup)
import ToA.Component.Panel (tripanel)
import ToA.Util.Html (css, hr)
import ToA.Util.Optic ((^::), (#~), (#@~))

data Action
  = Receive (Connected Store Name)
  | Navigate Route (Maybe MouseEvent)
  | SetHp String
  | SetVigour String
  | SetPersonalResolve Int
  | SetPartyResolve Int
  | SetStatus Name Int
  | SetPowerDieName String Int String
  | SetPowerDieValue String Int
  | NewPowerDie
  | RemovePowerDie String

combatCharacterPage
  :: ∀ q o m
   . MonadAff m
  => MonadStore StoreAction Store m
  => Character m
  => Navigate m
  => H.Component q Name o m
combatCharacterPage =
  connect selectAll $ H.mkComponent
    { initialState: deriveState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where

  deriveState { context: { icon, characters }, input } =
    { icon: icon, char: characters ^. at input }

  act = case _ of
    Receive update -> H.put $ deriveState update
    Navigate r e -> navigate r e

    SetHp hpStr -> H.gets _.char >>= (_ /\ fromString hpStr) >>> case _ of
      Just c /\ Just hp -> saveChar $ c # _currentHp .~ hp
      _ -> pure unit
    SetVigour vigStr -> H.gets _.char >>= (_ /\ fromString vigStr) >>> case _ of
      Just c /\ Just vigour -> saveChar $ c # _currentVigor .~ vigour
      _ -> pure unit
    SetPersonalResolve resolve -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c # _currentPerRes .~ resolve
    SetPartyResolve resolve -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c # _currentParRes .~ resolve
    SetStatus status n -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c # _currentStatus <. at status ?~ n
    SetPowerDieName name n newName -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c
        # _currentPowerDice <. at name .~ Nothing
        # _currentPowerDice <. at newName ?~ n
    SetPowerDieValue name n -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c # _currentPowerDice <. at name ?~ n
    NewPowerDie -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c # _currentPowerDice <. at "" ?~ 0
    RemovePowerDie name -> H.gets _.char >>= case _ of
      Nothing -> pure unit
      Just c -> saveChar $ c # _currentPowerDice <. at name .~ Nothing

  render { icon, char } =
    let
      { abilities, classes, colours, jobs, keywords, talents, traits } = icon

      job = jobs
        ^? traversed
          <. filtered
            (preview _name >>> eq (char ^? _Just <. _build <. _primary))

      cls = classes
        ^? traversed
          <<< filtered (preview _name >>> eq (job ^? _Just <. _class))

      trs =
        traits
          ^:: traversed
          <. filtered
            ( preview _name >>>
                ( ( (\_ -> pure Zero /= (char ^? _Just <. _build <. _level))
                      && (eq (job ^? _Just <. _trait))
                  ) ||
                    (eq (cls ^? _Just <. _trait))
                )
            )

      tls =
        talents
          ^:: traversed
          <. filtered
            ( view _id >>> elem ~$
                (char ^:: _Just <. _build <. _talents <. traversed)
            )

      abs = sort
        $ abilities
        ^:: traversed
        <. filtered
          ( view _name >>> elem ~$
              (char ^. _Just <. _build <. _abilities <. _active)
          )

    in
      HD.div
        [ css [ "flex", "flex-col", "grow", "gap-2" ] ]
        [ HD.div
            [ css [ "flex", "items-center", "gap-x-2" ] ] $ join
            [ char # foldMap \c -> pure $
                HD.a
                  [ css
                      [ "px-2"
                      , "py-1"
                      , "rounded"
                      , "bg-stone-400"
                      , "text-stone-800"
                      , "dark:bg-stone-700"
                      , "dark:text-stone-300"
                      , "hover:bg-stone-500"
                      , "focus:bg-stone-500"
                      , "dark:hover:bg-stone-500"
                      , "dark:focus:bg-stone-500"
                      ]
                  , HP.href $ print routeCodec
                      (Characters $ Just $ ViewChar $ c ^. _name)
                  , HE.onClick $ Navigate
                      (Characters $ Just $ ViewChar $ c ^. _name) <<< pure
                  ]
                  [ HD.text "View" ]

            , char # foldMap \c -> pure $
                HD.h2
                  [ css [ "font-bold" ] ]
                  [ HD.text $ c ^. _name <. _Newtype ]
            ]

        , tripanel
            [ HD.div
                [ css [ "flex", "justify-between" ] ]
                [ HD.span
                    [ css [ "font-bold" ] ]
                    [ HD.text "HP: " ]

                , HD.div
                    [ css [ "flex" ] ] $ char # foldMap \c ->
                    let
                      max = cls ^? _Just <. _hp
                      hp = c ^. _currentHp
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
                          , HE.onValueChange SetHp
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
                    [ css [ "flex" ] ] $ char # foldMap \c ->
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
                        , HP.value $ c ^. _currentVigor <. to show
                        , HE.onValueChange SetVigour
                        ]
                    , HD.div
                        [ css [ "min-w-8", "text-right" ] ]
                        [ HD.text $ "/ " <>
                            cls ^. _Just <. _hp <. to (show <<< (_ / 4))
                        ]
                    ]
                ]

            , hr

            , HD.div
                [ css [ "w-max" ] ]
                [ HD.span
                    [ css [ "font-bold" ] ]
                    [ HD.text "Defense: " ]

                , HD.span []
                    [ HD.text $ cls ^. _Just <. _defense <. to show ]
                ]

            , HD.div
                [ css [ "w-max" ] ]
                [ HD.span
                    [ css [ "font-bold" ] ]
                    [ HD.text "Free Move: " ]

                , HD.span []
                    [ HD.text $ cls ^. _Just <. _move <. to show ]
                ]

            , hr

            , HD.div
                [ css [ "w-max" ] ]
                $ char # foldMap (pure <<< renderResolve)

            , hr

            , HD.div
                [ css [ "flex", "flex-col", "w-full" ]
                ] $ char # foldMap \c ->
                keywords
                  ^:: traversed
                  <. filtered (has (_category <. _Status))
                  <. to \k -> renderStatus c (k ^. _name) 3

            , hr

            , HD.div
                [ css [ "flex", "flex-col", "w-full" ] ]
                $
                  [ HD.div
                      [ css [ "font-bold" ] ]
                      [ HD.text "Power Dice" ]
                  ]
                <>
                  ( char # foldMap \c ->
                      ( c # (_currentPowerDice <. itraversed)
                          #@~ (pure <.. renderPowerDie)
                      ) <>
                        [ HD.div
                            [ css
                                [ "w-full"
                                , "flex"
                                , "justify-center"
                                ]
                            ]
                            [ HD.button
                                [ HP.type_ HP.ButtonButton
                                , HE.onClick \_ -> NewPowerDie
                                ]
                                [ HD.text "+" ]
                            ]
                        ]
                  )
            ]
            [ HD.div
                [ css
                    [ "grid"
                    , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                    , "gap-2"
                    ]
                ]
                $ trs
                <#> \t ->
                  HD.div []
                    [ HD.div
                        [ css [ "font-bold" ] ]
                        [ HD.text $ t ^. _name <. _Newtype ]
                    , t # _desc #~ markup icon
                    ]

            , HD.div
                [ css
                    [ "grid"
                    , "grid-cols-[repeat(auto-fit,minmax(100px,1fr))]"
                    , "gap-2"
                    ]
                ]
                $ tls
                <#> \t ->
                  HD.div []
                    [ HD.div
                        [ css [ "font-bold" ]
                        , style $ fromMaybe (pure unit)
                            $ color
                            <$> colours
                            ^? traversed
                              <. filtered
                                (view _name >>> eq (t ^. _colour))
                              <. _value
                        ]
                        [ HD.text $ t ^. _name <. _Newtype ]
                    , t # _desc #~ markup icon
                    ]

            , HD.div
                [ css
                    [ "grid"
                    , "grid-cols-[repeat(auto-fit,minmax(min(200px,100%),1fr))]"
                    , "gap-2"
                    ]
                ] $ join
                [ [ HD.div
                      [ css [ "flex", "gap-x-2" ] ]
                      $
                        abilities
                      ^:: traversed
                      <. filtered
                        (preview _name >>> eq (cls ^? _Just <. _basic))
                      <. to (renderAbility icon)
                  ]

                , guard
                    (char # hasn't (_Just <. _build <. _level <. only Zero))
                    [ HD.div
                        [ css [ "flex", "gap-x-2" ] ] $
                        abilities
                          ^:: traversed
                          <. filtered
                            (preview _name >>> eq (job ^? _Just <. _limitBreak))
                          <. to (renderAbility icon)
                    ]
                ]
            ]
            [ HD.div
                [ css
                    [ "grid"
                    , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
                    , "gap-x-2"
                    , "gap-y-6"
                    ]
                ]
                $ abs
                <#> renderAbility icon
            ]
        ]

  renderResolve char =
    let
      per = char ^. _currentPerRes
      par = char ^. _currentParRes
    in
      HD.div
        [ css [ "flex", "flex-col", "gap-y-2", "w-full" ] ]
        [ HD.div [ css [ "font-bold" ] ] [ HD.text "Resolve" ]
        , HD.div
            [ css [ "flex", "flex-col" ] ]
            [ HD.div [] [ HD.text "Personal" ]
            , HD.div
                [ css [ "mt-1", "space-x-1" ] ]
                $ (1 .. 9)
                <#> \x ->
                  HD.button
                    [ css
                        [ "rounded"
                        , "size-[1em]"
                        , if per >= x then "bg-amber-400"
                          else "bg-stone-400 dark:bg-stone-700"
                        ]
                    , HP.type_ HP.ButtonButton
                    , HE.onClick \_ -> SetPersonalResolve
                        if per == x then x - 1 else x
                    ]
                    []
            ]
        , HD.div
            [ css [ "flex", "flex-col" ] ]
            [ HD.div [] [ HD.text "Party" ]
            , HD.div
                [ css [ "mt-1", "space-x-1" ] ]
                $ (1 .. 9)
                <#> \x ->
                  HD.button
                    [ css
                        [ "rounded"
                        , "size-[1em]"
                        , if par >= x then "bg-amber-400"
                          else "bg-stone-400 dark:bg-stone-700"
                        ]
                    , HP.type_ HP.ButtonButton
                    , HE.onClick \_ -> SetPartyResolve
                        if par == x then x - 1 else x
                    ]
                    []
            ]
        ]

  renderStatus _ _ max | max <= 0 = HD.div [] []
  renderStatus char status max =
    let
      n = char ^. _currentStatus <. at status <. to (fromMaybe 0)
    in
      HD.div
        [ css [ "w-full", "flex", "justify-between" ] ]
        [ HD.div [] [ HD.text $ status ^. simple _Newtype ]
        , HD.div
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
                , HE.onClick \_ -> SetStatus status if n == x then x - 1 else x
                ]
                []
        ]

  renderPowerDie name n =
    HD.div
      [ css [ "flex", "flex-col", "my-2" ] ]
      [ HD.div
          [ css [ "flex", "justify-between" ] ]
          [ HD.input
              [ css
                  [ "bg-stone-400"
                  , "text-stone-800"
                  , "dark:bg-stone-700"
                  , "dark:text-stone-300"
                  ]
              , HP.value name
              , HE.onValueChange $ SetPowerDieName name n
              ]
          , HD.button
              [ HP.type_ HP.ButtonButton
              , HE.onClick \_ -> RemovePowerDie name
              ]
              [ HD.text "-" ]
          ]

      , HD.div
          [ css [ "mt-1", "space-x-1" ] ]
          $ (1 .. 6)
          <#> \x ->
            HD.button
              [ css
                  [ "rounded"
                  , "size-[1em]"
                  , if n >= x then "bg-sky-600"
                    else "bg-stone-400 dark:bg-stone-700"
                  ]
              , HP.type_ HP.ButtonButton
              , HE.onClick \_ -> SetPowerDieValue name
                  if n == x then x - 1 else x
              ]
              []
      ]
