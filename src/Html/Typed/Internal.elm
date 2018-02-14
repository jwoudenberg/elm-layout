module Html.Typed.Internal exposing (..)

import Html
import Html.Attributes
import Html.Events
import Json.Decode exposing (Decoder)


type Attribute attrs msg
    = Attribute (SubAttribute msg)


type SubAttribute msg
    = On String Html.Events.Options (Decoder msg)
    | Style (List ( String, String ))
    | Attribute_ String String
    | Property String Json.Decode.Value


mkAttr : SubAttribute msg -> Html.Attribute msg
mkAttr attr =
    case attr of
        On event options msgDecoder ->
            Html.Events.onWithOptions event options msgDecoder

        Style list ->
            Html.Attributes.style list

        Attribute_ name value ->
            Html.Attributes.attribute name value

        Property name value ->
            Html.Attributes.property name value


toSubAttr : Attribute attrs msg -> SubAttribute msg
toSubAttr (Attribute subAttr) =
    subAttr


on : String -> Decoder msg -> Attribute attrs msg
on event msgDecoder =
    onWithOptions event Html.Events.defaultOptions msgDecoder


onWithOptions : String -> Html.Events.Options -> Decoder msg -> Attribute attrs msg
onWithOptions event options msgDecoder =
    Attribute (On event options msgDecoder)


mapAttr : (a -> msg) -> Attribute attrs a -> Attribute attrs msg
mapAttr fn (Attribute attr) =
    Attribute (mapSubAttr fn attr)


mapSubAttr : (a -> msg) -> SubAttribute a -> SubAttribute msg
mapSubAttr fn attr =
    case attr of
        On event options msgDecoder ->
            On event options (Json.Decode.map fn msgDecoder)

        Style list ->
            Style list

        Attribute_ name value ->
            Attribute_ name value

        Property name value ->
            Property name value
