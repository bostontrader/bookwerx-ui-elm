module Currency.API.Put exposing (putCurrencyCommand)

import Currency.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


putCurrencyCommand : String -> String -> String -> Cmd Msg
putCurrencyCommand url contentType post_body =
    Http.request
        { method = "PUT"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> CurrencyPutted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CurrencyMsgA