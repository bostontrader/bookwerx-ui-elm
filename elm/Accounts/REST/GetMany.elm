-- REST Level B.  See README.md
module Accounts.REST.GetMany exposing ( getManyAccountsCommand )

import Http
import RemoteData
import Json.Decode exposing ( list )

import Routing exposing ( extractUrlProxied )
import Accounts.REST.JSON exposing ( accountDecoder )
import Types exposing
    ( Msg ( AccountsReceived )
    , RouteProxied ( AccountsGetMany )
    , Account
    )

getManyAccountsCommand : Cmd Msg
getManyAccountsCommand =
    list accountDecoder
        |> Http.get ( extractUrlProxied AccountsGetMany )
        |> RemoteData.sendRequest
        |> Cmd.map AccountsReceived
