module Semantic.Internal exposing (..)

import Html exposing (Attribute, Html)


{- Element types.

   Only semantic elements get a type, so no Div or Span here.
-}


type alias Attrs msg =
    List (Attribute msg)


type H1 child msg
    = H1 (Attrs msg) child


type H2 child msg
    = H2 (Attrs msg) child


type Section child msg
    = Section (Attrs msg) child


type P child msg
    = P (Attrs msg) child



-- Add more types for semantic elements below.
