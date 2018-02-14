module Html.Typed.Attributes
    exposing
        ( accept
        , acceptCharset
        , accesskey
        , action
        , align
        , alt
        , async
        , attribute
        , autocomplete
        , autofocus
        , autoplay
        , challenge
        , charset
        , checked
        , cite
        , class
        , classList
        , cols
        , colspan
        , content
        , contenteditable
        , contextmenu
        , controls
        , coords
        , datetime
        , default
        , defaultValue
        , defer
        , dir
        , disabled
        , download
        , downloadAs
        , draggable
        , dropzone
        , enctype
        , for
        , form
        , formaction
        , headers
        , height
        , hidden
        , href
        , hreflang
        , httpEquiv
        , id
        , ismap
        , itemprop
        , keytype
        , kind
        , lang
        , language
        , list
        , loop
        , manifest
        , map
        , max
        , maxlength
        , media
        , method
        , min
        , minlength
        , multiple
        , name
        , novalidate
        , pattern
        , ping
        , placeholder
        , poster
        , preload
        , property
        , pubdate
        , readonly
        , rel
        , required
        , reversed
        , rows
        , rowspan
        , sandbox
        , scope
        , scoped
        , seamless
        , selected
        , shape
        , size
        , spellcheck
        , src
        , srcdoc
        , srclang
        , start
        , step
        , style
        , tabindex
        , target
        , title
        , type_
        , usemap
        , value
        , width
        , wrap
        )

{-|

@docs style, property, attribute, map , class, classList, id, title, hidden , type_, value, defaultValue, checked, placeholder, selected , accept, acceptCharset, action, autocomplete, autofocus, disabled, enctype, formaction, list, maxlength, minlength, method, multiple, name, novalidate, pattern, readonly, required, size, for, form , max, min, step , cols, rows, wrap , href, target, download, downloadAs, hreflang, media, ping, rel , ismap, usemap, shape, coords , src, height, width, alt , autoplay, controls, loop, preload, poster, default, kind, srclang , sandbox, seamless, srcdoc , reversed, start , align, colspan, rowspan, headers, scope , async, charset, content, defer, httpEquiv, language, scoped , accesskey, contenteditable, contextmenu, dir, draggable, dropzone, itemprop, lang, spellcheck, tabindex , challenge, keytype , cite, datetime, pubdate, manifest

-}

import Html.Typed.Internal as Internal exposing (Attribute)
import Json.Encode as Json


{-| -}
style : List ( String, String ) -> Attribute attrs msg
style =
    Internal.Attribute << Internal.Style


{-| -}
classList : List ( String, Bool ) -> Attribute attrs msg
classList list =
    list
        |> List.filter Tuple.second
        |> List.map Tuple.first
        |> String.join " "
        |> class


{-| -}
property : String -> Json.Value -> Attribute attrs msg
property name value =
    Internal.Attribute <| Internal.Property name value


stringProperty : String -> String -> Attribute attrs msg
stringProperty name string =
    property name (Json.string string)


boolProperty : String -> Bool -> Attribute attrs msg
boolProperty name bool =
    property name (Json.bool bool)


{-| -}
attribute : String -> String -> Attribute attrs msg
attribute name string =
    Internal.Attribute <| Internal.Attribute_ name string


{-| -}
map : (a -> msg) -> Attribute attrs a -> Attribute attrs msg
map =
    Internal.mapAttr


{-| -}
class : String -> Attribute attrs msg
class name =
    stringProperty "className" name


{-| -}
hidden : Bool -> Attribute attrs msg
hidden bool =
    boolProperty "hidden" bool


{-| -}
id : String -> Attribute attrs msg
id name =
    stringProperty "id" name


{-| -}
title : String -> Attribute attrs msg
title name =
    stringProperty "title" name


{-| -}
accesskey : Char -> Attribute attrs msg
accesskey char =
    stringProperty "accessKey" (String.fromChar char)


{-| -}
contenteditable : Bool -> Attribute attrs msg
contenteditable bool =
    boolProperty "contentEditable" bool


{-| -}
contextmenu : String -> Attribute attrs msg
contextmenu value =
    attribute "contextmenu" value


{-| -}
dir : String -> Attribute attrs msg
dir value =
    stringProperty "dir" value


{-| -}
draggable : String -> Attribute attrs msg
draggable value =
    attribute "draggable" value


{-| -}
dropzone : String -> Attribute attrs msg
dropzone value =
    stringProperty "dropzone" value


