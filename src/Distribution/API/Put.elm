module Distribution.API.Put exposing (putDistributionCommand)

import Distribution.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


putDistributionCommand : String -> String -> String -> Cmd Msg
putDistributionCommand url contentType post_body =
    Http.request
        { method = "PUT"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> DistributionPutted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map DistributionMsgA