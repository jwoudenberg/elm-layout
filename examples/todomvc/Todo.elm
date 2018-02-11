port module Todo exposing (..)

{-| TodoMVC implemented in Elm, using typed HTML and CSS for rendering.

Based on the original TodoMVC which can be found here: <https://github.com/evancz/elm-todomvc>

-}

import Dom
import Html
import Html.Attributes exposing (..)
import Html.Typed exposing (..)
import Html.Typed.Attributes exposing (..)
import Html.Typed.Events exposing (..)
import Html.Events exposing (keyCode)
import Json.Decode as Json
import String
import Task


main : Program (Maybe Model) Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view >> Html.Typed.toRaw
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }


port setStorage : Model -> Cmd msg


{-| We want to `setStorage` on every update. This function adds the setStorage
command for every step of the update function.
-}
updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage newModel, cmds ]
        )



-- MODEL
-- The full application state of our todo app.


type alias Model =
    { entries : List Entry
    , field : String
    , uid : Int
    , visibility : String
    }


type alias Entry =
    { description : String
    , completed : Bool
    , editing : Bool
    , id : Int
    }


emptyModel : Model
emptyModel =
    { entries = []
    , visibility = "All"
    , field = ""
    , uid = 0
    }


newEntry : String -> Int -> Entry
newEntry desc id =
    { description = desc
    , completed = False
    , editing = False
    , id = id
    }


init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    Maybe.withDefault emptyModel savedModel ! []



-- UPDATE


{-| Users of our app can trigger messages by clicking and typing. These
messages are fed into the `update` function as they occur, letting us react
to them.
-}
type Msg
    = NoOp
    | UpdateField String
    | EditingEntry Int Bool
    | UpdateEntry Int String
    | Add
    | Delete Int
    | DeleteComplete
    | Check Int Bool
    | CheckAll Bool
    | ChangeVisibility String



-- How we update our Model on a given Msg?


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Add ->
            { model
                | uid = model.uid + 1
                , field = ""
                , entries =
                    if String.isEmpty model.field then
                        model.entries
                    else
                        model.entries ++ [ newEntry model.field model.uid ]
            }
                ! []

        UpdateField str ->
            { model | field = str }
                ! []

        EditingEntry id isEditing ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | editing = isEditing }
                    else
                        t

                focus =
                    Dom.focus ("todo-" ++ toString id)
            in
                { model | entries = List.map updateEntry model.entries }
                    ! [ Task.attempt (\_ -> NoOp) focus ]

        UpdateEntry id task ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | description = task }
                    else
                        t
            in
                { model | entries = List.map updateEntry model.entries }
                    ! []

        Delete id ->
            { model | entries = List.filter (\t -> t.id /= id) model.entries }
                ! []

        DeleteComplete ->
            { model | entries = List.filter (not << .completed) model.entries }
                ! []

        Check id isCompleted ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | completed = isCompleted }
                    else
                        t
            in
                { model | entries = List.map updateEntry model.entries }
                    ! []

        CheckAll isCompleted ->
            let
                updateEntry t =
                    { t | completed = isCompleted }
            in
                { model | entries = List.map updateEntry model.entries }
                    ! []

        ChangeVisibility visibility ->
            { model | visibility = visibility }
                ! []



-- VIEW


type Page
    = Page (Section {} PageBody) PageFooter


type PageBody
    = PageBody PageHeader Entries Controls


type alias PageHeader =
    Header {} InputContent


type InputContent
    = InputContent (H1 {} String) (Input { onKeyDown : Msg, onInput : Msg } ())


type alias Entries =
    Section {} EntriesContent


type EntriesContent
    = EntriesContent (Input { onClick : Msg } ()) (Label {} String) (Ul {} (List TodoItem))


type alias TodoItem =
    Li {} TodoItemContents


type TodoItemContents
    = TodoItemContents ViewMode EditMode


type ViewMode
    = ViewMode (Input { onClick : Msg } ()) (Label { onDoubleClick : Msg } String) (Button { onClick : Msg } ())


type alias EditMode =
    Input { onInput : Msg, onBlur : Msg, onKeyDown : Msg } ()


type alias Controls =
    Footer {} ControlsContent


type ControlsContent
    = ControlsContent ControlsCount ControlsFilters ControlsClear


type ControlsCount
    = ControlsCount (Strong {} String) String


type alias ControlsFilters =
    Ul {} ControlsFiltersContent


type ControlsFiltersContent
    = ControlsFiltersContent Filter String Filter String Filter


type alias Filter =
    Li { onClick : Msg } (A {} String)


type alias ControlsClear =
    Button { onClick : Msg } String


type alias PageFooter =
    Footer {} ( P {} String, Link, Link )


type alias Link =
    P {} ( String, A {} String )


view : Model -> Html Page Msg
view model =
    div
        [ attr <| class "todomvc-wrapper"
        , attr <| style [ ( "visibility", "hidden" ) ]
        ]
        (within Page
            |> add
                (section
                    [ attr <| class "todoapp" ]
                    (within PageBody
                        |> add (viewInput model.field)
                        |> add (viewEntries model.visibility model.entries)
                        |> add (viewControls model.visibility model.entries)
                    )
                )
            |> add infoFooter
        )


viewInput : String -> Html PageHeader Msg
viewInput task =
    header
        [ attr <| class "header" ]
        (within InputContent
            |> add (h1 [] (text "todos"))
            |> add
                (input
                    [ attr <| class "new-todo"
                    , attr <| placeholder "What needs to be done?"
                    , attr <| autofocus True
                    , attr <| value task
                    , attr <| name "newTodo"
                    , onInput UpdateField
                    , onEnter Add
                    ]
                    empty
                )
        )


