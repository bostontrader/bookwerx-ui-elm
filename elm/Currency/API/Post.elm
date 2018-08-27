-- API Level C.  See README.md
module Currency.API.Post exposing ( postCurrencyCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( CurrencyMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CurrenciesPost ) )

import Currency.Plumbing exposing
    ( CurrencyPostHttpResponse(..)
    , PostCurrencyResponse
    )
import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing (..)


postCurrencyCommand : Currency -> Cmd Msg
postCurrencyCommand currency =
    ( Http.request
        { method = "POST"
        , headers = []
        , url = extractUrlProxied CurrenciesPost -- this is a route not a Msg
        , body = Http.jsonBody (newCurrencyEncoder currency)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map CurrencyPosted
    |> Cmd.map CurrencyMsgA


newCurrencyEncoder : Currency -> Encode.Value
newCurrencyEncoder currency =
    Encode.object
        [ ( "symbol", Encode.string currency.symbol )
        , ( "title", Encode.string currency.title )
        ]


responseDecoder : Decoder CurrencyPostHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorCurrencyPostDecoder
        ]


dataResponseDecoderA : Decoder CurrencyPostHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> CurrencyPostDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" postCurrencyResponseDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : PostCurrencyResponse }

errorCurrencyPostDecoder : Decoder CurrencyPostHttpResponse -- Same!
errorCurrencyPostDecoder =
    map
    (\response -> CurrencyPostErrorsResponse response.errors)
    errorsResponseDecoder


postCurrencyResponseDecoder : Decoder PostCurrencyResponse
postCurrencyResponseDecoder =
    decode PostCurrencyResponse
        |> required "insertedId" string