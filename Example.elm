module Example exposing (..)

import Css exposing (Snippet, Style)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Json.Encode
import Layout exposing (..)
import Semantic exposing (..)
import Style exposing (Styling)


{- Step 0: Suppose we have the following model for a blog. -}


type alias Model =
    List Post


type alias Post =
    { id : Int
    , title : String
    , body : String
    }


model : Model
model =
    [ { id = 1, title = "Treatise on Bears", body = "Bears are magnificent!" }
    , { id = 2, title = "On the subject of Koalas", body = "I prefer bears." }
    ]



{- Step 1: Define the structure of your view

   Note that you can only use semantic elements in defining your structure,
   so no div's and span's.
   This means you're forced to think about the semantics of your view.
   It also ensures you cannot mix semantics with layout.

-}


type alias Page msg =
    Section (List (BlogPost msg)) msg


type alias BlogPost msg =
    Section ( H2 String msg, P String msg ) msg



{- Step 2: Define the content of your view

   Note how these functions are focussed on content and behaviour, nothing more.
   All styling and layout concerns are somewhere else.

   This would be an excellent surface to write tests against.
-}


page : Model -> Page Msg
page model =
    Section [] (List.map post model)


post : Post -> BlogPost Msg
post { id, title, body } =
    Section [ onClick (ToPost id) ]
        ( H2 [] title
        , P [] body
        )



{- Step 3: Write your layout function.

   Here we define how the page semantically defined above should be layed out.
   If the page type above changes, the layout should break.

-}


layout : Page msg -> Layout msg
layout page =
    section (col layoutPost) page


layoutPost : BlogPost msg -> Layout msg
layoutPost post =
    section
        (col2 (h2 text) (p text))
        post


view : Model -> Html Msg
view =
    page >> layout >> html



{- Step 4: Define styling for your elements

   Note that we reuse our previously defined type aliases for part of the page,
   no classnames necessary.
   The phantom `Styling` type will ensure the tree of styles we create matches
   the page structure.

   If the page type above breaks the styling should break.
-}


style : Styling (Page msg)
style =
    Style.section [] (Style.all stylePost)


stylePost : Styling (BlogPost msg)
stylePost =
    Style.section
        [ Css.border3 (Css.px 1) Css.solid (Css.hex "#000000") ]
        Style.none


css : String
css =
    Css.compile [ Style.stylesheet style ]
        |> .css


main : Html Msg
main =
    Html.div []
        [ view model
        , Html.node "style"
            [ Attr.property "textContent" (Json.Encode.string css)
            , Attr.property "type" (Json.Encode.string "text/css")
            ]
            []
        ]


type Msg
    = ToPost Int
