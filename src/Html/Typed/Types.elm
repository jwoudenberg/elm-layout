module Html.Typed.Types exposing (H1, H2, H3, H4, H5, H6, P, Section)

-- # Elements
-- This is a type level API for Html documents.
-- Use the standard types defined here or create your own.


type H1 attrs child
    = H1Type Never


type H2 attrs child
    = H2Type Never


type H3 attrs child
    = H3Type Never


type H4 attrs child
    = H4Type Never


type H5 attrs child
    = H5Type Never


type H6 attrs child
    = H6Type Never


type Section attrs child
    = SectionType Never


type P attrs child
    = PType Never
