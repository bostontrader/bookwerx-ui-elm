module Account.API.GetMany exposing (getManyAccountsCommand)

import Account.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getManyAccountsCommand : String -> Cmd Msg
getManyAccountsCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> AccountsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AccountMsgA
