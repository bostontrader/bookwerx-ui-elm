module Distribution.API.Post exposing (postDistributionCommand)

import Distribution.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


postDistributionCommand : String -> String -> String -> Cmd Msg
postDistributionCommand url contentType post_body =
    Http.request
        { method = "POST"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> DistributionPosted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map DistributionMsgA
