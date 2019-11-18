module Transaction.API.GetMany exposing (getManyTransactionsCommand)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Transaction.MsgB exposing (MsgB(..))


getManyTransactionsCommand : String -> Cmd Msg
getManyTransactionsCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> TransactionsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map TransactionMsgA
