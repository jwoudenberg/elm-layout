module Html.Typed.Internal exposing (..)

import Html
import Html.Attributes
import Html.Events
import Json.Decode exposing (Decoder)


type Attribute attrs msg
    = Attribute (SubAttribute msg)


type SubAttribute msg
    = On String Html.Events.Options (Decoder msg)
    | Raw (Html.Attribute msg)


mkAttr : SubAttribute msg -> Html.Attribute msg
mkAttr attr =
    case attr of
        On event options msgDecoder ->
            Html.Events.onWithOptions event options msgDecoder

        Raw attr ->
            attr


fromRaw : Html.Attribute msg -> Attribute attrs msg
fromRaw attr =
    Attribute (Raw attr)


toSubAttr : Attribute attrs msg -> SubAttribute msg
toSubAttr (Attribute subAttr) =
    subAttr


on : String -> Decoder msg -> Attribute attrs msg
on event msgDecoder =
    onWithOptions event Html.Events.defaultOptions msgDecoder


onWithOptions : String -> Html.Events.Options -> Decoder msg -> Attribute attrs msg
onWithOptions event options msgDecoder =
    Attribute (On event options msgDecoder)


mapAttr : (msgA -> msgB) -> SubAttribute msgA -> SubAttribute msgB
mapAttr fn attr =
    case attr of
        On event options msgDecoder ->
            On event options (Json.Decode.map fn msgDecoder)

        Raw attr ->
            Raw (Html.Attributes.map fn attr)
