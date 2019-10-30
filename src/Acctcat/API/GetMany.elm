module Acctcat.API.GetMany exposing (getManyAcctcatsCommand)

import Acctcat.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getManyAcctcatsCommand : String -> Cmd Msg
getManyAcctcatsCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> AcctcatsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AcctcatMsgA
