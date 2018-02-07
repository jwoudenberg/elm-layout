module Html.Typed.Internal exposing (..)

import Html
import Html.Events
import Json.Decode exposing (Decoder)


type Attribute attrs msg
    = Attribute (SubAttribute msg)


type SubAttribute msg
    = On String (Decoder msg)


mkAttr : SubAttribute msg -> Html.Attribute msg
mkAttr attr =
    case attr of
        On event msgDecoder ->
            Html.Events.on event msgDecoder


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
