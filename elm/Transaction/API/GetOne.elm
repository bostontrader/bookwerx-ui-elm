-- API Level C.  See README.md
module Transaction.API.GetOne exposing ( getOneTransactionCommand )

import Http
import Json.Decode exposing ( Decoder, map )
import Json.Decode.Pipeline exposing ( decode, required )
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( TransactionMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( TransactionsGetOne ) )

import Transaction.API.JSON exposing ( transactionDecoder )
import Transaction.Plumbing exposing ( TransactionGetOneHttpResponse(..) )
import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing ( TransactionMsgB ( TransactionReceived ) )


getOneTransactionCommand : String -> Cmd Msg
getOneTransactionCommand transaction_id =
    responseDecoder
    |> Http.get ( ( extractUrlProxied TransactionsGetOne ) ++ transaction_id )
    |> RemoteData.sendRequest
    |> Cmd.map TransactionReceived
    |> Cmd.map TransactionMsgA


responseDecoder : Decoder TransactionGetOneHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorTransactionGetOneDecoder
        ]


dataResponseDecoderA : Decoder TransactionGetOneHttpResponse -- Same!
dataResponseDecoderA =
    map
        (\response -> TransactionGetOneDataResponse response.data)
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" transactionDecoder
-- need this because I cannot substitute the literal
type alias Catfood = { data : Transaction }


errorTransactionGetOneDecoder : Decoder TransactionGetOneHttpResponse -- Same!
errorTransactionGetOneDecoder =
    map
    (\response -> TransactionGetOneErrorsResponse response.errors)
    errorsResponseDecoder
