module ToA.Page.Character.Edit
  ( editCharacterPage
  ) where

import ToA.Prelude

import CSS (color)

import Data.Array ((..), cons, deleteAt, elem, intersperse)
import Data.Codec (decode, encode)
import Data.Either (Either(..), hush, isLeft)
import Data.Filterable (filter, partitionMap)
import Data.Foldable (all, foldMap, intercalate)
import Data.Int (fromString)
import Data.Lens
  ( Lens'
  , (^.)
  , (^?)
  , (%~)
  , (%=)
  , (.~)
  , (.=)
  , (?~)
  , (?=)
  , (<>=)
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
import Data.Lens.Index (ix)
import Data.Lens.Indexed (itraversed)
import Data.Lens.Iso.Newtype (_Newtype)
import Data.Map (Map, empty, fromFoldable, lookup, member)
import Data.Maybe (Maybe(..), fromMaybe, isNothing)
import Data.Monoid (guard)
import Data.Tuple (fst)

import Halogen as H
import Halogen.HTML as HD
import Halogen.HTML.CSS (style)
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Store.Connect (Connected, connect)
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.Select (selectAll)

import Parsing.String (parseErrorHuman)

import Web.HTML.Common as WC
import Web.UIEvent.MouseEvent (MouseEvent)

import ToA.Capability.Character (class Character, saveChar)
import ToA.Capability.Navigate (class Navigate, navigate)
import ToA.Data.Route (Route(..), CharacterPath(..))
import ToA.Data.Store (Store, StoreAction)

import ToA.Data.Icon (Icon)
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
import ToA.Data.Icon.Class (_class)
import ToA.Data.Icon.Colour (_colour, _value)
import ToA.Data.Icon.Id (Id(..), _id)
import ToA.Data.Icon.Name (Name(..), _name)
import ToA.Data.Icon.Trait (_trait)

import ToA.Data.Icon.Pc.Class (_apprentice, _hp)
import ToA.Data.Icon.Pc.Job (JobLevel(..), stringJobLevel, _soul)
import ToA.Data.Icon.Pc.Job (_abilities, _talents) as J

import ToA.Component.Ability (renderAbility)
import ToA.Component.Panel (tripanel)
import ToA.Component.Talent (renderTalent)
import ToA.Component.Trait (renderTrait)
import ToA.Util.Html (css, hr)
import ToA.Util.Optic ((^::), (#~), key)
import ToA.Util.Style as S

data Mode = Visual | Text

data Preview = PreviewJobs | PreviewTalents | PreviewAbilities

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

type VisualState =
  { name :: String
  , level :: Level
  , jobs :: Map Name JobLevel
  , primary :: Maybe Name
  , talents :: Array Id
  , abilities :: Array (Name /\ Boolean)
  }

_vName :: Lens' VisualState String
_vName = key @"name"

_vLevel :: Lens' VisualState Level
_vLevel = key @"level"

_vJobs :: Lens' VisualState (Map Name JobLevel)
_vJobs = key @"jobs"

_vPrimary :: Lens' VisualState (Maybe Name)
_vPrimary = key @"primary"

_vTalents :: Lens' VisualState (Array Id)
_vTalents = key @"talents"

_vAbilities :: Lens' VisualState (Array (Name /\ Boolean))
_vAbilities = key @"abilities"

type PageState =
  { icon :: Icon
  , mode :: Mode
  , pathChar :: Maybe Character
  , pre :: Maybe Preview
  , visual :: VisualState
  , text :: String
  }

_mode :: Lens' PageState Mode
_mode = key @"mode"

_pre :: Lens' PageState (Maybe Preview)
_pre = key @"pre"

_visual :: Lens' PageState VisualState
_visual = key @"visual"

_text :: Lens' PageState String
_text = key @"text"

data Action
  = Receive (Connected Store (Maybe Name))
  | Navigate Route (Maybe MouseEvent)
  | SaveChar (Maybe Character)
  | SetMode Mode
  | SetPreview (Maybe Preview)
  | SetName String
  | SetLevel String
  | SetPrimary (Maybe Name)
  | NewJob
  | SetJobName Name JobLevel String
  | SetJobLevel Name String
  | RemoveJob Name
  | NewTalent
  | SetTalents Int String
  | RemoveTalent Int
  | NewAbility
  | SetAbility Int Name Boolean
  | RemoveAbility Int
  | SetTextChar String

editCharacterPage
  :: ∀ q o m
   . MonadStore StoreAction Store m
  => Character m
  => Navigate m
  => H.Component q (Maybe Name) o m
editCharacterPage =
  connect selectAll $ H.mkComponent
    { initialState: deriveState
    , render
    , eval: H.mkEval H.defaultEval
        { handleAction = act
        , receive = pure <<< Receive
        }
    }
  where

  deriveState { context, input } =
    let
      pathChar = context.characters ^?
        traversed <. filtered (preview _name >>> eq input)
    in
      { icon: context.icon
      , pathChar
      , mode: Visual
      , pre: Nothing
      , visual:
          { name: pathChar ^. _Just <. _name <. _Newtype
          , level: fromMaybe Zero $ pathChar ^? _Just <. _build <. _level
          , jobs: fromMaybe empty $ pathChar ^? _Just <. _build <. _jobs
          , primary: pathChar ^? _Just <. _build <. _primary
          , talents: pathChar ^. _Just <. _build <. _talents
          , abilities: pathChar ^. _Just <. _build <. _abilities
              <. takeBoth _active _inactive
              <. to \(a /\ i) -> ((_ /\ true) <$> a) <> ((_ /\ false) <$> i)
          }
      , text: encode (stringCharacter context.icon)
          $ fromMaybe emptyTextChar pathChar
      }

  act = case _ of
    Receive update -> H.put $ deriveState update
    Navigate r e -> navigate r e
    SaveChar mchar -> mchar # foldMap \char -> do
      saveChar char
      navigate (Characters $ Just $ ViewChar $ char ^. _name) Nothing

    SetMode mode -> _mode .= mode
    SetPreview pre -> _pre .= pre

    SetName name ->
      _visual <. _vName .= name
    SetLevel levelStr ->
      fromString levelStr >>= L.fromInt # foldMap \level ->
        _visual <. _vLevel .= level
    SetPrimary primary ->
      _visual <. _vPrimary .= primary

    NewJob ->
      _visual <. _vJobs <. at (Name "") ?= I
    SetJobName name level newName ->
      _visual %= \v -> v
        # _vJobs <. at name .~ Nothing
        # _vJobs <. at (Name newName) ?~ level
        # _vPrimary %~ \p -> if all (eq name) p then Just (Name newName) else p
    SetJobLevel name levelStr ->
      decode stringJobLevel levelStr # hush # foldMap \level ->
        _visual <. _vJobs <. at name ?= level
    RemoveJob name ->
      _visual %= \v -> v
        # _vJobs <. at name .~ Nothing
        # _vPrimary %~ \p -> if all (eq name) p then Nothing else p

    NewTalent ->
      _visual <. _vTalents <>= [ Id "" ]
    SetTalents i id ->
      _visual <. _vTalents <. ix i .= Id id
    RemoveTalent i ->
      H.gets _.visual.talents >>= deleteAt i >>> foldMap \talents ->
        _visual <. _vTalents .= talents

    NewAbility ->
      _visual <. _vAbilities <>= [ Name "" /\ false ]
    SetAbility i name active ->
      _visual <. _vAbilities <. ix i .= name /\ active
    RemoveAbility i ->
      H.gets _.visual.abilities >>= deleteAt i >>> foldMap \abilities ->
        _visual <. _vAbilities .= abilities

    SetTextChar text -> _text .= text

  render { icon, mode, pre, pathChar, visual, text } =
    case mode of
      Visual -> editCharacterForm icon pathChar pre visual
      Text -> editCharacterText icon pathChar text

  editCharacterForm
    icon
    pathChar
    pre
    { name, level, jobs, primary, talents, abilities } =
    let
      partitionedAbilities = abilities
        # partitionMap
          (\(a /\ isActive) -> if isActive then Right a else Left a)
        >>> \{ left, right } -> { active: right, inactive: left }
      activeAbilities = partitionedAbilities.active
      inactiveAbilities = partitionedAbilities.inactive

      charJobs = icon.jobs # filter (view _name >>> member ~$ jobs)
      charClasses = icon.classes # filter
        (view _name >>> elem ~$ (charJobs ^:: traversed <. _class))
      charTalents = icon.talents # filter
        (view _id >>> elem ~$ (charJobs ^:: traversed <. J._talents <. traversed))
      charAbilities = icon.abilities # filter
        ( view _name >>> elem ~$
            ( charClasses ^. traversed <. _apprentice
                <> charJobs
                ^:: traversed
                <. J._abilities
                <. traversed
                <. _2
            )
        )

      previewJobs = icon.jobs # foldMap \j -> pure $
        HD.div [] $
          [ HD.div
              [ css [ "font-bold" ]
              , style $ fromMaybe (pure unit) $ color <$> icon.colours
                  ^? traversed
                    <. filtered (view _name >>> eq (j ^. _colour))
                    <. _value
              ]
              [ HD.text $ j ^. _name <. _Newtype ]
          ] <>
            (icon.traits # traversed <. filtered (_name `elemOf` (j ^. _trait))
              #~ pure <<< renderTrait icon)
      previewTalents = charTalents # foldMap (pure <<< renderTalent icon)
      previewAbilities = charAbilities # foldMap (pure <<< renderAbility icon)

      character = do
        p <- primary
        state <- case pathChar ^? _Just <. _state of
          Just s -> Just s
          Nothing -> do
            hp <- charClasses ^?
              traversed
                <. filtered
                  ( preview _name >>> eq
                      ( charJobs ^? traversed <. filtered (_name `elemOf` p) <.
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
          { name: Name name
          , build: Build
              { level
              , primary: p
              , jobs: jobs # at (Name "") .~ Nothing
              , talents
              , abilities: partitionedAbilities
              }
          , state
          }

    in
      HD.form
        [ css [ "flex", "flex-col", "grow", "gap-2" ] ]
        [ HD.div
            [ css [ "flex", "justify-between", "gap-2" ] ]
            [ HD.button
                [ css S.button
                , HP.type_ HP.ButtonButton
                , HE.onClick \_ -> SetMode Text
                ]
                [ HD.text "Text" ]

            , HD.div
                [ css [ "flex", "gap-2" ] ]
                [ HD.button
                    [ css S.button
                    , HP.type_ HP.ButtonSubmit
                    , HP.disabled $ isNothing character
                    , HE.onClick \_ -> SaveChar character
                    ]
                    [ HD.text "Save" ]

                , HD.button
                    [ css S.button
                    , HP.type_ HP.ButtonButton
                    , HE.onClick \_ -> Navigate
                        (Characters $ ViewChar <<< view _name <$> pathChar)
                        Nothing
                    ]
                    [ HD.text "Cancel" ]
                ]
            ]

        , tripanel
            ( case pre of
                Nothing -> []
                Just PreviewJobs -> previewJobs
                Just PreviewTalents -> previewTalents
                Just PreviewAbilities -> previewAbilities
            )
            [ HD.label
                [ css [ "flex", "justify-between", "gap-2" ] ]
                [ HD.span [ css [ "font-bold" ] ] [ HD.text "Name" ]
                , HD.input
                    [ css S.input
                    , HP.value name
                    , HE.onValueChange SetName
                    ]
                ]

            , HD.label
                [ css [ "flex", "justify-between", "gap-2" ] ]
                [ HD.span [ css [ "font-bold" ] ] [ HD.text "Level" ]
                , HD.select
                    [ css S.input
                    , HP.name "Level"
                    , HE.onValueChange SetLevel
                    ] $ (L.toInt bottom .. L.toInt top) <#> \l ->
                      HD.option
                        [ HP.value $ show l ]
                        [ HD.text $ show l ]
                ]

            , HD.fieldset
                [ css [ "flex", "flex-col", "gap-1" ] ] $ join
                [ [ HD.legend [ css [ "font-bold" ] ] [ HD.text "Jobs" ] ]

                , jobs # itraversed `ifoldMapOf` \n l -> pure $
                    HD.div
                      [ css [ "flex", "justify-between", "gap-2" ] ]
                      [ HD.select
                          [ css S.input
                          , HP.name $ n ^. simple _Newtype <> "Job"
                          , HE.onMouseOver \_ -> SetPreview $ pure PreviewJobs
                          , HE.onFocus \_ -> SetPreview $ pure PreviewJobs
                          , HE.onValueChange $ SetJobName n l
                          ] $ intercalate [ hr ] $
                          [ HD.option
                              [ HP.value "" ]
                              [ HD.text "-- Select job --" ]
                          ] `cons`
                            ( icon.classes <#> \c ->
                                filter (_class `elemOf` (c ^. _name))
                                  icon.souls
                                  <#> \s ->
                                    HD.optgroup
                                      [ HP.prop (WC.PropName "label")
                                          $ s ^. _name <. _Newtype
                                      ]
                                      $ filter (_soul `elemOf` (s ^. _name))
                                          icon.jobs
                                      <#> \j ->
                                        HD.option
                                          [ HP.value $ j ^. _name <. _Newtype
                                          , HP.selected $ n == j ^. _name
                                          ]
                                          [ HD.text $ j ^. _name <. _Newtype ]
                            )

                      , HD.select
                          [ css S.input
                          , HP.name $ n ^. simple _Newtype <> "JobLevel"
                          , HE.onValueChange $ SetJobLevel n
                          ] $ [ I, II, III, IV ] <#> \jl ->
                          HD.option
                            ( [ HP.value $ encode stringJobLevel jl
                              ] <> guard (l == jl) [ HP.selected true ]
                            )
                            [ HD.text $ encode stringJobLevel jl ]

                      , HD.button
                          [ css
                              [ "rounded"
                              , "self-center"
                              , "size-[1em]"
                              , if primary == Just n then "bg-sky-600"
                                else "bg-stone-400 dark:bg-stone-700"
                              ]
                          , HP.type_ HP.ButtonButton
                          , HE.onClick \_ -> SetPrimary
                              if primary == Just n then Nothing else Just n
                          ]
                          []

                      , HD.button
                          [ css $ S.interactable <> [ "px-2", "rounded" ]
                          , HP.type_ HP.ButtonButton
                          , HE.onClick \_ -> RemoveJob n
                          ]
                          [ HD.text "-" ]
                      ]

                , [ HD.button
                      [ css S.button
                      , HP.type_ HP.ButtonButton
                      , HE.onClick \_ -> NewJob
                      ]
                      [ HD.text "+" ]
                  ]
                ]

            , HD.fieldset
                [ css [ "flex", "flex-col", "gap-1" ] ] $ join
                [ [ HD.legend [ css [ "font-bold" ] ] [ HD.text "Talents" ] ]
                , talents # itraversed `ifoldMapOf` \i id -> pure $
                    HD.div
                      [ css [ "flex", "justify-between", "gap-2" ] ]
                      [ HD.select
                          [ css S.input
                          , HP.name $ "talent-" <> show i
                          , HE.onMouseOver \_ ->
                              SetPreview $ pure PreviewTalents
                          , HE.onFocus \_ -> SetPreview $ pure PreviewTalents
                          , HE.onValueChange $ SetTalents i
                          ] $
                          intersperse hr $
                            ( HD.option
                                [ HP.value "" ]
                                [ HD.text "-- Select talent --" ]
                            ) `cons`
                              ( charJobs <#> \j ->
                                  HD.optgroup
                                    [ HP.prop (WC.PropName "label")
                                        $ j ^. _name <. _Newtype
                                    ]
                                    $ charTalents
                                    # filter
                                        ( view _id >>> elem ~$
                                            (j ^:: J._talents <. traversed)
                                        )
                                    <#> \t ->
                                      HD.option
                                        [ HP.value $ t ^. _id <. _Newtype
                                        , HP.selected $ id == t ^. _id
                                        , HP.disabled
                                            $ elem (t ^. _id) talents
                                        ]
                                        [ HD.text $ t ^. _name <. _Newtype ]
                              )

                      , HD.button
                          [ css $ S.interactable <> [ "px-2", "rounded" ]
                          , HP.type_ HP.ButtonButton
                          , HE.onClick \_ -> RemoveTalent i
                          ]
                          [ HD.text "-" ]
                      ]

                , [ HD.button
                      [ css S.button
                      , HP.type_ HP.ButtonButton
                      , HE.onClick \_ -> NewTalent
                      ]
                      [ HD.text "+" ]
                  ]
                ]

            , HD.fieldset
                [ css [ "flex", "flex-col", "gap-1" ] ] $ join
                [ [ HD.legend [ css [ "font-bold" ] ] [ HD.text "Abilities" ] ]
                , abilities # itraversed `ifoldMapOf` \i (n /\ x) -> pure $
                    HD.div
                      [ css [ "flex", "justify-between", "gap-2" ] ]
                      [ HD.select
                          [ css S.input
                          , HP.name $ "ability-" <> show i <> "-name"
                          , HE.onMouseOver \_ ->
                              SetPreview $ pure PreviewAbilities
                          , HE.onFocus \_ -> SetPreview $ pure PreviewAbilities
                          , HE.onValueChange $ Name >>> SetAbility i ~$ x
                          ] $ join
                          [ [ HD.option
                                [ HP.value "" ]
                                [ HD.text "-- Select ability --" ]

                            , hr
                            ]

                          , charJobs <#> \j ->
                              HD.optgroup
                                [ HP.prop (WC.PropName "label")
                                    $ j ^. _name <. _Newtype
                                ]
                                $ icon.abilities
                                # filter
                                    ( view _name >>> elem ~$
                                        ( j ^:: J._abilities
                                            <. traversed
                                            <. filtered
                                              ( preview _1 >>>
                                                  (_ <= lookup (j ^. _name) jobs)
                                              )
                                            <. _2
                                        )
                                    )
                                <#> \a ->
                                  HD.option
                                    [ HP.value $ a ^. _name <. _Newtype
                                    , HP.selected $ n == a ^. _name
                                    , HP.disabled
                                        $ elem (a ^. _name) <<< map fst
                                        $ abilities
                                    ]
                                    [ HD.text $ a ^. _name <. _Newtype ]

                          , [ hr ]

                          , charClasses <#> \c ->
                              HD.optgroup
                                [ HP.prop (WC.PropName "label")
                                    $ c ^. _name <. _Newtype
                                ]
                                $ icon.abilities
                                # filter
                                    (view _name >>> elem ~$ (c ^. _apprentice))
                                <#> \a ->
                                  HD.option
                                    [ HP.value $ a ^. _name <. _Newtype
                                    , HP.selected $ n == a ^. _name
                                    , HP.disabled
                                        $ elem (a ^. _name) <<< map fst
                                        $ abilities
                                    ]
                                    [ HD.text $ a ^. _name <. _Newtype ]
                          ]

                      , HD.button
                          [ css
                              [ "rounded"
                              , "self-center"
                              , "size-[1em]"
                              , if x then "bg-sky-600"
                                else "bg-stone-400 dark:bg-stone-700"
                              ]
                          , HP.type_ HP.ButtonButton
                          , HE.onClick \_ -> SetAbility i n (not x)
                          ]
                          []

                      , HD.button
                          [ css $ S.interactable <> [ "px-2", "rounded" ]
                          , HP.type_ HP.ButtonButton
                          , HE.onClick \_ -> RemoveAbility i
                          ]
                          [ HD.text "-" ]
                      ]

                , [ HD.button
                      [ css S.button
                      , HP.type_ HP.ButtonButton
                      , HE.onClick \_ -> NewAbility
                      ]
                      [ HD.text "+" ]
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
                ] $ join
                [ [ HD.h4
                      [ css [ "col-span-full", "text-center", "font-bold" ] ]
                      [ HD.text "Active" ]
                  ]
                , activeAbilities # traversed #~ \n ->
                    icon.abilities # traversed <. filtered (_name `elemOf` n) #~
                      pure <<< renderAbility icon
                ]

            , HD.div [ css [ "my-4" ] ] [ hr ]

            , HD.div
                [ css
                    [ "grid"
                    , "grid-cols-[repeat(auto-fit,minmax(min(250px,100%),1fr))]"
                    , "gap-x-2"
                    , "gap-y-6"
                    ]
                ] $ join
                [ [ HD.h4
                      [ css [ "col-span-full", "text-center", "font-bold" ] ]
                      [ HD.text "Inactive" ]
                  ]
                , inactiveAbilities # traversed #~ \n ->
                    icon.abilities # traversed <. filtered (_name `elemOf` n) #~
                      pure <<< renderAbility icon
                ]
            ]
        ]

  editCharacterText icon pathChar char =
    let
      parsed = decode (stringCharacter icon) $ char
    in
      HD.div
        [ css [ "flex", "flex-col", "w-full", "gap-2" ] ]
        [ HD.form
            [ css [ "flex", "flex-col", "gap-2" ] ]
            [ HD.div
                [ css [ "flex", "justify-between", "gap-2" ] ]
                [ HD.button
                    [ css S.button
                    , HP.type_ HP.ButtonButton
                    , HE.onClick \_ -> SetMode Visual
                    ]
                    [ HD.text "Visual" ]

                , HD.div
                    [ css [ "flex", "gap-2" ] ]
                    [ HD.button
                        [ css S.button
                        , HP.type_ HP.ButtonSubmit
                        , HP.disabled $ isLeft parsed
                        , HE.onClick \_ -> SaveChar $ hush parsed
                        ]
                        [ HD.text "Save" ]

                    , HD.button
                        [ css S.button
                        , HP.type_ HP.ButtonButton
                        , HE.onClick \_ -> Navigate
                            (Characters $ ViewChar <<< view _name <$> pathChar)
                            Nothing
                        ]
                        [ HD.text "Cancel" ]
                    ]
                ]

            , HD.label
                [ css [ "font-bold" ], HP.for "edit" ]
                [ HD.text "Edit character" ]

            , HD.div
                [ css [ "flex" ] ]
                [ HD.textarea
                    [ css $ S.input <> [ "mx-2", "font-mono" ]
                    , HP.rows 15
                    , HP.cols 40
                    , HP.id "edit"
                    , HP.value char
                    , HE.onValueChange SetTextChar
                    ]

                , case parsed of
                    Right _ -> HD.span [] []
                    Left e ->
                      HD.pre
                        [ css [ "text-red-600" ] ]
                        [ HD.text $ intercalate "\n" $ parseErrorHuman char 20 e
                        ]
                ]

            ]
        ]
