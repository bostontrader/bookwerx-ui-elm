module Acctcat.API.Post exposing (postAcctcatCommand)

import Acctcat.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


postAcctcatCommand : String -> String -> String -> Cmd Msg
postAcctcatCommand url contentType post_body =
    Http.request
        { method = "POST"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> AcctcatPosted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AcctcatMsgA
