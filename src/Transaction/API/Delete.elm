module Transaction.API.Delete exposing (deleteTransactionCommand)

import Transaction.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


deleteTransactionCommand : String -> Cmd Msg
deleteTransactionCommand url =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> TransactionDeleted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map TransactionMsgA