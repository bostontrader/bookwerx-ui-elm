{- A Decimal Floating Point (DFP) is a type composed of two integers, a significand and an exponent. Using this format we can readily represent the _exact_ amounts that we find in financial transactions using a method similar to scientific notation, w/o rounding error. Please see https://en.wikipedia.org/wiki/Decimal_floating_point for more info.

   Not only must we represent DFP but we must be able to perform a handful of useful operations on them such as adding, rounding, and string formatting.  This is a small subset of possible operations that can be imagined, but it's enough for this application.
-}


module DecimalFP exposing (DFP, DFPFmt, dfpDecoder, dfp_abs, dfp_add, dfp_equal, dfp_fmt, dfp_round)

import Json.Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (required)


type alias DFP =
    { amount : Int
    , exp : Int
    }


dfpDecoder : Decoder DFP
dfpDecoder =
    Json.Decode.succeed DFP
        |> required "amount" int
        |> required "exp" int



-- A string representation of a DFP with a flag to indicate whether or not there is a loss of precision due to rounding.


type alias DFPFmt =
    { s : String
    , r : Bool -- True = loss of precision due to rounding.
    }



-- Given a DFP, return a DFP representing the absolute value of the original.


dfp_abs : DFP -> DFP
dfp_abs n =
    if n.amount < 0 then
        DFP -n.amount n.exp

    else
        n



-- Given two DFP, return their sum.


dfp_add : DFP -> DFP -> DFP
dfp_add n1 n2 =
    let
        d =
            n1.exp - n2.exp
    in
    if d >= 1 then
        dfp_add { amount = n1.amount * 10, exp = n1.exp - 1 } n2

    else if d == 0 then
        { amount = n1.amount + n2.amount, exp = n1.exp }

    else
        -- d < 0
        dfp_add n2 n1


dfp_equal : DFP -> DFP -> Bool
dfp_equal d1 d2 =
    d1.amount == d2.amount && d1.exp == d2.exp



{- Given a DFP and an Int p, round the DFP to the 10^p position and produce a formatted string with a decimal point and suitable leading and trailing zeros.

   Tamper with this at your own peril.  Feel free to figure this out, refactor, or simplify.
-}


dfp_fmt : Int -> DFP -> DFPFmt
dfp_fmt p dfp =
    let
        negative =
            dfp.amount < 0

        sign =
            if negative then
                "-"

            else
                ""

        -- Ensure that the quantity of digits available does not exceed the quantity desired to display.
        -- If dfp_norm != norm dfp then there are digits obscured by rounding.
        dfp_norm =
            norm (dfp_round p dfp)

        samt =
            if negative then
                String.slice 1 99 (String.fromInt dfp_norm.amount)

            else
                String.fromInt dfp_norm.amount

        slen =
            String.length samt

        s2 =
            if dfp_norm.exp < 0 then
                -- move dp to the left
                if abs dfp_norm.exp < slen then
                    --split samt and insert dp
                    insertDp (slen - abs dfp_norm.exp) samt ++ String.repeat (abs p + dfp_norm.exp) "0"

                else if abs dfp_norm.exp == slen then
                    "0." ++ samt ++ String.repeat (abs p - slen) "0"

                else
                    -- abs(dfp_norm.exp) > slen
                    "0." ++ String.repeat (abs dfp_norm.exp - slen) "0" ++ samt ++ String.repeat (abs p - slen - (abs dfp_norm.exp - slen)) "0"

            else if dfp_norm.exp == 0 then
                -- don't move the dp
                samt ++ "." ++ String.repeat -p "0"

            else
                -- dfp_norm.exp > 0, move dp to the right
                samt ++ String.repeat dfp_norm.exp "0" ++ "." ++ String.repeat -p "0"

        s3 =
            if String.right 1 s2 == "." then
                String.dropRight 1 s2

            else
                s2

        s4 =
            sign ++ s3
    in
    -- If dfp_norm != norm(dfp) then there are digits obscured by rounding.
    DFPFmt s4 (not (dfp_equal dfp_norm (norm dfp)))


insertDp : Int -> String -> String
insertDp pos samt =
    let
        lsamt =
            String.length samt

        lhs =
            String.left pos samt

        rhs =
            String.right (lsamt - pos) samt
    in
    lhs ++ "." ++ rhs



{- Normalize a DFP. Given a DFP A, return a new DFP B, such that the significand of DFP B has no trailing zeros.

   For example: {amount: 1, exp: 3}, {amount: 10, exp 2}, and {amount:100, exp 1} all represent 1000, but let's use the first choice as the normalized value.
-}


norm : DFP -> DFP
norm d =
    if d.amount == 0 then
        DFP 0 0

    else if modBy 10 d.amount == 0 then
        --norm (DFP (d.amount // 10) (d.exp + 1))
        norm (DFP (round(toFloat(d.amount) / 10)) (d.exp + 1))
    else
        -- already in normal form
        d



-- Given an Int p and a DFP d, round d as necessary such that 10^p is the last digit, and return the final rounded DFP result


dfp_round : Int -> DFP -> DFP
dfp_round p d =
    if p <= d.exp then
        -- already rounded enough
        d

    else
        let
            last_digit =
                modBy 10 d.amount

            new_amount =
                if last_digit >= 5 then
                    (d.amount |> toFloat) / 10 |> round
                else
                    (d.amount |> toFloat) / 10 |> round

            new_dfp =
                DFP new_amount (d.exp + 1)
        in
        dfp_round p new_dfp
