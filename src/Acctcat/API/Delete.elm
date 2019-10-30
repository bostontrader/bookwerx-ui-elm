module Acctcat.API.Delete exposing (deleteAcctcatCommand)

import Acctcat.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


deleteAcctcatCommand : String -> Cmd Msg
deleteAcctcatCommand url =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> AcctcatDeleted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AcctcatMsgA
