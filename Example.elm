module Example exposing (..)

import Css exposing (Snippet, Style)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Json.Encode
import Layout exposing (Layout)
import Semantic exposing (H2, P, Section)
import Style exposing (Styling)


{- Step 1: Define the structure of your view

   Note that you can only use semantic elements in defining your structure, so no div's and span's.
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


page : Page Msg
page =
    Semantic.section []
        [ post1, post2 ]


post1 : BlogPost Msg
post1 =
    Semantic.section [ onClick (ToPost 1) ]
        ( Semantic.h2 [] "First Post"
        , Semantic.p [] "Let me tell you all about style-elements..."
        )


post2 : BlogPost Msg
post2 =
    Semantic.section [ onClick (ToPost 2) ]
        ( Semantic.h2 [] "Part Two"
        , Semantic.p [] "In which we continue where part 1 left off."
        )



{- Step 3: Write your layout function.

   Here we define how the page semantically defined above should be layed out.
   If the page type above changes, the layout should break.

-}


view : Page msg -> Html msg
view page =
    Layout.section (Layout.col layoutPost) page
        |> Layout.view


layoutPost : BlogPost msg -> Layout msg
layoutPost post =
    post
        |> Layout.section (Layout.col2 (Layout.h2 Layout.text) (Layout.p Layout.text))



{- Step 4: Define styling for your elements

   Note that we reuse our previously defined type aliases for part of the page, no classnames necessary.
   The phantom `Styling` type will ensure the tree of styles we create matches the page structure.

   To ensure we only do styling here and no layouts, we might create a lib that exposes a subset of elm-css.

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
        [ view page
        , Html.node "style"
            [ Attr.property "textContent" (Json.Encode.string css)
            , Attr.property "type" (Json.Encode.string "text/css")
            ]
            []
        ]


type Msg
    = ToPost Int