onEnter : Msg -> Attribute { r | onKeyDown : Msg } Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on .onKeyDown "keydown" (Json.andThen isEnter keyCode)



-- VIEW ALL ENTRIES


viewEntries : String -> List Entry -> Html Entries Msg
viewEntries visibility entries =
    let
        isVisible todo =
            case visibility of
                "Completed" ->
                    todo.completed

                "Active" ->
                    not todo.completed

                _ ->
                    True

        allCompleted =
            List.all .completed entries

        cssVisibility =
            if List.isEmpty entries then
                "hidden"
            else
                "visible"
    in
        section
            [ attr <| class "main"
            , attr <| style [ ( "visibility", cssVisibility ) ]
            ]
            (within EntriesContent
                |> add
                    (input
                        [ attr <| class "toggle-all"
                        , attr <| type_ "checkbox"
                        , attr <| name "toggle"
                        , attr <| checked allCompleted
                        , onClick (CheckAll (not allCompleted))
                        ]
                        empty
                    )
                |> add
                    (label
                        [ attr <| for "toggle-all" ]
                        (text "Mark all as complete")
                    )
                |> add
                    (ul
                        [ attr <| class "todo-list" ]
                        (keyedList <|
                            List.map viewKeyedEntry (List.filter isVisible entries)
                        )
                    )
            )



-- VIEW INDIVIDUAL ENTRIES


viewKeyedEntry : Entry -> ( String, Html TodoItem Msg )
viewKeyedEntry todo =
    ( toString todo.id, viewEntry todo )


viewEntry : Entry -> Html TodoItem Msg
viewEntry todo =
    li
        [ attr <| classList [ ( "completed", todo.completed ), ( "editing", todo.editing ) ] ]
        (within TodoItemContents
            |> add
                (div
                    [ attr <| class "view" ]
                    (within ViewMode
                        |> add
                            (input
                                [ attr <| class "toggle"
                                , attr <| type_ "checkbox"
                                , attr <| checked todo.completed
                                , onClick (Check todo.id (not todo.completed))
                                ]
                                empty
                            )
                        |> add
                            (label
                                [ onDoubleClick (EditingEntry todo.id True) ]
                                (text todo.description)
                            )
                        |> add
                            (button
                                [ attr <| class "destroy"
                                , onClick (Delete todo.id)
                                ]
                                empty
                            )
                    )
                )
            |> add
                (input
                    [ attr <| class "edit"
                    , attr <| value todo.description
                    , attr <| name "title"
                    , attr <| id ("todo-" ++ toString todo.id)
                    , onInput (UpdateEntry todo.id)
                    , onBlur (EditingEntry todo.id False)
                    , onEnter (EditingEntry todo.id False)
                    ]
                    empty
                )
        )



-- VIEW CONTROLS AND FOOTER


viewControls : String -> List Entry -> Html Controls Msg
viewControls visibility entries =
    let
        entriesCompleted =
            List.length (List.filter .completed entries)

        entriesLeft =
            List.length entries - entriesCompleted
    in
        footer
            [ attr <| class "footer"
            , attr <| hidden (List.isEmpty entries)
            ]
            (within ControlsContent
                |> add (viewControlsCount entriesLeft)
                |> add (viewControlsFilters visibility)
                |> add (viewControlsClear entriesCompleted)
            )


viewControlsCount : Int -> Html ControlsCount Msg
viewControlsCount entriesLeft =
    let
        item_ =
            if entriesLeft == 1 then
                " item"
            else
                " items"
    in
        span
            [ attr <| class "todo-count" ]
            (within ControlsCount
                |> add (strong [] (text (toString entriesLeft)))
                |> add (text (item_ ++ " left"))
            )


viewControlsFilters : String -> Html ControlsFilters Msg
viewControlsFilters visibility =
    ul
        [ attr <| class "filters" ]
        (within ControlsFiltersContent
            |> add (visibilitySwap "#/" "All" visibility)
            |> add (text " ")
            |> add (visibilitySwap "#/active" "Active" visibility)
            |> add (text " ")
            |> add (visibilitySwap "#/completed" "Completed" visibility)
        )


visibilitySwap : String -> String -> String -> Html Filter Msg
visibilitySwap uri visibility actualVisibility =
    li
        [ onClick (ChangeVisibility visibility) ]
        (a [ attr <| href uri, attr <| classList [ ( "selected", visibility == actualVisibility ) ] ]
            (text visibility)
        )


viewControlsClear : Int -> Html ControlsClear Msg
viewControlsClear entriesCompleted =
    button
        [ attr <| class "clear-completed"
        , attr <| hidden (entriesCompleted == 0)
        , onClick DeleteComplete
        ]
        (text ("Clear completed (" ++ toString entriesCompleted ++ ")"))


infoFooter : Html PageFooter msg
infoFooter =
    footer [ attr <| class "info" ]
        (within (,,)
            |> add (p [] (text "Double-click to edit a todo"))
            |> add
                (p []
                    (within (,)
                        |> add (text "Written by ")
                        |> add (a [ attr <| href "https://github.com/evancz" ] (text "Evan Czaplicki"))
                    )
                )
            |> add
                (p []
                    (within (,)
                        |> add (text "Part of ")
                        |> add (a [ attr <| href "http://todomvc.com" ] (text "TodoMVC"))
                    )
                )
        )
