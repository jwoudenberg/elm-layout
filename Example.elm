module Example exposing (..)

import View exposing (..)


type alias Page =
    ( OnClick Msg (H1 String), OneOfTwo ListPosts SinglePost )


type alias ListPosts =
    List (Section SinglePost)


type alias SinglePost =
    ( OnClick Msg (H2 String), PostContent )


type alias PostContent =
    P String


type Msg
    = ToPost Int
    | ToHome


type alias Model =
    { posts : List Post
    , currentPost : Maybe Int
    }


type alias Post =
    { id : Int
    , title : String
    , content : String
    }


model : Model
model =
    { posts = [ { id = 1, title = "Bears", content = "A treatise on bears." } ]
    , currentPost = Just 1
    }


view : Model -> View Page custom Msg
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
                opt1 <| viewHome model.posts

            Just post ->
                opt2 <| viewPost post
        )


viewHeader : View (OnClick Msg (H1 String)) custom Msg
viewHeader =
    onClick ToHome (h1 (text "My Blog!"))


viewHome : List Post -> View ListPosts custom Msg
viewHome posts =
    list <| List.map (section << viewPost) posts


viewPost : Post -> View SinglePost custom Msg
viewPost post =
    tuple2 (viewTitle post) (p <| text post.content)


viewTitle : Post -> View (OnClick Msg (H2 String)) custom Msg
viewTitle post =
    onClick (ToPost post.id) (h2 <| text post.title)
