module ToA.Page.Character.Edit
  ( editCharacterPage
  ) where

import ToA.Prelude

import CSS (color)

import Data.Array (cons, deleteAt, elem, modifyAt, snoc, updateAt)
import Data.Codec (decode, encode)
import Data.Either (Either(..), hush, isLeft)
import Data.Filterable (filter, partitionMap)
import Data.Foldable (all, foldMap, intercalate)
import Data.Int (floor)
import Data.Lens
  ( (^.)
  , (^?)
  , (.~)
  , (?~)
  , elemOf
  , ifoldMapOf
  , preview
  , view
  , filtered
  , takeBoth
  , to
  , traversed
  , _1
  , _2
  , _Just
  )
import Data.Lens.At (at)
import Data.Lens.Common (simple)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (empty, fromFoldable, lookup, member)
import Data.Maybe (Maybe(..), fromMaybe, isNothing, maybe)
import Data.Monoid (guard)
import Data.Profunctor.Strong (first, second)
import Data.Tuple (fst)

import Deku.Core (Nut, fixed)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.DOM.Attributes as DA
import Deku.DOM.Combinators as DC
import Deku.DOM.Listeners as DL
import Deku.Hooks ((<#~>), cycle, useHotRant, useState, useState')

import Effect (Effect)

import Parsing.String (parseErrorHuman)

import Web.HTML.HTMLTextAreaElement (fromEventTarget, value)

import ToA.Component.Ability (renderAbility)
import ToA.Component.Panel (tripanel)
import ToA.Component.Talent (renderTalent)
import ToA.Component.Trait (renderTrait)
import ToA.Data.Env (Env, _navigate, _saveChar)
import ToA.Data.Icon.Character
  ( Character(..)
  , State(..)
  , Build(..)
  , Level(..)
  , stringCharacter
  , _abilities
  , _active
  , _build
  , _inactive
  , _jobs
  , _level
  , _primary
  , _state
  , _talents
  )
import ToA.Data.Icon.Character (fromInt, toInt) as L
import ToA.Data.Icon.Class (_apprentice, _class, _hp)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Id (Id(..), _id)
import ToA.Data.Icon.Job (JobLevel(..), stringJobLevel, _soul)
import ToA.Data.Icon.Job (_abilities, _talents) as J
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Icon.Trait (_trait)
import ToA.Data.Route (Route(..), CharacterPath(..))
import ToA.Util.Html (css_, hr, style_)
import ToA.Util.Optic ((^::), (#~))
import ToA.Util.Style as S

data Mode = Visual | Text

editCharacterPage :: Env -> Maybe Name -> Nut
editCharacterPage env@{ characters } pathChar =
  characters <#~> \chars -> Deku.do
    setMode /\ mode <- useState Visual

    let
      initChar = chars ^? traversed <. filtered (preview _name >>> eq pathChar)

    mode <#~> case _ of
      Visual -> editCharacterForm env setMode initChar
      Text -> editCharacterText env setMode initChar

editCharacterForm :: Env -> (Mode -> Effect Unit) -> Maybe Character -> Nut
editCharacterForm env@{ icon } setMode initChar = icon <#~> \icon_ -> Deku.do
  setName /\ name <- useState
    (initChar ^. _Just <. _name <. _Newtype)
  setLevel /\ level <- useState $ fromMaybe Zero
    (initChar ^? _Just <. _build <. _level)
  setJobs /\ jobs <- useState $ fromMaybe empty
    (initChar ^? _Just <. _build <. _jobs)
  setPrimary /\ primary <- useState
    (initChar ^? _Just <. _build <. _primary)
  setTalents /\ talents <- useState
    (initChar ^. _Just <. _build <. _talents)
  setAbilities /\ abilities <- useState
    ( initChar ^. _Just <. _build <. _abilities
        <. takeBoth _active _inactive
        <. to \(a /\ i) -> ((_ /\ true) <$> a) <> ((_ /\ false) <$> i)
    )

  setPreview /\ pre <- useState'

  partitionedAbilities <- useHotRant $ abilities
    <#> partitionMap
      (\(a /\ isActive) -> if isActive then Right a else Left a)
    >>> \{ left, right } -> { active: right, inactive: left }
  activeAbilities <- useHotRant $ partitionedAbilities <#> _.active
  inactiveAbilities <- useHotRant $ partitionedAbilities <#> _.inactive

  charJobs <- useHotRant $ jobs <#> \js ->
    icon_.jobs # filter (view _name >>> member ~$ js)
  charClasses <- useHotRant $ charJobs <#> \js ->
    icon_.classes # filter
      (view _name >>> elem ~$ (js ^:: traversed <. _class))
  charTalents <- useHotRant $ charJobs <#> \js ->
    icon_.talents # filter
      (view _id >>> elem ~$ (js ^:: traversed <. J._talents <. traversed))
  charAbilities <- useHotRant $ charJobs <&> charClasses
    <#> \(js /\ cs) -> icon_.abilities # filter
      ( view _name >>> elem ~$
          ( cs ^. traversed <. _apprentice
              <> js
              ^:: traversed
              <. J._abilities
              <. traversed
              <. _2
          )
      )

  let
    previewJobs = icon_.jobs # foldMap \j ->
      D.div []
        [ D.div
            [ css_ [ "font-bold" ]
            , style_ $ fromMaybe (pure unit) $ color <$> icon_.colours
                ^? traversed
                  <. filtered (view _name >>> eq (j ^. _colour))
                  <. _value
            ]
            [ D.text_ $ j ^. _name <. _Newtype ]
        , icon_.traits # traversed <. filtered (_name `elemOf` (j ^. _trait))
            #~ renderTrait icon_
        ]
    previewTalents = charTalents <#> foldMap (renderTalent icon_)
    previewAbilities = charAbilities <#> foldMap (renderAbility icon_)

    character = ado
      n <- name
      l <- level
      j <- jobs <#> at (Name "") .~ Nothing
      t <- talents
      a <- partitionedAbilities
      p' <- primary
      cjs <- charJobs
      ccs <- charClasses
      in
        do
          p <- p'
          state <- case initChar ^? _Just <. _state of
            Just s -> Just s
            Nothing -> do
              hp <- ccs ^?
                traversed
                  <. filtered
                    ( preview _name >>> eq
                        ( cjs ^? traversed <. filtered (_name `elemOf` p) <.
                            _class
                        )
                    )
                  <. _hp
              pure $ State
                { combat:
                    { hp
                    , vigor: 0
                    , powerDice: empty
                    , status: empty
                    , partyResolve: 0
                    }
                , expedition:
                    { wounded: false
                    , camps: 0
                    , personalResolve: 0
                    , combats: 0
                    }
                , interlude: {}
                }
          pure $ Character
            { name: Name n
            , build: Build
                { level: l, primary: p, jobs: j, talents: t, abilities: a }
            , state
            }

  D.form
    [ css_ [ "flex", "flex-col", "grow", "gap-2" ] ]
    [ D.div
        [ css_ [ "flex", "justify-between", "gap-2" ] ]
        [ D.button
            [ css_ S.button
            , DL.runOn_ DL.click $ setMode Text
            ]
            [ D.text_ "Text" ]

        , D.div
            [ css_ [ "flex", "gap-2" ] ]
            [ D.button
                [ css_ S.button
                , DA.xtypeSubmit
                , DA.disabled $ show <<< isNothing <$> character
                , DL.runOn DL.click $ character <#> maybe (pure unit) \c -> do
                    c # env ^. _saveChar
                    (env ^. _navigate)
                      (Characters $ Just $ ViewChar $ c ^. _name)
                      Nothing
                ]
                [ D.text_ "Save" ]

            , D.button
                [ css_ S.button
                , DA.xtypeButton
                , DL.runOn_ DL.click $
                    (env ^. _navigate)
                      (Characters $ ViewChar <<< view _name <$> initChar)
                      Nothing
                ]
                [ D.text_ "Cancel" ]
            ]
        ]

    , tripanel
        [ cycle pre ]
        [ D.label
            [ css_ [ "flex", "justify-between", "gap-2" ] ]
            [ D.span [ css_ [ "font-bold" ] ] [ D.text_ "Name" ]
            , D.input
                [ css_ S.input
                , DA.value name
                , DL.valueOn_ DL.change setName
                ]
                []
            ]

        , D.label
            [ css_ [ "flex", "justify-between", "gap-2" ] ]
            [ D.span [ css_ [ "font-bold" ] ] [ D.text_ "Level" ]
            , D.input
                [ css_ S.input
                , DA.xtypeNumber
                , DA.min_ $ show $ L.toInt bottom
                , DA.max_ $ show $ L.toInt top
                , DA.value $ show <<< L.toInt <$> level
                , DL.numberOn_ DL.change $ floor >>> L.fromInt >>>
                    maybe (pure unit) setLevel
                ]
                []
            ]

        , D.fieldset
            [ css_ [ "flex", "flex-col", "gap-1" ] ]
            [ D.legend [ css_ [ "font-bold" ] ] [ D.text_ "Jobs" ]
            , jobs <&> primary <#~> \(js /\ p) ->
                js # itraversed `ifoldMapOf` \n l ->
                  D.div
                    [ css_ [ "flex", "justify-between", "gap-2" ] ]
                    [ D.select
                        [ css_ S.input
                        , DA.name_ $ n ^. simple _Newtype <> "Job"
                        , DL.runOn_ DL.mouseover $ setPreview previewJobs
                        , DL.runOn_ DL.focus $ setPreview previewJobs
                        , DL.selectOn_ DL.change $ \newN -> do
                            setJobs $ js # at n .~ Nothing # at (Name newN) ?~ l
                            when (all (eq n) p) $ setPrimary $ Just $ Name newN
                        ] $ intercalate [ hr ] $
                        [ D.option
                            [ DA.value_ "" ]
                            [ D.text_ "-- Select job --" ]
                        ] `cons`
                          ( icon_.classes <#> \c ->
                              filter (_class `elemOf` (c ^. _name))
                                icon_.souls
                                <#> \s ->
                                  D.optgroup
                                    [ DA.label_ $ s ^. _name <. _Newtype ]
                                    $ filter (_soul `elemOf` (s ^. _name))
                                        icon_.jobs
                                    <#> \j ->
                                      D.option
                                        ( [ DA.value_ $ j ^. _name <. _Newtype
                                          ] <> guard (n == j ^. _name)
                                            [ DA.selected_ "selected" ]
                                        )
                                        [ D.text_ $ j ^. _name <. _Newtype ]
                          )

                    , D.select
                        [ css_ S.input
                        , DA.name_ $ n ^. simple _Newtype <> "JobLevel"
                        , DL.selectOn_ DL.change
                            $ decode stringJobLevel
                            >>> hush
                            >>> maybe (pure unit)
                              (\newL -> setJobs (js # at n ?~ newL))
                        ] $ [ I, II, III, IV ] <#> \jl ->
                        D.option
                          ( [ DA.value_ $ encode stringJobLevel jl
                            ] <> guard (l == jl) [ DA.selected_ "selected" ]
                          )
                          [ D.text_ $ encode stringJobLevel jl ]

                    , D.button
                        [ css_
                            [ "rounded"
                            , "self-center"
                            , "size-[1em]"
                            , if p == Just n then "bg-sky-600"
                              else "bg-stone-500 dark:bg-stone-700"
                            ]
                        , DL.runOn_ DL.click $ setPrimary
                            if p == Just n then Nothing else Just n
                        ]
                        []

                    , D.button
                        [ css_ $ S.interactable <> [ "px-2", "rounded" ]
                        , DA.xtypeButton
                        , DL.runOn_ DL.click do
                            setJobs $ js # at n .~ Nothing
                            when (p == Just n) $ setPrimary Nothing
                        ]
                        [ D.text_ "-" ]
                    ]

            , D.button
                [ css_ S.button
                , DA.xtypeButton
                , DL.runOn DL.click $ jobs <#> setJobs <<< (at (Name "") ?~ I)
                ]
                [ D.text_ "+" ]
            ]

        , D.fieldset
            [ css_ [ "flex", "flex-col", "gap-1" ] ]
            [ D.legend [ css_ [ "font-bold" ] ] [ D.text_ "Talents" ]
            , { cjs: _, cts: _, pts: _, jts: _ }
                <$> charJobs
                <*> charTalents
                <*> previewTalents
                <*> talents
                <#~> \{ cjs, cts, pts, jts } ->
                  jts # itraversed `ifoldMapOf` \i id ->
                    D.div
                      [ css_ [ "flex", "justify-between", "gap-2" ] ]
                      [ D.select
                          [ css_ S.input
                          , DA.name_ $ "talent-" <> show i
                          , DL.runOn_ DL.mouseover $ setPreview pts
                          , DL.runOn_ DL.focus $ setPreview pts
                          , DL.selectOn_ DL.change $ Id
                              >>> (updateAt i ~$ jts)
                              >>> maybe (pure unit) setTalents
                          ]
                          [ intercalate hr $
                              ( D.option
                                  [ DA.value_ "" ]
                                  [ D.text_ "-- Select talent --" ]
                              ) `cons`
                                ( cjs <#> \j ->
                                    D.optgroup
                                      [ DA.label_ $ j ^. _name <. _Newtype ]
                                      $ cts
                                      # filter
                                          ( view _id >>> elem ~$
                                              (j ^:: J._talents <. traversed)
                                          )
                                      <#> \t ->
                                        D.option
                                          ( [ DA.value_ $ t ^. _id <. _Newtype
                                            , DA.disabled
                                                $ show
                                                <<< elem (t ^. _id)
                                                <$> talents
                                            ] <> guard (id == t ^. _id)
                                              [ DA.selected_ "selected" ]
                                          )
                                          [ D.text_ $ t ^. _name <. _Newtype ]
                                )
                          ]

                      , D.button
                          [ css_ $ S.interactable <> [ "px-2", "rounded" ]
                          , DA.xtypeButton
                          , DL.runOn DL.click $ talents
                              <#> deleteAt i
                              >>> maybe (pure unit) setTalents
                          ]
                          [ D.text_ "-" ]
                      ]

            , D.button
                [ css_ S.button
                , DA.xtypeButton
                , DL.runOn DL.click $ talents <#> setTalents <<< (snoc ~$ Id "")
                ]
                [ D.text_ "+" ]
            ]

        , D.fieldset
            [ css_ [ "flex", "flex-col", "gap-1" ] ]
            [ D.legend [ css_ [ "font-bold" ] ] [ D.text_ "Abilities" ]
            , { cjs: _, ccs: _, pas: _, js: _, jas: _ }
                <$> charJobs
                <*> charClasses
                <*> previewAbilities
                <*> jobs
                <*> abilities
                <#~> \{ cjs, ccs, pas, js, jas } ->
                  jas # itraversed `ifoldMapOf` \i (n /\ x) ->
                    D.div
                      [ css_ [ "flex", "justify-between", "gap-2" ] ]
                      [ D.select
                          [ css_ S.input
                          , DA.name_ $ "ability-" <> show i <> "-name"
                          , DL.runOn_ DL.mouseover $ setPreview pas
                          , DL.runOn_ DL.focus $ setPreview pas
                          , DL.selectOn_ DL.change $ \newA ->
                              modifyAt i (first $ const $ Name newA) jas
                                # maybe (pure unit) setAbilities
                          ]
                          [ D.option
                              [ DA.value_ "" ]
                              [ D.text_ "-- Select ability --" ]

                          , hr

                          , fixed $ cjs <#> \j ->
                              D.optgroup
                                [ DA.label_ $ j ^. _name <. _Newtype ]
                                $ icon_.abilities
                                # filter
                                    ( view _name >>> elem ~$
                                        ( j ^:: J._abilities
                                            <. traversed
                                            <. filtered
                                              ( preview _1 >>>
                                                  (_ <= lookup (j ^. _name) js)
                                              )
                                            <. _2
                                        )
                                    )
                                <#> \a ->
                                  D.option
                                    ( [ DA.value_ $ a ^. _name <. _Newtype
                                      , DA.disabled_
                                          $ show
                                          <<< elem (a ^. _name)
                                          <<< map fst
                                          $ jas
                                      ] <> guard (n == a ^. _name)
                                        [ DA.selected_ "selected" ]
                                    )
                                    [ D.text_ $ a ^. _name <. _Newtype ]

                          , hr

                          , fixed $ ccs <#> \c ->
                              D.optgroup
                                [ DA.label_ $ c ^. _name <. _Newtype ]
                                $ icon_.abilities
                                # filter
                                    (view _name >>> elem ~$ (c ^. _apprentice))
                                <#> \a ->
                                  D.option
                                    ( [ DA.value_ $ a ^. _name <. _Newtype
                                      , DA.disabled_
                                          $ show
                                          <<< elem (a ^. _name)
                                          <<< map fst
                                          $ jas
                                      ] <> guard (n == a ^. _name)
                                        [ DA.selected_ "selected" ]
                                    )
                                    [ D.text_ $ a ^. _name <. _Newtype ]
                          ]

                      , D.button
                          [ css_
                              [ "rounded"
                              , "self-center"
                              , "size-[1em]"
                              , if x then "bg-sky-600"
                                else "bg-stone-500 dark:bg-stone-700"
                              ]
                          , DL.runOn_ DL.click
                              $ modifyAt i (second not) jas
                              # maybe (pure unit) setAbilities
                          ]
                          []

                      , D.button
                          [ css_ $ S.interactable <> [ "px-2", "rounded" ]
                          , DA.xtypeButton
                          , DL.runOn_ DL.click
                              $ deleteAt i jas
                              # maybe (pure unit) setAbilities
                          ]
                          [ D.text_ "-" ]
                      ]

            , D.button
                [ css_ S.button
                , DA.xtypeButton
                , DL.runOn DL.click $ abilities
                    <#> setAbilities
                    <<< (snoc ~$ (Name "" /\ false))
                ]
                [ D.text_ "+" ]
            ]
        ]
        [ D.div
            [ css_
                [ "grid"
                , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
                , "gap-x-2"
                , "gap-y-6"
                ]
            ]
            [ D.h4
                [ css_ [ "col-span-full", "text-center", "font-bold" ] ]
                [ D.text_ "Active" ]
            , activeAbilities <#~> traversed #~ \n ->
                icon_.abilities # traversed <. filtered (_name `elemOf` n) #~
                  renderAbility icon_
            ]

        , D.div [ css_ [ "my-4" ] ] [ hr ]

        , D.div
            [ css_
                [ "grid"
                , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
                , "gap-x-2"
                , "gap-y-6"
                ]
            ]
            [ D.h4
                [ css_ [ "col-span-full", "text-center", "font-bold" ] ]
                [ D.text_ "Inactive" ]
            , inactiveAbilities <#~> traversed #~ \n ->
                icon_.abilities # traversed <. filtered (_name `elemOf` n) #~
                  renderAbility icon_
            ]
        ]
    ]

editCharacterText :: Env -> (Mode -> Effect Unit) -> Maybe Character -> Nut
editCharacterText env@{ icon } setMode initChar = icon <#~> \icon_ -> Deku.do
  setChar /\ char <- useState
    $ encode (stringCharacter icon_)
    $ fromMaybe emptyTextChar initChar

  let parsed = decode (stringCharacter icon_) <$> char

  D.div
    [ css_ [ "flex", "flex-col", "w-full", "gap-2" ] ]
    [ D.form
        [ css_ [ "flex", "flex-col", "gap-2" ] ]
        [ D.div
            [ css_ [ "flex", "justify-between", "gap-2" ] ]
            [ D.button
                [ css_ S.button
                , DL.runOn_ DL.click $ setMode Visual
                ]
                [ D.text_ "Visual" ]

            , D.div
                [ css_ [ "flex", "gap-2" ] ]
                [ D.button
                    [ DL.runOn DL.click $ parsed <#> case _ of
                        Left _ -> pure unit
                        Right c -> do
                          c # env ^. _saveChar
                          (env ^. _navigate)
                            (Characters $ Just $ ViewChar $ c ^. _name)
                            Nothing
                    , DA.disabled $ show <<< isLeft <$> parsed
                    , css_ S.button
                    ]
                    [ D.text_ "Save" ]

                , D.button
                    [ css_ S.button
                    , DL.runOn_ DL.click $
                        (env ^. _navigate)
                          (Characters $ ViewChar <<< view _name <$> initChar)
                          Nothing
                    ]
                    [ D.text_ "Cancel" ]
                ]
            ]

        , D.label
            [ DA.for_ "edit", css_ [ "font-bold" ] ]
            [ D.text_ "Edit character" ]

        , D.div
            [ css_ [ "flex" ] ]
            [ D.textarea
                [ css_ $ S.input <> [ "mx-2", "font-mono" ]
                , DC.transformOn { fromEventTarget, value } DL.input
                    (pure setChar)
                , DA.rows_ "15"
                , DA.cols_ "40"
                , DA.id_ "edit"
                ]
                [ D.text char ]

            , char <&> parsed <#~> \(c /\ p) -> case p of
                Right _ -> mempty
                Left e ->
                  D.pre
                    [ css_ [ "text-red-600" ] ]
                    [ D.text_ $ intercalate "\n" $ parseErrorHuman c 20 e ]
            ]

        ]
    ]

emptyTextChar :: Character
emptyTextChar = Character
  { name: Name "<Character name>"
  , state: State
      { combat:
          { hp: 0
          , vigor: 0
          , powerDice: empty
          , status: empty
          , partyResolve: 0
          }
      , expedition:
          { wounded: false
          , camps: 0
          , personalResolve: 0
          , combats: 0
          }
      , interlude: {}
      }
  , build: Build
      { level: Zero
      , primary: Name "<Primary job>"
      , jobs: fromFoldable [ Name "<Job 1>" /\ I, Name "<Job 2>" /\ IV ]
      , talents: [ Id "<Talent>" ]
      , abilities:
          { active: [ Name "<Active ability>" ]
          , inactive: [ Name "<Inactive ability>" ]
          }
      }
  }
