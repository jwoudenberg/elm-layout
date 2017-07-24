module Semantic exposing (H1, H2, P, Section, h1, h2, p, section)

import Semantic.Internal as Internal


{- Element types.

   Only semantic elements get a type, so no Div or Span here.
-}


type alias H1 child msg =
    Internal.H1 child msg


type alias H2 child msg =
    Internal.H2 child msg


type alias Section child msg =
    Internal.Section child msg


type alias P child msg =
    Internal.P child msg


h1 : Internal.Attrs msg -> child -> H1 child msg
h1 =
    Internal.H1


h2 : Internal.Attrs msg -> child -> H2 child msg
h2 =
    Internal.H2


section : Internal.Attrs msg -> child -> Section child msg
section =
    Internal.Section


p : Internal.Attrs msg -> child -> P child msg
p =
    Internal.P
