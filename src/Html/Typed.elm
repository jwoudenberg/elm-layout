module Html.Typed exposing (Click, H1, H2, Html, On, P, Section, add, debug, h1, h2, list, map, name, on, onClick, p, section, text, toRaw, within)

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
-- 1. A phantom type ensures the Html corresponds to the page type.
-- 2. We don't render directly into Html to support different interpreters:
--    - Elm-css uses a different Html type.
--    - A view test might wish to interpret the view in a different way.
--    - Certain optimizations (like collapsing unnecessary containers) are only
--      possible if we can introspect our page structure.


type Html tipe msg
    = Html (SubHtml msg)


type SubHtml msg
    = H1 (SubHtml msg)
    | H2 (SubHtml msg)
    | H3 (SubHtml msg)
    | H4 (SubHtml msg)
    | H5 (SubHtml msg)
    | H6 (SubHtml msg)
    | Section (SubHtml msg)
    | P (SubHtml msg)
    | Text String
    | List (List (SubHtml msg))
    | On String (Decoder msg) (SubHtml msg)


toSubHtml : Html tipe msg -> SubHtml msg
toSubHtml (Html subHtml) =
    subHtml


h1 : Html tipe msg -> Html (H1 tipe) msg
h1 child =
    Html <| H1 (toSubHtml child)


h2 : Html tipe msg -> Html (H2 tipe) msg
h2 child =
    Html <| H2 (toSubHtml child)


h3 : Html tipe msg -> Html (H3 tipe) msg
h3 child =
    Html <| H3 (toSubHtml child)


section : Html tipe msg -> Html (Section tipe) msg
section child =
    Html <| Section (toSubHtml child)


p : Html tipe msg -> Html (P tipe) msg
p child =
    Html <| P (toSubHtml child)


onClick : msg -> Html tipe msg -> Html (On Click msg tipe) msg
onClick msg child =
    on "click" (Json.Decode.succeed msg) child


on : String -> Decoder msg -> Html tipe msg -> Html (On event msg tipe) msg
on event msgDecoder child =
    Html <| On event msgDecoder (toSubHtml child)


text : String -> Html String msg
text text =
    Html <| Text text


list : List (Html tipe msg) -> Html (List tipe) msg
list xs =
    Html <| List (List.map toSubHtml xs)


within : (a -> b) -> Html (a -> b) msg
within _ =
    Html <| List []


add : Html tipe1 msg -> Html (tipe1 -> tipe2) msg -> Html tipe2 msg
add child2 child1 =
    Html <|
        case ( toSubHtml child1, toSubHtml child2 ) of
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
debug : Html tipe msg
debug =
    Html <| Text "Debugging value. Remove me!"


map : (msgA -> msgB) -> Html tipe msgA -> Html tipe msgB
map fn (Html subHtml) =
    Html (mapSubHtml fn subHtml)


{-| Name a view type to have that name appear in compiler errors rather than a
tree of html types.

Suppose your social network app contains a chatbox widget. Ordinarily view
compilation errors of parts of your page that include the widget would contain
the tree-like Html type describing the widget. Using `name` we can make it that
we only see the widget name instead.

    type ChatBoxWidget
        = ChatBoxWidget ( H2 String, List Message )

    view : Model -> Html ChatBoxWidget msg
    view model =
        name ChatBoxWidget
            ( h2 (text "Chatbox")
            , list (List.map viewMessage model.messages)
            )

-}
name : (a -> b) -> Html a msg -> Html b msg
name _ (Html subHtml) =
    Html subHtml


mapSubHtml : (msgA -> msgB) -> SubHtml msgA -> SubHtml msgB
mapSubHtml fn subHtml =
    case subHtml of
        H1 child ->
            H1 (mapSubHtml fn child)

        H2 child ->
            H2 (mapSubHtml fn child)

        H3 child ->
            H3 (mapSubHtml fn child)

        H4 child ->
            H4 (mapSubHtml fn child)

        H5 child ->
            H5 (mapSubHtml fn child)

        H6 child ->
            H6 (mapSubHtml fn child)

        Section child ->
            Section (mapSubHtml fn child)

        P child ->
            P (mapSubHtml fn child)

        Text text ->
            Text text

        List children ->
            List (List.map (mapSubHtml fn) children)

        On event msgDecoder child ->
            On event (Json.Decode.map fn msgDecoder) (mapSubHtml fn child)



-- # Html generation
-- One example of a view interpreter, this one producing plain Html.


toRaw : Html tipe msg -> Html.Html msg
toRaw (Html subHtml) =
    mkSubHtml [] subHtml


mkSubHtml : List (Html.Attribute msg) -> SubHtml msg -> Html.Html msg
mkSubHtml attrs subHtml =
    case subHtml of
        H1 child ->
            Html.h1 attrs (List.map (mkSubHtml []) (toChildren child))

        H2 child ->
            Html.h2 attrs (List.map (mkSubHtml []) (toChildren child))

        H3 child ->
            Html.h3 attrs (List.map (mkSubHtml []) (toChildren child))

        H4 child ->
            Html.h4 attrs (List.map (mkSubHtml []) (toChildren child))

        H5 child ->
            Html.h5 attrs (List.map (mkSubHtml []) (toChildren child))

        H6 child ->
            Html.h6 attrs (List.map (mkSubHtml []) (toChildren child))

        Section child ->
            Html.section attrs (List.map (mkSubHtml []) (toChildren child))

        P child ->
            Html.p attrs (List.map (mkSubHtml []) (toChildren child))

        Text text ->
            Html.text text

        List children ->
            Html.div attrs (List.map (mkSubHtml []) children)

        On event msgDecoder child ->
            mkSubHtml [ Html.Events.on event msgDecoder ] child


toChildren : SubHtml msg -> List (SubHtml msg)
toChildren subHtml =
    case subHtml of
        H1 _ ->
            [ subHtml ]

        H2 _ ->
            [ subHtml ]

        H3 _ ->
            [ subHtml ]

        H4 _ ->
            [ subHtml ]

        H5 _ ->
            [ subHtml ]

        H6 _ ->
            [ subHtml ]

        Section _ ->
            [ subHtml ]

        P _ ->
            [ subHtml ]

        Text _ ->
            [ subHtml ]

        List children ->
            children

        On _ _ _ ->
            [ subHtml ]
