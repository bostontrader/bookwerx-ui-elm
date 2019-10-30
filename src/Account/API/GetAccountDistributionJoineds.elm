-- Get the DistributionJoineds related to a particular account
module Account.API.GetAccountDistributionJoineds exposing (getAccountDistributionJoinedsCommand)

import Account.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getAccountDistributionJoinedsCommand : String -> Cmd Msg
getAccountDistributionJoinedsCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> AccountDistributionJoinedsReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map AccountMsgA