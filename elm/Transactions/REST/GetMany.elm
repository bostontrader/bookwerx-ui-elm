-- REST Level B.  See README.md
module Transactions.REST.GetMany exposing ( getManyTransactionsCommand )

import Http
import RemoteData
import Json.Decode exposing ( list )

import Routing exposing ( extractUrlProxied )
import Transactions.REST.JSON exposing ( transactionDecoder )
import Types exposing
    ( Msg ( TransactionsReceived )
    , RouteProxied ( TransactionsGetMany )
    , Transaction
    )

getManyTransactionsCommand : Cmd Msg
getManyTransactionsCommand =
    list transactionDecoder
        |> Http.get ( extractUrlProxied TransactionsGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map TransactionsReceived
