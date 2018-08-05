-- REST Level A.  See README.md
module Transactions.REST.Delete exposing ( deleteTransactionCommand )

import Http

import Routing exposing ( extractUrlProxied )
import Types exposing
    ( Msg ( TransactionDeleted )
    , RouteProxied ( TransactionsDelete )
    , Transaction
    )


deleteTransactionCommand : Transaction -> Cmd Msg
deleteTransactionCommand transaction =
    deleteTransactionRequest transaction
        |> Http.send TransactionDeleted


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
