module Lint.API.GetLints exposing (getLintsCmd)

import Http
import Lint.MsgB exposing (MsgB(..))
import Msg exposing (Msg(..))
import RemoteData


getLintsCmd : String -> Cmd Msg
getLintsCmd url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> LintsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map LintMsgA
