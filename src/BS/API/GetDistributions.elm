module BS.API.GetDistributions exposing (getDistributionsCmd)

import BS.Model exposing (BSSection(..))
import BS.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData

getDistributionsCmd : String -> BSSection -> Cmd Msg
getDistributionsCmd url bssection =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> DistributionsReceived bssection)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map BSMsgA
