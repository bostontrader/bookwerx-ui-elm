module Report.API.GetDistributions exposing (getDistributionsCmd)

import Report.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getDistributionsCmd : String -> Cmd Msg
getDistributionsCmd url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> DistributionsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map ReportMsgA