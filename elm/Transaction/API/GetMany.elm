-- API Level B.  See README.md
module Transaction.API.GetMany exposing ( getManyTransactionsCommand )

import Http
import Json.Decode exposing ( list )
import RemoteData

import Msg exposing ( Msg ( TransactionMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( TransactionsGetMany ) )

import Transaction.API.JSON exposing ( transactionDecoder )
import Transaction.Transaction exposing ( Transaction )
import Transaction.TransactionMsgB exposing ( TransactionMsgB ( TransactionsReceived ) )


getManyTransactionsCommand : Cmd Msg
getManyTransactionsCommand =
    list transactionDecoder
        |> Http.get ( extractUrlProxied TransactionsGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map TransactionsReceived
        |> Cmd.map TransactionMsgA
