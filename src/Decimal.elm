module Decimal exposing (DV, dabs, dadd, dfmt, dvColumnHeader, viewDV)

import Html exposing (Html, td, th, text)

import Html.Attributes exposing (class, style)
import Msg exposing (Msg)
import Types exposing (DRCRFormat(..))

type alias DV =
    { amt : Int
    , exp : Int
    }
-- Given a single decimal type struct, return the absolute value.

dabs : DV -> DV
dabs n =
    if n.amt < 0 then
        DV -n.amt n.exp
    else
        n

-- Given two decimal type structs, return their sum.

dadd : DV -> DV -> DV
dadd n1 n2 =
    let
        d =
            n1.exp - n2.exp
    in
    if d >= 1 then
        dadd { amt = n1.amt * 10, exp = n1.exp - 1 } n2

    else if d == 0 then
        { amt = n1.amt + n2.amt, exp = n1.exp }

    else
        -- d < 0
        dadd n2 n1



-- Given given a decimal type struct and a number of decimal places, produce a String image


dfmt : Int -> { amt : Int, exp : Int } -> String
dfmt p n =
    let
        negative =
            n.amt < 0

        samt =
            if negative then
                String.slice 1 99 (String.fromInt n.amt)

            else
                String.fromInt n.amt

        --len_samt = String.length samt
        sign =
            if negative then
                "-"

            else
                ""
    in
    if n.exp >= 0 then
        sign ++ f1 n.exp samt ++ "." ++ String.repeat p "0"

    else
    -- Time to pad or round
    if
        p + n.exp > 0
    then
        sign ++ f1 n.exp samt ++ String.repeat (p + n.exp) "0"

    else
        --exp 3
        sign ++ round p (f1 n.exp samt)


dvColumnHeader : String -> DRCRFormat -> List (Html Msg)
dvColumnHeader heading drcr =
    case drcr of
        DRCR ->
            [ th[style "padding-right" "0em" ][text heading]
            , th[style "padding-left" "0.3em"][] -- drcr column
            ]
        PlusAndMinus ->
            [ th[][text heading] ]

viewDV : DV -> Int -> DRCRFormat -> String -> List( String, String ) -> List (Html Msg)
viewDV dv p drcr c s =
    case drcr of
        DRCR ->
            if dv.amt < 0 then
                [ td
                    --[ class c, style s ]
                    [ class c ]

                    [ text (dfmt p (dabs dv) ) ]
                , td[style  "padding-left" "0.3em" ][ text "CR"]
                ]
            else if dv.amt == 0 then
                [ td
                    --[ class c, style s ]
                    [ class c ]

                    [ text (dfmt p dv) ]
                , td[][ text ""]
                ]
            else -- must be > 0
                [ td
                    --[ class c, style s ]
                    [ class c ]
                    [ text (dfmt p dv) ]
                , td[style "padding-left" "0.3em" ][ text "DR"]
                ]

        PlusAndMinus ->
            [ td
                --[ class c, style s ]
                [ class c]
                [ text (dfmt p dv) ]
            ]



-- Given a String image of a decimal type struct and a number of decimal places, produce a rounded String


round : Int -> String -> String
round p samt =
    let
        lsamt =
            String.length samt

        idxs =
            String.indexes "." samt

        n =
            case List.head idxs of
                Just v ->
                    v

                Nothing ->
                    0

        -- should never get here
        samt_m2 =
            String.left (lsamt - 1) samt

        round_digit =
            case String.toInt (String.slice (lsamt - 2) (lsamt - 1) samt) of
                --Ok v ->
                Just v ->
                    v

                --Err _ ->
                Nothing ->
                    0

        last_digit =
            case String.toInt (String.right 1 samt) of
                --Ok v ->
                Just v ->
                    v

                --Err _ ->
                Nothing ->
                    0

        new_digit =
            if last_digit >= 5 then
                round_digit + 1

            else
                round_digit

        q =
            lsamt - n - 1
    in
    if q < p then
        samt_m2 ++ "c"

    else if q == p then
        samt_m2 ++ String.fromInt last_digit

    else
        round p samt_m2


insertDp : Int -> String -> String
insertDp exp samt =
    let
        lhs =
            String.slice 0 (String.length samt + exp) samt

        rhs =
            String.right (0 - exp) samt
    in
    lhs ++ "." ++ rhs



-- Given the mantissa as a String and an exponent, return a String with a decimal point inserted into the correct position -or- a String appropriately padded with zeros.  For example:
-- 1 e4    = 1nnnnn
-- 1 e-4   = 0.nnn1
-- 467 e-2 = 4.67


f1 : Int -> String -> String
f1 exp samt =
    if exp > 0 then
        samt ++ String.repeat (exp - String.length samt + 1) "0"
        -- 1yyyyy

    else if exp == 0 then
        samt

    else
    -- must be < 0
    if
        String.length samt + exp >= 1
    then
        insertDp exp samt

    else
        "0." ++ String.repeat (-1 * (exp + String.length samt)) "0" ++ samt
