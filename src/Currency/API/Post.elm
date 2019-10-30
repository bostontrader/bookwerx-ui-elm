module Currency.API.Post exposing (postCurrencyCommand)

import Currency.MsgB exposing (MsgB(..))
import Http
import Msg exposing (Msg(..))
import RemoteData


postCurrencyCommand : String -> String -> String -> Cmd Msg
postCurrencyCommand url contentType post_body =
    Http.request
        { method = "POST"
        , headers = [] -- application/x-www-form-urlencoded is set by stringBody
        , url = url
        , body = Http.stringBody contentType post_body
        , expect = Http.expectString (RemoteData.fromResult >> CurrencyPosted)
        , timeout = Nothing
        , tracker = Nothing
        }
        |> Cmd.map CurrencyMsgA