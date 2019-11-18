module Transaction.API.GetOne exposing (getOneTransactionCommand)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Transaction.MsgB exposing (..)


getOneTransactionCommand : String -> Cmd Msg
getOneTransactionCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> TransactionReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map TransactionMsgA
