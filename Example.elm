module Example exposing (..)

import Html
import View exposing (..)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view >> View.toHtml (\_ -> identity)
        , update = \msg model -> model
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
