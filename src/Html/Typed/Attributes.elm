module Html.Typed.Attributes exposing (..)

import Html
import Html.Typed.Internal exposing (Attribute)


attr : Html.Attribute msg -> Attribute attrs msg
attr =
    Html.Typed.Internal.fromRaw
