module Html.Typed.Events exposing (onBlur, onClick, onDoubleClick, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp)

import Html.Events exposing (defaultOptions)
import Html.Typed.Internal exposing (Attribute, on, onWithOptions)
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


onCheck : (Bool -> msg) -> Attribute { r | onCheck : msg } msg
onCheck tagger =
    on "change" (Json.Decode.map tagger Html.Events.targetChecked)


onSubmit : msg -> Attribute { r | onSubmit : msg } msg
onSubmit msg =
    onWithOptions "submit" onSubmitOptions (Json.Decode.succeed msg)


onSubmitOptions : Html.Events.Options
onSubmitOptions =
    { defaultOptions | preventDefault = True }


onBlur : msg -> Attribute { r | onBlur : msg } msg
onBlur msg =
    on "blur" (Json.Decode.succeed msg)


onFocus : msg -> Attribute { r | onFocus : msg } msg
onFocus msg =
    on "focus" (Json.Decode.succeed msg)


onMouseDown : msg -> Attribute { r | onMouseDown : msg } msg
onMouseDown msg =
    on "mousedown" (Json.Decode.succeed msg)


onMouseUp : msg -> Attribute { r | onMouseUp : msg } msg
onMouseUp msg =
    on "mouseup" (Json.Decode.succeed msg)


onMouseEnter : msg -> Attribute { r | onMouseEnter : msg } msg
onMouseEnter msg =
    on "mouseenter" (Json.Decode.succeed msg)


onMouseLeave : msg -> Attribute { r | onMouseLeave : msg } msg
onMouseLeave msg =
    on "mouseleave" (Json.Decode.succeed msg)


onMouseOver : msg -> Attribute { r | onMouseOver : msg } msg
onMouseOver msg =
    on "mouseover" (Json.Decode.succeed msg)


onMouseOut : msg -> Attribute { r | onMouseOut : msg } msg
onMouseOut msg =
    on "mouseout" (Json.Decode.succeed msg)


on : String -> Decoder msg -> Attribute attrs msg
on =
    Html.Typed.Internal.on


onWithOptions : String -> Html.Events.Options -> Decoder msg -> Attribute attrs msg
onWithOptions =
    Html.Typed.Internal.onWithOptions
