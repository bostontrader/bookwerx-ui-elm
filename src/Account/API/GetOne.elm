module Account.API.GetOne exposing (getOneAccountCommand)

import Account.MsgB as MsgB
import Http
import Msg exposing (Msg)
import RemoteData



getOneAccountCommand : String -> Cmd Msg
getOneAccountCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> MsgB.AccountReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map Msg.AccountMsgA