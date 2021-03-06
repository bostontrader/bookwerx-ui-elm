module Currency.Currency exposing (..)

import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)



-- This alias and decoder directly matches a struct in bookwerx-core.


type alias CurrencySymbol =
    { currency_id : Int
    , symbol : String
    }


currencySymbolDecoder : Decoder CurrencySymbol
currencySymbolDecoder =
    Json.Decode.succeed CurrencySymbol
        |> required "currency_id" int
        |> required "symbol" string



-- Legacy aliai.  Clean this up


type alias Currency =
    { id : Int
    , apikey : String
    , symbol : String
    , title : String
    }


type alias CurrencyShort =
    { symbol : String
    , title : String
    }
