module Html.Typed.Attributes exposing (..)

{-|

@docs attr

-}

import Html
import Html.Typed.Internal exposing (Attribute)


{-| Turn a regular attribute created using elm-lang/html into a Html.Typed.Attribute.
-}
attr : Html.Attribute msg -> Attribute attrs msg
attr =
    Html.Typed.Internal.fromRaw
