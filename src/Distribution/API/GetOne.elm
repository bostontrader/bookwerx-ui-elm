module Distribution.API.GetOne exposing (getOneDistributionCommand)

import Distribution.MsgB exposing (..)
import Http
import Msg exposing (Msg(..))
import RemoteData


getOneDistributionCommand : String -> Cmd Msg
getOneDistributionCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> DistributionReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map DistributionMsgA
