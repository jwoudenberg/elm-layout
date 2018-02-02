module View exposing (Click, H1, H2, On, P, Section, View, add, debug, h1, h2, list, map, name, on, onClick, p, section, text, toHtml, tuple2, within)

import Html
import Html.Events
import Json.Decode exposing (Decoder)


-- # Elements
-- This is a type level API for Html documents.
-- Use the standard types defined here or create your own.


type H1 child
    = H1Type Never


type H2 child
    = H2Type Never


type H3 child
    = H3Type Never


type H4 child
    = H4Type Never


type H5 child
    = H5Type Never


type H6 child
    = H6Type Never


type Section child
    = SectionType Never


type P child
    = PType Never


type On event msg child
    = OnType Never


type Click
    = Click Never



-- # Single type representation
-- This is meant for creating view functions.
-- 1. A phantom type ensures the View corresponds to the page type.
-- 2. We don't render directly into Html to support different interpreters:
--    - Elm-css uses a different Html type.
--    - A view test might wish to interpret the view in a different way.
--    - Certain optimizations (like collapsing unnecessary containers) are only
--      possible if we can introspect our page structure.


type View tipe msg
    = View (SubView msg)


type SubView msg
    = H1 (SubView msg)
    | H2 (SubView msg)
    | H3 (SubView msg)
    | H4 (SubView msg)
    | H5 (SubView msg)
    | H6 (SubView msg)
    | Section (SubView msg)
    | P (SubView msg)
    | Text String
    | List (List (SubView msg))
    | On String (Decoder msg) (SubView msg)


toSubView : View tipe msg -> SubView msg
toSubView (View subView) =
    subView


h1 : View tipe msg -> View (H1 tipe) msg
h1 child =
    View <| H1 (toSubView child)


h2 : View tipe msg -> View (H2 tipe) msg
h2 child =
    View <| H2 (toSubView child)


h3 : View tipe msg -> View (H3 tipe) msg
h3 child =
    View <| H3 (toSubView child)


section : View tipe msg -> View (Section tipe) msg
section child =
    View <| Section (toSubView child)


p : View tipe msg -> View (P tipe) msg
p child =
    View <| P (toSubView child)


onClick : msg -> View tipe msg -> View (On Click msg tipe) msg
onClick msg child =
    on "click" (Json.Decode.succeed msg) child


on : String -> Decoder msg -> View tipe msg -> View (On event msg tipe) msg
on event msgDecoder child =
    View <| On event msgDecoder (toSubView child)


text : String -> View String msg
text text =
    View <| Text text


list : List (View tipe msg) -> View (List tipe) msg
list xs =
    View <| List (List.map toSubView xs)


tuple2 : View tipe1 msg -> View tipe2 msg -> View ( tipe1, tipe2 ) msg
tuple2 child1 child2 =
    View <| List [ toSubView child1, toSubView child2 ]


within : (a -> b) -> View (a -> b) msg
within _ =
    View <| List []


add : View tipe1 msg -> View (tipe1 -> tipe2) msg -> View tipe2 msg
add child2 child1 =
    View <|
        case ( toSubView child1, toSubView child2 ) of
            ( List xs, List ys ) ->
                List (xs ++ ys)

            ( List xs, y ) ->
                List (xs ++ [ y ])

            ( x, List ys ) ->
                List (x :: ys)

            ( x, y ) ->
                List [ x, y ]


{-| Useful during development, to get unimplemented parts of view functions compiling.
-}
debug : View tipe msg
debug =
    View <| Text "Debugging value. Remove me!"


map : (msgA -> msgB) -> View tipe msgA -> View tipe msgB
map fn (View subView) =
    View (mapSubView fn subView)


{-| Name a view type to have that name appear in compiler errors rather than a
tree of html types.

Suppose your social network app contains a chatbox widget. Ordinarily view
compilation errors of parts of your page that include the widget would contain
the tree-like Html type describing the widget. Using `name` we can make it that
we only see the widget name instead.

    type ChatBoxWidget
        = ChatBoxWidget ( H2 String, List Message )

    view : Model -> View ChatBoxWidget msg
    view model =
        name ChatBoxWidget
            ( h2 (text "Chatbox")
            , list (List.map viewMessage model.messages)
            )

-}
name : (a -> b) -> View a msg -> View b msg
name _ (View subView) =
    View subView


mapSubView : (msgA -> msgB) -> SubView msgA -> SubView msgB
mapSubView fn subView =
    case subView of
        H1 child ->
            H1 (mapSubView fn child)

        H2 child ->
            H2 (mapSubView fn child)

        H3 child ->
            H3 (mapSubView fn child)

        H4 child ->
            H4 (mapSubView fn child)

        H5 child ->
            H5 (mapSubView fn child)

        H6 child ->
            H6 (mapSubView fn child)

        Section child ->
            Section (mapSubView fn child)

        P child ->
            P (mapSubView fn child)

        Text text ->
            Text text

        List children ->
            List (List.map (mapSubView fn) children)

        On event msgDecoder child ->
            On event (Json.Decode.map fn msgDecoder) (mapSubView fn child)



-- # View generation
-- One example of a view interpreter, this one producing plain Html.


toHtml : View tipe msg -> Html.Html msg
toHtml (View subView) =
    mkSubView [] subView


mkSubView : List (Html.Attribute msg) -> SubView msg -> Html.Html msg
mkSubView attrs subView =
    case subView of
        H1 child ->
            Html.h1 attrs (List.map (mkSubView []) (toChildren child))

        H2 child ->
            Html.h2 attrs (List.map (mkSubView []) (toChildren child))

        H3 child ->
            Html.h3 attrs (List.map (mkSubView []) (toChildren child))

        H4 child ->
            Html.h4 attrs (List.map (mkSubView []) (toChildren child))

        H5 child ->
            Html.h5 attrs (List.map (mkSubView []) (toChildren child))

        H6 child ->
            Html.h6 attrs (List.map (mkSubView []) (toChildren child))

        Section child ->
            Html.section attrs (List.map (mkSubView []) (toChildren child))

        P child ->
            Html.p attrs (List.map (mkSubView []) (toChildren child))

        Text text ->
            Html.text text

        List children ->
            Html.div attrs (List.map (mkSubView []) children)

        On event msgDecoder child ->
            mkSubView [ Html.Events.on event msgDecoder ] child


toChildren : SubView msg -> List (SubView msg)
toChildren subView =
    case subView of
        H1 _ ->
            [ subView ]

        H2 _ ->
            [ subView ]

        H3 _ ->
            [ subView ]

        H4 _ ->
            [ subView ]

        H5 _ ->
            [ subView ]

        H6 _ ->
            [ subView ]

        Section _ ->
            [ subView ]

        P _ ->
            [ subView ]

        Text _ ->
            [ subView ]

        List children ->
            children

        On _ _ _ ->
            [ subView ]
