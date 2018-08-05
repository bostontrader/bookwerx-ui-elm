-- REST Level C.  See README.md
module Accounts.REST.Post exposing ( postAccountCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Accounts.REST.JSON exposing
    ( newAccountEncoder
    , postAccountDecoder
    )

import Types exposing
    ( Msg ( AccountCreated )
    , RouteProxied ( AccountsPost )
    , Account
    )

postAccountCommand : Account -> Cmd Msg
postAccountCommand account =
    Cmd.map AccountCreated
        ( RemoteData.sendRequest
            ( Http.request
                { method = "POST"
                , headers = []
                , url = extractUrlProxied AccountsPost
                , body = Http.jsonBody (newAccountEncoder account)
                , expect = Http.expectJson postAccountDecoder
                , timeout = Nothing
                , withCredentials = False
                }
            )
        )
