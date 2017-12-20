module View exposing (H1, H2, OnClick, OneOf, OneOfFour, OneOfThree, OneOfTwo, P, Section, View, debug, h1, h2, list, map, maybe, onClick, opt1, opt2, opt3, opt4, p, section, text, toHtml, tuple2)

import Html exposing (Html)
import Html.Events


-- # Elements
-- This is a type level API for Html documents.
-- Use the standard types defined here or create your own.


type H1 child
    = H1Type Never


type H2 child
    = H2Type Never


type Section child
    = SectionType Never


type P child
    = PType Never


type OnClick msg child
    = OnClickType Never


type OneOf children
    = OneOfType Never


type alias OneOfTwo tipe1 tipe2 =
    OneOf { opt1 : tipe1, opt2 : tipe2 }


type alias OneOfThree tipe1 tipe2 tipe3 =
    OneOf { opt1 : tipe1, opt2 : tipe2, opt3 : tipe3 }


type alias OneOfFour tipe1 tipe2 tipe3 tipe4 =
    OneOf { opt1 : tipe1, opt2 : tipe2, opt3 : tipe3, opt4 : tipe4 }



-- # Single type representation
-- This is meant for creating view functions.
-- 1. A phantom type ensures the View corresponds to the page type.
-- 2. Customize the `SubView` type with your own stuff.
-- 3. We don't render directly into Html to support different interpreters:
--    - Elm-css uses a different Html type.
--    - A view test might wish to interpret the view in a different way.
--    - Certain optimizations (like collapsing unnecessary containers) are only
--      possible if we can introspect our page structure.


type View tipe custom msg
    = View (SubView custom msg)


type SubView custom msg
    = H1 (SubView custom msg)
    | H2 (SubView custom msg)
    | Section (SubView custom msg)
    | P (SubView custom msg)
    | Text String
    | List (List (SubView custom msg))
    | OnClick msg (SubView custom msg)
    | Custom custom (SubView custom msg)


toSubView : View tipe custom msg -> SubView custom msg
toSubView (View subView) =
    subView


h1 : View tipe custom msg -> View (H1 tipe) custom msg
h1 child =
    View <| H1 (toSubView child)


h2 : View tipe custom msg -> View (H2 tipe) custom msg
h2 child =
    View <| H2 (toSubView child)


section : View tipe custom msg -> View (Section tipe) custom msg
section child =
    View <| H2 (toSubView child)


p : View tipe custom msg -> View (P tipe) custom msg
p child =
    View <| P (toSubView child)


onClick : msg -> View tipe custom msg -> View (OnClick msg tipe) custom msg
onClick msg child =
    View <| OnClick msg (toSubView child)


text : String -> View String custom msg
text text =
    View <| Text text


maybe : Maybe a -> View tipe1 custom msg -> (a -> View tipe2 custom msg) -> View (OneOfTwo tipe1 tipe2) custom msg
maybe maybe (View first) second =
    case maybe of
        Nothing ->
            View first

        Just x ->
            let
                (View sub) =
                    second x
            in
            View sub


list : List (View tipe custom msg) -> View (List tipe) custom msg
list xs =
    View <| List (List.map toSubView xs)


opt1 : View tipe custom msg -> View (OneOf { r | opt1 : tipe }) custom msg
opt1 child =
    View <| toSubView child


opt2 : View tipe custom msg -> View (OneOf { r | opt2 : tipe }) custom msg
opt2 child =
    View <| toSubView child


opt3 : View tipe custom msg -> View (OneOf { r | opt3 : tipe }) custom msg
opt3 child =
    View <| toSubView child


opt4 : View tipe custom msg -> View (OneOf { r | opt4 : tipe }) custom msg
opt4 child =
    View <| toSubView child


tuple2 : View tipe1 custom msg -> View tipe2 custom msg -> View ( tipe1, tipe2 ) custom msg
tuple2 child1 child2 =
    View <| List [ toSubView child1, toSubView child2 ]


{-| Useful during development, to get unimplemented parts of view functions compiling.
-}
debug : View tipe custom msg
debug =
    View <| Text "Debugging value. Remove me!"


map : (msgA -> msgB) -> View tipe custom msgA -> View tipe custom msgB
map fn (View subView) =
    View (mapSubView fn subView)


mapSubView : (msgA -> msgB) -> SubView custom msgA -> SubView custom msgB
mapSubView fn subView =
    case subView of
        H1 child ->
            H1 (mapSubView fn child)

        H2 child ->
            H2 (mapSubView fn child)

        Section child ->
            Section (mapSubView fn child)

        P child ->
            P (mapSubView fn child)

        Text text ->
            Text text

        List children ->
            List (List.map (mapSubView fn) children)

        OnClick msg child ->
            OnClick (fn msg) (mapSubView fn child)

        Custom custom child ->
            Custom custom (mapSubView fn child)



-- # View generation
-- One example of a view interpreter, this one producing plain Html.


toHtml : (custom -> Html msg -> Html msg) -> View tipe custom msg -> Html msg
toHtml viewCustom (View subView) =
    mkSubView viewCustom [] subView


mkSubView : (custom -> Html msg -> Html msg) -> List (Html.Attribute msg) -> SubView custom msg -> Html msg
mkSubView viewCustom attrs subView =
    case subView of
        H1 child ->
            Html.h1 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        H2 child ->
            Html.h2 attrs (List.map (mkSubView viewCustom []) (toChildren child))

        Section child ->
            Html.section attrs (List.map (mkSubView viewCustom []) (toChildren child))

        P child ->
            Html.p attrs (List.map (mkSubView viewCustom []) (toChildren child))

        Text text ->
            Html.text text

        List children ->
            Html.div attrs (List.map (mkSubView viewCustom []) children)

        OnClick msg child ->
            mkSubView viewCustom [ Html.Events.onClick msg ] child

        Custom custom child ->
            viewCustom custom (mkSubView viewCustom attrs child)


toChildren : SubView custom msg -> List (SubView custom msg)
toChildren subView =
    case subView of
        H1 _ ->
            [ subView ]

        H2 _ ->
            [ subView ]

        Section _ ->
            [ subView ]

        P _ ->
            [ subView ]

        Text _ ->
            [ subView ]

        List children ->
            children

        OnClick _ _ ->
            [ subView ]

        Custom _ _ ->
            [ subView ]
