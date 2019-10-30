module Currency.API.Delete exposing (deleteCurrencyCommand)

import Currency.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


deleteCurrencyCommand : String -> Cmd Msg
deleteCurrencyCommand url =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectString (RemoteData.fromResult >> CurrencyDeleted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CurrencyMsgA