-- API Level A.  See README.md
module Account.API.Delete exposing ( deleteAccountCommand )

import Http

import Msg exposing ( Msg ( AccountMsgA ) )
import Routing exposing ( extractUrlProxied )
import Types exposing ( RouteProxied ( AccountsDelete ) )

import Account.Account exposing ( Account )
import Account.AccountMsgB exposing ( AccountMsgB ( AccountDeleted ) )


deleteAccountCommand : Account -> Cmd Msg
deleteAccountCommand account =
    deleteAccountRequest account
        |> Http.send AccountDeleted
        |> Cmd.map AccountMsgA


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
