module Account.API.Post exposing (postAccountCommand)

import Account.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


postAccountCommand : String -> String -> String -> Cmd Msg
postAccountCommand url contentType post_body =
    Http.request
        { method = "POST"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> AccountPosted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AccountMsgA
