module Html.Typed.Events exposing (on, onBlur, onClick, onDoubleClick, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onWithOptions)

{-|


## Event handler constructors

@docs on, onBlur, onClick, onDoubleClick, onInput, onMouseDown, onMouseEnter, onMouseLeave, onMouseOut, onMouseOver, onMouseUp, onWithOptions

-}

import Html.Events exposing (defaultOptions)
import Html.Typed.Internal exposing (Attribute, on, onWithOptions)
import Json.Decode exposing (Decoder)


{-| -}
onClick : msg -> Attribute { r | onClick : msg } msg
onClick msg =
    on .onClick "click" (Json.Decode.succeed msg)


{-| -}
onDoubleClick : msg -> Attribute { r | onDoubleClick : msg } msg
onDoubleClick msg =
    on .onDoubleClick "dblclick" (Json.Decode.succeed msg)


{-| -}
onInput : (String -> msg) -> Attribute { r | onInput : msg } msg
onInput tagger =
    on .onInput "input" (Json.Decode.map tagger Html.Events.targetValue)


{-| -}
onCheck : (Bool -> msg) -> Attribute { r | onCheck : msg } msg
onCheck tagger =
    on .onCheck "change" (Json.Decode.map tagger Html.Events.targetChecked)


{-| -}
onSubmit : msg -> Attribute { r | onSubmit : msg } msg
onSubmit msg =
    onWithOptions .onSubmit "submit" onSubmitOptions (Json.Decode.succeed msg)


onSubmitOptions : Html.Events.Options
onSubmitOptions =
    { defaultOptions | preventDefault = True }


{-| -}
onBlur : msg -> Attribute { r | onBlur : msg } msg
onBlur msg =
    on .onBlur "blur" (Json.Decode.succeed msg)


{-| -}
onFocus : msg -> Attribute { r | onFocus : msg } msg
onFocus msg =
    on .onFocus "focus" (Json.Decode.succeed msg)


{-| -}
onMouseDown : msg -> Attribute { r | onMouseDown : msg } msg
onMouseDown msg =
    on .onMouseDown "mousedown" (Json.Decode.succeed msg)


{-| -}
onMouseUp : msg -> Attribute { r | onMouseUp : msg } msg
onMouseUp msg =
    on .onMouseUp "mouseup" (Json.Decode.succeed msg)


{-| -}
onMouseEnter : msg -> Attribute { r | onMouseEnter : msg } msg
onMouseEnter msg =
    on .onMouseEnter "mouseenter" (Json.Decode.succeed msg)


{-| -}
onMouseLeave : msg -> Attribute { r | onMouseLeave : msg } msg
onMouseLeave msg =
    on .onMouseLeave "mouseleave" (Json.Decode.succeed msg)


{-| -}
onMouseOver : msg -> Attribute { r | onMouseOver : msg } msg
onMouseOver msg =
    on .onMouseOver "mouseover" (Json.Decode.succeed msg)


{-| -}
onMouseOut : msg -> Attribute { r | onMouseOut : msg } msg
onMouseOut msg =
    on .onMouseOut "mouseout" (Json.Decode.succeed msg)


{-| -}
on : (attrs -> msg) -> String -> Decoder msg -> Attribute attrs msg
on _ =
    Html.Typed.Internal.on


{-| -}
onWithOptions : (attrs -> msg) -> String -> Html.Events.Options -> Decoder msg -> Attribute attrs msg
onWithOptions _ =
    Html.Typed.Internal.onWithOptions
