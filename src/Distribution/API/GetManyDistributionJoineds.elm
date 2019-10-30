module Distribution.API.GetManyDistributionJoineds exposing (getManyDistributionJoinedsCommand)

import Distribution.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getManyDistributionJoinedsCommand : String -> Cmd Msg
getManyDistributionJoinedsCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> DistributionJoinedsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map DistributionMsgA