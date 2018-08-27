-- API Level B.  See README.md
module Account.API.GetMany exposing ( getManyAccountsCommand )

import Http
import Json.Decode exposing ( list )
import RemoteData

import Msg exposing ( Msg ( AccountMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( AccountsGetMany ) )

import Account.API.JSON exposing ( accountDecoder )
import Account.Account exposing ( Account )
import Account.AccountMsgB exposing ( AccountMsgB ( AccountsReceived ) )


getManyAccountsCommand : Cmd Msg
getManyAccountsCommand =
    list accountDecoder
        |> Http.get ( extractUrlProxied AccountsGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map AccountsReceived
        |> Cmd.map AccountMsgA
