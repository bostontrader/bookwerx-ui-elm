-- REST Level C.  See README.md
module Transactions.REST.Patch exposing ( patchTransactionCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Transactions.REST.JSON exposing
    ( patchTransactionDecoder
    , transactionEncoder
    )

import Types exposing
    ( Msg ( TransactionPatched )
    , RouteProxied ( TransactionsPatch )
    , Transaction
    )

patchTransactionCommand : Transaction -> Cmd Msg
patchTransactionCommand transaction =
    Cmd.map TransactionPatched
        ( RemoteData.sendRequest
            ( Http.request
                { method = "PATCH"
                , headers = []
                , url = ( extractUrlProxied TransactionsPatch )  ++ transaction.id
                , body = Http.jsonBody (transactionEncoder transaction)
                , expect = Http.expectJson patchTransactionDecoder
                , timeout = Nothing
                , withCredentials = False
                }
            )
        )
