module Example exposing (..)

import Html
import Html.Typed exposing (..)


type alias Model =
    { posts : List Post
    , currentPost : Maybe Int
    }


type Msg
    = ToPost Int
    | ToHome


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view >> Html.Typed.toRaw
        , update = update
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToPost id ->
            { model | currentPost = Just id }

        ToHome ->
            { model | currentPost = Nothing }


init : Model
init =
    { posts =
        [ { id = 1, title = "Bears", content = "A treatise on bears." }
        , { id = 2, title = "Sharks", content = "Not nearly as awesome as bears." }
        ]
    , currentPost = Nothing
    }


type Page
    = Page Header Body


type alias Header =
    On Click Msg (H1 String)


type Body
    = ListPosts (List SinglePost)
    | SinglePost SinglePost


type alias SinglePost =
    Section PostBody


type PostBody
    = PostBody PostTitle PostContent


type alias PostTitle =
    On Click Msg (H2 String)


type alias PostContent =
    P String


type alias Post =
    { id : Int
    , title : String
    , content : String
    }


view : Model -> Html Page Msg
view model =
    let
        currentPost : Maybe Post
        currentPost =
            model.posts
                |> List.filter (\p -> Just p.id == model.currentPost)
                |> List.head
    in
    within Page
        |> add viewHeader
        |> add
            (case currentPost of
                Nothing ->
                    name ListPosts <| viewHome model.posts

                Just post ->
                    name SinglePost <| viewPost post
            )


viewHeader : Html Header Msg
viewHeader =
    onClick ToHome (h1 (text "My Blog!"))


viewHome : List Post -> Html (List SinglePost) Msg
viewHome posts =
    list <| List.map viewPost posts


viewPost : Post -> Html SinglePost Msg
viewPost post =
    within PostBody
        |> add (viewTitle post)
        |> add (p <| text post.content)
        |> section


viewTitle : Post -> Html PostTitle Msg
viewTitle post =
    onClick (ToPost post.id) (h2 <| text post.title)


type MyWidget
    = MyWidget


myWidget : Html.Html msg
myWidget =
    Html.text "Hello World!"
