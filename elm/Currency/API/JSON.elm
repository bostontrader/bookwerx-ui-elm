module Currency.API.JSON exposing
    ( currencyDecoder
    , currencyEncoder 
    )

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Currency.Currency exposing ( Currency )


currencyEncoder : Currency -> Encode.Value
currencyEncoder currency =
    Encode.object
        [ ("symbol", Encode.string currency.symbol)
        , ("title", Encode.string currency.title)
        ]


currencyDecoder : Decoder Currency
currencyDecoder =
    decode Currency
        |> required "_id" string
        |> required "symbol" string
        |> required "title" string
