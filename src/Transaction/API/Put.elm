module Transaction.API.Put exposing (putTransactionCommand)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Transaction.MsgB exposing (MsgB(..))


putTransactionCommand : String -> String -> String -> Cmd Msg
putTransactionCommand url contentType post_body =
    Http.request
        { method = "PUT"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> TransactionPutted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map TransactionMsgA