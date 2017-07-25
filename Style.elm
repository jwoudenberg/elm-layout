module Style exposing (Styling, all, none, section, stylesheet)

{-| The functions in this module allow you to define styles for the elements in your page type.

  - The use of this module is completely optional. It'll just generate elm-css for you that you will have to either embed in a style tag or turn into a style sheet.
  - This module uses elm-css but similar modules could be written for non-elm-css like styling languages.

-}

import Css exposing (Snippet, Style)
import Css.Elements
import Semantic exposing (..)


type Styling a
    = Styling (List Snippet)


section : List Style -> Styling child -> Styling (Section child msg)
section styles (Styling childSnippets) =
    Styling
        [ Css.Elements.section (Css.descendants childSnippets :: styles)
        ]


none : Styling a
none =
    Styling []


all : Styling child -> Styling (List child)
all (Styling snippets) =
    Styling snippets


stylesheet : Styling a -> Css.Stylesheet
stylesheet (Styling snippets) =
    Css.stylesheet snippets
