module Html.Typed.Internal exposing (..)

import Html
import Html.Attributes
import Html.Events
import Json.Decode exposing (Decoder)


type Attribute attrs msg
    = Attribute (SubAttribute msg)


type SubAttribute msg
    = On String (Decoder msg)
    | Raw (Html.Attribute msg)


mkAttr : SubAttribute msg -> Html.Attribute msg
mkAttr attr =
    case attr of
        On event msgDecoder ->
            Html.Events.on event msgDecoder

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
    Attribute (On event msgDecoder)


mapAttr : (msgA -> msgB) -> SubAttribute msgA -> SubAttribute msgB
mapAttr fn attr =
    case attr of
        On event msgDecoder ->
            On event (Json.Decode.map fn msgDecoder)

        Raw attr ->
            Raw (Html.Attributes.map fn attr)
