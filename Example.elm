module Example exposing (..)

import Html
import View exposing (..)


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
        , view = view >> View.toHtml (\_ -> identity)
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


type alias Page =
    ( SiteTitle, { home : ListPosts, post : SinglePost } )


type alias SiteTitle =
    On Click Msg (H1 String)


type alias ListPosts =
    List (Section SinglePost)


type alias SinglePost =
    ( PostTitle, PostContent )


type alias PostTitle =
    On Click Msg (H2 String)


type alias PostContent =
    P String


type alias Post =
    { id : Int
    , title : String
    , content : String
    }


view : Model -> View Page Msg
view model =
    let
        currentPost : Maybe Post
        currentPost =
            model.posts
                |> List.filter (\p -> Just p.id == model.currentPost)
                |> List.head
    in
    tuple2
        viewHeader
        (case currentPost of
            Nothing ->
                match .home <| viewHome model.posts

            Just post ->
                match .post <| viewPost post
        )


viewHeader : View SiteTitle Msg
viewHeader =
    onClick ToHome (h1 (text "My Blog!"))


viewHome : List Post -> View ListPosts Msg
viewHome posts =
    list <| List.map (section << viewPost) posts


viewPost : Post -> View SinglePost Msg
viewPost post =
    tuple2 (viewTitle post) (p <| text post.content)


viewTitle : Post -> View PostTitle Msg
viewTitle post =
    onClick (ToPost post.id) (h2 <| text post.title)
