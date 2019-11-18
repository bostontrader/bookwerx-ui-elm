module Account.API.Put exposing (putAccountCommand)

import Account.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


putAccountCommand : String -> String -> String -> Cmd Msg
putAccountCommand url contentType post_body =
    Http.request
        { method = "PUT"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> AccountPutted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AccountMsgA
