module Transaction.API.Post exposing (postTransactionCommand)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Transaction.MsgB exposing (MsgB(..))


postTransactionCommand : String -> String -> String -> Cmd Msg
postTransactionCommand url contentType post_body =
    Http.request
        { method = "POST"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> TransactionPosted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map TransactionMsgA