module Currency.API.GetOne exposing (getOneCurrencyCommand)

import Currency.MsgB exposing (..)
import Http
import Msg exposing (Msg(..))
import RemoteData


getOneCurrencyCommand : String -> Cmd Msg
getOneCurrencyCommand url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> CurrencyReceived)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CurrencyMsgA