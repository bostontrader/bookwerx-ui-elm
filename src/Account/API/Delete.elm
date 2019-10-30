module Account.API.Delete exposing (deleteAccountCommand)

import Account.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


deleteAccountCommand : String -> Cmd Msg
deleteAccountCommand url =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> AccountDeleted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AccountMsgA
