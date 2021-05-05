module Report.API.GetDistributions exposing (getDistributionsCmdA, getDistributionsCmdB)

import Http
import Msg exposing (Msg(..))
import RemoteData
import Report.Model exposing (ReportSection(..))
import Report.Msg



-- get distributions for a category that is a particular part of the BS or PNL


getDistributionsCmdA : String -> ReportSection -> Cmd Msg
getDistributionsCmdA url bssection =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> Report.Msg.DistributionsReceivedA bssection)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map Report



-- get distributions for a category that is not specifically known as a part of the BS or PNL.
getDistributionsCmdB : String -> Cmd Msg
getDistributionsCmdB url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> Report.Msg.DistributionsReceivedB)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map Report
