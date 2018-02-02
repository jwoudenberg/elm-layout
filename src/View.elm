module View exposing (Click, CustomView, H1, H2, On, P, Section, View, add, debug, h1, h2, list, map, name, on, onClick, p, section, text, toHtml, toHtmlSimple, tuple2, within)

import Html exposing (Html)
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
-- 2. Customize the `SubView` type with your own stuff.
-- 3. We don't render directly into Html to support different interpreters:
--    - Elm-css uses a different Html type.
--    - A view test might wish to interpret the view in a different way.
--    - Certain optimizations (like collapsing unnecessary containers) are only
--      possible if we can introspect our page structure.


type CustomView tipe custom msg
    = View (SubView custom msg)


{-| A View type that doesn't allow customizations. Nice to use when starting
out with this library.
-}
type alias View tipe msg =
    CustomView tipe () msg


type SubView custom msg
    = H1 (SubView custom msg)
    | H2 (SubView custom msg)
    | H3 (SubView custom msg)
    | H4 (SubView custom msg)
    | H5 (SubView custom msg)
    | H6 (SubView custom msg)
    | Section (SubView custom msg)
    | P (SubView custom msg)
    | Text String
    | List (List (SubView custom msg))
    | On String (Decoder msg) (SubView custom msg)
    | Custom custom (SubView custom msg)


toSubView : CustomView tipe custom msg -> SubView custom msg
toSubView (View subView) =
    subView


h1 : CustomView tipe custom msg -> CustomView (H1 tipe) custom msg
h1 child =
    View <| H1 (toSubView child)


h2 : CustomView tipe custom msg -> CustomView (H2 tipe) custom msg
h2 child =
    View <| H2 (toSubView child)


h3 : CustomView tipe custom msg -> CustomView (H3 tipe) custom msg
h3 child =
    View <| H3 (toSubView child)


section : CustomView tipe custom msg -> CustomView (Section tipe) custom msg
section child =
    View <| Section (toSubView child)


p : CustomView tipe custom msg -> CustomView (P tipe) custom msg
p child =
    View <| P (toSubView child)


onClick : msg -> CustomView tipe custom msg -> CustomView (On Click msg tipe) custom msg
onClick msg child =
    on "click" (Json.Decode.succeed msg) child


on : String -> Decoder msg -> CustomView tipe custom msg -> CustomView (On event msg tipe) custom msg
on event msgDecoder child =
    View <| On event msgDecoder (toSubView child)


text : String -> CustomView String custom msg
text text =
    View <| Text text


list : List (CustomView tipe custom msg) -> CustomView (List tipe) custom msg
list xs =
    View <| List (List.map toSubView xs)


tuple2 : CustomView tipe1 custom msg -> CustomView tipe2 custom msg -> CustomView ( tipe1, tipe2 ) custom msg
tuple2 child1 child2 =
    View <| List [ toSubView child1, toSubView child2 ]


within : (a -> b) -> CustomView (a -> b) custom msg
within _ =
    View <| List []


add : CustomView tipe1 custom msg -> CustomView (tipe1 -> tipe2) custom msg -> CustomView tipe2 custom msg
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
debug : CustomView tipe custom msg
debug =
    View <| Text "Debugging value. Remove me!"


map : (msgA -> msgB) -> CustomView tipe custom msgA -> CustomView tipe custom msgB
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

    view : Model -> View ChatBoxWidget custom msg
    view model =
        name ChatBoxWidget
            ( h2 (text "Chatbox")
            , list (List.map viewMessage model.messages)
            )

-}
name : (a -> b) -> CustomView a custom msg -> CustomView b custom msg
name _ (View subView) =
    View subView


mapSubView : (msgA -> msgB) -> SubView custom msgA -> SubView custom msgB
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

        Custom custom child ->
            Custom custom (mapSubView fn child)



-- # View generation
-- One example of a view interpreter, this one producing plain Html.


toHtml : (custom -> Html msg -> Html msg) -> CustomView tipe custom msg -> Html msg
toHtml viewCustom (View subView) =
    mkSubView viewCustom [] subView


toHtmlSimple : CustomView tipe custom msg -> Html msg
toHtmlSimple =
    toHtml (always identity)


mkSubView : (custom -> Html msg -> Html msg) -> List (Html.Attribute msg) -> SubView custom msg -> Html msg
mkSubView viewCustom attrs subView =
    case subView of
        H1 child ->
            Html.h1 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        H2 child ->
            Html.h2 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        H3 child ->
            Html.h3 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        H4 child ->
            Html.h4 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        H5 child ->
            Html.h5 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        H6 child ->
            Html.h6 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        Section child ->
            Html.section attrs (List.map (mkSubView viewCustom []) (toChildren child))

        P child ->
            Html.p attrs (List.map (mkSubView viewCustom []) (toChildren child))

        Text text ->
            Html.text text

        List children ->
            Html.div attrs (List.map (mkSubView viewCustom []) children)

        On event msgDecoder child ->
            mkSubView viewCustom [ Html.Events.on event msgDecoder ] child

        Custom custom child ->
            viewCustom custom (mkSubView viewCustom attrs child)


toChildren : SubView custom msg -> List (SubView custom msg)
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

        Custom _ _ ->
            [ subView ]
