-- API Level C.  See README.md
module Account.API.Post exposing ( postAccountCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( AccountMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( AccountsPost ) )

import Account.Plumbing exposing
    ( AccountPostHttpResponse(..)
    , PostAccountResponse
    )
import Account.Account exposing ( Account )
import Account.AccountMsgB exposing (..)


postAccountCommand : Account -> Cmd Msg
postAccountCommand account =
    ( Http.request
        { method = "POST"
        , headers = []
        , url = extractUrlProxied AccountsPost -- this is a route not a Msg
        , body = Http.jsonBody (newAccountEncoder account)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map AccountPosted
    |> Cmd.map AccountMsgA


newAccountEncoder : Account -> Encode.Value
newAccountEncoder account =
    Encode.object
        [ ( "title", Encode.string account.title )
        ]


responseDecoder : Decoder AccountPostHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorAccountPostDecoder
        ]


dataResponseDecoderA : Decoder AccountPostHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> AccountPostDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" postAccountResponseDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : PostAccountResponse }

errorAccountPostDecoder : Decoder AccountPostHttpResponse -- Same!
errorAccountPostDecoder =
    map
    (\response -> AccountPostErrorsResponse response.errors)
    errorsResponseDecoder


postAccountResponseDecoder : Decoder PostAccountResponse
postAccountResponseDecoder =
    decode PostAccountResponse
        |> required "insertedId" string