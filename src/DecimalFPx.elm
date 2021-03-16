{- Deprecated.  See DecimalFP instead.

A Decimal Floating Point (DFP) is a type composed of two integers, a significand and an exponent. Using this format we can readily represent the _exact_ amounts that we find in financial transactions using a method similar to scientific notation, w/o rounding error. Please see https://en.wikipedia.org/wiki/Decimal_floating_point for more info.

   Not only must we represent DFP but we must be able to perform a handful of useful operations on them such as adding, rounding, and string formatting.  This is a small subset of possible operations that can be imagined, but it's enough for this application.
-}


module DecimalFPx exposing (DFPFmtx, DFPx, dfpDecoderx)

import Json.Decode exposing (Decoder, int)
import Json.Decode.Pipeline exposing (required)


type alias DFPx =
    { amount : Int
    , exp : Int
    }


dfpDecoderx : Decoder DFPx
dfpDecoderx =
    Json.Decode.succeed DFPx
        |> required "amount" int
        |> required "exp" int



-- A string representation of a DFP with a flag to indicate whether or not there is a loss of precision due to rounding.


type alias DFPFmtx =
    { s : String
    , r : Bool -- True = loss of precision due to rounding.
    }
