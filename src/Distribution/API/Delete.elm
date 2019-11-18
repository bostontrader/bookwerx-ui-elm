module Distribution.API.Delete exposing (deleteDistributionCommand)

import Distribution.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


deleteDistributionCommand : String -> Cmd Msg
deleteDistributionCommand url =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> DistributionDeleted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map DistributionMsgA