{-| -}
itemprop : String -> Attribute attrs msg
itemprop value =
    attribute "itemprop" value


{-| -}
lang : String -> Attribute attrs msg
lang value =
    stringProperty "lang" value


{-| -}
spellcheck : Bool -> Attribute attrs msg
spellcheck bool =
    boolProperty "spellcheck" bool


{-| -}
tabindex : Int -> Attribute attrs msg
tabindex n =
    attribute "tabIndex" (toString n)


{-| -}
async : Bool -> Attribute attrs msg
async bool =
    boolProperty "async" bool


{-| -}
charset : String -> Attribute attrs msg
charset value =
    attribute "charset" value


{-| -}
content : String -> Attribute attrs msg
content value =
    stringProperty "content" value


{-| -}
defer : Bool -> Attribute attrs msg
defer bool =
    boolProperty "defer" bool


{-| -}
httpEquiv : String -> Attribute attrs msg
httpEquiv value =
    stringProperty "httpEquiv" value


{-| -}
language : String -> Attribute attrs msg
language value =
    stringProperty "language" value


{-| -}
scoped : Bool -> Attribute attrs msg
scoped bool =
    boolProperty "scoped" bool


{-| -}
src : String -> Attribute attrs msg
src value =
    stringProperty "src" value


{-| -}
height : Int -> Attribute attrs msg
height value =
    attribute "height" (toString value)


{-| -}
width : Int -> Attribute attrs msg
width value =
    attribute "width" (toString value)


{-| -}
alt : String -> Attribute attrs msg
alt value =
    stringProperty "alt" value


{-| -}
autoplay : Bool -> Attribute attrs msg
autoplay bool =
    boolProperty "autoplay" bool


{-| -}
controls : Bool -> Attribute attrs msg
controls bool =
    boolProperty "controls" bool


{-| -}
loop : Bool -> Attribute attrs msg
loop bool =
    boolProperty "loop" bool


{-| -}
preload : String -> Attribute attrs msg
preload value =
    stringProperty "preload" value


{-| -}
poster : String -> Attribute attrs msg
poster value =
    stringProperty "poster" value


{-| -}
default : Bool -> Attribute attrs msg
default bool =
    boolProperty "default" bool


{-| -}
kind : String -> Attribute attrs msg
kind value =
    stringProperty "kind" value


{-| -}
srclang : String -> Attribute attrs msg
srclang value =
    stringProperty "srclang" value


{-| -}
sandbox : String -> Attribute attrs msg
sandbox value =
    stringProperty "sandbox" value


{-| -}
seamless : Bool -> Attribute attrs msg
seamless bool =
    boolProperty "seamless" bool


{-| -}
srcdoc : String -> Attribute attrs msg
srcdoc value =
    stringProperty "srcdoc" value


{-| -}
type_ : String -> Attribute attrs msg
type_ value =
    stringProperty "type" value


{-| -}
value : String -> Attribute attrs msg
value value =
    stringProperty "value" value


{-| -}
defaultValue : String -> Attribute attrs msg
defaultValue value =
    stringProperty "defaultValue" value


{-| -}
checked : Bool -> Attribute attrs msg
checked bool =
    boolProperty "checked" bool


{-| -}
placeholder : String -> Attribute attrs msg
placeholder value =
    stringProperty "placeholder" value


{-| -}
selected : Bool -> Attribute attrs msg
selected bool =
    boolProperty "selected" bool


{-| -}
accept : String -> Attribute attrs msg
accept value =
    stringProperty "accept" value


{-| -}
acceptCharset : String -> Attribute attrs msg
acceptCharset value =
    stringProperty "acceptCharset" value


{-| -}
action : String -> Attribute attrs msg
action value =
    stringProperty "action" value


{-| -}
autocomplete : Bool -> Attribute attrs msg
autocomplete bool =
    stringProperty "autocomplete"
        (if bool then
            "on"
         else
            "off"
        )


{-| -}
autofocus : Bool -> Attribute attrs msg
autofocus bool =
    boolProperty "autofocus" bool


{-| -}
disabled : Bool -> Attribute attrs msg
disabled bool =
    boolProperty "disabled" bool


{-| -}
enctype : String -> Attribute attrs msg
enctype value =
    stringProperty "enctype" value


{-| -}
formaction : String -> Attribute attrs msg
formaction value =
    attribute "formAction" value


{-| -}
list : String -> Attribute attrs msg
list value =
    attribute "list" value


