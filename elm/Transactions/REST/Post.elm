-- REST Level C.  See README.md
module Transactions.REST.Post exposing ( postTransactionCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Transactions.REST.JSON exposing
    ( newTransactionEncoder
    , postTransactionDecoder
    )

import Types exposing
    ( Msg ( TransactionCreated )
    , RouteProxied ( TransactionsPost )
    , Transaction
    )

postTransactionCommand : Transaction -> Cmd Msg
postTransactionCommand transaction =
    Cmd.map TransactionCreated
        ( RemoteData.sendRequest
            ( Http.request
                { method = "POST"
                , headers = []
                , url = extractUrlProxied TransactionsPost
                , body = Http.jsonBody (newTransactionEncoder transaction)
                , expect = Http.expectJson postTransactionDecoder
                , timeout = Nothing
                , withCredentials = False
                }
            )
        )
