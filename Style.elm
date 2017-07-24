module Style exposing (Styling, all, none, section)

import Css exposing (Snippet, Style)
import Css.Elements
import Semantic exposing (..)


type Styling a
    = Styling (List Snippet)


section : List Style -> Styling child -> Styling (Section child msg)
section styles (Styling childSnippets) =
    Styling
        [ Css.Elements.section (Css.children childSnippets :: styles)
        ]


none : Styling a
none =
    Styling []


all : Styling child -> Styling (List child)
all (Styling snippets) =
    Styling snippets
