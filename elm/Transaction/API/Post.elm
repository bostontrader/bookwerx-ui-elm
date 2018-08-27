-- API Level C.  See README.md
module Transaction.API.Post exposing ( postTransactionCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( TransactionMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( TransactionsPost ) )

import Transaction.Plumbing exposing
    ( TransactionPostHttpResponse(..)
    , PostTransactionResponse
    )
import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing (..)


postTransactionCommand : Transaction -> Cmd Msg
postTransactionCommand transaction =
    ( Http.request
        { method = "POST"
        , headers = []
        , url = extractUrlProxied TransactionsPost -- this is a route not a Msg
        , body = Http.jsonBody (newTransactionEncoder transaction)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map TransactionPosted
    |> Cmd.map TransactionMsgA


newTransactionEncoder : Transaction -> Encode.Value
newTransactionEncoder transaction =
    Encode.object
        [ ( "datetime", Encode.string transaction.datetime )
        , ( "note", Encode.string transaction.note )
        ]


responseDecoder : Decoder TransactionPostHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorTransactionPostDecoder
        ]


dataResponseDecoderA : Decoder TransactionPostHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> TransactionPostDataResponse response.data) -- this picks out the data field
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" postTransactionResponseDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : PostTransactionResponse }

errorTransactionPostDecoder : Decoder TransactionPostHttpResponse -- Same!
errorTransactionPostDecoder =
    map
    (\response -> TransactionPostErrorsResponse response.errors)
    errorsResponseDecoder


postTransactionResponseDecoder : Decoder PostTransactionResponse
postTransactionResponseDecoder =
    decode PostTransactionResponse
        |> required "insertedId" string
