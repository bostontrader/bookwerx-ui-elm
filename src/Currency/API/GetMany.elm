module Currency.API.GetMany exposing (getManyCurrenciesCommand)

import Currency.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


getManyCurrenciesCommand : String -> Cmd Msg
getManyCurrenciesCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> CurrenciesReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CurrencyMsgA