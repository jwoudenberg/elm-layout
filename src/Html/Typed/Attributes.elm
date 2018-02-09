module Html.Typed.Attributes exposing (..)

import Html
import Html.Typed.Internal exposing (Attribute)


fromRaw : Html.Attribute msg -> Attribute attrs msg
fromRaw =
    Html.Typed.Internal.fromRaw