{-| -}
minlength : Int -> Attribute attrs msg
minlength n =
    attribute "minLength" (toString n)


{-| -}
maxlength : Int -> Attribute attrs msg
maxlength n =
    attribute "maxlength" (toString n)


{-| -}
method : String -> Attribute attrs msg
method value =
    stringProperty "method" value


{-| -}
multiple : Bool -> Attribute attrs msg
multiple bool =
    boolProperty "multiple" bool


{-| -}
name : String -> Attribute attrs msg
name value =
    stringProperty "name" value


{-| -}
novalidate : Bool -> Attribute attrs msg
novalidate bool =
    boolProperty "noValidate" bool


{-| -}
pattern : String -> Attribute attrs msg
pattern value =
    stringProperty "pattern" value


{-| -}
readonly : Bool -> Attribute attrs msg
readonly bool =
    boolProperty "readOnly" bool


{-| -}
required : Bool -> Attribute attrs msg
required bool =
    boolProperty "required" bool


{-| -}
size : Int -> Attribute attrs msg
size n =
    attribute "size" (toString n)


{-| -}
for : String -> Attribute attrs msg
for value =
    stringProperty "htmlFor" value


{-| -}
form : String -> Attribute attrs msg
form value =
    attribute "form" value


{-| -}
max : String -> Attribute attrs msg
max value =
    stringProperty "max" value


{-| -}
min : String -> Attribute attrs msg
min value =
    stringProperty "min" value


{-| -}
step : String -> Attribute attrs msg
step n =
    stringProperty "step" n


{-| -}
cols : Int -> Attribute attrs msg
cols n =
    attribute "cols" (toString n)


{-| -}
rows : Int -> Attribute attrs msg
rows n =
    attribute "rows" (toString n)


{-| -}
wrap : String -> Attribute attrs msg
wrap value =
    stringProperty "wrap" value


{-| -}
ismap : Bool -> Attribute attrs msg
ismap value =
    boolProperty "isMap" value


{-| -}
usemap : String -> Attribute attrs msg
usemap value =
    stringProperty "useMap" value


{-| -}
shape : String -> Attribute attrs msg
shape value =
    stringProperty "shape" value


{-| -}
coords : String -> Attribute attrs msg
coords value =
    stringProperty "coords" value


{-| -}
challenge : String -> Attribute attrs msg
challenge value =
    attribute "challenge" value


{-| -}
keytype : String -> Attribute attrs msg
keytype value =
    stringProperty "keytype" value


{-| -}
align : String -> Attribute attrs msg
align value =
    stringProperty "align" value


{-| -}
cite : String -> Attribute attrs msg
cite value =
    stringProperty "cite" value


{-| -}
href : String -> Attribute attrs msg
href value =
    stringProperty "href" value


{-| -}
target : String -> Attribute attrs msg
target value =
    stringProperty "target" value


{-| -}
download : Bool -> Attribute attrs msg
download bool =
    boolProperty "download" bool


{-| -}
downloadAs : String -> Attribute attrs msg
downloadAs value =
    stringProperty "download" value


{-| -}
hreflang : String -> Attribute attrs msg
hreflang value =
    stringProperty "hreflang" value


{-| -}
media : String -> Attribute attrs msg
media value =
    attribute "media" value


{-| -}
ping : String -> Attribute attrs msg
ping value =
    stringProperty "ping" value


{-| -}
rel : String -> Attribute attrs msg
rel value =
    attribute "rel" value


{-| -}
datetime : String -> Attribute attrs msg
datetime value =
    attribute "datetime" value


{-| -}
pubdate : String -> Attribute attrs msg
pubdate value =
    attribute "pubdate" value


{-| -}
reversed : Bool -> Attribute attrs msg
reversed bool =
    boolProperty "reversed" bool


{-| -}
start : Int -> Attribute attrs msg
start n =
    stringProperty "start" (toString n)


{-| -}
colspan : Int -> Attribute attrs msg
colspan n =
    attribute "colspan" (toString n)


{-| -}
headers : String -> Attribute attrs msg
headers value =
    stringProperty "headers" value


{-| -}
rowspan : Int -> Attribute attrs msg
rowspan n =
    attribute "rowspan" (toString n)


{-| -}
scope : String -> Attribute attrs msg
scope value =
    stringProperty "scope" value


{-| -}
manifest : String -> Attribute attrs msg
manifest value =
    attribute "manifest" value
