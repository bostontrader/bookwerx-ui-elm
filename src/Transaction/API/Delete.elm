module Transaction.API.Delete exposing (deleteTransactionCommand)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Transaction.MsgB exposing (MsgB(..))


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
