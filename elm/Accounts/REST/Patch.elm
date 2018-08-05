-- REST Level C.  See README.md
module Accounts.REST.Patch exposing ( patchAccountCommand )

import Http
import RemoteData

import Routing exposing ( extractUrlProxied )

import Accounts.REST.JSON exposing
    ( patchAccountDecoder
    , accountEncoder
    )

import Types exposing
    ( Msg ( AccountPatched )
    , RouteProxied ( AccountsPatch )
    , Account
    )

patchAccountCommand : Account -> Cmd Msg
patchAccountCommand account =
    Cmd.map AccountPatched
        ( RemoteData.sendRequest
            ( Http.request
                { method = "PATCH"
                , headers = []
                , url = ( extractUrlProxied AccountsPatch )  ++ account.id
                , body = Http.jsonBody (accountEncoder account)
                , expect = Http.expectJson patchAccountDecoder
                , timeout = Nothing
                , withCredentials = False
                }
            )
        )
