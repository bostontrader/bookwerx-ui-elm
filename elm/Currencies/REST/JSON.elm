module Currencies.REST.JSON exposing
    ( getOneCurrencyDecoder
    , patchCurrencyDecoder
    , postCurrencyDecoder
    , currencyDecoder
    , currencyEncoder, newCurrencyEncoder
    , currencyPatchResponseDecoder
    )


--currencyDecoder : Decoder Currency
--currencyDecoder =
--    decode Currency
--        |> required "_id" string
--        |> required "symbol" string
--        |> required "title" string

import Json.Decode exposing ( Decoder, string )
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode

import Types exposing
    ( errorResponseDecoder
    , Currency
    , CurrencyPostHttpResponse(..)
    , CurrencyPatchHttpResponse(..)
    )

currencyEncoder : Currency -> Encode.Value
currencyEncoder currency =
    Encode.object
        [ ("id", Encode.string currency.id)
        , ("symbol", Encode.string currency.symbol)
        , ("title", Encode.string currency.title)
        ]

newCurrencyEncoder : Currency -> Encode.Value
newCurrencyEncoder currency =
    Encode.object
        [ ( "symbol", Encode.string currency.symbol )
        , ( "title", Encode.string currency.title )
        ]

currencyDecoder : Decoder Currency
currencyDecoder =
    decode Currency
        |> required "_id" string
        |> required "symbol" string
        |> required "title" string

-- getOne
getOneCurrencyDecoder : Decoder CurrencyPostHttpResponse
getOneCurrencyDecoder =
    Json.Decode.oneOf
        [ validCurrencyEditDecoder
        , errorCurrencyEditDecoder
        ]

validCurrencyEditDecoder : Decoder CurrencyPostHttpResponse
validCurrencyEditDecoder =
    Json.Decode.map
        (\response -> ValidCurrencyPostResponse response.data)
        currencyEditResponseDecoder

errorCurrencyEditDecoder : Json.Decode.Decoder CurrencyPostHttpResponse
errorCurrencyEditDecoder =
    Json.Decode.map
    (\response -> ErrorCurrencyPostResponse response.errors)
    errorResponseDecoder

currencyEditResponseDecoder : Json.Decode.Decoder CurrencyEditValidResponse
currencyEditResponseDecoder =
    Json.Decode.Pipeline.decode CurrencyEditValidResponse
        |> Json.Decode.Pipeline.required "data" currencyDecoder

type alias CurrencyEditValidResponse = { data : Currency }

-- patch
patchCurrencyDecoder : Decoder CurrencyPatchHttpResponse
patchCurrencyDecoder =
    Json.Decode.oneOf
        [ validCurrencyPatchDecoder
        , errorCurrencyPatchDecoder
        ]

validCurrencyPatchDecoder : Decoder CurrencyPatchHttpResponse
validCurrencyPatchDecoder =
    Json.Decode.map
        (\response -> ValidCurrencyPatchResponse response.data)
        currencyPatchResponseDecoder

currencyPatchResponseDecoder : Json.Decode.Decoder CurrencyPatchValidResponse
currencyPatchResponseDecoder =
    Json.Decode.Pipeline.decode CurrencyPatchValidResponse
        |> Json.Decode.Pipeline.required "data" currencyDecoder

errorCurrencyPatchDecoder : Json.Decode.Decoder CurrencyPatchHttpResponse
errorCurrencyPatchDecoder =
    Json.Decode.map
    (\response -> ErrorCurrencyPatchResponse response.errors)
    errorResponseDecoder

type alias CurrencyPatchValidResponse = { data : Currency }


-- post
--postCurrencyDecoder
--resultDecoder : Decoder PostCurrencyResult
--resultDecoder =
--    decode PostCurrencyResult
--        |> required "n" int
--        |> required "ok" int
postCurrencyDecoder : Decoder CurrencyPostHttpResponse
postCurrencyDecoder =
    Json.Decode.oneOf
        [ validCurrencyPostDecoder
        , errorCurrencyPostDecoder
        ]

validCurrencyPostDecoder : Decoder CurrencyPostHttpResponse
validCurrencyPostDecoder =
    Json.Decode.map
        (\response -> ValidCurrencyPostResponse response.data)
        currencyPostResponseDecoder

currencyPostResponseDecoder : Json.Decode.Decoder CurrencyPostValidResponse
currencyPostResponseDecoder =
    Json.Decode.Pipeline.decode CurrencyPostValidResponse
        |> Json.Decode.Pipeline.required "data" currencyDecoder

errorCurrencyPostDecoder : Json.Decode.Decoder CurrencyPostHttpResponse
errorCurrencyPostDecoder =
    Json.Decode.map
    (\response -> ErrorCurrencyPostResponse response.errors)
    errorResponseDecoder

type alias CurrencyPostValidResponse = { data : Currency }
