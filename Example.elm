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
        , view = view >> Html.Typed.toHtml
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
    = Page SiteTitle PageType


type PageType
    = HomePage ListPosts
    | PostPage SinglePost


type alias SiteTitle =
    On Click Msg (H1 String)


type alias ListPosts =
    List (Section SinglePost)


type SinglePost
    = SinglePost ( PostTitle, PostContent )


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
                    name HomePage <| viewHome model.posts

                Just post ->
                    name PostPage <| viewPost post
            )


viewHeader : Html SiteTitle Msg
viewHeader =
    onClick ToHome (h1 (text "My Blog!"))


viewHome : List Post -> Html ListPosts Msg
viewHome posts =
    list <| List.map (section << viewPost) posts


viewPost : Post -> Html SinglePost Msg
viewPost post =
    tuple2 (viewTitle post) (p <| text post.content)
        |> name SinglePost


viewTitle : Post -> Html PostTitle Msg
viewTitle post =
    onClick (ToPost post.id) (h2 <| text post.title)


type MyWidget
    = MyWidget


myWidget : Html.Html msg
myWidget =
    Html.text "Hello World!"
