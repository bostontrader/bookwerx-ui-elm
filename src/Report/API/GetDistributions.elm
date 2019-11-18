module Report.API.GetDistributions exposing (getDistributionsCmd)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Report.MsgB exposing (MsgB(..))


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
