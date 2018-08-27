-- API Level A.  See README.md
module Transaction.API.Delete exposing ( deleteTransactionCommand )

import Http

import Msg exposing ( Msg ( TransactionMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( TransactionsDelete ) )

import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing ( TransactionMsgB ( TransactionDeleted ) )


deleteTransactionCommand : Transaction -> Cmd Msg
deleteTransactionCommand transaction =
    deleteTransactionRequest transaction
        |> Http.send TransactionDeleted
        |> Cmd.map TransactionMsgA


deleteTransactionRequest : Transaction -> Http.Request String
deleteTransactionRequest transaction =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = ( extractUrlProxied TransactionsDelete ) ++ transaction.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
