-- API Level C.  See README.md
module Currency.API.GetOne exposing ( getOneCurrencyCommand )

import Http
import Json.Decode exposing ( Decoder, map )
import Json.Decode.Pipeline exposing ( decode, required )
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( CurrencyMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CurrenciesGetOne ) )

import Currency.API.JSON exposing ( currencyDecoder )
import Currency.Plumbing exposing ( CurrencyGetOneHttpResponse(..) )
import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing (..)


getOneCurrencyCommand : String -> Cmd Msg
getOneCurrencyCommand currency_id =
    responseDecoder
    |> Http.get ( ( extractUrlProxied CurrenciesGetOne ) ++ currency_id )
    |> RemoteData.sendRequest
    |> Cmd.map CurrencyReceived
    |> Cmd.map CurrencyMsgA


responseDecoder : Decoder CurrencyGetOneHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorCurrencyGetOneDecoder
        ]


dataResponseDecoderA : Decoder CurrencyGetOneHttpResponse -- Same!
dataResponseDecoderA =
    map
        (\response -> CurrencyGetOneDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" currencyDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : Currency }


errorCurrencyGetOneDecoder : Decoder CurrencyGetOneHttpResponse -- Same!
errorCurrencyGetOneDecoder =
    map
    (\response -> CurrencyGetOneErrorsResponse response.errors)
    errorsResponseDecoder
