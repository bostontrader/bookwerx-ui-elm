-- REST Level C.  See README.md
module Transactions.REST.GetOne exposing ( getOneTransactionCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Transactions.REST.JSON exposing
    ( getOneTransactionDecoder
    , transactionEncoder
    )

import Types exposing
    ( Msg ( TransactionReceived )
    , RouteProxied ( TransactionsGetOne )
    , Transaction
    )

getOneTransactionCommand : String -> Cmd Msg
getOneTransactionCommand transaction_id =
    Cmd.map TransactionReceived
        ( RemoteData.sendRequest
            ( Http.get ( ( extractUrlProxied TransactionsGetOne ) ++ transaction_id )  getOneTransactionDecoder )
        )
