-- API Level C.  See README.md
module Transaction.API.Patch exposing ( patchTransactionCommand )

import Http
import Json.Decode exposing ( Decoder, bool, field, int, map, map3, oneOf, string)
import Json.Decode.Pipeline exposing ( decode, required )
import Json.Encode as Encode
import RemoteData

import JSON exposing ( errorsResponseDecoder )
import Msg exposing ( Msg ( TransactionMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( TransactionsPatch ) )

import Transaction.API.JSON exposing ( transactionDecoder, transactionEncoder )
import Transaction.Plumbing exposing ( TransactionPatchHttpResponse (..) )
import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing ( TransactionMsgB ( TransactionPatched ) )


patchTransactionCommand : Transaction -> Cmd Msg
patchTransactionCommand transaction =
    ( Http.request
        { method = "PATCH"
        , headers = []
        , url = ( extractUrlProxied TransactionsPatch )  ++ transaction.id
        , body = Http.jsonBody (transactionEncoder transaction)
        , expect = Http.expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
    )
    |> RemoteData.sendRequest
    |> Cmd.map TransactionPatched
    |> Cmd.map TransactionMsgA


responseDecoder : Decoder TransactionPatchHttpResponse -- Same!
responseDecoder =
    Json.Decode.oneOf
        [ dataResponseDecoderA
        , errorTransactionPatchDecoder
        ]


dataResponseDecoderA : Decoder TransactionPatchHttpResponse -- Same!
dataResponseDecoderA =
    Json.Decode.map
        (\response -> TransactionPatchDataResponse response.data)
        dataResponseDecoderB


dataResponseDecoderB : Decoder Catfood
dataResponseDecoderB =
    decode Catfood
        |> required "data" transactionDecoder
-- need this because I cannot substitue the literal
type alias Catfood = { data : Transaction }


errorTransactionPatchDecoder : Decoder TransactionPatchHttpResponse -- Same!
errorTransactionPatchDecoder =
    Json.Decode.map
    (\response -> TransactionPatchErrorsResponse response.errors)
    errorsResponseDecoder
