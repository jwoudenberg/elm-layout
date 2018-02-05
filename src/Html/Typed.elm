module Html.Typed exposing (H1, H2, Html, P, Section, add, debug, fromRaw, h1, h2, list, map, name, on, onClick, p, section, text, toRaw, within)

import Html
import Html.Events
import Json.Decode exposing (Decoder)


-- # Elements
-- This is a type level API for Html documents.
-- Use the standard types defined here or create your own.


type H1 attrs child
    = H1Type Never


type H2 attrs child
    = H2Type Never


type H3 attrs child
    = H3Type Never


type H4 attrs child
    = H4Type Never


type H5 attrs child
    = H5Type Never


type H6 attrs child
    = H6Type Never


type Section attrs child
    = SectionType Never


type P attrs child
    = PType Never



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
    = Node String (List (SubAttr msg)) (SubHtml msg)
    | Text String
    | List (List (SubHtml msg))
    | Raw (Html.Html msg)


type Attr attrs msg
    = Attr (SubAttr msg)


type SubAttr msg
    = On String (Decoder msg)


toSubHtml : Html tipe msg -> SubHtml msg
toSubHtml (Html subHtml) =
    subHtml


toSubAttr : Attr attrs msg -> SubAttr msg
toSubAttr (Attr subAttr) =
    subAttr


h1 : List (Attr attrs msg) -> Html tipe msg -> Html (H1 attrs tipe) msg
h1 attrs child =
    Html <| Node "h1" (List.map toSubAttr attrs) (toSubHtml child)


h2 : List (Attr attrs msg) -> Html tipe msg -> Html (H2 attrs tipe) msg
h2 attrs child =
    Html <| Node "h2" (List.map toSubAttr attrs) (toSubHtml child)


h3 : List (Attr attrs msg) -> Html tipe msg -> Html (H3 attrs tipe) msg
h3 attrs child =
    Html <| Node "h3" (List.map toSubAttr attrs) (toSubHtml child)


section : List (Attr attrs msg) -> Html tipe msg -> Html (Section attrs tipe) msg
section attrs child =
    Html <| Node "section" (List.map toSubAttr attrs) (toSubHtml child)


p : List (Attr attrs msg) -> Html tipe msg -> Html (P attrs tipe) msg
p attrs child =
    Html <| Node "p" (List.map toSubAttr attrs) (toSubHtml child)


onClick : msg -> Attr { r | onClick : msg } msg
onClick msg =
    on "click" (Json.Decode.succeed msg)


onDoubleClick : msg -> Attr { r | onDoubleClick : msg } msg
onDoubleClick msg =
    on "dblclick" (Json.Decode.succeed msg)


onInput : (String -> msg) -> Attr { r | onInput : msg } msg
onInput tagger =
    on "input" (Json.Decode.map tagger Html.Events.targetValue)


onBlur : msg -> Attr { r | onBlur : msg } msg
onBlur msg =
    on "blur" (Json.Decode.succeed msg)


on : String -> Decoder msg -> Attr attrs msg
on event msgDecoder =
    Attr (On event msgDecoder)


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
        Node tag attrs child ->
            Node tag (List.map (mapAttr fn) attrs) (mapSubHtml fn child)

        Text text ->
            Text text

        List children ->
            List (List.map (mapSubHtml fn) children)

        Raw html ->
            Raw (Html.map fn html)


mapAttr : (msgA -> msgB) -> SubAttr msgA -> SubAttr msgB
mapAttr fn attr =
    case attr of
        On event msgDecoder ->
            On event (Json.Decode.map fn msgDecoder)



-- # Html generation
-- One example of a view interpreter, this one producing plain Html.


toRaw : Html tipe msg -> Html.Html msg
toRaw (Html subHtml) =
    mkSubHtml [] subHtml


fromRaw : Html.Html msg -> Html tipe msg
fromRaw html =
    Html <| Raw html


mkSubHtml : List (Html.Attribute msg) -> SubHtml msg -> Html.Html msg
mkSubHtml attrs subHtml =
    case subHtml of
        Node tag attrs child ->
            Html.node tag (List.map mkAttr attrs) (List.map (mkSubHtml []) (toChildren child))

        Text text ->
            Html.text text

        List children ->
            Html.div attrs (List.map (mkSubHtml []) children)

        Raw html ->
            html


mkAttr : SubAttr msg -> Html.Attribute msg
mkAttr attr =
    case attr of
        On event msgDecoder ->
            Html.Events.on event msgDecoder


toChildren : SubHtml msg -> List (SubHtml msg)
toChildren subHtml =
    case subHtml of
        Node _ _ _ ->
            [ subHtml ]

        Text _ ->
            [ subHtml ]

        List children ->
            children

        Raw _ ->
            []
