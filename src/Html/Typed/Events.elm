module Html.Typed.Events exposing (onBlur, onClick, onDoubleClick, onInput)

import Html.Events
import Html.Typed.Internal exposing (Attribute, on)
import Json.Decode exposing (Decoder)


onClick : msg -> Attribute { r | onClick : msg } msg
onClick msg =
    on "click" (Json.Decode.succeed msg)


onDoubleClick : msg -> Attribute { r | onDoubleClick : msg } msg
onDoubleClick msg =
    on "dblclick" (Json.Decode.succeed msg)


onInput : (String -> msg) -> Attribute { r | onInput : msg } msg
onInput tagger =
    on "input" (Json.Decode.map tagger Html.Events.targetValue)


onBlur : msg -> Attribute { r | onBlur : msg } msg
onBlur msg =
    on "blur" (Json.Decode.succeed msg)
