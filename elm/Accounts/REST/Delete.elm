-- REST Level A.  See README.md
module Accounts.REST.Delete exposing ( deleteAccountCommand )

import Http

import Routing exposing ( extractUrlProxied )
import Types exposing
    ( Msg ( AccountDeleted )
    , RouteProxied ( AccountsDelete )
    , Account
    )


deleteAccountCommand : Account -> Cmd Msg
deleteAccountCommand account =
    deleteAccountRequest account
        |> Http.send AccountDeleted


deleteAccountRequest : Account -> Http.Request String
deleteAccountRequest account =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = ( extractUrlProxied AccountsDelete ) ++ account.id
        , body = Http.emptyBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }
