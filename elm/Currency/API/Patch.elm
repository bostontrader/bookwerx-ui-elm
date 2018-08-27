-- API Level C.  See README.md
module Currency.API.Patch exposing ( patchCurrencyCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( CurrencyMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( CurrenciesPatch ) )

import Currency.API.JSON exposing ( currencyDecoder, currencyEncoder )
import Currency.Plumbing exposing ( CurrencyPatchHttpResponse (..) )
import Currency.Currency exposing ( Currency )
import Currency.CurrencyMsgB exposing ( CurrencyMsgB ( CurrencyPatched ) )


patchCurrencyCommand : Currency -> Cmd Msg
patchCurrencyCommand currency =
    ( Http.request
        { method = "PATCH"
        , headers = []
        , url = ( extractUrlProxied CurrenciesPatch )  ++ currency.id
        , body = Http.jsonBody (currencyEncoder currency)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map CurrencyPatched
    |> Cmd.map CurrencyMsgA


responseDecoder : Decoder CurrencyPatchHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorCurrencyPatchDecoder
        ]


dataResponseDecoderA : Decoder CurrencyPatchHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> CurrencyPatchDataResponse response.data)
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" currencyDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : Currency }


errorCurrencyPatchDecoder : Decoder CurrencyPatchHttpResponse -- Same!
errorCurrencyPatchDecoder =
    Json.Decode.map
    (\response -> CurrencyPatchErrorsResponse response.errors)
    errorsResponseDecoder
