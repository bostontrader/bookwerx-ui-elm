-- REST Level C.  See README.md
module Accounts.REST.GetOne exposing ( getOneAccountCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Accounts.REST.JSON exposing
    ( getOneAccountDecoder
    , accountEncoder
    )

import Types exposing
    ( Msg ( AccountReceived )
    , RouteProxied ( AccountsGetOne )
    , Account
    )

getOneAccountCommand : String -> Cmd Msg
getOneAccountCommand account_id =
    Cmd.map AccountReceived
        ( RemoteData.sendRequest
            ( Http.get ( ( extractUrlProxied AccountsGetOne ) ++ account_id )  getOneAccountDecoder )
        )