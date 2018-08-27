-- API Level C.  See README.md
module Account.API.GetOne exposing ( getOneAccountCommand )

import Http
import Json.Decode exposing ( Decoder, map )
import Json.Decode.Pipeline exposing ( decode, required )
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( AccountMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( AccountsGetOne ) )

import Account.API.JSON exposing ( accountDecoder )
import Account.Plumbing exposing ( AccountGetOneHttpResponse(..) )
import Account.Account exposing ( Account )
import Account.AccountMsgB exposing (..)


getOneAccountCommand : String -> Cmd Msg
getOneAccountCommand account_id =
    responseDecoder
    |> Http.get ( ( extractUrlProxied AccountsGetOne ) ++ account_id )
    |> RemoteData.sendRequest
    |> Cmd.map AccountReceived
    |> Cmd.map AccountMsgA


responseDecoder : Decoder AccountGetOneHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorAccountGetOneDecoder
        ]


dataResponseDecoderA : Decoder AccountGetOneHttpResponse -- Same!
dataResponseDecoderA =
    map
        (\response -> AccountGetOneDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" accountDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : Account }


errorAccountGetOneDecoder : Decoder AccountGetOneHttpResponse -- Same!
errorAccountGetOneDecoder =
    map
    (\response -> AccountGetOneErrorsResponse response.errors)
    errorsResponseDecoder

